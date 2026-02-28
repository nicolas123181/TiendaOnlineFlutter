import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../shared/exceptions/failures.dart';
import '../../../../shared/services/supabase_service.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';

/// Implementación del repositorio de productos
class ProductRepositoryImpl implements ProductRepository {
  final SupabaseClient _client;

  ProductRepositoryImpl(this._client);

  @override
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
  }) async {
    try {
      final from = (page - 1) * limit;
      final to = from + limit - 1;

      var query = _client.from('products').select('''
        *,
        categories (id, name, slug)
      ''');

      // Filtros
      if (categorySlug != null) {
        // Primero obtenemos el category_id
        final categoryResult = await _client
            .from('categories')
            .select('id')
            .eq('slug', categorySlug)
            .single();
        query = query.eq('category_id', categoryResult['id']);
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.ilike('name', '%$searchQuery%');
      }

      if (onlyOnSale == true) {
        query = query.eq('is_on_sale', true);
      }

      if (onlyInStock == true) {
        query = query.gt('stock', 0);
      }

      if (onlyFeatured == true) {
        query = query.eq('featured', true);
      }

      // Ordenamiento y paginación
      final response = await query
          .order(sortBy, ascending: ascending)
          .range(from, to);

      final products = (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();

      return right(products);
    } on PostgrestException catch (e) {
      return left(ServerFailure(message: e.message, originalError: e));
    } catch (e) {
      return left(
        UnknownFailure(message: 'Error al obtener productos', originalError: e),
      );
    }
  }

  @override
  FutureEither<ProductModel> getProductBySlug(String slug) async {
    try {
      final response = await _client
          .from('products')
          .select('''
            *,
            categories (id, name, slug)
          ''')
          .eq('slug', slug)
          .single();

      return right(ProductModel.fromJson(response));
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        return left(ProductFailure.notFound());
      }
      return left(ServerFailure(message: e.message, originalError: e));
    } catch (e) {
      return left(
        UnknownFailure(
          message: 'Error al obtener el producto',
          originalError: e,
        ),
      );
    }
  }

  @override
  FutureEither<ProductModel> getProductById(int id) async {
    try {
      final response = await _client
          .from('products')
          .select('''
            *,
            categories (id, name, slug)
          ''')
          .eq('id', id)
          .single();

      return right(ProductModel.fromJson(response));
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        return left(ProductFailure.notFound());
      }
      return left(ServerFailure(message: e.message, originalError: e));
    } catch (e) {
      return left(
        UnknownFailure(
          message: 'Error al obtener el producto',
          originalError: e,
        ),
      );
    }
  }

  @override
  FutureEither<List<ProductModel>> getFeaturedProducts({int limit = 4}) async {
    return getProducts(limit: limit, onlyFeatured: true);
  }

  @override
  FutureEither<List<ProductModel>> getProductsOnSale({int limit = 4}) async {
    return getProducts(limit: limit, onlyOnSale: true, onlyInStock: true);
  }

  @override
  FutureEither<List<ProductModel>> searchProducts(String query) async {
    return getProducts(searchQuery: query, limit: 50);
  }

  @override
  FutureEither<int> checkStock(int productId) async {
    try {
      final response = await _client
          .from('products')
          .select('stock')
          .eq('id', productId)
          .single();

      return right(response['stock'] as int);
    } on PostgrestException catch (e) {
      return left(ServerFailure(message: e.message, originalError: e));
    } catch (e) {
      return left(
        UnknownFailure(message: 'Error al verificar stock', originalError: e),
      );
    }
  }

  // ============================================
  // OPERACIONES ADMIN
  // ============================================

  @override
  FutureEither<ProductModel> createProduct(ProductModel product) async {
    try {
      final data = {
        'name': product.name,
        'slug': product.slug,
        'description': product.description,
        'price': product.price,
        'sale_price': product.salePrice,
        'is_on_sale': product.isOnSale,
        'stock': product.stock,
        'category_id': product.categoryId,
        'images': product.images,
        'featured': product.featured,
      };

      final response = await _client.from('products').insert(data).select('''
            *,
            categories (id, name, slug)
          ''').single();

      return right(ProductModel.fromJson(response));
    } on PostgrestException catch (e) {
      return left(ServerFailure(message: e.message, originalError: e));
    } catch (e) {
      return left(
        UnknownFailure(message: 'Error al crear el producto', originalError: e),
      );
    }
  }

  @override
  FutureEither<ProductModel> updateProduct(ProductModel product) async {
    try {
      final data = {
        'name': product.name,
        'slug': product.slug,
        'description': product.description,
        'price': product.price,
        'sale_price': product.salePrice,
        'is_on_sale': product.isOnSale,
        'stock': product.stock,
        'category_id': product.categoryId,
        'images': product.images,
        'featured': product.featured,
      };

      final response = await _client
          .from('products')
          .update(data)
          .eq('id', product.id)
          .select('''
            *,
            categories (id, name, slug)
          ''')
          .single();

      return right(ProductModel.fromJson(response));
    } on PostgrestException catch (e) {
      return left(ServerFailure(message: e.message, originalError: e));
    } catch (e) {
      return left(
        UnknownFailure(
          message: 'Error al actualizar el producto',
          originalError: e,
        ),
      );
    }
  }

  @override
  FutureEither<void> deleteProduct(int id) async {
    try {
      await _client.from('products').delete().eq('id', id);
      return right(null);
    } on PostgrestException catch (e) {
      return left(ServerFailure(message: e.message, originalError: e));
    } catch (e) {
      return left(
        UnknownFailure(
          message: 'Error al eliminar el producto',
          originalError: e,
        ),
      );
    }
  }

  @override
  FutureEither<void> updateStock(int productId, int newStock) async {
    try {
      await _client
          .from('products')
          .update({'stock': newStock})
          .eq('id', productId);
      return right(null);
    } on PostgrestException catch (e) {
      return left(ServerFailure(message: e.message, originalError: e));
    } catch (e) {
      return left(
        UnknownFailure(message: 'Error al actualizar stock', originalError: e),
      );
    }
  }

  @override
  FutureEither<void> toggleSale({
    required int productId,
    required bool isOnSale,
    int? salePrice,
    DateTime? saleEndsAt,
  }) async {
    try {
      await _client
          .from('products')
          .update({
            'is_on_sale': isOnSale,
            'sale_price': salePrice,
            'sale_ends_at': saleEndsAt?.toIso8601String(),
          })
          .eq('id', productId);
      return right(null);
    } on PostgrestException catch (e) {
      return left(ServerFailure(message: e.message, originalError: e));
    } catch (e) {
      return left(
        UnknownFailure(message: 'Error al actualizar oferta', originalError: e),
      );
    }
  }
}

/// Provider del repositorio de productos
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ProductRepositoryImpl(client);
});
