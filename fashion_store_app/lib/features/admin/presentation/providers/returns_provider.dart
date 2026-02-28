// Provider para administración de devoluciones

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../config/constants/app_constants.dart';
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
  Future<void> markAsReceived(int returnId) async {
    final apiSuccess = await _callUpdateReturnApi(
      returnId: returnId,
      status: 'received',
    );

    // Fallback: actualizar directamente en Supabase si la API falla (sin email)
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
    }

    _invalidateCache();
  }

  /// Procesar reembolso vía Web API (Stripe refund + email + stock + factura rectificativa)
  Future<void> processRefund({
    required int returnId,
    double? refundAmount,
  }) async {
    final apiSuccess = await _callUpdateReturnApi(
      returnId: returnId,
      status: 'refunded',
      refundAmount: refundAmount,
    );

    // Fallback: solo actualizar estado en Supabase (SIN procesar Stripe, SIN email)
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
    }

    _invalidateCache();
  }

  /// Rechazar devolución (envía email al cliente con el motivo)
  Future<void> rejectReturn({
    required int returnId,
    required String reason,
  }) async {
    final apiSuccess = await _callUpdateReturnApi(
      returnId: returnId,
      status: 'rejected',
      adminNotes: reason,
    );

    // Fallback: actualizar directamente en Supabase (sin email)
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
    }

    _invalidateCache();
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
