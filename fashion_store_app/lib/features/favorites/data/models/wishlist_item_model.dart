import 'package:freezed_annotation/freezed_annotation.dart';

part 'wishlist_item_model.freezed.dart';
part 'wishlist_item_model.g.dart';

/// Modelo de item de wishlist
@freezed
class WishlistItemModel with _$WishlistItemModel {
  const WishlistItemModel._();

  const factory WishlistItemModel({
    required int id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'product_id') required int productId,
    required String size,
    @JsonKey(name: 'notified_low_stock') @Default(false) bool notifiedLowStock,
    @JsonKey(name: 'notified_sale') @Default(false) bool notifiedSale,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    // Datos del producto (de la vista wishlist_with_details)
    @JsonKey(name: 'product_name') String? productName,
    @JsonKey(name: 'product_slug') String? productSlug,
    @JsonKey(name: 'product_price') int? productPrice,
    @JsonKey(name: 'product_sale_price') int? productSalePrice,
    @JsonKey(name: 'product_is_on_sale') @Default(false) bool productIsOnSale,
    @JsonKey(name: 'product_images') List<String>? productImages,
    @JsonKey(name: 'size_stock') int? sizeStock,
  }) = _WishlistItemModel;

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) =>
      _$WishlistItemModelFromJson(json);

  /// Primera imagen del producto
  String? get firstImage => productImages != null && productImages!.isNotEmpty
      ? productImages![0]
      : null;

  /// Precio a mostrar (con descuento si aplica)
  int get displayPrice => productSalePrice ?? productPrice ?? 0;

  /// Porcentaje de descuento
  int? get discountPercentage {
    if (productIsOnSale && productSalePrice != null && productPrice != null) {
      return ((productPrice! - productSalePrice!) * 100 / productPrice!)
          .round();
    }
    return null;
  }

  /// Si tiene stock disponible
  bool get hasStock => (sizeStock ?? 0) > 0;

  /// Si el stock está bajo
  bool get isLowStock => (sizeStock ?? 0) > 0 && (sizeStock ?? 0) <= 9;
}
