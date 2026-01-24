// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductSizeImpl _$$ProductSizeImplFromJson(Map<String, dynamic> json) =>
    _$ProductSizeImpl(
      id: (json['id'] as num).toInt(),
      productId: (json['product_id'] as num).toInt(),
      size: json['size'] as String,
      stock: (json['stock'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ProductSizeImplToJson(_$ProductSizeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'size': instance.size,
      'stock': instance.stock,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
