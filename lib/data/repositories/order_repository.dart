import '../models/order.dart';
import '../models/cart_item.dart';
import '../models/shipping_address.dart';
import '../models/shipping_method.dart';
import '../models/coupon.dart';
import '../../core/services/supabase_service.dart';
import '../../core/services/stripe_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

/// Repositorio de pedidos
class OrderRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;
  final StripeService _stripeService = StripeService.instance;

  /// Obtiene los pedidos del usuario actual
  Future<List<Order>> getUserOrders({int limit = 20}) async {
    try {
      return await _supabaseService.getUserOrders(limit: limit);
    } catch (e) {
      return [];
    }
  }

  /// Obtiene un pedido por ID
  Future<Order?> getOrderById(String orderId) async {
    try {
      return await _supabaseService.getOrderById(orderId);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene un pedido por número de pedido
  Future<Order?> getOrderByNumber(String orderNumber) async {
    try {
      return await _supabaseService.getOrderByNumber(orderNumber);
    } catch (e) {
      return null;
    }
  }

  /// Crea un nuevo pedido
  Future<OrderResult> createOrder({
    required List<CartItem> items,
    required ShippingAddress address,
    required ShippingMethod shippingMethod,
    Coupon? coupon,
    String? notes,
  }) async {
    try {
      // Calcular totales
      final subtotal = items.fold(0, (sum, item) => sum + item.totalPrice);
      final shippingCost = shippingMethod.price;
      final discount = coupon?.calculateDiscount(subtotal) ?? 0;
      final taxRate = 21.0; // 21% IVA
      final taxableAmount = subtotal - discount + shippingCost;
      final taxAmount = (taxableAmount * taxRate / 100).round();
      final total = taxableAmount + taxAmount;

      // Crear el pedido en Supabase
      final order = await _supabaseService.createOrder(
        items: items,
        shippingAddressId: address.id,
        shippingMethodId: shippingMethod.id,
        couponId: coupon?.id,
        subtotal: subtotal,
        shippingCost: shippingCost,
        discount: discount,
        taxAmount: taxAmount,
        total: total,
        notes: notes,
      );

      if (order == null) {
        return OrderResult.error(message: 'Error al crear el pedido');
      }

      return OrderResult.success(order: order);
    } catch (e) {
      return OrderResult.error(message: 'Error al crear el pedido: $e');
    }
  }

  /// Procesa el pago de un pedido
  Future<PaymentResult> processPayment({
    required Order order,
    required String paymentMethodId,
  }) async {
    try {
      // Crear intención de pago en Stripe
      final paymentIntent = await _stripeService.createPaymentIntent(
        amount: order.total,
        currency: 'eur',
        customerEmail: order.customerEmail,
        metadata: {
          'order_id': order.id.toString(),
        },
      );

      if (paymentIntent['client_secret'] == null) {
        return PaymentResult.error(
            message: 'Error al crear la intención de pago');
      }

      // Confirmar el pago
      final confirmed = await _stripeService.confirmPayment(
        clientSecret: paymentIntent['client_secret'] as String,
      );

      final isPaid = confirmed.status == PaymentIntentsStatus.Succeeded ||
          confirmed.status == PaymentIntentsStatus.RequiresCapture;

      if (isPaid) {
        // Actualizar estado del pedido
        await _supabaseService.updateOrderStatus(
          order.id.toString(),
          OrderStatus.processing.name,
        );

        await _supabaseService.updateOrderPaymentStatus(
          order.id.toString(),
          'paid',
          paymentIntent['id'] as String?,
        );

        return PaymentResult.success(
          paymentIntentId: paymentIntent['id'] as String?,
          message: 'Pago procesado correctamente',
        );
      } else {
        return PaymentResult.error(message: 'El pago no pudo ser confirmado');
      }
    } catch (e) {
      return PaymentResult.error(message: 'Error al procesar el pago: $e');
    }
  }

  /// Cancela un pedido
  Future<OrderResult> cancelOrder(String orderId) async {
    try {
      final order = await _supabaseService.getOrderById(orderId);

      if (order == null) {
        return OrderResult.error(message: 'Pedido no encontrado');
      }

      if (!order.canBeCancelled) {
        return OrderResult.error(
          message: 'Este pedido no puede ser cancelado',
        );
      }

      await _supabaseService.updateOrderStatus(
        orderId,
        OrderStatus.cancelled.name,
      );

      final updatedOrder = order.copyWith(
        status: OrderStatus.cancelled.name,
        updatedAt: DateTime.now(),
      );

      return OrderResult.success(
        order: updatedOrder,
        message: 'Pedido cancelado correctamente',
      );
    } catch (e) {
      return OrderResult.error(message: 'Error al cancelar el pedido: $e');
    }
  }

  /// Rastrea un pedido por número de seguimiento
  Future<TrackingInfo?> trackOrder(String orderId) async {
    try {
      final order = await _supabaseService.getOrderById(orderId);
      if (order == null) return null;

      final status = OrderStatus.fromString(order.status);

      return TrackingInfo(
        orderNumber: order.id.toString(),
        status: status,
        trackingNumber: order.trackingNumber,
        trackingUrl: null,
        estimatedDelivery: null,
        statusHistory: _generateStatusHistory(order),
      );
    } catch (e) {
      return null;
    }
  }

  List<TrackingStep> _generateStatusHistory(Order order) {
    final steps = <TrackingStep>[];
    final statuses = [
      OrderStatus.pending,
      OrderStatus.processing,
      OrderStatus.shipped,
      OrderStatus.delivered,
    ];

    final currentStatus = OrderStatus.fromString(order.status);
    final currentStatusIndex = statuses.indexOf(currentStatus);

    for (int i = 0; i < statuses.length; i++) {
      final status = statuses[i];
      steps.add(TrackingStep(
        status: status,
        title: _getStatusTitle(status),
        description: _getStatusDescription(status),
        isCompleted:
            i <= currentStatusIndex && currentStatus != OrderStatus.cancelled,
        isCurrent:
            i == currentStatusIndex && currentStatus != OrderStatus.cancelled,
        timestamp: i <= currentStatusIndex ? order.updatedAt : null,
      ));
    }

    return steps;
  }

  String _getStatusTitle(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pedido recibido';
      case OrderStatus.processing:
        return 'En preparación';
      case OrderStatus.shipped:
        return 'Enviado';
      case OrderStatus.delivered:
        return 'Entregado';
      case OrderStatus.paid:
        return 'Pago confirmado';
      case OrderStatus.cancelled:
        return 'Cancelado';
      case OrderStatus.refunded:
        return 'Reembolsado';
      case OrderStatus.ready_for_pickup:
        return 'Listo para recoger';
    }
  }

  String _getStatusDescription(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Hemos recibido tu pedido';
      case OrderStatus.processing:
        return 'Estamos preparando tu pedido';
      case OrderStatus.shipped:
        return 'Tu pedido está en camino';
      case OrderStatus.delivered:
        return 'Pedido entregado';
      case OrderStatus.paid:
        return 'Pago verificado correctamente';
      case OrderStatus.cancelled:
        return 'Pedido cancelado';
      case OrderStatus.refunded:
        return 'Pedido reembolsado';
      case OrderStatus.ready_for_pickup:
        return 'Tu pedido está listo para recoger';
    }
  }

  // ==================== Admin Methods ====================

  /// Obtiene todos los pedidos (Admin)
  Future<OrdersResult> getAllOrders({
    int page = 1,
    int limit = 20,
    String? status,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final result = await _supabaseService.getAllOrders(
        page: page,
        limit: limit,
        status: status,
        searchQuery: searchQuery,
        startDate: startDate,
        endDate: endDate,
      );

      return OrdersResult.success(
        orders: result['orders'] as List<Order>,
        total: result['total'] as int,
        hasMore: result['hasMore'] as bool,
      );
    } catch (e) {
      return OrdersResult.error(message: 'Error al cargar pedidos: $e');
    }
  }

  /// Actualiza el estado de un pedido (Admin)
  Future<OrderResult> updateOrderStatus(
    String orderId,
    OrderStatus status, {
    String? trackingNumber,
    String? trackingUrl,
  }) async {
    try {
      await _supabaseService.updateOrderStatus(orderId, status.name);

      if (trackingNumber != null) {
        await _supabaseService.updateOrderTracking(
          orderId,
          trackingNumber,
          trackingUrl,
        );
      }

      final updatedOrder = await _supabaseService.getOrderById(orderId);

      return OrderResult.success(
        order: updatedOrder,
        message: 'Estado actualizado correctamente',
      );
    } catch (e) {
      return OrderResult.error(message: 'Error al actualizar estado: $e');
    }
  }

  /// Obtiene estadísticas de pedidos (Admin)
  Future<OrderStats> getOrderStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final stats = await _supabaseService.getOrderStats(
        startDate: startDate,
        endDate: endDate,
      );

      return OrderStats(
        totalOrders: stats['totalOrders'] as int? ?? 0,
        pendingOrders: stats['pendingOrders'] as int? ?? 0,
        processingOrders: stats['processingOrders'] as int? ?? 0,
        shippedOrders: stats['shippedOrders'] as int? ?? 0,
        deliveredOrders: stats['deliveredOrders'] as int? ?? 0,
        cancelledOrders: stats['cancelledOrders'] as int? ?? 0,
        totalRevenue: stats['totalRevenue'] as int? ?? 0,
        averageOrderValue: stats['averageOrderValue'] as int? ?? 0,
      );
    } catch (e) {
      return OrderStats.empty();
    }
  }
}

/// Resultado de operaciones de pedidos
class OrderResult {
  final bool isSuccess;
  final Order? order;
  final String? message;

  OrderResult._({
    required this.isSuccess,
    this.order,
    this.message,
  });

  factory OrderResult.success({Order? order, String? message}) {
    return OrderResult._(
      isSuccess: true,
      order: order,
      message: message,
    );
  }

  factory OrderResult.error({required String message}) {
    return OrderResult._(
      isSuccess: false,
      message: message,
    );
  }
}

/// Resultado de consulta de pedidos
class OrdersResult {
  final bool isSuccess;
  final List<Order> orders;
  final int total;
  final bool hasMore;
  final String? errorMessage;

  OrdersResult._({
    required this.isSuccess,
    this.orders = const [],
    this.total = 0,
    this.hasMore = false,
    this.errorMessage,
  });

  factory OrdersResult.success({
    required List<Order> orders,
    required int total,
    required bool hasMore,
  }) {
    return OrdersResult._(
      isSuccess: true,
      orders: orders,
      total: total,
      hasMore: hasMore,
    );
  }

  factory OrdersResult.error({required String message}) {
    return OrdersResult._(
      isSuccess: false,
      errorMessage: message,
    );
  }
}

/// Resultado de pago
class PaymentResult {
  final bool isSuccess;
  final String? paymentIntentId;
  final String? message;

  PaymentResult._({
    required this.isSuccess,
    this.paymentIntentId,
    this.message,
  });

  factory PaymentResult.success({String? paymentIntentId, String? message}) {
    return PaymentResult._(
      isSuccess: true,
      paymentIntentId: paymentIntentId,
      message: message,
    );
  }

  factory PaymentResult.error({required String message}) {
    return PaymentResult._(
      isSuccess: false,
      message: message,
    );
  }
}

/// Información de seguimiento
class TrackingInfo {
  final String orderNumber;
  final OrderStatus status;
  final String? trackingNumber;
  final String? trackingUrl;
  final DateTime? estimatedDelivery;
  final List<TrackingStep> statusHistory;

  TrackingInfo({
    required this.orderNumber,
    required this.status,
    this.trackingNumber,
    this.trackingUrl,
    this.estimatedDelivery,
    required this.statusHistory,
  });
}

/// Paso de seguimiento
class TrackingStep {
  final OrderStatus status;
  final String title;
  final String description;
  final bool isCompleted;
  final bool isCurrent;
  final DateTime? timestamp;

  TrackingStep({
    required this.status,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.isCurrent,
    this.timestamp,
  });
}

/// Estadísticas de pedidos
class OrderStats {
  final int totalOrders;
  final int pendingOrders;
  final int processingOrders;
  final int shippedOrders;
  final int deliveredOrders;
  final int cancelledOrders;
  final int totalRevenue;
  final int averageOrderValue;

  OrderStats({
    required this.totalOrders,
    required this.pendingOrders,
    required this.processingOrders,
    required this.shippedOrders,
    required this.deliveredOrders,
    required this.cancelledOrders,
    required this.totalRevenue,
    required this.averageOrderValue,
  });

  factory OrderStats.empty() {
    return OrderStats(
      totalOrders: 0,
      pendingOrders: 0,
      processingOrders: 0,
      shippedOrders: 0,
      deliveredOrders: 0,
      cancelledOrders: 0,
      totalRevenue: 0,
      averageOrderValue: 0,
    );
  }
}
