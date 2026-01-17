import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../categories/data/models/category_model.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

/// Modelo de Producto
@freezed
abstract class ProductModel with _$ProductModel {
  const ProductModel._();

  const factory ProductModel({
    required int id,
    required String name,
    required String slug,
    String? description,
    @JsonKey(name: 'short_description') String? shortDescription,
    required int price,
    @JsonKey(name: 'sale_price') int? salePrice,
    @Default(0) int stock,
    @JsonKey(name: 'is_on_sale') @Default(false) bool isOnSale,
    @JsonKey(name: 'is_featured') @Default(false) bool isFeatured,
    @JsonKey(name: 'image_url') String? imageUrl,
    @Default(<String>[]) List<String> images,
    @JsonKey(name: 'category_id') int? categoryId,
    CategoryModel? category,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  // ============================================
  // PROPIEDADES COMPUTADAS
  // ============================================

  /// Imagen principal del producto
  String get mainImage =>
      imageUrl ??
      (images.isNotEmpty
          ? images.first
          : 'https://via.placeholder.com/400x600?text=No+Image');

  /// Precio actual (con o sin descuento)
  int get currentPrice => isOnSale && salePrice != null ? salePrice! : price;

  /// Porcentaje de descuento
  int get discountPercentage {
    if (!isOnSale || salePrice == null || price == 0) return 0;
    return (((price - salePrice!) / price) * 100).round();
  }

  /// ¿Está en stock?
  bool get isInStock => stock > 0;

  /// ¿Agotado?
  bool get isOutOfStock => stock <= 0;

  /// ¿Quedan pocas unidades? (menos de 5)
  bool get isLowStock => stock > 0 && stock <= 5;

  /// Ahorro en céntimos
  int get savings => isOnSale && salePrice != null ? price - salePrice! : 0;

  /// Precio formateado
  String get formattedPrice => '${(currentPrice / 100).toStringAsFixed(2)} €';

  /// Precio original formateado
  String get formattedOriginalPrice => '${(price / 100).toStringAsFixed(2)} €';
}

/// Modelo para variante de producto (talla, color, etc.)
@freezed
abstract class ProductVariant with _$ProductVariant {
  const factory ProductVariant({
    required int id,
    @JsonKey(name: 'product_id') required int productId,
    String? size,
    String? color,
    @Default(0) int stock,
    @JsonKey(name: 'price_modifier') @Default(0) int priceModifier,
    String? sku,
  }) = _ProductVariant;

  factory ProductVariant.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantFromJson(json);
}
