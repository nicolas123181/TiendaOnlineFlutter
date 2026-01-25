// Provider para administración de devoluciones

import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  /// Marcar devolución como recibida
  Future<void> markAsReceived(int returnId) async {
    final supabase = ref.read(supabaseClientProvider);

    await supabase
        .from('returns')
        .update({
          'status': 'received',
          'received_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', returnId);

    _invalidateCache();
  }

  /// Procesar reembolso
  Future<void> processRefund({
    required int returnId,
    String? stripeRefundId,
  }) async {
    final supabase = ref.read(supabaseClientProvider);

    await supabase
        .from('returns')
        .update({
          'status': 'refunded',
          'refunded_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
          if (stripeRefundId != null) 'stripe_refund_id': stripeRefundId,
        })
        .eq('id', returnId);

    _invalidateCache();
  }

  /// Rechazar devolución
  Future<void> rejectReturn({
    required int returnId,
    required String reason,
  }) async {
    final supabase = ref.read(supabaseClientProvider);

    await supabase
        .from('returns')
        .update({
          'status': 'rejected',
          'admin_notes': reason,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', returnId);

    _invalidateCache();
  }

  /// Actualizar notas del admin
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
