import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/wishlist_item.dart';
import '../../data/models/product.dart';
import '../../data/repositories/wishlist_repository.dart';
import 'auth_provider.dart';

/// Provider del repositorio de wishlist
final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  return WishlistRepository();
});

/// Estado de la lista de deseos
class WishlistState {
  final List<WishlistItem> items;
  final bool isLoading;
  final String? error;
  final String? successMessage;
  final Set<int> processingIds; // IDs de productos siendo procesados

  WishlistState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.successMessage,
    this.processingIds = const {},
  });

  int get count => items.length;

  bool get isEmpty => items.isEmpty;

  bool isInWishlist(int productId) {
    return items.any((item) => item.productId == productId);
  }

  bool isProcessing(int productId) {
    return processingIds.contains(productId);
  }

  WishlistState copyWith({
    List<WishlistItem>? items,
    bool? isLoading,
    String? error,
    String? successMessage,
    Set<int>? processingIds,
  }) {
    return WishlistState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
      processingIds: processingIds ?? this.processingIds,
    );
  }
}

/// Notifier de la lista de deseos
class WishlistNotifier extends StateNotifier<WishlistState> {
  final WishlistRepository _repository;
  final Ref _ref;

  WishlistNotifier(this._repository, this._ref) : super(WishlistState()) {
    // Cargar wishlist solo si el usuario está autenticado
    _ref.listen(isAuthenticatedProvider, (previous, next) {
      if (next) {
        loadWishlist();
      } else {
        // Limpiar wishlist cuando el usuario cierra sesión
        state = WishlistState();
      }
    }, fireImmediately: true);
  }

  /// Carga la lista de deseos
  Future<void> loadWishlist() async {
    final isAuthenticated = _ref.read(isAuthenticatedProvider);
    if (!isAuthenticated) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final items = await _repository.getWishlist();
      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar la lista de deseos',
      );
    }
  }

  /// Añade un producto a la lista de deseos
  Future<void> addToWishlist(Product product) async {
    final isAuthenticated = _ref.read(isAuthenticatedProvider);
    if (!isAuthenticated) {
      state = state.copyWith(
        error: 'Debes iniciar sesión para usar la lista de deseos',
      );
      return;
    }

    // Marcar como en proceso
    state = state.copyWith(
      processingIds: {...state.processingIds, product.id},
      error: null,
    );

    final result = await _repository.addToWishlist(product);

    if (result.isSuccess) {
      // Recargar la lista
      final items = await _repository.getWishlist();
      state = state.copyWith(
        items: items,
        processingIds: {...state.processingIds}..remove(product.id),
        successMessage: result.message,
      );
    } else {
      state = state.copyWith(
        processingIds: {...state.processingIds}..remove(product.id),
        error: result.message,
      );
    }
  }

  /// Elimina un producto de la lista de deseos
  Future<void> removeFromWishlist(int productId) async {
    // Marcar como en proceso
    state = state.copyWith(
      processingIds: {...state.processingIds, productId},
      error: null,
    );

    final result = await _repository.removeFromWishlist(productId);

    if (result.isSuccess) {
      state = state.copyWith(
        items: state.items.where((i) => i.productId != productId).toList(),
        processingIds: {...state.processingIds}..remove(productId),
        successMessage: result.message,
      );
    } else {
      state = state.copyWith(
        processingIds: {...state.processingIds}..remove(productId),
        error: result.message,
      );
    }
  }

  /// Alterna el estado de un producto en la lista de deseos
  Future<void> toggleWishlist(Product product) async {
    if (state.isInWishlist(product.id)) {
      await removeFromWishlist(product.id);
    } else {
      await addToWishlist(product);
    }
  }

  /// Limpia toda la lista de deseos
  Future<void> clearWishlist() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.clearWishlist();

    if (result.isSuccess) {
      state = state.copyWith(
        items: [],
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

  /// Limpia los mensajes
  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}

/// Provider del notifier de wishlist
final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, WishlistState>((ref) {
  final repository = ref.watch(wishlistRepositoryProvider);
  return WishlistNotifier(repository, ref);
});

/// Provider del número de items en la wishlist
final wishlistCountProvider = Provider<int>((ref) {
  return ref.watch(wishlistProvider).count;
});

/// Provider para verificar si un producto está en la wishlist
final isInWishlistProvider = Provider.family<bool, int>((ref, productId) {
  return ref.watch(wishlistProvider).isInWishlist(productId);
});

/// Provider de los productos completos de la wishlist
final wishlistProductsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(wishlistRepositoryProvider);
  return await repository.getWishlistProducts();
});
