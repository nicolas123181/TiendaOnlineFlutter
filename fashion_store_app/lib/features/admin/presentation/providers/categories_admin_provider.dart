// Provider para administración de categorías

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/services/cloudinary_service.dart';
import '../../../../shared/services/supabase_service.dart';
import '../../../categories/presentation/providers/categories_provider.dart';

/// Provider para acciones de categorías (crear, editar, eliminar)
final categoryActionsProvider = Provider((ref) {
  return CategoryActions(ref);
});

class CategoryActions {
  final Ref ref;

  CategoryActions(this.ref);

  /// Subir imagen de categoría a Cloudinary
  Future<String> uploadCategoryImage(XFile imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final result = await CloudinaryService.uploadImage(
      imageBytes: bytes,
      fileName: imageFile.name,
      folder: 'categorias',
    );
    return result.url;
  }

  /// Crear nueva categoría
  Future<void> createCategory({
    required String name,
    required String description,
    String? imageUrl,
  }) async {
    final supabase = ref.read(supabaseClientProvider);

    // Generar slug
    final slug = _generateSlug(name);

    await supabase.from('categories').insert({
      'name': name,
      'slug': slug,
      'description': description,
      if (imageUrl != null) 'image_url': imageUrl,
    });

    ref.invalidate(categoriesProvider);
  }

  /// Actualizar categoría existente
  Future<void> updateCategory({
    required int categoryId,
    required String name,
    required String description,
    String? imageUrl,
  }) async {
    final supabase = ref.read(supabaseClientProvider);

    final slug = _generateSlug(name);

    await supabase
        .from('categories')
        .update({
          'name': name,
          'slug': slug,
          'description': description,
          if (imageUrl != null) 'image_url': imageUrl,
        })
        .eq('id', categoryId);

    ref.invalidate(categoriesProvider);
  }

  /// Eliminar categoría
  /// Retorna true si se eliminó, false si tiene productos
  Future<bool> deleteCategory(int categoryId) async {
    final supabase = ref.read(supabaseClientProvider);

    // Verificar si hay productos en esta categoría
    final productCount = await supabase
        .from('products')
        .select()
        .eq('category_id', categoryId)
        .count();

    if (productCount.count > 0) {
      return false; // No se puede eliminar
    }

    // Eliminar categoría
    await supabase.from('categories').delete().eq('id', categoryId);
    ref.invalidate(categoriesProvider);
    return true;
  }

  /// Generar slug desde el nombre
  String _generateSlug(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[áàäâ]'), 'a')
        .replaceAll(RegExp(r'[éèëê]'), 'e')
        .replaceAll(RegExp(r'[íìïî]'), 'i')
        .replaceAll(RegExp(r'[óòöô]'), 'o')
        .replaceAll(RegExp(r'[úùüû]'), 'u')
        .replaceAll(RegExp(r'[ñ]'), 'n')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }
}
