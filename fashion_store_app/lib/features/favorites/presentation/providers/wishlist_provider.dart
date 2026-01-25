import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/wishlist_item_model.dart';
import '../../data/repositories/wishlist_service.dart';

/// Provider de la lista de wishlist del usuario
final wishlistProvider = FutureProvider<List<WishlistItemModel>>((ref) async {
  final service = ref.watch(wishlistServiceProvider);
  return service.getUserWishlist();
});

/// Provider para verificar si un producto está en wishlist
final isInWishlistProvider = FutureProvider.family<bool, WishlistCheckParams>((
  ref,
  params,
) async {
  final service = ref.watch(wishlistServiceProvider);
  return service.isInWishlist(productId: params.productId, size: params.size);
});

/// Provider para contar items en wishlist
final wishlistCountProvider = Provider<int>((ref) {
  final wishlistAsync = ref.watch(wishlistProvider);
  return wishlistAsync.when(
    data: (items) => items.length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// Notifier para acciones de wishlist
final wishlistActionsProvider =
    NotifierProvider<WishlistActionsNotifier, WishlistActionsState>(() {
      return WishlistActionsNotifier();
    });

/// Estado de las acciones de wishlist
class WishlistActionsState {
  final bool isLoading;
  final String? error;
  final String? successMessage;

  const WishlistActionsState({
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  WishlistActionsState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
  }) {
    return WishlistActionsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
    );
  }
}

/// Notifier para acciones de wishlist
class WishlistActionsNotifier extends Notifier<WishlistActionsState> {
  @override
  WishlistActionsState build() => const WishlistActionsState();

  WishlistService get _service => ref.read(wishlistServiceProvider);

  /// Agregar a wishlist
  Future<void> addToWishlist({
    required int productId,
    required String size,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _service.addToWishlist(productId: productId, size: size);

      // Invalidar el provider de wishlist para refrescar
      ref.invalidate(wishlistProvider);

      state = state.copyWith(
        isLoading: false,
        successMessage: 'Producto agregado a favoritos',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al agregar a favoritos: $e',
      );
    }
  }

  /// Eliminar de wishlist
  Future<void> removeFromWishlist(int wishlistId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _service.removeFromWishlist(wishlistId);

      // Invalidar el provider de wishlist para refrescar
      ref.invalidate(wishlistProvider);

      state = state.copyWith(
        isLoading: false,
        successMessage: 'Producto eliminado de favoritos',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al eliminar de favoritos: $e',
      );
    }
  }

  /// Alternar producto en wishlist
  Future<bool> toggleWishlist({
    required int productId,
    required String size,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final isAdded = await _service.toggleWishlist(
        productId: productId,
        size: size,
      );

      // Invalidar el provider de wishlist para refrescar
      ref.invalidate(wishlistProvider);

      state = state.copyWith(
        isLoading: false,
        successMessage: isAdded
            ? 'Producto agregado a favoritos'
            : 'Producto eliminado de favoritos',
      );

      return isAdded;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al actualizar favoritos: $e',
      );
      return false;
    }
  }

  /// Limpiar mensajes
  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}

/// Parámetros para verificar si está en wishlist
class WishlistCheckParams {
  final int productId;
  final String size;

  const WishlistCheckParams({required this.productId, required this.size});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WishlistCheckParams &&
          runtimeType == other.runtimeType &&
          productId == other.productId &&
          size == other.size;

  @override
  int get hashCode => productId.hashCode ^ size.hashCode;
}
