// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    _CartItemModel(
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

Map<String, dynamic> _$CartItemModelToJson(_CartItemModel instance) =>
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
