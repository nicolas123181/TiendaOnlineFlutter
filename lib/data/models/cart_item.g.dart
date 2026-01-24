// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartItemImpl _$$CartItemImplFromJson(Map<String, dynamic> json) =>
    _$CartItemImpl(
      productId: (json['product_id'] as num).toInt(),
      productName: json['product_name'] as String,
      productSlug: json['product_slug'] as String,
      productImage: json['product_image'] as String?,
      price: (json['price'] as num).toInt(),
      size: json['size'] as String,
      quantity: (json['quantity'] as num).toInt(),
      salePrice: (json['sale_price'] as num?)?.toInt(),
      isOnSale: json['is_on_sale'] as bool? ?? false,
      availableStock: (json['available_stock'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$CartItemImplToJson(_$CartItemImpl instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'product_name': instance.productName,
      'product_slug': instance.productSlug,
      'product_image': instance.productImage,
      'price': instance.price,
      'size': instance.size,
      'quantity': instance.quantity,
      'sale_price': instance.salePrice,
      'is_on_sale': instance.isOnSale,
      'available_stock': instance.availableStock,
    };

_$CartImpl _$$CartImplFromJson(Map<String, dynamic> json) => _$CartImpl(
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      couponCode: json['coupon_code'] as String?,
      discountAmount: (json['discount_amount'] as num?)?.toInt() ?? 0,
      discountType: json['discount_type'] as String?,
      discountValue: (json['discount_value'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$CartImplToJson(_$CartImpl instance) =>
    <String, dynamic>{
      'items': instance.items,
      'coupon_code': instance.couponCode,
      'discount_amount': instance.discountAmount,
      'discount_type': instance.discountType,
      'discount_value': instance.discountValue,
    };
