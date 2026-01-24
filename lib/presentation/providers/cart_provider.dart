import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/cart_item.dart';
import '../../data/models/product.dart';
import '../../data/models/coupon.dart';
import '../../data/repositories/cart_repository.dart';
import '../../data/repositories/coupon_repository.dart';
import '../../config/app_constants.dart';

/// Provider del repositorio del carrito
final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository();
});

/// Provider del repositorio de cupones
final couponRepositoryProvider = Provider<CouponRepository>((ref) {
  return CouponRepository();
});

/// Estado del carrito
class CartState {
  final Cart cart;
  final Coupon? appliedCoupon;
  final int discount;
  final bool isLoading;
  final String? error;
  final String? successMessage;

  CartState({
    required this.cart,
    this.appliedCoupon,
    this.discount = 0,
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  factory CartState.initial() {
    return CartState(cart: Cart.empty);
  }

  /// Subtotal (sin IVA ni envío)
  int get subtotal => cart.subtotal;

  /// Subtotal con descuento aplicado
  int get subtotalWithDiscount => subtotal - discount;

  /// Coste de envío
  int get shippingCost {
    if (subtotalWithDiscount >= AppConstants.freeShippingThreshold) {
      return 0;
    }
    return AppConstants.standardShippingCost;
  }

  /// IVA
  int get tax =>
      ((subtotalWithDiscount + shippingCost) * AppConstants.taxRate / 100)
          .round();

  /// Total
  int get total => subtotalWithDiscount + shippingCost + tax;

  /// Número de items
  int get itemCount => cart.totalItems;

  /// Verifica si el carrito está vacío
  bool get isEmpty => cart.isEmpty;

  /// Verifica si tiene envío gratis
  bool get hasFreeShipping =>
      subtotalWithDiscount >= AppConstants.freeShippingThreshold;

  /// Cantidad restante para envío gratis
  int get amountForFreeShipping {
    if (hasFreeShipping) return 0;
    return AppConstants.freeShippingThreshold - subtotalWithDiscount;
  }

  CartState copyWith({
    Cart? cart,
    Coupon? appliedCoupon,
    int? discount,
    bool? isLoading,
    String? error,
    String? successMessage,
    bool clearCoupon = false,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      appliedCoupon: clearCoupon ? null : (appliedCoupon ?? this.appliedCoupon),
      discount: clearCoupon ? 0 : (discount ?? this.discount),
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
    );
  }
}

/// Notifier del carrito
class CartNotifier extends StateNotifier<CartState> {
  final CartRepository _cartRepository;
  final CouponRepository _couponRepository;

  CartNotifier(this._cartRepository, this._couponRepository)
      : super(CartState.initial()) {
    _loadCart();
  }

  /// Carga el carrito desde almacenamiento local
  Future<void> _loadCart() async {
    state = state.copyWith(isLoading: true);

    final cart = await _cartRepository.getCart();
    state = state.copyWith(cart: cart, isLoading: false);
  }

  /// Recarga el carrito
  Future<void> refresh() async {
    await _loadCart();
  }

  /// Añade un producto al carrito
  Future<void> addToCart({
    required Product product,
    required String size,
    int quantity = 1,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _cartRepository.addToCart(
      product: product,
      size: size,
      quantity: quantity,
    );

    if (result.isSuccess) {
      // Recalcular descuento si hay cupón aplicado
      int newDiscount = 0;
      if (state.appliedCoupon != null) {
        newDiscount =
            state.appliedCoupon!.calculateDiscount(result.cart!.subtotal);
      }

      state = state.copyWith(
        cart: result.cart,
        discount: newDiscount,
        isLoading: false,
        successMessage: result.message,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }

  /// Actualiza la cantidad de un item
  Future<void> updateQuantity({
    required String itemId,
    required int quantity,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _cartRepository.updateQuantity(
      itemId: itemId,
      quantity: quantity,
    );

    if (result.isSuccess) {
      // Recalcular descuento
      int newDiscount = 0;
      if (state.appliedCoupon != null) {
        newDiscount =
            state.appliedCoupon!.calculateDiscount(result.cart!.subtotal);
      }

      state = state.copyWith(
        cart: result.cart,
        discount: newDiscount,
        isLoading: false,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }

  /// Incrementa la cantidad de un item
  Future<void> incrementQuantity(String itemId) async {
    final item = state.cart.items.firstWhere(
      (i) => i.id == itemId,
      orElse: () => throw Exception('Item not found'),
    );
    await updateQuantity(itemId: itemId, quantity: item.quantity + 1);
  }

  /// Decrementa la cantidad de un item
  Future<void> decrementQuantity(String itemId) async {
    final item = state.cart.items.firstWhere(
      (i) => i.id == itemId,
      orElse: () => throw Exception('Item not found'),
    );
    if (item.quantity > 1) {
      await updateQuantity(itemId: itemId, quantity: item.quantity - 1);
    } else {
      await removeFromCart(itemId);
    }
  }

  /// Elimina un item del carrito
  Future<void> removeFromCart(String itemId) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _cartRepository.removeFromCart(itemId: itemId);

    if (result.isSuccess) {
      // Recalcular descuento o quitar cupón si el carrito queda vacío
      int newDiscount = 0;
      Coupon? coupon = state.appliedCoupon;

      if (result.cart!.isEmpty) {
        coupon = null;
      } else if (coupon != null) {
        // Verificar si el cupón sigue siendo válido
        final validation = coupon.validate(result.cart!.subtotal);
        if (validation.isValid) {
          newDiscount = coupon.calculateDiscount(result.cart!.subtotal);
        } else {
          coupon = null;
        }
      }

      state = state.copyWith(
        cart: result.cart,
        appliedCoupon: coupon,
        discount: newDiscount,
        isLoading: false,
        successMessage: result.message,
        clearCoupon: coupon == null,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }

  /// Vacía el carrito
  Future<void> clearCart() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _cartRepository.clearCart();

    if (result.isSuccess) {
      state = state.copyWith(
        cart: result.cart,
        isLoading: false,
        clearCoupon: true,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }

  /// Aplica un cupón de descuento
  Future<void> applyCoupon(String code) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _couponRepository.validateCoupon(
      code: code,
      orderTotal: state.subtotal,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        appliedCoupon: result.coupon,
        discount: result.discount,
        isLoading: false,
        successMessage: result.message,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }

  /// Elimina el cupón aplicado
  void removeCoupon() {
    state = state.copyWith(clearCoupon: true);
  }

  /// Valida el carrito antes de checkout
  Future<bool> validateCart() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _cartRepository.validateCart();

    if (result.isValid) {
      state = state.copyWith(
        cart: result.cart,
        isLoading: false,
      );
      return true;
    } else {
      state = state.copyWith(
        cart: result.cart,
        isLoading: false,
        error: result.unavailableItems.isNotEmpty
            ? 'Algunos productos ya no están disponibles'
            : result.errorMessage,
      );
      return false;
    }
  }

  /// Sincroniza precios con el servidor
  Future<void> syncPrices() async {
    final result = await _cartRepository.syncPrices();
    if (result.isSuccess && result.cart != null) {
      // Recalcular descuento
      int newDiscount = 0;
      if (state.appliedCoupon != null) {
        newDiscount =
            state.appliedCoupon!.calculateDiscount(result.cart!.subtotal);
      }

      state = state.copyWith(
        cart: result.cart,
        discount: newDiscount,
      );
    }
  }

  /// Limpia los mensajes
  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}

/// Provider del notifier del carrito
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  final cartRepository = ref.watch(cartRepositoryProvider);
  final couponRepository = ref.watch(couponRepositoryProvider);
  return CartNotifier(cartRepository, couponRepository);
});

/// Provider del número de items en el carrito
final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).itemCount;
});

/// Provider del total del carrito
final cartTotalProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).total;
});
