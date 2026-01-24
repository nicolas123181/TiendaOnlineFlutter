import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_colors.dart';

/// Pantalla de gestión de categorías del admin
class AdminCategoriesScreen extends ConsumerStatefulWidget {
  const AdminCategoriesScreen({super.key});

  @override
  ConsumerState<AdminCategoriesScreen> createState() =>
      _AdminCategoriesScreenState();
}

class _AdminCategoriesScreenState extends ConsumerState<AdminCategoriesScreen> {
  final _searchController = TextEditingController();

  // Datos de ejemplo
  final List<_CategoryData> _categories = [
    _CategoryData(
      id: 'CAT-001',
      name: 'Camisas',
      slug: 'camisas',
      description: 'Camisas de vestir y casual para hombre',
      imageUrl: null,
      productCount: 45,
      isActive: true,
      displayOrder: 1,
    ),
    _CategoryData(
      id: 'CAT-002',
      name: 'Pantalones',
      slug: 'pantalones',
      description: 'Pantalones formales y casuales',
      imageUrl: null,
      productCount: 32,
      isActive: true,
      displayOrder: 2,
    ),
    _CategoryData(
      id: 'CAT-003',
      name: 'Blazers',
      slug: 'blazers',
      description: 'Blazers y americanas elegantes',
      imageUrl: null,
      productCount: 18,
      isActive: true,
      displayOrder: 3,
    ),
    _CategoryData(
      id: 'CAT-004',
      name: 'Polos',
      slug: 'polos',
      description: 'Polos de manga corta y larga',
      imageUrl: null,
      productCount: 28,
      isActive: true,
      displayOrder: 4,
    ),
    _CategoryData(
      id: 'CAT-005',
      name: 'Accesorios',
      slug: 'accesorios',
      description: 'Cinturones, corbatas y más',
      imageUrl: null,
      productCount: 67,
      isActive: true,
      displayOrder: 5,
    ),
    _CategoryData(
      id: 'CAT-006',
      name: 'Outlet',
      slug: 'outlet',
      description: 'Productos con descuento',
      imageUrl: null,
      productCount: 15,
      isActive: false,
      displayOrder: 6,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCategoryForm(null),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar categorías...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),

          // Información
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text(
                  '${_getFilteredCategories().length} categorías',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _reorderCategories,
                  icon: const Icon(Icons.swap_vert, size: 18),
                  label: const Text('Reordenar'),
                ),
              ],
            ),
          ),

          // Lista de categorías
          Expanded(
            child: _getFilteredCategories().isEmpty
                ? _buildEmptyState()
                : ReorderableListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _getFilteredCategories().length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex--;
                        final item =
                            _getFilteredCategories().removeAt(oldIndex);
                        _getFilteredCategories().insert(newIndex, item);
                        // Actualizar orden de visualización
                        for (int i = 0; i < _categories.length; i++) {
                          _categories[i] = _CategoryData(
                            id: _categories[i].id,
                            name: _categories[i].name,
                            slug: _categories[i].slug,
                            description: _categories[i].description,
                            imageUrl: _categories[i].imageUrl,
                            productCount: _categories[i].productCount,
                            isActive: _categories[i].isActive,
                            displayOrder: i + 1,
                          );
                        }
                      });
                    },
                    itemBuilder: (context, index) {
                      final category = _getFilteredCategories()[index];
                      return _CategoryCard(
                        key: ValueKey(category.id),
                        category: category,
                        onTap: () => _showCategoryForm(category),
                        onToggle: () => _toggleCategory(category),
                        onDelete: () => _confirmDelete(category),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryForm(null),
        backgroundColor: AppColors.brandNavy,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  List<_CategoryData> _getFilteredCategories() {
    if (_searchController.text.isEmpty) {
      return _categories
        ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    }
    final query = _searchController.text.toLowerCase();
    return _categories
        .where((cat) =>
            cat.name.toLowerCase().contains(query) ||
            cat.description.toLowerCase().contains(query))
        .toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'No hay categorías',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _showCategoryForm(null),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandNavy,
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            child: const Text('Crear categoría'),
          ),
        ],
      ),
    );
  }

  void _showCategoryForm(_CategoryData? category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) => _CategoryFormSheet(
        category: category,
        onSave: (newCategory) {
          setState(() {
            if (category != null) {
              final index = _categories.indexWhere((c) => c.id == category.id);
              if (index != -1) {
                _categories[index] = newCategory;
              }
            } else {
              _categories.add(newCategory);
            }
          });
        },
      ),
    );
  }

  void _toggleCategory(_CategoryData category) {
    setState(() {
      final index = _categories.indexWhere((c) => c.id == category.id);
      if (index != -1) {
        _categories[index] = _CategoryData(
          id: category.id,
          name: category.name,
          slug: category.slug,
          description: category.description,
          imageUrl: category.imageUrl,
          productCount: category.productCount,
          isActive: !category.isActive,
          displayOrder: category.displayOrder,
        );
      }
    });
  }

  void _confirmDelete(_CategoryData category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('Eliminar categoría'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('¿Eliminar la categoría "${category.name}"?'),
            if (category.productCount > 0) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                color: AppColors.warning.withValues(alpha: 0.1),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: AppColors.warning),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Esta categoría tiene ${category.productCount} productos asociados',
                        style: const TextStyle(color: AppColors.warning),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _categories.removeWhere((c) => c.id == category.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Categoría eliminada')),
              );
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

  void _reorderCategories() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) => _ReorderSheet(
        categories: _categories,
        onSave: (reorderedCategories) {
          setState(() {
            _categories.clear();
            _categories.addAll(reorderedCategories);
          });
        },
      ),
    );
  }
}

// Modelo de datos
class _CategoryData {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String? imageUrl;
  final int productCount;
  final bool isActive;
  final int displayOrder;

  _CategoryData({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    this.imageUrl,
    required this.productCount,
    required this.isActive,
    required this.displayOrder,
  });
}

// Widgets auxiliares
class _CategoryCard extends StatelessWidget {
  final _CategoryData category;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Drag handle
              const Icon(
                Icons.drag_handle,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: 12),

              // Imagen o placeholder
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  image: category.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(category.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: category.imageUrl == null
                    ? const Icon(
                        Icons.category,
                        color: AppColors.textTertiary,
                      )
                    : null,
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          category.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          color: category.isActive
                              ? AppColors.success.withValues(alpha: 0.1)
                              : AppColors.error.withValues(alpha: 0.1),
                          child: Text(
                            category.isActive ? 'Activa' : 'Inactiva',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: category.isActive
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${category.productCount} productos',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textTertiary,
                                  ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.link,
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '/${category.slug}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textTertiary,
                                    fontFamily: 'monospace',
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Acciones
              PopupMenuButton<String>(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onTap();
                      break;
                    case 'toggle':
                      onToggle();
                      break;
                    case 'delete':
                      onDelete();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Editar'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'toggle',
                    child: ListTile(
                      leading: Icon(
                        category.isActive
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      title: Text(category.isActive ? 'Desactivar' : 'Activar'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete, color: AppColors.error),
                      title: Text('Eliminar',
                          style: TextStyle(color: AppColors.error)),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryFormSheet extends StatefulWidget {
  final _CategoryData? category;
  final Function(_CategoryData) onSave;

  const _CategoryFormSheet({this.category, required this.onSave});

  @override
  State<_CategoryFormSheet> createState() => _CategoryFormSheetState();
}

class _CategoryFormSheetState extends State<_CategoryFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _slugController;
  late TextEditingController _descriptionController;
  String? _imageUrl;
  bool _isActive = true;
  bool _autoSlug = true;

  @override
  void initState() {
    super.initState();
    final category = widget.category;

    _nameController = TextEditingController(text: category?.name ?? '');
    _slugController = TextEditingController(text: category?.slug ?? '');
    _descriptionController =
        TextEditingController(text: category?.description ?? '');
    _imageUrl = category?.imageUrl;
    _isActive = category?.isActive ?? true;
    _autoSlug = category == null;

    _nameController.addListener(_onNameChanged);
  }

  void _onNameChanged() {
    if (_autoSlug) {
      _slugController.text = _generateSlug(_nameController.text);
    }
  }

  String _generateSlug(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[áàäâ]'), 'a')
        .replaceAll(RegExp(r'[éèëê]'), 'e')
        .replaceAll(RegExp(r'[íìïî]'), 'i')
        .replaceAll(RegExp(r'[óòöô]'), 'o')
        .replaceAll(RegExp(r'[úùüû]'), 'u')
        .replaceAll(RegExp(r'[ñ]'), 'n')
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .trim();
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    _slugController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          color: AppColors.background,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.category != null
                            ? 'Editar categoría'
                            : 'Nueva categoría',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Form
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Imagen
                        Text(
                          'Imagen de categoría',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {
                            // TODO: Implementar selección de imagen
                          },
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              border: Border.all(
                                color: AppColors.border,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: _imageUrl != null
                                ? Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.network(
                                        _imageUrl!,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() => _imageUrl = null);
                                          },
                                          icon: const Icon(Icons.close),
                                          style: IconButton.styleFrom(
                                            backgroundColor: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 48,
                                        color: AppColors.textTertiary,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Toca para añadir imagen',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Nombre
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre *',
                            hintText: 'Ej: Camisas',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El nombre es obligatorio';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Slug
                        TextFormField(
                          controller: _slugController,
                          decoration: InputDecoration(
                            labelText: 'Slug *',
                            hintText: 'ej: camisas',
                            prefixText: '/',
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.zero),
                            suffixIcon: Checkbox(
                              value: _autoSlug,
                              onChanged: (value) {
                                setState(() => _autoSlug = value ?? false);
                                if (_autoSlug) {
                                  _onNameChanged();
                                }
                              },
                            ),
                            helperText: _autoSlug ? 'Auto-generado' : null,
                          ),
                          enabled: !_autoSlug,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El slug es obligatorio';
                            }
                            if (!RegExp(r'^[a-z0-9-]+$').hasMatch(value)) {
                              return 'Solo letras minúsculas, números y guiones';
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
                            hintText: 'Descripción de la categoría',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),

                        // Estado
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Categoría activa'),
                          subtitle: const Text(
                              'Las categorías inactivas no se muestran en la tienda'),
                          value: _isActive,
                          onChanged: (value) =>
                              setState(() => _isActive = value),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),

                // Bottom bar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveCategory,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandNavy,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Text(
                          widget.category != null
                              ? 'Guardar cambios'
                              : 'Crear categoría',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveCategory() {
    if (!_formKey.currentState!.validate()) return;

    final category = _CategoryData(
      id: widget.category?.id ??
          'CAT-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
      name: _nameController.text,
      slug: _slugController.text,
      description: _descriptionController.text,
      imageUrl: _imageUrl,
      productCount: widget.category?.productCount ?? 0,
      isActive: _isActive,
      displayOrder: widget.category?.displayOrder ?? 99,
    );

    widget.onSave(category);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.category != null
              ? 'Categoría actualizada'
              : 'Categoría creada',
        ),
      ),
    );
  }
}

class _ReorderSheet extends StatefulWidget {
  final List<_CategoryData> categories;
  final Function(List<_CategoryData>) onSave;

  const _ReorderSheet({
    required this.categories,
    required this.onSave,
  });

  @override
  State<_ReorderSheet> createState() => _ReorderSheetState();
}

class _ReorderSheetState extends State<_ReorderSheet> {
  late List<_CategoryData> _orderedCategories;

  @override
  void initState() {
    super.initState();
    _orderedCategories = List.from(widget.categories);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Container(
        color: AppColors.background,
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reordenar categorías',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Lista reordenable
            Expanded(
              child: ReorderableListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                itemCount: _orderedCategories.length,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--;
                    final item = _orderedCategories.removeAt(oldIndex);
                    _orderedCategories.insert(newIndex, item);
                  });
                },
                itemBuilder: (context, index) {
                  final category = _orderedCategories[index];
                  return Container(
                    key: ValueKey(category.id),
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.drag_handle,
                            color: AppColors.textTertiary),
                        const SizedBox(width: 12),
                        Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          color: AppColors.brandNavy.withValues(alpha: 0.1),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.brandNavy,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            category.name,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          '${category.productCount}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Actualizar orden
                      final updatedCategories = _orderedCategories
                          .asMap()
                          .entries
                          .map((entry) => _CategoryData(
                                id: entry.value.id,
                                name: entry.value.name,
                                slug: entry.value.slug,
                                description: entry.value.description,
                                imageUrl: entry.value.imageUrl,
                                productCount: entry.value.productCount,
                                isActive: entry.value.isActive,
                                displayOrder: entry.key + 1,
                              ))
                          .toList();

                      widget.onSave(updatedCategories);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Orden actualizado')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandNavy,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text('Guardar orden'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
