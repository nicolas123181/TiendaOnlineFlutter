import '../models/wishlist_item.dart';
import '../models/product.dart';
import '../../core/services/supabase_service.dart';

/// Repositorio de lista de deseos
class WishlistRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;

  /// Obtiene la lista de deseos del usuario
  Future<List<WishlistItem>> getWishlist() async {
    try {
      return await _supabaseService.getWishlist();
    } catch (e) {
      return [];
    }
  }

  /// Verifica si un producto está en la lista de deseos
  Future<bool> isInWishlist(int productId) async {
    try {
      return await _supabaseService.isInWishlist(productId);
    } catch (e) {
      return false;
    }
  }

  /// Añade un producto a la lista de deseos
  Future<WishlistResult> addToWishlist(Product product) async {
    try {
      // Verificar si ya está en la lista
      final alreadyInWishlist = await _supabaseService.isInWishlist(product.id);

      if (alreadyInWishlist) {
        return WishlistResult.error(
          message: 'Este producto ya está en tu lista de deseos',
        );
      }

      await _supabaseService.addToWishlist(product.id);

      return WishlistResult.success(
        message: 'Producto añadido a la lista de deseos',
      );
    } catch (e) {
      return WishlistResult.error(
        message: 'Error al añadir a la lista de deseos: $e',
      );
    }
  }

  /// Elimina un producto de la lista de deseos
  Future<WishlistResult> removeFromWishlist(int productId) async {
    try {
      await _supabaseService.removeFromWishlist(productId);

      return WishlistResult.success(
        message: 'Producto eliminado de la lista de deseos',
      );
    } catch (e) {
      return WishlistResult.error(
        message: 'Error al eliminar de la lista de deseos: $e',
      );
    }
  }

  /// Alterna el estado de un producto en la lista de deseos
  Future<WishlistResult> toggleWishlist(Product product) async {
    try {
      final isInList = await _supabaseService.isInWishlist(product.id);

      if (isInList) {
        return await removeFromWishlist(product.id);
      } else {
        return await addToWishlist(product);
      }
    } catch (e) {
      return WishlistResult.error(
        message: 'Error al actualizar la lista de deseos: $e',
      );
    }
  }

  /// Obtiene el número de items en la lista de deseos
  Future<int> getWishlistCount() async {
    try {
      final items = await _supabaseService.getWishlist();
      return items.length;
    } catch (e) {
      return 0;
    }
  }

  /// Limpia toda la lista de deseos
  Future<WishlistResult> clearWishlist() async {
    try {
      final items = await _supabaseService.getWishlist();

      for (final item in items) {
        await _supabaseService.removeFromWishlist(item.productId);
      }

      return WishlistResult.success(
        message: 'Lista de deseos vaciada',
      );
    } catch (e) {
      return WishlistResult.error(
        message: 'Error al vaciar la lista de deseos: $e',
      );
    }
  }

  /// Obtiene los productos de la lista de deseos con detalles completos
  Future<List<Product>> getWishlistProducts() async {
    try {
      final wishlistItems = await _supabaseService.getWishlist();
      final products = <Product>[];

      for (final item in wishlistItems) {
        final product =
            await _supabaseService.getProductById(item.productId.toString());
        if (product != null) {
          products.add(product);
        }
      }

      return products;
    } catch (e) {
      return [];
    }
  }

  /// Mueve un item de la lista de deseos al carrito
  /// Nota: Requiere el CartRepository para añadir al carrito
  Future<WishlistResult> moveToCart({
    required int productId,
    required String size,
  }) async {
    try {
      // Solo eliminamos de la lista de deseos
      // El añadir al carrito se maneja desde el provider/screen
      await _supabaseService.removeFromWishlist(productId, size: size);

      return WishlistResult.success(
        message: 'Producto movido al carrito',
        movedToCart: true,
      );
    } catch (e) {
      return WishlistResult.error(
        message: 'Error al mover al carrito: $e',
      );
    }
  }
}

/// Resultado de operaciones de lista de deseos
class WishlistResult {
  final bool isSuccess;
  final String? message;
  final bool movedToCart;

  WishlistResult._({
    required this.isSuccess,
    this.message,
    this.movedToCart = false,
  });

  factory WishlistResult.success({String? message, bool movedToCart = false}) {
    return WishlistResult._(
      isSuccess: true,
      message: message,
      movedToCart: movedToCart,
    );
  }

  factory WishlistResult.error({required String message}) {
    return WishlistResult._(
      isSuccess: false,
      message: message,
    );
  }
}
