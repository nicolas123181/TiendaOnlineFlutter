import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository_impl.dart';

/// Provider para lista de productos con paginación
final productsProvider =
    FutureProvider.family<List<ProductModel>, ProductsFilter>((
      ref,
      filter,
    ) async {
      final repository = ref.watch(productRepositoryProvider);

      final result = await repository.getProducts(
        page: filter.page,
        limit: filter.limit,
        categorySlug: filter.categorySlug,
        searchQuery: filter.searchQuery,
        onlyOnSale: filter.onlyOnSale,
        onlyFeatured: filter.onlyFeatured,
        sortBy: filter.sortBy,
        ascending: filter.ascending,
      );

      return result.fold(
        (failure) => throw Exception(failure.message),
        (products) => products,
      );
    });

/// Provider para productos destacados
final featuredProductsProvider = FutureProvider<List<ProductModel>>((
  ref,
) async {
  final repository = ref.watch(productRepositoryProvider);

  final result = await repository.getFeaturedProducts(limit: 6);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (products) => products,
  );
});

/// Provider para productos en oferta
final saleProductsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);

  final result = await repository.getProductsOnSale(limit: 6);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (products) => products,
  );
});

/// Provider para detalle de producto por slug
final productBySlugProvider = FutureProvider.family<ProductModel, String>((
  ref,
  slug,
) async {
  final repository = ref.watch(productRepositoryProvider);

  final result = await repository.getProductBySlug(slug);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (product) => product,
  );
});

/// Provider para detalle de producto por ID
final productByIdProvider = FutureProvider.family<ProductModel, int>((
  ref,
  id,
) async {
  final repository = ref.watch(productRepositoryProvider);

  final result = await repository.getProductById(id);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (product) => product,
  );
});

/// Provider para búsqueda de productos
final searchProductsProvider =
    FutureProvider.family<List<ProductModel>, String>((ref, query) async {
      if (query.isEmpty) return [];

      final repository = ref.watch(productRepositoryProvider);

      final result = await repository.searchProducts(query);

      return result.fold(
        (failure) => throw Exception(failure.message),
        (products) => products,
      );
    });

// ============================================
// FILTROS
// ============================================

/// Filtro de productos
class ProductsFilter {
  final int page;
  final int limit;
  final String? categorySlug;
  final String? searchQuery;
  final bool? onlyOnSale;
  final bool? onlyFeatured;
  final String sortBy;
  final bool ascending;

  const ProductsFilter({
    this.page = 1,
    this.limit = 20,
    this.categorySlug,
    this.searchQuery,
    this.onlyOnSale,
    this.onlyFeatured,
    this.sortBy = 'created_at',
    this.ascending = false,
  });

  ProductsFilter copyWith({
    int? page,
    int? limit,
    String? categorySlug,
    String? searchQuery,
    bool? onlyOnSale,
    bool? onlyFeatured,
    String? sortBy,
    bool? ascending,
  }) {
    return ProductsFilter(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      categorySlug: categorySlug ?? this.categorySlug,
      searchQuery: searchQuery ?? this.searchQuery,
      onlyOnSale: onlyOnSale ?? this.onlyOnSale,
      onlyFeatured: onlyFeatured ?? this.onlyFeatured,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductsFilter &&
        other.page == page &&
        other.limit == limit &&
        other.categorySlug == categorySlug &&
        other.searchQuery == searchQuery &&
        other.onlyOnSale == onlyOnSale &&
        other.onlyFeatured == onlyFeatured &&
        other.sortBy == sortBy &&
        other.ascending == ascending;
  }

  @override
  int get hashCode {
    return Object.hash(
      page,
      limit,
      categorySlug,
      searchQuery,
      onlyOnSale,
      onlyFeatured,
      sortBy,
      ascending,
    );
  }
}

/// Provider del estado del filtro actual utilizando NotifierProvider
final currentFilterProvider =
    NotifierProvider<CurrentFilterNotifier, ProductsFilter>(() {
      return CurrentFilterNotifier();
    });

class CurrentFilterNotifier extends Notifier<ProductsFilter> {
  @override
  ProductsFilter build() => const ProductsFilter();

  void updateFilter(ProductsFilter filter) {
    state = filter;
  }

  void resetFilter() {
    state = const ProductsFilter();
  }
}
