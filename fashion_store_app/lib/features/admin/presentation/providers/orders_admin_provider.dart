// Provider para administración de pedidos

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/services/supabase_service.dart';

/// Provider para obtener lista de pedidos
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

/// Provider para obtener pedidos pendientes
final pendingOrdersProvider = FutureProvider<List<Map<String, dynamic>>>((
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

/// Provider para acciones de pedidos
final orderActionsProvider = Provider((ref) {
  return OrderActions(ref);
});

class OrderActions {
  final Ref ref;

  OrderActions(this.ref);

  /// Cambiar estado del pedido
  Future<void> updateOrderStatus({
    required int orderId,
    required String newStatus,
    String? trackingNumber,
    int? shippingCarrierId,
  }) async {
    final supabase = ref.read(supabaseClientProvider);

    final updateData = <String, dynamic>{'status': newStatus};

    if (trackingNumber != null) {
      updateData['tracking_number'] = trackingNumber;
    }

    if (shippingCarrierId != null) {
      updateData['shipping_carrier_id'] = shippingCarrierId;
    }

    // Actualizar fecha de envío si está listo o enviado
    if (newStatus == 'shipped') {
      updateData['shipped_at'] = DateTime.now().toIso8601String();
    }

    await supabase.from('orders').update(updateData).eq('id', orderId);

    // Invalidar el cache
    ref.invalidate(ordersListProvider);
    ref.invalidate(pendingOrdersProvider);
  }

  /// Cancelar pedido y procesar reembolso
  Future<void> cancelOrder({
    required int orderId,
    required String reason,
    String? stripeRefundId,
  }) async {
    final supabase = ref.read(supabaseClientProvider);

    await supabase
        .from('orders')
        .update({
          'status': 'cancelled',
          'cancellation_reason': reason,
          'cancelled_at': DateTime.now().toIso8601String(),
          if (stripeRefundId != null) 'stripe_refund_id': stripeRefundId,
        })
        .eq('id', orderId);

    // Invalidar el cache
    ref.invalidate(ordersListProvider);
    ref.invalidate(pendingOrdersProvider);
  }

  /// Marcar como entregado
  Future<void> markAsDelivered(int orderId) async {
    await updateOrderStatus(orderId: orderId, newStatus: 'delivered');
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
