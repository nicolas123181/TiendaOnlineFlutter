import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import '../../../../shared/services/supabase_service.dart';
import '../../../categories/presentation/providers/categories_provider.dart';
import '../providers/products_provider.dart';

class AdminProductFormScreen extends ConsumerStatefulWidget {
  final int? productId; // null = crear nuevo, != null = editar

  const AdminProductFormScreen({super.key, this.productId});

  @override
  ConsumerState<AdminProductFormScreen> createState() =>
      _AdminProductFormScreenState();
}

class _AdminProductFormScreenState
    extends ConsumerState<AdminProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _salePriceController = TextEditingController();

  int? _selectedCategoryId;
  bool _featured = false;
  DateTime? _saleEndsAt;
  List<String> _imageUrls = [];
  List<XFile> _pendingImages = [];
  Map<String, int> _sizeStock = {};
  bool _isLoading = false;

  final _availableSizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      _loadProduct();
    }
  }

  void _loadProduct() async {
    final product = await ref.read(
      productByIdProvider(widget.productId!).future,
    );
    if (product != null && mounted) {
      setState(() {
        _nameController.text = product['name'] ?? '';
        _descriptionController.text = product['description'] ?? '';
        _priceController.text = ((product['price'] ?? 0) / 100.0)
            .toStringAsFixed(2);
        _stockController.text = (product['stock'] ?? 0).toString();
        _selectedCategoryId = product['category_id'];
        _featured = product['featured'] ?? false;
        _imageUrls = List<String>.from(product['images'] ?? []);

        if (product['sale_price'] != null) {
          _salePriceController.text = ((product['sale_price'] as int) / 100.0)
              .toStringAsFixed(2);
        }
        if (product['sale_ends_at'] != null) {
          _saleEndsAt = DateTime.parse(product['sale_ends_at']);
        }
      });

      // Cargar tallas
      _loadSizes();
    }
  }

  void _loadSizes() async {
    final supabase = ref.read(supabaseClientProvider);
    final response = await supabase
        .from('product_sizes')
        .select('size, stock')
        .eq('product_id', widget.productId!);

    if (mounted) {
      setState(() {
        _sizeStock = {
          for (var item in response as List)
            item['size'] as String: item['stock'] as int,
        };
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _salePriceController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage();

    if (images.isNotEmpty &&
        (_imageUrls.length + _pendingImages.length + images.length) <= 5) {
      setState(() {
        _pendingImages.addAll(images);
      });
    } else if ((_imageUrls.length + _pendingImages.length + images.length) >
        5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Máximo 5 imágenes por producto')),
      );
    }
  }

  void _removeImage(int index, bool isPending) {
    setState(() {
      if (isPending) {
        _pendingImages.removeAt(index);
      } else {
        _imageUrls.removeAt(index);
      }
    });
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecciona una categoría')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final productActions = ref.read(productActionsProvider);

      // Subir imágenes pendientes
      if (_pendingImages.isNotEmpty) {
        final uploadedUrls = await productActions.uploadMultipleImages(
          _pendingImages,
        );
        _imageUrls.addAll(uploadedUrls);
      }

      final price = (double.parse(_priceController.text) * 100).round();
      final stock = int.parse(_stockController.text);
      final salePrice = _salePriceController.text.isNotEmpty
          ? (double.parse(_salePriceController.text) * 100).round()
          : null;

      if (widget.productId == null) {
        // Crear nuevo
        await productActions.createProduct(
          name: _nameController.text,
          description: _descriptionController.text,
          price: price,
          categoryId: _selectedCategoryId!,
          stock: stock,
          featured: _featured,
          salePrice: salePrice,
          saleEndsAt: _saleEndsAt,
          images: _imageUrls,
          sizeStock: _sizeStock.isNotEmpty ? _sizeStock : null,
        );

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Producto creado exitosamente')),
          );
        }
      } else {
        // Actualizar existente
        await productActions.updateProduct(
          id: widget.productId!,
          name: _nameController.text,
          description: _descriptionController.text,
          price: price,
          categoryId: _selectedCategoryId,
          stock: stock,
          featured: _featured,
          salePrice: salePrice,
          saleEndsAt: _saleEndsAt,
          images: _imageUrls,
          sizeStock: _sizeStock.isNotEmpty ? _sizeStock : null,
        );

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Producto actualizado exitosamente')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.productId == null ? 'Crear Producto' : 'Editar Producto',
        ),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Información básica
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información Básica',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del producto *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El nombre es obligatorio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _priceController,
                            decoration: const InputDecoration(
                              labelText: 'Precio (€) *',
                              border: OutlineInputBorder(),
                              prefixText: '€ ',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'El precio es obligatorio';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Precio inválido';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _stockController,
                            decoration: const InputDecoration(
                              labelText: 'Stock *',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'El stock es obligatorio';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Stock inválido';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Categoría
                    categoriesAsync.when(
                      data: (categories) => DropdownButtonFormField<int>(
                        value: _selectedCategoryId,
                        decoration: const InputDecoration(
                          labelText: 'Categoría *',
                          border: OutlineInputBorder(),
                        ),
                        items: categories.map((cat) {
                          return DropdownMenuItem(
                            value: cat.id,
                            child: Text(cat.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedCategoryId = value);
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Selecciona una categoría';
                          }
                          return null;
                        },
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) =>
                          const Text('Error al cargar categorías'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Imágenes
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Imágenes',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Máximo 5 imágenes',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),

                    // Previsualizaciones
                    if (_imageUrls.isNotEmpty || _pendingImages.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ..._imageUrls.asMap().entries.map((entry) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    entry.value,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                    onPressed: () =>
                                        _removeImage(entry.key, false),
                                  ),
                                ),
                              ],
                            );
                          }),
                          ..._pendingImages.asMap().entries.map((entry) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(entry.value.path),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                    onPressed: () =>
                                        _removeImage(entry.key, true),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    const SizedBox(height: 16),

                    OutlinedButton.icon(
                      onPressed: _pickImages,
                      icon: const Icon(Icons.add_photo_alternate),
                      label: const Text('Agregar Imágenes'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Oferta
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Oferta',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _salePriceController,
                      decoration: const InputDecoration(
                        labelText: 'Precio de oferta (€)',
                        border: OutlineInputBorder(),
                        prefixText: '€ ',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    const SizedBox(height: 16),

                    ListTile(
                      title: const Text('Fecha fin de oferta'),
                      subtitle: Text(
                        _saleEndsAt != null
                            ? DateFormat(
                                'dd/MM/yyyy HH:mm',
                              ).format(_saleEndsAt!)
                            : 'Sin fecha límite',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _saleEndsAt ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (date != null && mounted) {
                            setState(() => _saleEndsAt = date);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Stock por tallas
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stock por Tallas',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableSizes.map((size) {
                        return SizedBox(
                          width: 100,
                          child: TextFormField(
                            initialValue: _sizeStock[size]?.toString() ?? '',
                            decoration: InputDecoration(
                              labelText: size,
                              border: const OutlineInputBorder(),
                              isDense: true,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              final qty = int.tryParse(value);
                              if (qty != null && qty >= 0) {
                                _sizeStock[size] = qty;
                              } else if (value.isEmpty) {
                                _sizeStock.remove(size);
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Opciones
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: CheckboxListTile(
                  title: const Text('Producto destacado'),
                  subtitle: const Text('Aparecerá en "Ofertas Flash"'),
                  value: _featured,
                  onChanged: (value) {
                    setState(() => _featured = value ?? false);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Botones
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveProduct,
                    child: Text(
                      widget.productId == null
                          ? 'Crear Producto'
                          : 'Guardar Cambios',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
