// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WishlistItemModelImpl _$$WishlistItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$WishlistItemModelImpl(
  id: (json['id'] as num).toInt(),
  userId: json['user_id'] as String,
  productId: (json['product_id'] as num).toInt(),
  size: json['size'] as String,
  notifiedLowStock: json['notified_low_stock'] as bool? ?? false,
  notifiedSale: json['notified_sale'] as bool? ?? false,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  productName: json['product_name'] as String?,
  productSlug: json['product_slug'] as String?,
  productPrice: (json['product_price'] as num?)?.toInt(),
  productSalePrice: (json['product_sale_price'] as num?)?.toInt(),
  productIsOnSale: json['product_is_on_sale'] as bool? ?? false,
  productImages: (json['product_images'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  sizeStock: (json['size_stock'] as num?)?.toInt(),
);

Map<String, dynamic> _$$WishlistItemModelImplToJson(
  _$WishlistItemModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'product_id': instance.productId,
  'size': instance.size,
  'notified_low_stock': instance.notifiedLowStock,
  'notified_sale': instance.notifiedSale,
  'created_at': instance.createdAt?.toIso8601String(),
  'product_name': instance.productName,
  'product_slug': instance.productSlug,
  'product_price': instance.productPrice,
  'product_sale_price': instance.productSalePrice,
  'product_is_on_sale': instance.productIsOnSale,
  'product_images': instance.productImages,
  'size_stock': instance.sizeStock,
};
