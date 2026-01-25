// Provider simplificado para gestión de tallas

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/services/supabase_service.dart';
import '../../data/models/product_size.dart';

/// Provider para obtener tallas con bajo stock
final lowStockSizesProvider = FutureProvider<List<ProductSize>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);

  final response = await supabase
      .from('product_sizes')
      .select('*')
      .lte('stock', 5)
      .order('stock', ascending: true);

  return (response as List).map((json) => ProductSize.fromJson(json)).toList();
});

/// Provider para obtener todas las tallas de un producto
final productSizesProvider = FutureProvider.family<List<ProductSize>, int>((
  ref,
  productId,
) async {
  final supabase = ref.read(supabaseClientProvider);

  final response = await supabase
      .from('product_sizes')
      .select('*')
      .eq('product_id', productId);

  return (response as List).map((json) => ProductSize.fromJson(json)).toList();
});

/// Provider para acciones de tallas
final sizeActionsProvider = Provider((ref) => SizeActions(ref));

class SizeActions {
  final Ref ref;

  SizeActions(this.ref);

  Future<void> updateStock(int id, int newStock) async {
    final supabase = ref.read(supabaseClientProvider);

    await supabase
        .from('product_sizes')
        .update({'stock': newStock})
        .eq('id', id);

    ref.invalidate(lowStockSizesProvider);
  }

  Future<void> createSize({
    required int productId,
    required String size,
    required int stock,
  }) async {
    final supabase = ref.read(supabaseClientProvider);

    await supabase.from('product_sizes').insert({
      'product_id': productId,
      'size': size,
      'stock': stock,
    });

    ref.invalidate(lowStockSizesProvider);
    ref.invalidate(productSizesProvider(productId));
  }
}
