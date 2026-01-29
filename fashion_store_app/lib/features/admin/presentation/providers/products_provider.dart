// Provider completo para gestión de productos con CRUD

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/services/supabase_service.dart';
import '../../../../shared/services/cloudinary_service.dart';

/// Provider para listar todos los productos
final productsListProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final supabase = ref.read(supabaseClientProvider);

  final response = await supabase
      .from('products')
      .select('*, category:categories(*), product_sizes(*)')
      .order('created_at', ascending: false);

  return (response as List).cast<Map<String, dynamic>>();
});

/// Provider para obtener un producto por ID
final productByIdProvider = FutureProvider.family<Map<String, dynamic>?, int>((
  ref,
  id,
) async {
  final supabase = ref.read(supabaseClientProvider);

  final response = await supabase
      .from('products')
      .select('*, category:categories(*), product_sizes(*)')
      .eq('id', id)
      .maybeSingle();

  return response;
});

/// Provider para acciones de productos
final productActionsProvider = Provider((ref) => ProductActions(ref));

class ProductActions {
  final Ref ref;

  ProductActions(this.ref);

  /// Crear nuevo producto
  Future<int> createProduct({
    required String name,
    required String description,
    required int price,
    required int categoryId,
    required int stock,
    bool featured = false,
    int? salePrice,
    DateTime? saleEndsAt,
    List<String> images = const [],
    Map<String, int>? sizeStock,
  }) async {
    final supabase = ref.read(supabaseClientProvider);

    // Generar slug
    final slug = _generateSlug(name);

    // Crear producto
    final response = await supabase
        .from('products')
        .insert({
          'name': name,
          'slug': slug,
          'description': description,
          'price': price,
          'stock': stock,
          'category_id': categoryId,
          'featured': featured,
          'sale_price': salePrice,
          'is_on_sale': salePrice != null,
          'sale_ends_at': saleEndsAt?.toIso8601String(),
          'images': images,
        })
        .select('id')
        .single();

    final productId = response['id'] as int;

    // Insertar tallas si hay
    if (sizeStock != null && sizeStock.isNotEmpty) {
      final sizeInserts = sizeStock.entries
          .map(
            (entry) => {
              'product_id': productId,
              'size': entry.key,
              'stock': entry.value,
            },
          )
          .toList();

      await supabase.from('product_sizes').insert(sizeInserts);
    }

    // Invalidar providers
    ref.invalidate(productsListProvider);

    return productId;
  }

  /// Actualizar producto existente
  Future<void> updateProduct({
    required int id,
    String? name,
    String? description,
    int? price,
    int? categoryId,
    int? stock,
    bool? featured,
    int? salePrice,
    DateTime? saleEndsAt,
    List<String>? images,
    Map<String, int>? sizeStock,
  }) async {
    final supabase = ref.read(supabaseClientProvider);

    final updates = <String, dynamic>{};

    if (name != null) {
      updates['name'] = name;
      updates['slug'] = _generateSlug(name);
    }
    if (description != null) updates['description'] = description;
    if (price != null) updates['price'] = price;
    if (categoryId != null) updates['category_id'] = categoryId;
    if (stock != null) updates['stock'] = stock;
    if (featured != null) updates['featured'] = featured;
    if (salePrice != null) {
      updates['sale_price'] = salePrice;
      updates['is_on_sale'] = true;
    } else if (salePrice == 0) {
      updates['sale_price'] = null;
      updates['is_on_sale'] = false;
    }
    if (saleEndsAt != null) {
      updates['sale_ends_at'] = saleEndsAt.toIso8601String();
    }
    if (images != null) updates['images'] = images;

    await supabase.from('products').update(updates).eq('id', id);

    // Actualizar tallas si hay
    if (sizeStock != null) {
      // Eliminar tallas existentes
      await supabase.from('product_sizes').delete().eq('product_id', id);

      // Insertar nuevas tallas
      if (sizeStock.isNotEmpty) {
        final sizeInserts = sizeStock.entries
            .map(
              (entry) => {
                'product_id': id,
                'size': entry.key,
                'stock': entry.value,
              },
            )
            .toList();

        await supabase.from('product_sizes').insert(sizeInserts);
      }
    }

    // Invalidar providers
    ref.invalidate(productsListProvider);
    ref.invalidate(productByIdProvider(id));
  }

  /// Eliminar producto
  Future<void> deleteProduct(int id) async {
    final supabase = ref.read(supabaseClientProvider);

    // Eliminar tallas primero
    await supabase.from('product_sizes').delete().eq('product_id', id);

    // Eliminar producto
    await supabase.from('products').delete().eq('id', id);

    // Invalidar providers
    ref.invalidate(productsListProvider);
  }

  /// Subir imagen a Cloudinary
  Future<String> uploadProductImage(XFile imageFile) async {
    final bytes = await imageFile.readAsBytes();

    final result = await CloudinaryService.uploadImage(
      imageBytes: bytes,
      fileName: imageFile.name,
      folder: 'productos',
    );

    return result.url;
  }

  /// Subir múltiples imágenes
  Future<List<String>> uploadMultipleImages(List<XFile> imageFiles) async {
    final urls = <String>[];

    for (final imageFile in imageFiles) {
      try {
        final url = await uploadProductImage(imageFile);
        urls.add(url);
      } catch (e) {
        // Continuar con las demás imágenes si una falla
        print('Error uploading image ${imageFile.name}: $e');
      }
    }

    return urls;
  }

  /// Generar slug desde nombre
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
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  /// Actualizar solo imágenes
  Future<void> updateProductImages(int productId, List<String> images) async {
    await updateProduct(id: productId, images: images);
  }

  /// Actualizar solo stock de tallas
  Future<void> updateSizeStock(
    int productId,
    Map<String, int> sizeStock,
  ) async {
    await updateProduct(id: productId, sizeStock: sizeStock);
  }
}
