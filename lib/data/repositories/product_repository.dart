import '../models/product.dart';
import '../models/category.dart';
import '../../core/services/supabase_service.dart';
import '../../core/services/storage_service.dart';

/// Repositorio de productos
class ProductRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;
  final StorageService _storageService = StorageService.instance;

  /// Obtiene todos los productos con paginación
  Future<ProductsResult> getProducts({
    int page = 1,
    int limit = 12,
    String? categoryId,
    String? sortBy,
    bool? onSale,
    bool? featured,
    int? minPrice,
    int? maxPrice,
    List<String>? sizes,
    String? searchQuery,
    String? status,
  }) async {
    try {
      final result = await _supabaseService.getProducts(
        page: page,
        limit: limit,
        categoryId: categoryId,
        sortBy: sortBy,
        onSale: onSale,
        featured: featured,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sizes: sizes,
        searchQuery: searchQuery,
        status: status,
      );

      return ProductsResult.success(
        products: result['products'] as List<Product>,
        total: result['total'] as int,
        hasMore: result['hasMore'] as bool,
      );
    } catch (e) {
      return ProductsResult.error(message: 'Error al cargar productos: $e');
    }
  }

  /// Obtiene un producto por ID
  Future<Product?> getProductById(String id) async {
    try {
      final product = await _supabaseService.getProductById(id);

      if (product != null) {
        // Guardar en vistos recientemente
        final productId = int.tryParse(id);
        if (productId != null) {
          await _storageService.addRecentlyViewed(productId);
        }
      }

      return product;
    } catch (e) {
      return null;
    }
  }

  /// Obtiene un producto por slug
  Future<Product?> getProductBySlug(String slug) async {
    try {
      final product = await _supabaseService.getProductBySlug(slug);

      if (product != null) {
        // Guardar en vistos recientemente
        await _storageService.addRecentlyViewed(product.id);
      }

      return product;
    } catch (e) {
      return null;
    }
  }

  /// Obtiene productos destacados
  Future<List<Product>> getFeaturedProducts({int limit = 8}) async {
    try {
      return await _supabaseService.getFeaturedProducts(limit: limit);
    } catch (e) {
      return [];
    }
  }

  /// Obtiene productos en oferta
  Future<List<Product>> getSaleProducts({int limit = 8}) async {
    try {
      return await _supabaseService.getSaleProducts(limit: limit);
    } catch (e) {
      return [];
    }
  }

  /// Obtiene nuevos productos
  Future<List<Product>> getNewProducts({int limit = 8}) async {
    try {
      return await _supabaseService.getNewProducts(limit: limit);
    } catch (e) {
      return [];
    }
  }

  /// Obtiene productos por categoría
  Future<List<Product>> getProductsByCategory(
    String categoryId, {
    int limit = 20,
  }) async {
    try {
      return await _supabaseService.getProductsByCategory(
        categoryId,
        limit: limit,
      );
    } catch (e) {
      return [];
    }
  }

  /// Obtiene productos relacionados
  Future<List<Product>> getRelatedProducts(
    String productId, {
    int limit = 4,
  }) async {
    try {
      return await _supabaseService.getRelatedProducts(
        productId,
        limit: limit,
      );
    } catch (e) {
      return [];
    }
  }

  /// Busca productos
  Future<List<Product>> searchProducts(
    String query, {
    int limit = 20,
  }) async {
    try {
      if (query.trim().isEmpty) return [];

      // Guardar en búsquedas recientes
      await _storageService.addRecentSearch(query);

      return await _supabaseService.searchProducts(query, limit: limit);
    } catch (e) {
      return [];
    }
  }

  /// Obtiene productos vistos recientemente
  Future<List<Product>> getRecentlyViewedProducts({int limit = 8}) async {
    try {
      final productIds = await _storageService.getRecentlyViewed();
      if (productIds.isEmpty) return [];

      final products = <Product>[];
      for (final id in productIds.take(limit)) {
        final product = await _supabaseService.getProductById(id.toString());
        if (product != null) {
          products.add(product);
        }
      }
      return products;
    } catch (e) {
      return [];
    }
  }

  /// Obtiene las búsquedas recientes
  Future<List<String>> getRecentSearches() async {
    return await _storageService.getRecentSearches();
  }

  /// Limpia las búsquedas recientes
  Future<void> clearRecentSearches() async {
    await _storageService.clearRecentSearches();
  }

  /// Elimina una búsqueda reciente
  Future<void> removeRecentSearch(String query) async {
    await _storageService.removeRecentSearch(query);
  }

  /// Obtiene todas las categorías
  Future<List<Category>> getCategories() async {
    try {
      return await _supabaseService.getCategories();
    } catch (e) {
      return [];
    }
  }

  /// Obtiene una categoría por ID
  Future<Category?> getCategoryById(String id) async {
    try {
      return await _supabaseService.getCategoryById(id);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene una categoría por slug
  Future<Category?> getCategoryBySlug(String slug) async {
    try {
      return await _supabaseService.getCategoryBySlug(slug);
    } catch (e) {
      return null;
    }
  }

  /// Verifica el stock de un producto
  Future<bool> checkStock(String productId, String size, int quantity) async {
    try {
      final id = int.tryParse(productId);
      if (id == null) return false;
      return await _supabaseService.checkProductStock(id, size, quantity);
    } catch (e) {
      return false;
    }
  }

  // ==================== Admin Methods ====================

  /// Crea un nuevo producto (Admin)
  Future<Product?> createProduct(Product product) async {
    try {
      return await _supabaseService.createProduct(product);
    } catch (e) {
      return null;
    }
  }

  /// Actualiza un producto (Admin)
  Future<Product?> updateProduct(Product product) async {
    try {
      return await _supabaseService.updateProduct(product);
    } catch (e) {
      return null;
    }
  }

  /// Elimina un producto (Admin)
  Future<bool> deleteProduct(String id) async {
    try {
      await _supabaseService.deleteProduct(id);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Actualiza el stock de un producto (Admin)
  Future<bool> updateStock(
    String productId,
    String size,
    int newStock,
  ) async {
    try {
      await _supabaseService.updateProductStock(productId, size, newStock);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Crea una categoría (Admin)
  Future<Category?> createCategory(Category category) async {
    try {
      return await _supabaseService.createCategory(category);
    } catch (e) {
      return null;
    }
  }

  /// Actualiza una categoría (Admin)
  Future<Category?> updateCategory(Category category) async {
    try {
      return await _supabaseService.updateCategory(category);
    } catch (e) {
      return null;
    }
  }

  /// Elimina una categoría (Admin)
  Future<bool> deleteCategory(String id) async {
    try {
      await _supabaseService.deleteCategory(id);
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Resultado de la consulta de productos
class ProductsResult {
  final bool isSuccess;
  final List<Product> products;
  final int total;
  final bool hasMore;
  final String? errorMessage;

  ProductsResult._({
    required this.isSuccess,
    this.products = const [],
    this.total = 0,
    this.hasMore = false,
    this.errorMessage,
  });

  factory ProductsResult.success({
    required List<Product> products,
    required int total,
    required bool hasMore,
  }) {
    return ProductsResult._(
      isSuccess: true,
      products: products,
      total: total,
      hasMore: hasMore,
    );
  }

  factory ProductsResult.error({required String message}) {
    return ProductsResult._(
      isSuccess: false,
      errorMessage: message,
    );
  }
}
