// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductModel _$ProductModelFromJson(Map<String, dynamic> json) =>
    _ProductModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      shortDescription: json['short_description'] as String?,
      price: (json['price'] as num).toInt(),
      salePrice: (json['sale_price'] as num?)?.toInt(),
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      isOnSale: json['is_on_sale'] as bool? ?? false,
      isFeatured: json['is_featured'] as bool? ?? false,
      imageUrl: json['image_url'] as String?,
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      categoryId: (json['category_id'] as num?)?.toInt(),
      category: json['category'] == null
          ? null
          : CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ProductModelToJson(_ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'short_description': instance.shortDescription,
      'price': instance.price,
      'sale_price': instance.salePrice,
      'stock': instance.stock,
      'is_on_sale': instance.isOnSale,
      'is_featured': instance.isFeatured,
      'image_url': instance.imageUrl,
      'images': instance.images,
      'category_id': instance.categoryId,
      'category': instance.category,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_ProductVariant _$ProductVariantFromJson(Map<String, dynamic> json) =>
    _ProductVariant(
      id: (json['id'] as num).toInt(),
      productId: (json['product_id'] as num).toInt(),
      size: json['size'] as String?,
      color: json['color'] as String?,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      priceModifier: (json['price_modifier'] as num?)?.toInt() ?? 0,
      sku: json['sku'] as String?,
    );

Map<String, dynamic> _$ProductVariantToJson(_ProductVariant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'size': instance.size,
      'color': instance.color,
      'stock': instance.stock,
      'price_modifier': instance.priceModifier,
      'sku': instance.sku,
    };
