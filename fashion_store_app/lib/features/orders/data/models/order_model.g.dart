// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => _OrderModel(
  id: (json['id'] as num).toInt(),
  userId: json['user_id'] as String?,
  customerEmail: json['customer_email'] as String,
  customerName: json['customer_name'] as String?,
  customerPhone: json['customer_phone'] as String?,
  status: json['status'] as String? ?? 'pending',
  paymentStatus: json['payment_status'] as String? ?? 'pending',
  paymentMethod: json['payment_method'] as String?,
  subtotal: (json['subtotal'] as num).toInt(),
  discount: (json['discount'] as num?)?.toInt() ?? 0,
  shippingCost: (json['shipping_cost'] as num?)?.toInt() ?? 0,
  total: (json['total'] as num).toInt(),
  shippingAddress: json['shipping_address'] as String?,
  shippingCity: json['shipping_city'] as String?,
  shippingPostalCode: json['shipping_postal_code'] as String?,
  billingAddress: json['billing_address'] as String?,
  notes: json['notes'] as String?,
  trackingNumber: json['tracking_number'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <OrderItemModel>[],
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  shippedAt: json['shipped_at'] == null
      ? null
      : DateTime.parse(json['shipped_at'] as String),
  deliveredAt: json['delivered_at'] == null
      ? null
      : DateTime.parse(json['delivered_at'] as String),
);

Map<String, dynamic> _$OrderModelToJson(_OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'customer_email': instance.customerEmail,
      'customer_name': instance.customerName,
      'customer_phone': instance.customerPhone,
      'status': instance.status,
      'payment_status': instance.paymentStatus,
      'payment_method': instance.paymentMethod,
      'subtotal': instance.subtotal,
      'discount': instance.discount,
      'shipping_cost': instance.shippingCost,
      'total': instance.total,
      'shipping_address': instance.shippingAddress,
      'shipping_city': instance.shippingCity,
      'shipping_postal_code': instance.shippingPostalCode,
      'billing_address': instance.billingAddress,
      'notes': instance.notes,
      'tracking_number': instance.trackingNumber,
      'items': instance.items,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'shipped_at': instance.shippedAt?.toIso8601String(),
      'delivered_at': instance.deliveredAt?.toIso8601String(),
    };

_OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) =>
    _OrderItemModel(
      id: (json['id'] as num).toInt(),
      orderId: (json['order_id'] as num).toInt(),
      productId: (json['product_id'] as num).toInt(),
      productName: json['product_name'] as String,
      productImage: json['product_image'] as String?,
      size: json['size'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unit_price'] as num).toInt(),
      subtotal: (json['subtotal'] as num).toInt(),
    );

Map<String, dynamic> _$OrderItemModelToJson(_OrderItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'product_id': instance.productId,
      'product_name': instance.productName,
      'product_image': instance.productImage,
      'size': instance.size,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
      'subtotal': instance.subtotal,
    };
