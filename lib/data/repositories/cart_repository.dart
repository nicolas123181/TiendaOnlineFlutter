import '../models/cart_item.dart';
import '../models/product.dart';
import '../../core/services/supabase_service.dart';
import '../../core/services/storage_service.dart';

/// Repositorio del carrito de compras
class CartRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;
  final StorageService _storageService = StorageService.instance;

  /// Obtiene el carrito actual
  Future<Cart> getCart() async {
    return _storageService.getCart();
  }

  /// Añade un producto al carrito
  Future<CartResult> addToCart({
    required Product product,
    required String size,
    int quantity = 1,
  }) async {
    try {
      // Verificar stock
      final hasStock = await _supabaseService.checkProductStock(
        product.id,
        size,
        quantity,
      );

      if (!hasStock) {
        return CartResult.error(
          message: 'No hay suficiente stock disponible',
        );
      }

      // Obtener carrito actual
      final cart = _storageService.getCart();
      final currentItems = cart.items;

      // Buscar si ya existe el producto con esa talla
      final existingIndex = currentItems.indexWhere(
        (item) => item.productId == product.id && item.size == size,
      );

      List<CartItem> updatedItems;

      if (existingIndex >= 0) {
        // Actualizar cantidad si ya existe
        final existingItem = currentItems[existingIndex];
        final newQuantity = existingItem.quantity + quantity;

        // Verificar stock para la nueva cantidad
        final canUpdate = await _supabaseService.checkProductStock(
          product.id,
          size,
          newQuantity,
        );

        if (!canUpdate) {
          return CartResult.error(
            message: 'No hay suficiente stock para esta cantidad',
          );
        }

        updatedItems = List.from(currentItems);
        updatedItems[existingIndex] = existingItem.copyWith(
          quantity: newQuantity,
        );
      } else {
        // Añadir nuevo item
        final newItem = CartItem(
          productId: product.id,
          productName: product.name,
          productSlug: product.slug,
          productImage: product.images.isNotEmpty ? product.images.first : null,
          size: size,
          price: product.price,
          salePrice: product.hasActiveDiscount ? product.salePrice : null,
          isOnSale: product.hasActiveDiscount,
          availableStock: product.getStockForSize(size),
          quantity: quantity,
        );
        updatedItems = [...currentItems, newItem];
      }

      // Guardar carrito actualizado
      await _storageService.saveCart(cart.copyWith(items: updatedItems));

      return CartResult.success(
        cart: cart.copyWith(items: updatedItems),
        message: 'Producto añadido al carrito',
      );
    } catch (e) {
      return CartResult.error(message: 'Error al añadir al carrito: $e');
    }
  }

  /// Actualiza la cantidad de un item del carrito
  Future<CartResult> updateQuantity({
    required String itemId,
    required int quantity,
  }) async {
    try {
      if (quantity < 1) {
        return removeFromCart(itemId: itemId);
      }

      final cart = _storageService.getCart();
      final currentItems = cart.items;
      final itemIndex = currentItems.indexWhere((item) => item.id == itemId);

      if (itemIndex < 0) {
        return CartResult.error(
            message: 'Producto no encontrado en el carrito');
      }

      final item = currentItems[itemIndex];

      // Verificar stock
      final hasStock = await _supabaseService.checkProductStock(
        item.productId,
        item.size,
        quantity,
      );

      if (!hasStock) {
        return CartResult.error(
          message: 'No hay suficiente stock disponible',
        );
      }

      // Actualizar cantidad
      final updatedItems = List<CartItem>.from(currentItems);
      updatedItems[itemIndex] = item.copyWith(quantity: quantity);

      await _storageService.saveCart(cart.copyWith(items: updatedItems));

      return CartResult.success(
        cart: cart.copyWith(items: updatedItems),
      );
    } catch (e) {
      return CartResult.error(message: 'Error al actualizar cantidad: $e');
    }
  }

  /// Elimina un item del carrito
  Future<CartResult> removeFromCart({required String itemId}) async {
    try {
      final cart = _storageService.getCart();
      final currentItems = cart.items;
      final updatedItems =
          currentItems.where((item) => item.id != itemId).toList();

      await _storageService.saveCart(cart.copyWith(items: updatedItems));

      return CartResult.success(
        cart: cart.copyWith(items: updatedItems),
        message: 'Producto eliminado del carrito',
      );
    } catch (e) {
      return CartResult.error(message: 'Error al eliminar del carrito: $e');
    }
  }

  /// Vacía el carrito
  Future<CartResult> clearCart() async {
    try {
      await _storageService.clearCart();
      return CartResult.success(cart: Cart.empty);
    } catch (e) {
      return CartResult.error(message: 'Error al vaciar el carrito: $e');
    }
  }

  /// Valida el stock de todos los items del carrito
  Future<CartValidationResult> validateCart() async {
    try {
      final cart = _storageService.getCart();
      final currentItems = cart.items;
      final unavailableItems = <CartItem>[];
      final validItems = <CartItem>[];

      for (final item in currentItems) {
        final hasStock = await _supabaseService.checkProductStock(
          item.productId,
          item.size,
          item.quantity,
        );

        if (hasStock) {
          validItems.add(item);
        } else {
          unavailableItems.add(item);
        }
      }

      // Si hay items sin stock, actualizar el carrito solo con los válidos
      if (unavailableItems.isNotEmpty) {
        await _storageService.saveCart(cart.copyWith(items: validItems));
      }

      return CartValidationResult(
        isValid: unavailableItems.isEmpty,
        cart: cart.copyWith(items: validItems),
        unavailableItems: unavailableItems,
      );
    } catch (e) {
      return CartValidationResult(
        isValid: false,
        cart: Cart.empty,
        unavailableItems: [],
        errorMessage: 'Error al validar el carrito: $e',
      );
    }
  }

  /// Obtiene el número de items en el carrito
  Future<int> getCartItemCount() async {
    final cart = _storageService.getCart();
    return cart.items.fold<int>(0, (sum, item) => sum + item.quantity);
  }

  /// Sincroniza precios del carrito con los actuales
  Future<CartResult> syncPrices() async {
    try {
      final cart = _storageService.getCart();
      final currentItems = cart.items;
      final updatedItems = <CartItem>[];

      for (final item in currentItems) {
        final product =
            await _supabaseService.getProductById(item.productId.toString());

        if (product != null) {
          updatedItems.add(item.copyWith(
            price: product.price,
            salePrice: product.hasActiveDiscount ? product.salePrice : null,
            isOnSale: product.hasActiveDiscount,
            productImage: product.images.isNotEmpty
                ? product.images.first
                : item.productImage,
            productName: product.name,
            productSlug: product.slug,
            availableStock: product.getStockForSize(item.size),
          ));
        }
        // Si el producto ya no existe, no lo incluimos
      }

      await _storageService.saveCart(cart.copyWith(items: updatedItems));

      return CartResult.success(
        cart: cart.copyWith(items: updatedItems),
      );
    } catch (e) {
      return CartResult.error(message: 'Error al sincronizar precios: $e');
    }
  }
}

/// Resultado de operaciones del carrito
class CartResult {
  final bool isSuccess;
  final Cart? cart;
  final String? message;

  CartResult._({
    required this.isSuccess,
    this.cart,
    this.message,
  });

  factory CartResult.success({required Cart cart, String? message}) {
    return CartResult._(
      isSuccess: true,
      cart: cart,
      message: message,
    );
  }

  factory CartResult.error({required String message}) {
    return CartResult._(
      isSuccess: false,
      message: message,
    );
  }
}

/// Resultado de validación del carrito
class CartValidationResult {
  final bool isValid;
  final Cart cart;
  final List<CartItem> unavailableItems;
  final String? errorMessage;

  CartValidationResult({
    required this.isValid,
    required this.cart,
    required this.unavailableItems,
    this.errorMessage,
  });
}
