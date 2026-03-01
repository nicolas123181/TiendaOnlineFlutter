// Provider para administración de devoluciones

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../config/constants/app_constants.dart';
import '../../../../shared/services/invoice_service.dart';
import '../../../../shared/services/resend_email_service.dart';
import '../../../../shared/services/supabase_service.dart';
import '../../data/models/return_model.dart';

/// Provider para listar todas las devoluciones
final returnsProvider = FutureProvider<List<ReturnModel>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);

  final response = await supabase
      .from('returns')
      .select('*')
      .order('created_at', ascending: false);

  return (response as List).map((json) => ReturnModel.fromJson(json)).toList();
});

/// Provider para devoluciones pendientes (pending + in_transit)
final pendingReturnsProvider = FutureProvider<List<ReturnModel>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);

  final response = await supabase
      .from('returns')
      .select('*')
      .inFilter('status', ['pending', 'in_transit'])
      .order('created_at', ascending: true);

  return (response as List).map((json) => ReturnModel.fromJson(json)).toList();
});

/// Provider para devoluciones recibidas (pendientes de reembolso)
final receivedReturnsProvider = FutureProvider<List<ReturnModel>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);

  final response = await supabase
      .from('returns')
      .select('*')
      .eq('status', 'received')
      .order('received_at', ascending: true);

  return (response as List).map((json) => ReturnModel.fromJson(json)).toList();
});

/// Provider para devoluciones completadas (refunded + rejected)
final completedReturnsProvider = FutureProvider<List<ReturnModel>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);

  final response = await supabase
      .from('returns')
      .select('*')
      .inFilter('status', ['refunded', 'rejected'])
      .order('updated_at', ascending: false);

  return (response as List).map((json) => ReturnModel.fromJson(json)).toList();
});

/// Provider para estadísticas de devoluciones
final returnsStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final returns = await ref.watch(returnsProvider.future);

  return {
    'pending': returns
        .where((r) => r.status == 'pending' || r.status == 'in_transit')
        .length,
    'received': returns.where((r) => r.status == 'received').length,
    'refunded': returns.where((r) => r.status == 'refunded').length,
    'rejected': returns.where((r) => r.status == 'rejected').length,
    'total': returns.length,
  };
});

/// Provider para acciones de devoluciones
final returnActionsProvider = Provider((ref) => ReturnActions(ref));

class ReturnActions {
  final Ref ref;

  ReturnActions(this.ref);

  /// Llamada centralizada a la Web API /api/admin/update-return
  /// que maneja: emails, reembolso Stripe, restauración de stock y factura rectificativa.
  /// Si la API falla, hace fallback a Supabase directo (sin email).
  Future<bool> _callUpdateReturnApi({
    required int returnId,
    required String status,
    String? adminNotes,
    double? refundAmount,
  }) async {
    final apiKey = AppConstants.adminApiKey;
    final baseUrl = AppConstants.webApiBaseUrl;

    if (apiKey.isEmpty) {
      debugPrint(
        '[ReturnActions] ADMIN_API_KEY vacía, no se puede llamar a la API web',
      );
      return false;
    }

    try {
      final body = <String, dynamic>{'returnId': returnId, 'status': status};

      if (adminNotes != null && adminNotes.isNotEmpty) {
        body['adminNotes'] = adminNotes;
      }

      if (refundAmount != null) {
        body['refundAmount'] = refundAmount;
      }

      debugPrint(
        '[ReturnActions] Llamando a $baseUrl/api/admin/update-return con status=$status',
      );

      final response = await http
          .post(
            Uri.parse('$baseUrl/api/admin/update-return'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $apiKey',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      debugPrint(
        '[ReturnActions] Respuesta API: ${response.statusCode} - ${response.body}',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          debugPrint(
            '[ReturnActions] API exitosa. Email enviado: ${data['emailSent']}',
          );
          return true;
        }
      }

      debugPrint('[ReturnActions] API devolvió error: ${response.body}');
      return false;
    } catch (e) {
      debugPrint('[ReturnActions] Error llamando API web: $e');
      return false;
    }
  }

  /// Marcar devolución como recibida (envía email de "paquete recibido, en revisión")
  Future<bool> markAsReceived(int returnId) async {
    final apiSuccess = await _callUpdateReturnApi(
      returnId: returnId,
      status: 'received',
    );

    // Fallback: actualizar directamente en Supabase + enviar email via Resend
    if (!apiSuccess) {
      debugPrint(
        '[ReturnActions] Fallback a Supabase directo para markAsReceived',
      );
      final supabase = ref.read(supabaseClientProvider);
      await supabase
          .from('returns')
          .update({
            'status': 'received',
            'received_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', returnId);

      // Enviar email directamente via Resend
      final emailSent = await _sendReturnEmail(
        returnId: returnId,
        type: 'received',
      );
      _invalidateCache();
      return emailSent;
    }

    _invalidateCache();
    return apiSuccess;
  }

  /// Procesar reembolso vía Web API (Stripe refund + email + stock + factura rectificativa)
  Future<bool> processRefund({
    required int returnId,
    double? refundAmount,
  }) async {
    final apiSuccess = await _callUpdateReturnApi(
      returnId: returnId,
      status: 'refunded',
      refundAmount: refundAmount,
    );

    // Fallback: actualizar estado en Supabase + restaurar stock + factura rectificativa + email con PDF
    if (!apiSuccess) {
      debugPrint(
        '[ReturnActions] Fallback a Supabase directo para processRefund',
      );
      final supabase = ref.read(supabaseClientProvider);
      await supabase
          .from('returns')
          .update({
            'status': 'refunded',
            'refunded_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', returnId);

      // Obtener datos completos de la devolución
      List<Map<String, dynamic>>? attachments;
      try {
        final returnData = await supabase
            .from('returns')
            .select('*')
            .eq('id', returnId)
            .single();

        final orderId = (returnData['order_id'] as num).toInt();
        final customerName =
            returnData['customer_name'] as String? ?? 'Cliente';
        final customerEmail = returnData['customer_email'] as String? ?? '';
        final dbRefundAmount =
            (returnData['refund_amount'] as num?)?.toInt() ?? 0;
        final returnItems = returnData['items'] as List<dynamic>? ?? [];

        final invoiceService = InvoiceService(supabase);

        // Restaurar stock de los productos devueltos
        if (returnItems.isNotEmpty) {
          final stockItems = returnItems.map((item) {
            final m = item as Map<String, dynamic>;
            return {
              'product_id': m['productId'] ?? m['product_id'],
              'quantity': m['quantity'] ?? 1,
              'size': m['size'] ?? m['productSize'],
            };
          }).toList();
          await invoiceService.restoreStock(stockItems);
          debugPrint(
            '[ReturnActions] Stock restaurado para devolución #$returnId',
          );
        }

        // Calcular monto de reembolso en céntimos
        final refundCents = refundAmount != null
            ? (refundAmount * 100).round()
            : dbRefundAmount;

        // Crear factura rectificativa
        final creditNoteItems = returnItems.map((item) {
          final m = item as Map<String, dynamic>;
          return CreditNoteItem(
            productId: m['productId'] as int? ?? m['product_id'] as int?,
            productName:
                m['productName'] as String? ??
                m['product_name'] as String? ??
                'Producto',
            productSize: m['size'] as String? ?? m['productSize'] as String?,
            quantity: (m['quantity'] as num?)?.toInt() ?? 1,
            unitPrice:
                (m['unitPrice'] as num?)?.toInt() ??
                (m['unit_price'] as num?)?.toInt() ??
                0,
          );
        }).toList();

        final creditNote = await invoiceService.createCreditNote(
          orderId: orderId,
          customerName: customerName,
          customerEmail: customerEmail,
          items: creditNoteItems,
          refundAmountCents: refundCents,
          notes: 'Factura rectificativa por devolución #$returnId',
        );

        // Intentar descargar PDF de la factura rectificativa
        if (creditNote != null) {
          final invoiceId = (creditNote['id'] as num).toInt();
          final pdfBytes = await invoiceService.fetchInvoicePdfBytes(invoiceId);
          if (pdfBytes != null) {
            attachments = [
              ResendEmailService.makeAttachment(
                filename: 'factura_rectificativa_$invoiceId.pdf',
                content: pdfBytes,
              ),
            ];
            debugPrint(
              '[ReturnActions] PDF adjuntado para factura #$invoiceId',
            );
          }
        }
      } catch (e) {
        debugPrint('[ReturnActions] Error en credit note/stock restore: $e');
        // Continuamos con el envío de email sin adjunto
      }

      // Enviar email directamente via Resend (con PDF adjunto si disponible)
      final emailSent = await _sendReturnEmail(
        returnId: returnId,
        type: 'refunded',
        refundAmount: refundAmount,
        attachments: attachments,
      );
      await _ensureCreditNoteForReturn(
        returnId: returnId,
        refundAmount: refundAmount,
      );
      _invalidateCache();
      return emailSent;
    }

    await _ensureCreditNoteForReturn(
      returnId: returnId,
      refundAmount: refundAmount,
    );
    _invalidateCache();
    return apiSuccess;
  }

  Future<void> _ensureCreditNoteForReturn({
    required int returnId,
    double? refundAmount,
  }) async {
    final supabase = ref.read(supabaseClientProvider);

    try {
      final returnData = await supabase
          .from('returns')
          .select('*')
          .eq('id', returnId)
          .single();

      final orderId = (returnData['order_id'] as num).toInt();

      Map<String, dynamic>? existingCreditNote;
      try {
        existingCreditNote = await supabase
            .from('invoices')
            .select('id')
            .eq('order_id', orderId)
            .eq('type', 'credit_note')
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle();
      } catch (_) {
        final invoices = await supabase
            .from('invoices')
            .select('id, total, payment_status, notes')
            .eq('order_id', orderId)
            .order('created_at', ascending: false);

        existingCreditNote = List<Map<String, dynamic>>.from(invoices)
            .cast<Map<String, dynamic>?>()
            .firstWhere((invoice) {
              if (invoice == null) return false;
              final total = (invoice['total'] as num?)?.toInt() ?? 0;
              final paymentStatus = invoice['payment_status'] as String?;
              final notes = (invoice['notes'] as String? ?? '').toLowerCase();

              return total < 0 ||
                  paymentStatus == 'refunded' ||
                  notes.contains('rectificativa');
            }, orElse: () => null);
      }

      if (existingCreditNote != null) {
        return;
      }

      final customerName = returnData['customer_name'] as String? ?? 'Cliente';
      final customerEmail = returnData['customer_email'] as String? ?? '';
      final dbRefundAmount =
          (returnData['refund_amount'] as num?)?.toInt() ?? 0;
      final returnItems = returnData['items'] as List<dynamic>? ?? [];

      if (customerEmail.isEmpty || returnItems.isEmpty) {
        return;
      }

      final refundCents = refundAmount != null
          ? (refundAmount * 100).round()
          : dbRefundAmount;

      final creditNoteItems = returnItems.map((item) {
        final m = item as Map<String, dynamic>;
        return CreditNoteItem(
          productId: m['productId'] as int? ?? m['product_id'] as int?,
          productName:
              m['productName'] as String? ??
              m['product_name'] as String? ??
              'Producto',
          productSize: m['size'] as String? ?? m['productSize'] as String?,
          quantity: (m['quantity'] as num?)?.toInt() ?? 1,
          unitPrice:
              (m['unitPrice'] as num?)?.toInt() ??
              (m['unit_price'] as num?)?.toInt() ??
              0,
        );
      }).toList();

      final invoiceService = InvoiceService(supabase);
      await invoiceService.createCreditNote(
        orderId: orderId,
        customerName: customerName,
        customerEmail: customerEmail,
        items: creditNoteItems,
        refundAmountCents: refundCents,
        notes: 'Factura rectificativa por devolución #$returnId',
      );
    } catch (e) {
      debugPrint('[ReturnActions] _ensureCreditNoteForReturn: $e');
    }
  }

  /// Rechazar devolución (envía email al cliente con el motivo)
  Future<bool> rejectReturn({
    required int returnId,
    required String reason,
  }) async {
    final apiSuccess = await _callUpdateReturnApi(
      returnId: returnId,
      status: 'rejected',
      adminNotes: reason,
    );

    // Fallback: actualizar directamente en Supabase + enviar email via Resend
    if (!apiSuccess) {
      debugPrint(
        '[ReturnActions] Fallback a Supabase directo para rejectReturn',
      );
      final supabase = ref.read(supabaseClientProvider);
      await supabase
          .from('returns')
          .update({
            'status': 'rejected',
            'admin_notes': reason,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', returnId);

      // Enviar email directamente via Resend
      final emailSent = await _sendReturnEmail(
        returnId: returnId,
        type: 'rejected',
        rejectionReason: reason,
      );
      _invalidateCache();
      return emailSent;
    }

    _invalidateCache();
    return apiSuccess;
  }

  /// Enviar email de devolución directamente via Resend API
  Future<bool> _sendReturnEmail({
    required int returnId,
    required String type,
    double? refundAmount,
    String? rejectionReason,
    List<Map<String, dynamic>>? attachments,
  }) async {
    try {
      final supabase = ref.read(supabaseClientProvider);
      final returnData = await supabase
          .from('returns')
          .select('customer_email, customer_name, return_number, refund_amount')
          .eq('id', returnId)
          .single();

      final email = returnData['customer_email'] as String? ?? '';
      final name = returnData['customer_name'] as String? ?? 'Cliente';
      final returnNumber =
          returnData['return_number'] as String? ?? 'RET-$returnId';
      final dbRefundAmount = returnData['refund_amount'] as int?;

      if (email.isEmpty) {
        debugPrint(
          '[ReturnActions] No se encontró email del cliente para returnId=$returnId',
        );
        return false;
      }

      bool emailSent = false;
      switch (type) {
        case 'received':
          emailSent = await ResendEmailService.sendReturnReceivedEmail(
            customerEmail: email,
            customerName: name,
            returnNumber: returnNumber,
          );
          break;
        case 'refunded':
          final amount =
              refundAmount ??
              (dbRefundAmount != null ? dbRefundAmount / 100.0 : 0.0);
          emailSent = await ResendEmailService.sendRefundProcessedEmail(
            customerEmail: email,
            customerName: name,
            returnNumber: returnNumber,
            amount: amount,
            attachments: attachments,
          );
          break;
        case 'rejected':
          emailSent = await ResendEmailService.sendReturnRejectedEmail(
            customerEmail: email,
            customerName: name,
            returnNumber: returnNumber,
            reason: rejectionReason ?? 'No se proporcionó motivo',
          );
          break;
      }

      debugPrint('[ReturnActions] Resend email ($type) enviado: $emailSent');
      return emailSent;
    } catch (e) {
      debugPrint('[ReturnActions] Error enviando email via Resend: $e');
      return false;
    }
  }

  /// Actualizar notas del admin (no necesita email)
  Future<void> updateAdminNotes({
    required int returnId,
    required String notes,
  }) async {
    final supabase = ref.read(supabaseClientProvider);

    await supabase
        .from('returns')
        .update({
          'admin_notes': notes,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', returnId);

    _invalidateCache();
  }

  void _invalidateCache() {
    ref.invalidate(returnsProvider);
    ref.invalidate(pendingReturnsProvider);
    ref.invalidate(receivedReturnsProvider);
    ref.invalidate(completedReturnsProvider);
    ref.invalidate(returnsStatsProvider);
  }
}
