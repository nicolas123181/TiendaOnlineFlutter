import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

/// Modelo de Pedido
@freezed
abstract class OrderModel with _$OrderModel {
  const OrderModel._();

  const factory OrderModel({
    required int id,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'customer_email') required String customerEmail,
    @JsonKey(name: 'customer_name') String? customerName,
    @JsonKey(name: 'customer_phone') String? customerPhone,
    @Default('pending') String status,
    @JsonKey(name: 'payment_status') @Default('pending') String paymentStatus,
    @JsonKey(name: 'payment_method') String? paymentMethod,
    required int subtotal,
    @Default(0) int discount,
    @JsonKey(name: 'shipping_cost') @Default(0) int shippingCost,
    required int total,
    @JsonKey(name: 'shipping_address') String? shippingAddress,
    @JsonKey(name: 'shipping_city') String? shippingCity,
    @JsonKey(name: 'shipping_postal_code') String? shippingPostalCode,
    @JsonKey(name: 'billing_address') String? billingAddress,
    String? notes,
    @JsonKey(name: 'tracking_number') String? trackingNumber,
    @Default(<OrderItemModel>[]) List<OrderItemModel> items,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'shipped_at') DateTime? shippedAt,
    @JsonKey(name: 'delivered_at') DateTime? deliveredAt,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  // ============================================
  // PROPIEDADES COMPUTADAS
  // ============================================

  /// Estado de visualización
  String get displayStatus {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'confirmed':
        return 'Confirmado';
      case 'processing':
        return 'En proceso';
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

  /// Color del estado
  int get statusColorValue {
    switch (status) {
      case 'pending':
        return 0xFFFFA726; // Orange
      case 'confirmed':
        return 0xFF42A5F5; // Blue
      case 'processing':
        return 0xFF7E57C2; // Purple
      case 'shipped':
        return 0xFF26A69A; // Teal
      case 'delivered':
        return 0xFF66BB6A; // Green
      case 'cancelled':
        return 0xFFEF5350; // Red
      default:
        return 0xFF9E9E9E; // Grey
    }
  }

  /// ¿Puede cancelarse?
  bool get canCancel => status == 'pending' || status == 'confirmed';

  /// Número de items
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

/// Modelo de Item del Pedido
@freezed
abstract class OrderItemModel with _$OrderItemModel {
  const OrderItemModel._();

  const factory OrderItemModel({
    required int id,
    @JsonKey(name: 'order_id') required int orderId,
    @JsonKey(name: 'product_id') required int productId,
    @JsonKey(name: 'product_name') required String productName,
    @JsonKey(name: 'product_image') String? productImage,
    String? size,
    required int quantity,
    @JsonKey(name: 'unit_price') required int unitPrice,
    required int subtotal,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  /// Precio formateado
  String get formattedPrice => '${(unitPrice / 100).toStringAsFixed(2)} €';

  /// Subtotal formateado
  String get formattedSubtotal => '${(subtotal / 100).toStringAsFixed(2)} €';
}
