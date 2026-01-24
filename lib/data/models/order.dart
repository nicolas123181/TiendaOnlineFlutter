import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

/// Estados posibles de un pedido
enum OrderStatus {
  pending,
  processing,
  paid,
  ready_for_pickup,
  shipped,
  delivered,
  cancelled,
  refunded;

  /// Obtiene el texto en español del estado
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pendiente';
      case OrderStatus.processing:
        return 'Procesando';
      case OrderStatus.paid:
        return 'Pagado';
      case OrderStatus.ready_for_pickup:
        return 'Listo para recoger';
      case OrderStatus.shipped:
        return 'Enviado';
      case OrderStatus.delivered:
        return 'Entregado';
      case OrderStatus.cancelled:
        return 'Cancelado';
      case OrderStatus.refunded:
        return 'Reembolsado';
    }
  }

  /// Crea desde string de la base de datos
  static OrderStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'processing':
        return OrderStatus.processing;
      case 'paid':
        return OrderStatus.paid;
      case 'ready_for_pickup':
        return OrderStatus.ready_for_pickup;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'refunded':
        return OrderStatus.refunded;
      default:
        return OrderStatus.pending;
    }
  }
}

/// Item de un pedido
@freezed
class OrderItem with _$OrderItem {
  const OrderItem._(); // Constructor privado para permitir métodos

  const factory OrderItem({
    required int id,
    @JsonKey(name: 'order_id') required int orderId,
    @JsonKey(name: 'product_id') int? productId,
    @JsonKey(name: 'product_name') required String productName,
    @JsonKey(name: 'product_price') required int productPrice, // En centavos
    required int quantity,
    String? size,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  /// Total del item
  int get totalPrice => productPrice * quantity;
}

/// Modelo de Pedido
@freezed
class Order with _$Order {
  const Order._(); // Constructor privado para permitir métodos

  const factory Order({
    required int id,
    @JsonKey(name: 'customer_email') required String customerEmail,
    @JsonKey(name: 'customer_name') required String customerName,
    @JsonKey(name: 'customer_address') required String customerAddress,
    @JsonKey(name: 'customer_city') required String customerCity,
    @JsonKey(name: 'customer_postal_code') required String customerPostalCode,
    @JsonKey(name: 'customer_phone') String? customerPhone,
    @Default('pending') String status,
    required int total, // En centavos
    int? subtotal, // En centavos
    @Default(0) int discount, // En centavos
    @JsonKey(name: 'shipping_cost') @Default(0) int shippingCost, // En centavos
    @JsonKey(name: 'shipping_method_id') int? shippingMethodId,
    @JsonKey(name: 'carrier_id') int? carrierId,
    @JsonKey(includeFromJson: false, includeToJson: false) String? carrierName,
    @JsonKey(name: 'tracking_number') String? trackingNumber,
    @JsonKey(name: 'stripe_payment_intent_id') String? stripePaymentIntentId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'order_items', includeToJson: false)
    @Default([])
    List<OrderItem> items,
  }) = _Order;

  /// Factory personalizado para manejar JSON de Supabase
  factory Order.fromJson(Map<String, dynamic> json) {
    // Parsear items si vienen incluidos
    List<OrderItem> itemsList = [];
    if (json['order_items'] != null && json['order_items'] is List) {
      itemsList = (json['order_items'] as List)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    // Obtener nombre del carrier si viene incluido
    String? carrierName;
    if (json['shipping_carriers'] != null) {
      carrierName = (json['shipping_carriers'] as Map<String, dynamic>)['name']
          as String?;
    }

    return Order(
      id: json['id'] as int,
      customerEmail: json['customer_email'] as String,
      customerName: json['customer_name'] as String,
      customerAddress: json['customer_address'] as String,
      customerCity: json['customer_city'] as String,
      customerPostalCode: json['customer_postal_code'] as String,
      customerPhone: json['customer_phone'] as String?,
      status: json['status'] as String? ?? 'pending',
      total: json['total'] as int,
      subtotal: json['subtotal'] as int?,
      discount: json['discount'] as int? ?? 0,
      shippingCost: json['shipping_cost'] as int? ?? 0,
      shippingMethodId: json['shipping_method_id'] as int?,
      carrierId: json['carrier_id'] as int?,
      carrierName: carrierName,
      trackingNumber: json['tracking_number'] as String?,
      stripePaymentIntentId: json['stripe_payment_intent_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      items: itemsList,
    );
  }

  /// Texto del estado en español
  String get statusText {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'paid':
        return 'Pagado';
      case 'ready_for_pickup':
        return 'Listo para recoger';
      case 'shipped':
        return 'Enviado';
      case 'delivered':
        return 'Entregado';
      case 'cancelled':
        return 'Cancelado';
      default:
        return status;
    }
  }

  /// Verifica si el pedido puede ser cancelado
  bool get canBeCancelled => status == 'pending' || status == 'paid';

  /// Verifica si el pedido puede solicitar devolución
  bool get canRequestReturn => status == 'delivered';

  /// Verifica si el pedido tiene tracking
  bool get hasTracking => trackingNumber != null && trackingNumber!.isNotEmpty;

  /// Verifica si el pedido está en progreso
  bool get isInProgress =>
      status == 'pending' ||
      status == 'paid' ||
      status == 'ready_for_pickup' ||
      status == 'shipped';

  /// Verifica si el pedido está completado
  bool get isCompleted => status == 'delivered';

  /// Verifica si el pedido está cancelado
  bool get isCancelled => status == 'cancelled';

  /// IVA calculado (21%)
  int get taxAmount {
    final baseAmount = (subtotal ?? total) - discount;
    return (baseAmount * 0.21).round();
  }

  /// Cantidad total de items
  int get totalItemsCount => items.fold(0, (sum, item) => sum + item.quantity);
}
