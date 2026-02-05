import '../../../../shared/exceptions/failures.dart';
import '../../data/models/product_model.dart';

/// Contrato del repositorio de productos
abstract class ProductRepository {
  /// Obtener todos los productos con paginación
  FutureEither<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 20,
    String? categorySlug,
    String? searchQuery,
    bool? onlyOnSale,
    bool? onlyInStock,
    bool? onlyFeatured,
    String sortBy = 'created_at',
    bool ascending = false,
  });

  /// Obtener un producto por su slug
  FutureEither<ProductModel> getProductBySlug(String slug);

  /// Obtener un producto por su ID
  FutureEither<ProductModel> getProductById(int id);

  /// Obtener productos destacados
  FutureEither<List<ProductModel>> getFeaturedProducts({int limit = 4});

  /// Obtener productos en oferta
  FutureEither<List<ProductModel>> getProductsOnSale({int limit = 4});

  /// Buscar productos
  FutureEither<List<ProductModel>> searchProducts(String query);

  /// Verificar stock de un producto
  FutureEither<int> checkStock(int productId);

  // ============================================
  // OPERACIONES ADMIN
  // ============================================

  /// Crear un producto
  FutureEither<ProductModel> createProduct(ProductModel product);

  /// Actualizar un producto
  FutureEither<ProductModel> updateProduct(ProductModel product);

  /// Eliminar un producto
  FutureEither<void> deleteProduct(int id);

  /// Actualizar stock
  FutureEither<void> updateStock(int productId, int newStock);

  /// Activar/desactivar oferta
  FutureEither<void> toggleSale({
    required int productId,
    required bool isOnSale,
    int? salePrice,
    DateTime? saleEndsAt,
  });
}
