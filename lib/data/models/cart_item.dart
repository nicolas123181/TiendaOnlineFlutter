import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

/// Item del carrito de compra
@freezed
class CartItem with _$CartItem {
  const CartItem._(); // Constructor privado para permitir métodos

  const factory CartItem({
    @JsonKey(name: 'product_id') required int productId,
    @JsonKey(name: 'product_name') required String productName,
    @JsonKey(name: 'product_slug') required String productSlug,
    @JsonKey(name: 'product_image') String? productImage,
    required int price, // Precio unitario en centavos
    required String size,
    required int quantity,
    @JsonKey(name: 'sale_price') int? salePrice,
    @JsonKey(name: 'is_on_sale') @Default(false) bool isOnSale,
    @JsonKey(name: 'available_stock') @Default(0) int availableStock,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  /// Precio unitario actual (considera ofertas)
  int get currentPrice {
    if (isOnSale && salePrice != null) {
      return salePrice!;
    }
    return price;
  }

  /// Precio total del item (cantidad * precio unitario)
  int get totalPrice => currentPrice * quantity;

  /// Ahorro por oferta
  int get savings {
    if (!isOnSale || salePrice == null) return 0;
    return (price - salePrice!) * quantity;
  }

  /// Clave única del item (producto + talla)
  String get uniqueKey => '${productId}_$size';

  /// Alias de uniqueKey para compatibilidad con UI
  String get id => uniqueKey;

  /// Verifica si se puede agregar más cantidad
  bool get canAddMore => quantity < availableStock;

  /// Cantidad máxima que se puede agregar
  int get maxQuantity => availableStock;
}

/// Modelo del carrito completo
@freezed
class Cart with _$Cart {
  const Cart._(); // Constructor privado para permitir métodos

  const factory Cart({
    @Default([]) List<CartItem> items,
    @JsonKey(name: 'coupon_code') String? couponCode,
    @JsonKey(name: 'discount_amount') @Default(0) int discountAmount,
    @JsonKey(name: 'discount_type') String? discountType,
    @JsonKey(name: 'discount_value') int? discountValue,
  }) = _Cart;

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  /// Carrito vacío
  static const Cart empty = Cart();

  /// Cantidad total de items
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  /// Subtotal sin descuento
  int get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);

  /// Ahorro total por ofertas
  int get totalSavings => items.fold(0, (sum, item) => sum + item.savings);

  /// Total con descuento de cupón aplicado
  int get totalAfterDiscount {
    final total = subtotal - discountAmount;
    return total > 0 ? total : 0;
  }

  /// Verifica si el carrito está vacío
  bool get isEmpty => items.isEmpty;

  /// Verifica si tiene un cupón aplicado
  bool get hasCoupon => couponCode != null && couponCode!.isNotEmpty;

  /// Obtiene un item por su clave única
  CartItem? getItem(String uniqueKey) {
    return items.where((item) => item.uniqueKey == uniqueKey).firstOrNull;
  }

  /// Verifica si un producto con talla específica está en el carrito
  bool containsProduct(int productId, String size) {
    return items.any(
      (item) => item.productId == productId && item.size == size,
    );
  }

  /// Elimina el cupón aplicado
  Cart removeCoupon() {
    return Cart(
      items: items,
      couponCode: null,
      discountAmount: 0,
      discountType: null,
      discountValue: null,
    );
  }
}
