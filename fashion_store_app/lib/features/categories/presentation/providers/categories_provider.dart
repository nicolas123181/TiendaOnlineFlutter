import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/services/supabase_service.dart';
import '../../data/models/category_model.dart';

/// Provider para lista de categorías
final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final client = ref.watch(supabaseClientProvider);

  try {
    final response = await client
        .from('categories')
        .select('*, products:products(count)')
        .order('name');

    return (response as List).map((json) {
      final productCount = json['products'] is List
          ? (json['products'] as List).length
          : 0;
      return CategoryModel.fromJson({...json, 'productCount': productCount});
    }).toList();
  } catch (e) {
    throw Exception('Error al cargar categorías');
  }
});

/// Provider para una categoría por slug
final categoryBySlugProvider = FutureProvider.family<CategoryModel, String>((
  ref,
  slug,
) async {
  final client = ref.watch(supabaseClientProvider);

  try {
    final response = await client
        .from('categories')
        .select()
        .eq('slug', slug)
        .single();

    return CategoryModel.fromJson(response);
  } catch (e) {
    throw Exception('Categoría no encontrada');
  }
});
