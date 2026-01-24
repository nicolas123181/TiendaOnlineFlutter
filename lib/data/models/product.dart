import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

/// Modelo de Talla de Producto con stock
@freezed
class ProductSize with _$ProductSize {
  const ProductSize._(); // Constructor privado para permitir métodos

  const factory ProductSize({
    required int id,
    @JsonKey(name: 'product_id') required int productId,
    required String size,
    required int stock,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ProductSize;

  factory ProductSize.fromJson(Map<String, dynamic> json) =>
      _$ProductSizeFromJson(json);

  /// Verifica si hay stock disponible
  bool get isAvailable => stock > 0;

  /// Verifica si tiene stock bajo
  bool get isLowStock => stock > 0 && stock <= 5;

  /// Verifica si está agotado
  bool get isOutOfStock => stock == 0;
}

/// Modelo de Producto
@freezed
class Product with _$Product {
  const Product._(); // Constructor privado para permitir métodos

  const factory Product({
    required int id,
    required String name,
    required String slug,
    String? description,
    required int price, // En centavos
    @JsonKey(name: 'sale_price') int? salePrice, // Precio de oferta en centavos
    @JsonKey(name: 'is_on_sale') @Default(false) bool isOnSale,
    @JsonKey(name: 'sale_ends_at') DateTime? saleEndsAt,
    @Default(0) int stock,
    @JsonKey(name: 'category_id') int? categoryId,
    @JsonKey(includeFromJson: false, includeToJson: false) String? categoryName,
    @Default([]) List<String> images,
    @Default(false) bool featured,
    @Default('active') String status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'product_sizes', includeToJson: false)
    @Default([])
    List<ProductSize> sizes,
  }) = _Product;

  /// Factory personalizado para manejar JSON de Supabase
  factory Product.fromJson(Map<String, dynamic> json) {
    // Extraer nombre de categoría si viene en 'categories'
    String? categoryName;
    if (json['categories'] != null && json['categories'] is Map) {
      categoryName = (json['categories'] as Map)['name'] as String?;
    }

    // Manejar imágenes que pueden venir como lista o null
    List<String> imagesList = [];
    if (json['images'] != null && json['images'] is List) {
      imagesList = (json['images'] as List).map((e) => e.toString()).toList();
    }

    // Parsear tallas si vienen incluidas
    List<ProductSize> sizesList = [];
    if (json['product_sizes'] != null && json['product_sizes'] is List) {
      sizesList = (json['product_sizes'] as List)
          .map((e) => ProductSize.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      price: json['price'] as int,
      salePrice: json['sale_price'] as int?,
      isOnSale: json['is_on_sale'] as bool? ?? false,
      saleEndsAt: json['sale_ends_at'] != null
          ? DateTime.parse(json['sale_ends_at'] as String)
          : null,
      stock: json['stock'] as int? ?? 0,
      categoryId: json['category_id'] as int?,
      categoryName: categoryName,
      images: imagesList,
      featured: json['featured'] as bool? ?? false,
      status: json['status'] as String? ?? 'active',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      sizes: sizesList,
    );
  }

  /// Precio actual (considera ofertas)
  int get currentPrice {
    if (isOnSale && salePrice != null) {
      // Verificar si la oferta sigue vigente
      if (saleEndsAt == null || saleEndsAt!.isAfter(DateTime.now())) {
        return salePrice!;
      }
    }
    return price;
  }

  /// Porcentaje de descuento
  int get discountPercentage {
    if (!isOnSale || salePrice == null) return 0;
    return (((price - salePrice!) / price) * 100).round();
  }

  /// Verifica si actualmente tiene oferta activa
  bool get hasActiveDiscount {
    if (!isOnSale || salePrice == null) return false;
    if (saleEndsAt == null) return true;
    return saleEndsAt!.isAfter(DateTime.now());
  }

  /// Imagen principal (primera imagen o placeholder)
  String get mainImage {
    return images.isNotEmpty ? images.first : '';
  }

  /// Stock total sumando todas las tallas
  int get totalStock {
    if (sizes.isEmpty) return stock;
    return sizes.fold(0, (sum, size) => sum + size.stock);
  }

  /// Verifica si hay stock disponible
  bool get isAvailable => totalStock > 0;

  /// Verifica si tiene stock bajo
  bool get isLowStock => totalStock > 0 && totalStock <= 5;

  /// Precio efectivo actual (alias de currentPrice)
  int get effectivePrice => currentPrice;

  /// Verifica si el producto es nuevo (creado en los últimos 30 días)
  bool get isNew =>
      createdAt.isAfter(DateTime.now().subtract(const Duration(days: 30)));

  /// Verifica si hay stock disponible (alias de isAvailable)
  bool get isInStock => isAvailable;

  /// Obtiene el stock de una talla específica
  int getStockForSize(String sizeName) {
    final size = sizes.where((s) => s.size == sizeName).firstOrNull;
    return size?.stock ?? 0;
  }

  /// Verifica si una talla está disponible
  bool isSizeAvailable(String sizeName) {
    return getStockForSize(sizeName) > 0;
  }

  /// Lista de tallas disponibles
  List<String> get availableSizes {
    return sizes.where((s) => s.stock > 0).map((s) => s.size).toList();
  }

  /// Convierte a JSON para Supabase
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'description': description,
      'price': price,
      'sale_price': salePrice,
      'is_on_sale': isOnSale,
      'sale_ends_at': saleEndsAt?.toIso8601String(),
      'stock': stock,
      'category_id': categoryId,
      'images': images,
      'featured': featured,
      'status': status,
    };
  }
}
