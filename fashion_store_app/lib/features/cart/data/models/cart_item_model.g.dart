// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartItemModelImpl _$$CartItemModelImplFromJson(Map<String, dynamic> json) =>
    _$CartItemModelImpl(
      productId: (json['productId'] as num).toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      price: (json['price'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      size: json['size'] as String,
      imageUrl: json['imageUrl'] as String,
      maxStock: (json['maxStock'] as num?)?.toInt() ?? 99,
      salePrice: (json['salePrice'] as num?)?.toInt(),
      isOnSale: json['isOnSale'] as bool? ?? false,
    );

Map<String, dynamic> _$$CartItemModelImplToJson(_$CartItemModelImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'name': instance.name,
      'slug': instance.slug,
      'price': instance.price,
      'quantity': instance.quantity,
      'size': instance.size,
      'imageUrl': instance.imageUrl,
      'maxStock': instance.maxStock,
      'salePrice': instance.salePrice,
      'isOnSale': instance.isOnSale,
    };
