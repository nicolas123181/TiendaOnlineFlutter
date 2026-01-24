import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/product.dart';
import '../../data/models/category.dart';
import '../../data/repositories/product_repository.dart';

/// Provider del repositorio de productos
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

/// Provider de todas las categorías
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.getCategories();
});

/// Provider de productos destacados
final featuredProductsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.getFeaturedProducts(limit: 8);
});

/// Provider de productos en oferta
final saleProductsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.getSaleProducts(limit: 8);
});

/// Provider de nuevos productos
final newProductsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.getNewProducts(limit: 8);
});

/// Provider de productos vistos recientemente
final recentlyViewedProductsProvider =
    FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.getRecentlyViewedProducts(limit: 8);
});

/// Provider de búsquedas recientes
final recentSearchesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.getRecentSearches();
});

/// Provider de un producto por ID
final productByIdProvider =
    FutureProvider.family<Product?, String>((ref, id) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.getProductById(id);
});

/// Provider de un producto por slug
final productBySlugProvider =
    FutureProvider.family<Product?, String>((ref, slug) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.getProductBySlug(slug);
});

/// Provider de una categoría por ID
final categoryByIdProvider =
    FutureProvider.family<Category?, String>((ref, id) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.getCategoryById(id);
});

/// Provider de una categoría por slug
final categoryBySlugProvider =
    FutureProvider.family<Category?, String>((ref, slug) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.getCategoryBySlug(slug);
});

/// Provider de productos por categoría
final productsByCategoryProvider =
    FutureProvider.family<List<Product>, String>((ref, categoryId) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.getProductsByCategory(categoryId, limit: 20);
});

/// Provider de productos relacionados
final relatedProductsProvider =
    FutureProvider.family<List<Product>, String>((ref, productId) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.getRelatedProducts(productId, limit: 4);
});

/// Parámetros de filtro para productos
class ProductFilterParams {
  final int page;
  final int limit;
  final String? categoryId;
  final String? sortBy;
  final bool? onSale;
  final bool? featured;
  final int? minPrice;
  final int? maxPrice;
  final List<String>? sizes;
  final String? searchQuery;
  final String? status;

  const ProductFilterParams({
    this.page = 1,
    this.limit = 12,
    this.categoryId,
    this.sortBy,
    this.onSale,
    this.featured,
    this.minPrice,
    this.maxPrice,
    this.sizes,
    this.searchQuery,
    this.status,
  });

  ProductFilterParams copyWith({
    int? page,
    int? limit,
    String? categoryId,
    String? sortBy,
    bool? onSale,
    bool? featured,
    int? minPrice,
    int? maxPrice,
    List<String>? sizes,
    String? searchQuery,
    String? status,
    bool clearCategory = false,
    bool clearSort = false,
    bool clearPriceRange = false,
    bool clearSizes = false,
    bool clearSearch = false,
    bool clearStatus = false,
  }) {
    return ProductFilterParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      sortBy: clearSort ? null : (sortBy ?? this.sortBy),
      onSale: onSale ?? this.onSale,
      featured: featured ?? this.featured,
      minPrice: clearPriceRange ? null : (minPrice ?? this.minPrice),
      maxPrice: clearPriceRange ? null : (maxPrice ?? this.maxPrice),
      sizes: clearSizes ? null : (sizes ?? this.sizes),
      searchQuery: clearSearch ? null : (searchQuery ?? this.searchQuery),
      status: clearStatus ? null : (status ?? this.status),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductFilterParams &&
        other.page == page &&
        other.limit == limit &&
        other.categoryId == categoryId &&
        other.sortBy == sortBy &&
        other.onSale == onSale &&
        other.featured == featured &&
        other.minPrice == minPrice &&
        other.maxPrice == maxPrice &&
        _listEquals(other.sizes, sizes) &&
        other.searchQuery == searchQuery &&
        other.status == status;
  }

  @override
  int get hashCode => Object.hash(
        page,
        limit,
        categoryId,
        sortBy,
        onSale,
        featured,
        minPrice,
        maxPrice,
        sizes,
        searchQuery,
        status,
      );

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Estado del listado de productos
class ProductsState {
  final List<Product> products;
  final int total;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final ProductFilterParams filters;

  ProductsState({
    this.products = const [],
    this.total = 0,
    this.hasMore = false,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.filters = const ProductFilterParams(),
  });

  ProductsState copyWith({
    List<Product>? products,
    int? total,
    bool? hasMore,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    ProductFilterParams? filters,
  }) {
    return ProductsState(
      products: products ?? this.products,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      filters: filters ?? this.filters,
    );
  }
}

/// Notifier del listado de productos con filtros y paginación
class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductRepository _repository;

  ProductsNotifier(this._repository) : super(ProductsState());

  /// Carga productos con los filtros actuales
  Future<void> loadProducts({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(
        isLoading: true,
        error: null,
        filters: state.filters.copyWith(page: 1),
      );
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    final result = await _repository.getProducts(
      page: state.filters.page,
      limit: state.filters.limit,
      categoryId: state.filters.categoryId,
      sortBy: state.filters.sortBy,
      onSale: state.filters.onSale,
      featured: state.filters.featured,
      minPrice: state.filters.minPrice,
      maxPrice: state.filters.maxPrice,
      sizes: state.filters.sizes,
      searchQuery: state.filters.searchQuery,
      status: state.filters.status,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        products: result.products,
        total: result.total,
        hasMore: result.hasMore,
        isLoading: false,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.errorMessage,
      );
    }
  }

  /// Carga más productos (paginación)
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;

    state = state.copyWith(
      isLoadingMore: true,
      filters: state.filters.copyWith(page: state.filters.page + 1),
    );

    final result = await _repository.getProducts(
      page: state.filters.page,
      limit: state.filters.limit,
      categoryId: state.filters.categoryId,
      sortBy: state.filters.sortBy,
      onSale: state.filters.onSale,
      featured: state.filters.featured,
      minPrice: state.filters.minPrice,
      maxPrice: state.filters.maxPrice,
      sizes: state.filters.sizes,
      searchQuery: state.filters.searchQuery,
      status: state.filters.status,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        products: [...state.products, ...result.products],
        total: result.total,
        hasMore: result.hasMore,
        isLoadingMore: false,
      );
    } else {
      state = state.copyWith(
        isLoadingMore: false,
        error: result.errorMessage,
      );
    }
  }

  /// Aplica filtros
  Future<void> applyFilters({
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
    state = state.copyWith(
      filters: ProductFilterParams(
        page: 1,
        limit: state.filters.limit,
        categoryId: categoryId,
        sortBy: sortBy,
        onSale: onSale,
        featured: featured,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sizes: sizes,
        searchQuery: searchQuery,
        status: status,
      ),
    );

    await loadProducts();
  }

  /// Limpia todos los filtros
  Future<void> clearFilters() async {
    state = state.copyWith(
      filters: const ProductFilterParams(),
    );
    await loadProducts();
  }

  /// Cambia el ordenamiento
  Future<void> setSort(String? sortBy) async {
    state = state.copyWith(
      filters: state.filters.copyWith(sortBy: sortBy, page: 1),
    );
    await loadProducts();
  }

  /// Cambia la categoría
  Future<void> setCategory(String? categoryId) async {
    state = state.copyWith(
      filters: state.filters.copyWith(
        categoryId: categoryId,
        page: 1,
        clearCategory: categoryId == null,
      ),
    );
    await loadProducts();
  }
}

/// Provider del notifier de productos
final productsProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return ProductsNotifier(repository);
});

/// Provider para búsqueda de productos
final searchResultsProvider =
    FutureProvider.family<List<Product>, String>((ref, query) async {
  if (query.isEmpty) return [];
  final repository = ref.watch(productRepositoryProvider);
  return await repository.searchProducts(query, limit: 20);
});
