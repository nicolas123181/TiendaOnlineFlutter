// Provider para administración de pedidos

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../config/constants/app_constants.dart';
import '../../../../shared/services/invoice_service.dart';
import '../../../../shared/services/resend_email_service.dart';
import '../../../../shared/services/supabase_service.dart';

/// Provider para obtener lista de TODOS los pedidos (para lista completa)
final ordersListProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final supabase = ref.read(supabaseClientProvider);

  final response = await supabase
      .from('orders')
      .select('*, order_items(*), shipping_carriers(*)')
      .order('created_at', ascending: false);

  return List<Map<String, dynamic>>.from(response);
});

/// Provider para obtener pedidos activos (paid, ready_for_pickup, shipped)
final activeOrdersProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final supabase = ref.read(supabaseClientProvider);

  final response = await supabase
      .from('orders')
      .select('*, order_items(*)')
      .inFilter('status', ['paid', 'ready_for_pickup', 'shipped'])
      .order('created_at', ascending: true);

  return List<Map<String, dynamic>>.from(response);
});

/// Provider para obtener pedidos completados (delivered, cancelled)
final completedOrdersProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final supabase = ref.read(supabaseClientProvider);

  final response = await supabase
      .from('orders')
      .select('*, order_items(*)')
      .inFilter('status', ['delivered', 'cancelled'])
      .order('created_at', ascending: false)
      .limit(100);

  return List<Map<String, dynamic>>.from(response);
});

/// Provider para obtener métodos de envío
final shippingMethodsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final supabase = ref.read(supabaseClientProvider);

  final response = await supabase.from('shipping_methods').select('*');

  return List<Map<String, dynamic>>.from(response);
});

/// Provider para obtener transportistas activos
final shippingCarriersProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final supabase = ref.read(supabaseClientProvider);

  final response = await supabase
      .from('shipping_carriers')
      .select('*')
      .eq('is_active', true)
      .order('display_order');

  return List<Map<String, dynamic>>.from(response);
});

/// Provider para acciones de pedidos
final orderActionsProvider = Provider((ref) {
  return OrderActions(ref);
});

class OrderActions {
  final Ref ref;

  OrderActions(this.ref);

  /// Cambiar estado del pedido via Web API (envía emails) con fallback a Supabase directo.
  /// Retorna true si la API web tuvo éxito (email enviado), false si usó fallback.
  Future<bool> updateOrderStatus({
    required int orderId,
    required String newStatus,
    String? trackingNumber,
    int? shippingCarrierId,
  }) async {
    final supabase = ref.read(supabaseClientProvider);

    // Obtener datos del pedido para el email (customer info)
    String? customerEmail;
    String? customerName;
    String? carrierName;
    String? trackingUrlTemplate;

    try {
      final order = await supabase
          .from('orders')
          .select('customer_email, customer_name')
          .eq('id', orderId)
          .single();
      customerEmail = order['customer_email'] as String?;
      customerName = order['customer_name'] as String?;
    } catch (_) {
      // Si no podemos obtener datos del cliente, continuamos sin email
    }

    // Obtener datos del transportista si aplica
    if (newStatus == 'shipped' && shippingCarrierId != null) {
      try {
        final carrier = await supabase
            .from('shipping_carriers')
            .select('name, tracking_url_template')
            .eq('id', shippingCarrierId)
            .single();
        carrierName = carrier['name'] as String?;
        trackingUrlTemplate = carrier['tracking_url_template'] as String?;
      } catch (_) {
        // Continuamos sin datos del transportista
      }
    }

    // Intentar vía Web API (actualiza BD + envía email)
    bool apiSuccess = false;
    final apiKey = AppConstants.adminApiKey;
    final baseUrl = AppConstants.webApiBaseUrl;

    debugPrint(
      '[OrderActions] apiKey empty: ${apiKey.isEmpty}, customerEmail: $customerEmail, baseUrl: $baseUrl',
    );

    if (apiKey.isNotEmpty && customerEmail != null) {
      try {
        final body = <String, dynamic>{
          'orderId': orderId,
          'status': newStatus,
          'customerEmail': customerEmail,
          'customerName': customerName ?? 'Cliente',
        };

        if (newStatus == 'shipped' &&
            shippingCarrierId != null &&
            trackingNumber != null) {
          body['carrierId'] = shippingCarrierId;
          body['carrierName'] = carrierName ?? '';
          body['trackingNumber'] = trackingNumber;
          if (trackingUrlTemplate != null) {
            body['trackingUrlTemplate'] = trackingUrlTemplate;
          }
        }

        debugPrint(
          '[OrderActions] Llamando a $baseUrl/api/admin/update-order-status con status=$newStatus',
        );

        final response = await http
            .post(
              Uri.parse('$baseUrl/api/admin/update-order-status'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $apiKey',
              },
              body: jsonEncode(body),
            )
            .timeout(const Duration(seconds: 15));

        debugPrint(
          '[OrderActions] Respuesta API: ${response.statusCode} - ${response.body}',
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['success'] == true) {
            apiSuccess = true;
            debugPrint(
              '[OrderActions] API exitosa. Email enviado: ${data['emailSent']}',
            );
          }
        }
      } catch (e) {
        debugPrint('[OrderActions] Error llamando API web: $e');
      }
    } else {
      debugPrint(
        '[OrderActions] Saltando API web: apiKey empty=${apiKey.isEmpty}, email=$customerEmail',
      );
    }

    // Fallback: actualizar directamente en Supabase + enviar email via Resend
    if (!apiSuccess) {
      debugPrint(
        '[OrderActions] Fallback a Supabase directo para orderId=$orderId',
      );
      final updateData = <String, dynamic>{
        'status': newStatus,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (newStatus == 'shipped' &&
          shippingCarrierId != null &&
          trackingNumber != null) {
        updateData['carrier_id'] = shippingCarrierId;
        updateData['tracking_number'] = trackingNumber;
      }

      await supabase.from('orders').update(updateData).eq('id', orderId);

      // Enviar email directamente via Resend API
      if (customerEmail != null && customerEmail.isNotEmpty) {
        bool emailSent = false;
        try {
          switch (newStatus) {
            case 'ready_for_pickup':
              emailSent = await ResendEmailService.sendReadyForPickupEmail(
                orderId: orderId,
                customerEmail: customerEmail,
                customerName: customerName ?? 'Cliente',
              );
              break;
            case 'shipped':
              String? trackingUrl;
              if (trackingUrlTemplate != null && trackingNumber != null) {
                trackingUrl = trackingUrlTemplate.replaceAll(
                  '{tracking}',
                  trackingNumber,
                );
              }
              emailSent = await ResendEmailService.sendShippedEmail(
                orderId: orderId,
                customerEmail: customerEmail,
                customerName: customerName ?? 'Cliente',
                carrierName: carrierName,
                trackingNumber: trackingNumber,
                trackingUrl: trackingUrl,
              );
              break;
            case 'delivered':
              emailSent = await ResendEmailService.sendDeliveredEmail(
                orderId: orderId,
                customerEmail: customerEmail,
                customerName: customerName ?? 'Cliente',
              );
              break;
          }
          debugPrint('[OrderActions] Resend email enviado: $emailSent');
          if (emailSent) {
            // Email enviado directamente via Resend
            ref.invalidate(ordersListProvider);
            ref.invalidate(activeOrdersProvider);
            ref.invalidate(completedOrdersProvider);
            return true;
          }
        } catch (e) {
          debugPrint('[OrderActions] Error enviando email via Resend: $e');
        }
      }
    }

    // Invalidar todos los caches de pedidos
    ref.invalidate(ordersListProvider);
    ref.invalidate(activeOrdersProvider);
    ref.invalidate(completedOrdersProvider);
    return apiSuccess;
  }

  /// Cancelar pedido (restaurar stock + factura rectificativa + email con PDF)
  Future<void> cancelOrder({
    required int orderId,
    required String reason,
    String? stripeRefundId,
  }) async {
    final supabase = ref.read(supabaseClientProvider);

    // 1. Actualizar estado del pedido
    await supabase
        .from('orders')
        .update({
          'status': 'cancelled',
          'cancellation_reason': reason,
          'cancelled_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
          if (stripeRefundId != null) 'stripe_refund_id': stripeRefundId,
        })
        .eq('id', orderId);

    // 2. Obtener datos del pedido con items para restaurar stock + credit note
    try {
      final order = await supabase
          .from('orders')
          .select('*, order_items(*)')
          .eq('id', orderId)
          .single();

      final customerName = order['customer_name'] as String? ?? 'Cliente';
      final customerEmail = order['customer_email'] as String? ?? '';
      final totalAmount = (order['total'] as num?)?.toInt() ?? 0;
      final orderItems = order['order_items'] as List<dynamic>? ?? [];

      final invoiceService = InvoiceService(supabase);

      // 3. Restaurar stock de todos los productos del pedido
      if (orderItems.isNotEmpty) {
        final stockItems = orderItems.map((item) {
          final m = item as Map<String, dynamic>;
          return {
            'product_id': m['product_id'],
            'quantity': m['quantity'] ?? 1,
            'size': m['size'] ?? m['product_size'],
          };
        }).toList();
        await invoiceService.restoreStock(stockItems);
        debugPrint('[OrderActions] Stock restaurado para pedido #$orderId');
      }

      // 4. Crear factura rectificativa
      final creditNoteItems = orderItems.map((item) {
        final m = item as Map<String, dynamic>;
        return CreditNoteItem(
          productId: (m['product_id'] as num?)?.toInt(),
          productName: m['product_name'] as String? ?? 'Producto',
          productSize: m['size'] as String? ?? m['product_size'] as String?,
          quantity: (m['quantity'] as num?)?.toInt() ?? 1,
          unitPrice:
              (m['unit_price'] as num?)?.toInt() ??
              (m['price'] as num?)?.toInt() ??
              0,
        );
      }).toList();

      List<Map<String, dynamic>>? attachments;

      final creditNote = await invoiceService.createCreditNote(
        orderId: orderId,
        customerName: customerName,
        customerEmail: customerEmail,
        items: creditNoteItems,
        refundAmountCents: totalAmount,
        notes: 'Cancelación de pedido #$orderId. Motivo: $reason',
      );

      // 5. Intentar descargar PDF de la factura rectificativa
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
          debugPrint('[OrderActions] PDF adjuntado para factura #$invoiceId');
        }
      }

      // 6. Enviar email de cancelación con PDF adjunto
      if (customerEmail.isNotEmpty) {
        final emailSent = await ResendEmailService.sendOrderCancelledEmail(
          orderId: orderId,
          customerEmail: customerEmail,
          customerName: customerName,
          totalAmount: totalAmount / 100.0,
          attachments: attachments,
        );
        debugPrint('[OrderActions] Email cancelación enviado: $emailSent');
      }
    } catch (e) {
      debugPrint(
        '[OrderActions] Error en credit note/stock restore para cancelación: $e',
      );
      // El pedido ya fue marcado como cancelled, solo falló la parte extra
    }

    await _ensureCreditNoteForCancelledOrder(orderId: orderId, reason: reason);

    ref.invalidate(ordersListProvider);
    ref.invalidate(activeOrdersProvider);
    ref.invalidate(completedOrdersProvider);
  }

  Future<void> _ensureCreditNoteForCancelledOrder({
    required int orderId,
    required String reason,
  }) async {
    final supabase = ref.read(supabaseClientProvider);

    try {
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

      final order = await supabase
          .from('orders')
          .select('*, order_items(*)')
          .eq('id', orderId)
          .single();

      final customerName = order['customer_name'] as String? ?? 'Cliente';
      final customerEmail = order['customer_email'] as String? ?? '';
      final totalAmount = (order['total'] as num?)?.toInt() ?? 0;
      final orderItems = order['order_items'] as List<dynamic>? ?? [];

      if (customerEmail.isEmpty || orderItems.isEmpty || totalAmount <= 0) {
        return;
      }

      final creditNoteItems = orderItems.map((item) {
        final m = item as Map<String, dynamic>;
        return CreditNoteItem(
          productId: (m['product_id'] as num?)?.toInt(),
          productName: m['product_name'] as String? ?? 'Producto',
          productSize: m['size'] as String? ?? m['product_size'] as String?,
          quantity: (m['quantity'] as num?)?.toInt() ?? 1,
          unitPrice:
              (m['unit_price'] as num?)?.toInt() ??
              (m['price'] as num?)?.toInt() ??
              0,
        );
      }).toList();

      final invoiceService = InvoiceService(supabase);
      await invoiceService.createCreditNote(
        orderId: orderId,
        customerName: customerName,
        customerEmail: customerEmail,
        items: creditNoteItems,
        refundAmountCents: totalAmount,
        notes: 'Cancelación de pedido #$orderId. Motivo: $reason',
      );
    } catch (e) {
      debugPrint('[OrderActions] _ensureCreditNoteForCancelledOrder: $e');
    }
  }

  /// Marcar como entregado
  Future<bool> markAsDelivered(int orderId) async {
    return updateOrderStatus(orderId: orderId, newStatus: 'delivered');
  }

  /// Obtener detalles de un pedido
  Future<Map<String, dynamic>> getOrderDetails(int orderId) async {
    final supabase = ref.read(supabaseClientProvider);

    final response = await supabase
        .from('orders')
        .select('*, order_items(*), shipping_carriers(*)')
        .eq('id', orderId)
        .single();

    return response;
  }
}
