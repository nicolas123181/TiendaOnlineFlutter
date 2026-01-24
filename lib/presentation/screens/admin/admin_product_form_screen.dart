import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_colors.dart';

/// Formulario para crear/editar productos
class AdminProductFormScreen extends ConsumerStatefulWidget {
  final String? productId;

  const AdminProductFormScreen({super.key, this.productId});

  @override
  ConsumerState<AdminProductFormScreen> createState() =>
      _AdminProductFormScreenState();
}

class _AdminProductFormScreenState
    extends ConsumerState<AdminProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _hasChanges = false;

  // Controladores de texto
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _comparePriceController = TextEditingController();
  final _skuController = TextEditingController();
  final _stockController = TextEditingController();
  final _weightController = TextEditingController();

  // Estado del formulario
  String _selectedCategory = 'Camisas';
  String _selectedStatus = 'active';
  bool _trackInventory = true;
  bool _allowBackorder = false;
  bool _isFeatured = false;

  // Imágenes
  final List<String> _images = [];

  // Variantes
  final List<_ProductVariant> _variants = [];

  // Tallas y colores disponibles
  final List<String> _sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  final List<String> _colors = [
    'Negro',
    'Blanco',
    'Azul',
    'Gris',
    'Beige',
    'Marrón'
  ];

  // Categorías
  final List<String> _categories = [
    'Chaquetas',
    'Camisas',
    'Pantalones',
    'Accesorios',
    'Calzado',
    'Jerseys',
    'Trajes',
    'Polos',
  ];

  bool get _isEditing => widget.productId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadProduct();
    } else {
      // Generar SKU automático
      _skuController.text =
          'VNT-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    }
  }

  void _loadProduct() {
    // TODO: Cargar datos del producto desde el repositorio
    // Datos de ejemplo
    _nameController.text = 'Chaqueta Premium Navy';
    _descriptionController.text =
        'Elegante chaqueta en tejido premium. Corte entallado moderno.';
    _priceController.text = '199.00';
    _comparePriceController.text = '249.00';
    _skuController.text = 'VNT-001';
    _stockController.text = '25';
    _selectedCategory = 'Chaquetas';
    _selectedStatus = 'active';
    _isFeatured = true;

    _variants.addAll([
      _ProductVariant(size: 'M', color: 'Navy', stock: 10, sku: 'VNT-001-M-NV'),
      _ProductVariant(size: 'L', color: 'Navy', stock: 8, sku: 'VNT-001-L-NV'),
      _ProductVariant(size: 'M', color: 'Negro', stock: 7, sku: 'VNT-001-M-BK'),
    ]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _comparePriceController.dispose();
    _skuController.dispose();
    _stockController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _hasChanges) {
          _showDiscardDialog();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? 'Editar producto' : 'Nuevo producto'),
          actions: [
            if (_isEditing)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: _confirmDelete,
              ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: _showMoreOptions,
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          onChanged: () {
            if (!_hasChanges) {
              setState(() => _hasChanges = true);
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imágenes
                _buildImagesSection(),
                const SizedBox(height: 24),

                // Información básica
                _buildBasicInfoSection(),
                const SizedBox(height: 24),

                // Precios
                _buildPricingSection(),
                const SizedBox(height: 24),

                // Inventario
                _buildInventorySection(),
                const SizedBox(height: 24),

                // Variantes
                _buildVariantsSection(),
                const SizedBox(height: 24),

                // Organización
                _buildOrganizationSection(),
                const SizedBox(height: 24),

                // SEO
                _buildSeoSection(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  Widget _buildImagesSection() {
    return _SectionCard(
      title: 'Imágenes',
      child: Column(
        children: [
          if (_images.isEmpty)
            InkWell(
              onTap: _addImages,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.border,
                    style: BorderStyle.solid,
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 48,
                        color: AppColors.textTertiary,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Añadir imágenes',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Arrastra o haz clic para subir',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: 120,
              child: ReorderableListView(
                scrollDirection: Axis.horizontal,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--;
                    final item = _images.removeAt(oldIndex);
                    _images.insert(newIndex, item);
                  });
                },
                children: [
                  for (int i = 0; i < _images.length; i++)
                    _ImageTile(
                      key: ValueKey(_images[i]),
                      imageUrl: _images[i],
                      isMain: i == 0,
                      onRemove: () {
                        setState(() => _images.removeAt(i));
                      },
                    ),
                ],
              ),
            ),
          if (_images.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: OutlinedButton.icon(
                onPressed: _addImages,
                icon: const Icon(Icons.add),
                label: const Text('Añadir más imágenes'),
                style: OutlinedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return _SectionCard(
      title: 'Información básica',
      child: Column(
        children: [
          // Nombre
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nombre del producto *',
              hintText: 'Ej: Chaqueta Premium Navy',
              border: OutlineInputBorder(borderRadius: BorderRadius.zero),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El nombre es obligatorio';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Descripción
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Descripción',
              hintText: 'Describe el producto...',
              border: OutlineInputBorder(borderRadius: BorderRadius.zero),
              alignLabelWithHint: true,
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 16),

          // Categoría
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Categoría *',
              border: OutlineInputBorder(borderRadius: BorderRadius.zero),
            ),
            items: _categories.map((category) {
              return DropdownMenuItem(value: category, child: Text(category));
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedCategory = value);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection() {
    return _SectionCard(
      title: 'Precios',
      child: Column(
        children: [
          Row(
            children: [
              // Precio
              Expanded(
                child: TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Precio *',
                    prefixText: '€ ',
                    border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Requerido';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Precio inválido';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),

              // Precio anterior (tachado)
              Expanded(
                child: TextFormField(
                  controller: _comparePriceController,
                  decoration: const InputDecoration(
                    labelText: 'Precio anterior',
                    prefixText: '€ ',
                    border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                    helperText: 'Se mostrará tachado',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_priceController.text.isNotEmpty &&
              _comparePriceController.text.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: AppColors.success.withValues(alpha: 0.1),
              child: Row(
                children: [
                  const Icon(Icons.sell, size: 20, color: AppColors.success),
                  const SizedBox(width: 8),
                  Text(
                    'Descuento: ${_calculateDiscount()}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _calculateDiscount() {
    final price = double.tryParse(_priceController.text) ?? 0;
    final comparePrice = double.tryParse(_comparePriceController.text) ?? 0;
    if (comparePrice <= 0 || price >= comparePrice) return '0';
    final discount = ((comparePrice - price) / comparePrice * 100).round();
    return discount.toString();
  }

  Widget _buildInventorySection() {
    return _SectionCard(
      title: 'Inventario',
      child: Column(
        children: [
          Row(
            children: [
              // SKU
              Expanded(
                child: TextFormField(
                  controller: _skuController,
                  decoration: const InputDecoration(
                    labelText: 'SKU',
                    border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Stock
              Expanded(
                child: TextFormField(
                  controller: _stockController,
                  decoration: const InputDecoration(
                    labelText: 'Stock',
                    border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                  ),
                  keyboardType: TextInputType.number,
                  enabled: _trackInventory && _variants.isEmpty,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Peso
          TextFormField(
            controller: _weightController,
            decoration: const InputDecoration(
              labelText: 'Peso (kg)',
              hintText: 'Para calcular envío',
              border: OutlineInputBorder(borderRadius: BorderRadius.zero),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),

          // Opciones de inventario
          SwitchListTile(
            title: const Text('Seguimiento de inventario'),
            subtitle: const Text('Controla el stock disponible'),
            value: _trackInventory,
            onChanged: (value) => setState(() => _trackInventory = value),
            contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            title: const Text('Permitir reservas sin stock'),
            subtitle: const Text('Los clientes pueden comprar sin stock'),
            value: _allowBackorder,
            onChanged: _trackInventory
                ? (value) => setState(() => _allowBackorder = value)
                : null,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildVariantsSection() {
    return _SectionCard(
      title: 'Variantes',
      trailing: TextButton.icon(
        onPressed: _addVariant,
        icon: const Icon(Icons.add, size: 20),
        label: const Text('Añadir'),
      ),
      child: Column(
        children: [
          if (_variants.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.style_outlined,
                    size: 40,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sin variantes',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Añade tallas y colores para este producto',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _variants.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final variant = _variants[index];
                return _VariantTile(
                  variant: variant,
                  onEdit: () => _editVariant(index),
                  onDelete: () {
                    setState(() => _variants.removeAt(index));
                  },
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildOrganizationSection() {
    return _SectionCard(
      title: 'Organización',
      child: Column(
        children: [
          // Estado
          DropdownButtonFormField<String>(
            value: _selectedStatus,
            decoration: const InputDecoration(
              labelText: 'Estado',
              border: OutlineInputBorder(borderRadius: BorderRadius.zero),
            ),
            items: const [
              DropdownMenuItem(value: 'active', child: Text('Activo')),
              DropdownMenuItem(value: 'draft', child: Text('Borrador')),
              DropdownMenuItem(value: 'archived', child: Text('Archivado')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedStatus = value);
              }
            },
          ),
          const SizedBox(height: 16),

          // Destacado
          SwitchListTile(
            title: const Text('Producto destacado'),
            subtitle: const Text('Aparecerá en la sección de destacados'),
            value: _isFeatured,
            onChanged: (value) => setState(() => _isFeatured = value),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildSeoSection() {
    return _SectionCard(
      title: 'SEO',
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Título SEO',
              hintText: 'Título para buscadores',
              border: OutlineInputBorder(borderRadius: BorderRadius.zero),
              counterText: '0/70',
            ),
            maxLength: 70,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Descripción SEO',
              hintText: 'Descripción para buscadores',
              border: OutlineInputBorder(borderRadius: BorderRadius.zero),
              alignLabelWithHint: true,
              counterText: '0/160',
            ),
            maxLines: 3,
            maxLength: 160,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_isEditing)
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: const Text('Cancelar'),
                ),
              ),
            if (_isEditing) const SizedBox(width: 12),
            Expanded(
              flex: _isEditing ? 2 : 1,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandNavy,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(_isEditing ? 'Guardar cambios' : 'Crear producto'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addImages() {
    // TODO: Implementar selector de imágenes
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función de subida de imágenes')),
    );
  }

  void _addVariant() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) => _AddVariantSheet(
        sizes: _sizes,
        colors: _colors,
        baseSku: _skuController.text,
        onAdd: (variant) {
          setState(() => _variants.add(variant));
        },
      ),
    );
  }

  void _editVariant(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) => _AddVariantSheet(
        sizes: _sizes,
        colors: _colors,
        baseSku: _skuController.text,
        variant: _variants[index],
        onAdd: (variant) {
          setState(() => _variants[index] = variant);
        },
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Duplicar producto'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Duplicar producto
              },
            ),
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('Vista previa'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Vista previa
              },
            ),
            if (_isEditing)
              ListTile(
                leading: const Icon(Icons.archive_outlined),
                title: const Text('Archivar'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedStatus = 'archived');
                },
              ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('Eliminar producto'),
        content: const Text(
          '¿Estás seguro de eliminar este producto? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Eliminar producto
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showDiscardDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('Descartar cambios'),
        content: const Text(
          'Tienes cambios sin guardar. ¿Deseas descartarlos?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Seguir editando'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text('Descartar'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Implementar guardado real
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing ? 'Producto actualizado' : 'Producto creado',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

// Modelo de variante
class _ProductVariant {
  final String size;
  final String color;
  final int stock;
  final String sku;

  _ProductVariant({
    required this.size,
    required this.color,
    required this.stock,
    required this.sku,
  });
}

// Widgets auxiliares
class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _SectionCard({
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _ImageTile extends StatelessWidget {
  final String imageUrl;
  final bool isMain;
  final VoidCallback onRemove;

  const _ImageTile({
    super.key,
    required this.imageUrl,
    required this.isMain,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: isMain ? AppColors.brandNavy : AppColors.border,
          width: isMain ? 2 : 1,
        ),
      ),
      child: Stack(
        children: [
          Container(
            color: AppColors.brandNavy.withValues(alpha: 0.1),
            child: const Center(
              child: Icon(Icons.image, color: AppColors.textTertiary),
            ),
          ),
          if (isMain)
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                color: AppColors.brandNavy,
                child: const Text(
                  'Principal',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          Positioned(
            top: 4,
            right: 4,
            child: InkWell(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4),
                color: AppColors.error,
                child: const Icon(Icons.close, size: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VariantTile extends StatelessWidget {
  final _ProductVariant variant;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _VariantTile({
    required this.variant,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      title: Text('${variant.size} / ${variant.color}'),
      subtitle: Text(
        'SKU: ${variant.sku} • Stock: ${variant.stock}',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            onPressed: onDelete,
            color: AppColors.error,
          ),
        ],
      ),
    );
  }
}

class _AddVariantSheet extends StatefulWidget {
  final List<String> sizes;
  final List<String> colors;
  final String baseSku;
  final _ProductVariant? variant;
  final Function(_ProductVariant) onAdd;

  const _AddVariantSheet({
    required this.sizes,
    required this.colors,
    required this.baseSku,
    this.variant,
    required this.onAdd,
  });

  @override
  State<_AddVariantSheet> createState() => _AddVariantSheetState();
}

class _AddVariantSheetState extends State<_AddVariantSheet> {
  late String _selectedSize;
  late String _selectedColor;
  late TextEditingController _stockController;
  late TextEditingController _skuController;

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.variant?.size ?? widget.sizes.first;
    _selectedColor = widget.variant?.color ?? widget.colors.first;
    _stockController =
        TextEditingController(text: widget.variant?.stock.toString() ?? '0');
    _skuController = TextEditingController(
      text: widget.variant?.sku ??
          '${widget.baseSku}-$_selectedSize-$_selectedColor',
    );
  }

  @override
  void dispose() {
    _stockController.dispose();
    _skuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.variant != null ? 'Editar variante' : 'Nueva variante',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),

            // Talla
            DropdownButtonFormField<String>(
              value: _selectedSize,
              decoration: const InputDecoration(
                labelText: 'Talla',
                border: OutlineInputBorder(borderRadius: BorderRadius.zero),
              ),
              items: widget.sizes.map((size) {
                return DropdownMenuItem(value: size, child: Text(size));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedSize = value;
                    _updateSku();
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Color
            DropdownButtonFormField<String>(
              value: _selectedColor,
              decoration: const InputDecoration(
                labelText: 'Color',
                border: OutlineInputBorder(borderRadius: BorderRadius.zero),
              ),
              items: widget.colors.map((color) {
                return DropdownMenuItem(value: color, child: Text(color));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedColor = value;
                    _updateSku();
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Stock y SKU
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _stockController,
                    decoration: const InputDecoration(
                      labelText: 'Stock',
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _skuController,
                    decoration: const InputDecoration(
                      labelText: 'SKU',
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Botón guardar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onAdd(_ProductVariant(
                    size: _selectedSize,
                    color: _selectedColor,
                    stock: int.tryParse(_stockController.text) ?? 0,
                    sku: _skuController.text,
                  ));
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandNavy,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Text(widget.variant != null ? 'Actualizar' : 'Añadir'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _updateSku() {
    _skuController.text =
        '${widget.baseSku}-${_selectedSize.substring(0, 1)}-${_selectedColor.substring(0, 2).toUpperCase()}';
  }
}
