import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/services/local_storage_service.dart';
import '../../data/models/cart_item_model.dart';
import '../../../products/data/models/product_model.dart';

/// Provider del carrito usando Notifier de Riverpod
final cartProvider = NotifierProvider<CartNotifier, CartState>(() {
  return CartNotifier();
});

/// Notifier del carrito
class CartNotifier extends Notifier<CartState> {
  static const _storageKey = 'vantage_cart';

  @override
  CartState build() {
    // Cargar carrito del storage al inicializar
    _loadFromStorage();
    return const CartState();
  }

  // ============================================
  // MÉTODOS PÚBLICOS
  // ============================================

  /// Añadir producto al carrito
  void addItem({
    required ProductModel product,
    required String size,
    int quantity = 1,
    int? sizeStock,
  }) {
    final key = '${product.id}-$size';
    final currentItems = Map<String, CartItemModel>.from(state.items);
    final effectiveMaxStock = sizeStock ?? product.stock;

    if (currentItems.containsKey(key)) {
      // Actualizar cantidad si ya existe
      final existingItem = currentItems[key]!;
      // Actualizar maxStock por si cambió el stock de la talla
      final updatedItem = existingItem.copyWith(maxStock: effectiveMaxStock);
      final newQuantity = (updatedItem.quantity + quantity).clamp(
        1,
        effectiveMaxStock,
      );

      currentItems[key] = updatedItem.copyWith(quantity: newQuantity);
    } else {
      // Añadir nuevo item
      currentItems[key] = CartItemModel(
        productId: product.id,
        name: product.name,
        slug: product.slug,
        price: product.price,
        quantity: quantity.clamp(1, effectiveMaxStock),
        size: size,
        imageUrl: product.mainImage,
        maxStock: effectiveMaxStock,
        salePrice: product.salePrice,
        isOnSale: product.isOnSale,
      );
    }

    state = state.copyWith(items: currentItems);
    _saveToStorage();
  }

  /// Eliminar item del carrito
  void removeItem(String key) {
    final currentItems = Map<String, CartItemModel>.from(state.items);
    currentItems.remove(key);
    state = state.copyWith(items: currentItems);
    _saveToStorage();
  }

  /// Eliminar item por producto y talla
  void removeByProductAndSize(int productId, String size) {
    removeItem('$productId-$size');
  }

  /// Actualizar cantidad de un item
  void updateQuantity(String key, int quantity) {
    final currentItems = Map<String, CartItemModel>.from(state.items);
    final item = currentItems[key];

    if (item == null) return;

    if (quantity <= 0) {
      removeItem(key);
      return;
    }

    final newQuantity = quantity.clamp(1, item.maxStock);
    currentItems[key] = item.copyWith(quantity: newQuantity);

    state = state.copyWith(items: currentItems);
    _saveToStorage();
  }

  /// Incrementar cantidad
  void incrementQuantity(String key) {
    final item = state.items[key];
    if (item != null && item.canIncrease) {
      updateQuantity(key, item.quantity + 1);
    }
  }

  /// Decrementar cantidad
  void decrementQuantity(String key) {
    final item = state.items[key];
    if (item != null) {
      if (item.quantity > 1) {
        updateQuantity(key, item.quantity - 1);
      } else {
        removeItem(key);
      }
    }
  }

  /// Limpiar carrito
  void clear() {
    state = const CartState();
    _saveToStorage();
  }

  /// Verificar si un producto está en el carrito
  bool isInCart(int productId, {String? size}) {
    if (size != null) {
      return state.items.containsKey('$productId-$size');
    }
    return state.items.keys.any((key) => key.startsWith('$productId-'));
  }

  /// Obtener cantidad de un producto en el carrito
  int getQuantityInCart(int productId, String size) {
    final item = state.items['$productId-$size'];
    return item?.quantity ?? 0;
  }

  // ============================================
  // MÉTODOS PRIVADOS - PERSISTENCIA
  // ============================================

  Future<void> _loadFromStorage() async {
    try {
      final storage = ref.read(localStorageServiceProvider);
      final data = storage.getJsonList(_storageKey);

      if (data != null && data.isNotEmpty) {
        final items = <String, CartItemModel>{};
        for (final itemJson in data) {
          final item = CartItemModel.fromJson(itemJson);
          items[item.key] = item;
        }
        state = CartState(items: items);
      }
    } catch (e) {
      // Ignorar errores de carga
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final storage = ref.read(localStorageServiceProvider);
      final items = state.itemsList.map((item) => item.toJson()).toList();
      await storage.setJsonList(_storageKey, items);
    } catch (e) {
      // Ignorar errores de guardado
    }
  }
}

// ============================================
// PROVIDERS DERIVADOS
// ============================================

/// Provider del conteo de items
final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).totalItems;
});

/// Provider del subtotal
final cartSubtotalProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).subtotal;
});

/// Provider de si está vacío
final isCartEmptyProvider = Provider<bool>((ref) {
  return ref.watch(cartProvider).isEmpty;
});

/// Provider de lista de items
final cartItemsListProvider = Provider<List<CartItemModel>>((ref) {
  return ref.watch(cartProvider).itemsList;
});
