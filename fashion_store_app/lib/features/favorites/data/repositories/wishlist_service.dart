import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../shared/services/supabase_service.dart';
import '../models/wishlist_item_model.dart';

/// Provider del servicio de wishlist
final wishlistServiceProvider = Provider<WishlistService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return WishlistService(client);
});

/// Servicio para gestionar la wishlist
class WishlistService {
  final SupabaseClient _client;

  WishlistService(this._client);

  /// Obtener wishlist del usuario actual
  Future<List<WishlistItemModel>> getUserWishlist() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      print('🔍 Obteniendo wishlist para usuario: $userId');

      // Usar la vista wishlist_with_details que incluye datos del producto
      final response = await _client
          .from('wishlist_with_details')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      print('✅ Wishlist obtenida: ${response.length} items');

      return (response as List)
          .map((json) => WishlistItemModel.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Error obteniendo wishlist: $e');
      rethrow;
    }
  }

  /// Agregar producto a wishlist
  Future<void> addToWishlist({
    required int productId,
    required String size,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      print('➕ Agregando a wishlist: Producto $productId, Talla $size');

      await _client.from('wishlist').insert({
        'user_id': userId,
        'product_id': productId,
        'size': size,
      });

      print('✅ Producto agregado a wishlist');
    } catch (e) {
      print('❌ Error agregando a wishlist: $e');
      rethrow;
    }
  }

  /// Eliminar producto de wishlist
  Future<void> removeFromWishlist(int wishlistId) async {
    try {
      print('🗑️ Eliminando de wishlist: ID $wishlistId');

      await _client.from('wishlist').delete().eq('id', wishlistId);

      print('✅ Producto eliminado de wishlist');
    } catch (e) {
      print('❌ Error eliminando de wishlist: $e');
      rethrow;
    }
  }

  /// Verificar si un producto está en wishlist
  Future<bool> isInWishlist({
    required int productId,
    required String size,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return false;

      final response = await _client
          .from('wishlist')
          .select('id')
          .eq('user_id', userId)
          .eq('product_id', productId)
          .eq('size', size)
          .maybeSingle();

      return response != null;
    } catch (e) {
      print('❌ Error verificando wishlist: $e');
      return false;
    }
  }

  /// Obtener ID del item en wishlist (para eliminar)
  Future<int?> getWishlistItemId({
    required int productId,
    required String size,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return null;

      final response = await _client
          .from('wishlist')
          .select('id')
          .eq('user_id', userId)
          .eq('product_id', productId)
          .eq('size', size)
          .maybeSingle();

      return response?['id'] as int?;
    } catch (e) {
      print('❌ Error obteniendo ID de wishlist: $e');
      return null;
    }
  }

  /// Alternar producto en wishlist
  Future<bool> toggleWishlist({
    required int productId,
    required String size,
  }) async {
    final isAdded = await isInWishlist(productId: productId, size: size);

    if (isAdded) {
      final itemId = await getWishlistItemId(productId: productId, size: size);
      if (itemId != null) {
        await removeFromWishlist(itemId);
      }
      return false;
    } else {
      await addToWishlist(productId: productId, size: size);
      return true;
    }
  }
}
