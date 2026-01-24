import 'package:freezed_annotation/freezed_annotation.dart';

part 'wishlist_item.freezed.dart';

/// Modelo de Wishlist (Lista de deseos)
@Freezed(toJson: false, fromJson: false)
class WishlistItem with _$WishlistItem {
  const WishlistItem._(); // Constructor privado para permitir métodos

  const factory WishlistItem({
    required int id,
    required String userId,
    required int productId,
    required String size,
    @Default(false) bool notifiedLowStock,
    @Default(false) bool notifiedSale,
    required DateTime createdAt,
    // Datos del producto (cuando se incluyen en la consulta)
    String? productName,
    String? productSlug,
    String? productImage,
    int? productPrice,
    int? productSalePrice,
    bool? productIsOnSale,
    int? productStock,
  }) = _WishlistItem;

  /// Factory personalizado para manejar JSON de Supabase con productos anidados
  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    // Extraer datos del producto si vienen incluidos
    String? productName;
    String? productSlug;
    String? productImage;
    int? productPrice;
    int? productSalePrice;
    bool? productIsOnSale;
    int? productStock;

    if (json['products'] != null) {
      final product = json['products'] as Map<String, dynamic>;
      productName = product['name'] as String?;
      productSlug = product['slug'] as String?;
      productPrice = product['price'] as int?;
      productSalePrice = product['sale_price'] as int?;
      productIsOnSale = product['is_on_sale'] as bool?;
      productStock = product['stock'] as int?;

      // Obtener primera imagen
      if (product['images'] != null && product['images'] is List) {
        final images = product['images'] as List;
        if (images.isNotEmpty) {
          productImage = images.first.toString();
        }
      }
    }

    return WishlistItem(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      productId: json['product_id'] as int,
      size: json['size'] as String,
      notifiedLowStock: json['notified_low_stock'] as bool? ?? false,
      notifiedSale: json['notified_sale'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      productName: productName,
      productSlug: productSlug,
      productImage: productImage,
      productPrice: productPrice,
      productSalePrice: productSalePrice,
      productIsOnSale: productIsOnSale,
      productStock: productStock,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'product_id': productId,
      'size': size,
      'notified_low_stock': notifiedLowStock,
      'notified_sale': notifiedSale,
    };
  }

  /// Clave única del item
  String get uniqueKey => '${productId}_$size';

  /// Precio actual del producto
  int? get currentPrice {
    if (productIsOnSale == true && productSalePrice != null) {
      return productSalePrice;
    }
    return productPrice;
  }

  /// Verifica si el producto está en oferta
  bool get hasDiscount => productIsOnSale == true && productSalePrice != null;

  /// Verifica si tiene stock bajo
  bool get isLowStock =>
      productStock != null && productStock! > 0 && productStock! <= 5;

  /// Verifica si está agotado
  bool get isOutOfStock => productStock == null || productStock == 0;
}
