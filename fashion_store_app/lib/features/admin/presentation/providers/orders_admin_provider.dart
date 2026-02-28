// Provider para administración de pedidos

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../config/constants/app_constants.dart';
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

  /// Cambiar estado del pedido via Web API (envía emails) con fallback a Supabase directo
  Future<void> updateOrderStatus({
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

    // Fallback: actualizar directamente en Supabase (sin email)
    if (!apiSuccess) {
      debugPrint(
        '[OrderActions] Fallback a Supabase directo (sin email) para orderId=$orderId',
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
    }

    // Invalidar todos los caches de pedidos
    ref.invalidate(ordersListProvider);
    ref.invalidate(activeOrdersProvider);
    ref.invalidate(completedOrdersProvider);
  }

  /// Cancelar pedido
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
          'updated_at': DateTime.now().toIso8601String(),
          if (stripeRefundId != null) 'stripe_refund_id': stripeRefundId,
        })
        .eq('id', orderId);

    ref.invalidate(ordersListProvider);
    ref.invalidate(activeOrdersProvider);
    ref.invalidate(completedOrdersProvider);
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
