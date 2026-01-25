import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/services/supabase_service.dart';

/// Modelo para representar una talla con su stock
class ProductSizeStock {
  final int id;
  final int productId;
  final String size;
  final int stock;

  ProductSizeStock({
    required this.id,
    required this.productId,
    required this.size,
    required this.stock,
  });

  factory ProductSizeStock.fromJson(Map<String, dynamic> json) {
    return ProductSizeStock(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      size: json['size'] as String,
      stock: json['stock'] as int? ?? 0,
    );
  }

  bool get isAvailable => stock > 0;
  bool get isLowStock => stock > 0 && stock <= 3;
  bool get isOutOfStock => stock <= 0;
}

/// Provider para obtener el stock por tallas de un producto
final productSizesStockProvider =
    FutureProvider.family<List<ProductSizeStock>, int>((ref, productId) async {
      final supabase = ref.watch(supabaseClientProvider);

      final response = await supabase
          .from('product_sizes')
          .select('id, product_id, size, stock')
          .eq('product_id', productId)
          .order('size', ascending: true);

      return (response as List)
          .map((json) => ProductSizeStock.fromJson(json))
          .toList();
    });

/// Provider para obtener el stock de una talla específica
final sizeStockProvider =
    FutureProvider.family<int, ({int productId, String size})>((
      ref,
      params,
    ) async {
      final sizes = await ref.watch(
        productSizesStockProvider(params.productId).future,
      );
      final sizeData = sizes.firstWhere(
        (s) => s.size.toUpperCase() == params.size.toUpperCase(),
        orElse: () => ProductSizeStock(
          id: 0,
          productId: params.productId,
          size: params.size,
          stock: 0,
        ),
      );
      return sizeData.stock;
    });

/// Provider para obtener el mapa de tallas y stock
final productSizesMapProvider = FutureProvider.family<Map<String, int>, int>((
  ref,
  productId,
) async {
  final sizes = await ref.watch(productSizesStockProvider(productId).future);
  return {for (var s in sizes) s.size: s.stock};
});
