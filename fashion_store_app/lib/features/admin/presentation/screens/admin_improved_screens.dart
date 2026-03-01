// Pantallas mejoradas de admin - Categorías y Pedidos

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_text_styles.dart';
import '../../../../shared/services/supabase_service.dart';
import '../../../categories/data/models/category_model.dart';
import '../../../categories/presentation/providers/categories_provider.dart';
import '../providers/categories_admin_provider.dart';
import '../providers/orders_admin_provider.dart';

/// Pantalla mejorada de gestión de categorías con CRUD completo + imágenes
class AdminCategoriesScreenImproved extends ConsumerWidget {
  const AdminCategoriesScreenImproved({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCategoryDialog(context, ref),
          ),
        ],
      ),
      body: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('No hay categorías'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.82,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final hasProducts = category.productCount > 0;

              return Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          category.imageUrl != null &&
                                  category.imageUrl!.isNotEmpty
                              ? Image.network(
                                  category.displayImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.category,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : Container(
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.category,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                          // Product count badge
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: hasProducts
                                    ? Colors.black.withOpacity(0.65)
                                    : Colors.grey.withOpacity(0.65),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${category.productCount} productos',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Info + actions
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: AppTextStyles.labelLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '/${category.slug}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Edit button
                              InkWell(
                                onTap: () => _showCategoryDialog(
                                  context,
                                  ref,
                                  category: category,
                                ),
                                borderRadius: BorderRadius.circular(6),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.edit_outlined,
                                    size: 18,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                              // Delete or "En uso"
                              hasProducts
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange[50],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'En uso',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.orange[700],
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () => _confirmDelete(
                                        context,
                                        ref,
                                        category,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Icon(
                                          Icons.delete_outline,
                                          size: 18,
                                          color: Colors.red[400],
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    CategoryModel category,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar categoría'),
        content: Text(
          '¿Eliminar "${category.name}"? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final deleted = await ref
            .read(categoryActionsProvider)
            .deleteCategory(category.id);

        if (!deleted && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'No se puede eliminar: hay productos en esta categoría',
              ),
              backgroundColor: Colors.red,
            ),
          );
        } else if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Categoría eliminada')));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  void _showCategoryDialog(
    BuildContext context,
    WidgetRef ref, {
    CategoryModel? category,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => _CategoryFormDialog(ref: ref, category: category),
    );
  }
}

/// Dialog para crear/editar categoría con selección de imagen
class _CategoryFormDialog extends StatefulWidget {
  final WidgetRef ref;
  final CategoryModel? category;

  const _CategoryFormDialog({required this.ref, this.category});

  @override
  State<_CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<_CategoryFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  bool _loading = false;
  XFile? _pickedImage;
  Uint8List? _imagePreviewBytes;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.category?.description ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _pickedImage = picked;
        _imagePreviewBytes = bytes;
      });
    }
  }

  Future<void> _submit() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('El nombre es requerido')));
      return;
    }

    setState(() => _loading = true);
    try {
      String? imageUrl;
      if (_pickedImage != null) {
        imageUrl = await widget.ref
            .read(categoryActionsProvider)
            .uploadCategoryImage(_pickedImage!);
      }

      if (widget.category != null) {
        await widget.ref
            .read(categoryActionsProvider)
            .updateCategory(
              categoryId: widget.category!.id,
              name: _nameController.text.trim(),
              description: _descriptionController.text.trim(),
              imageUrl: imageUrl,
            );
      } else {
        await widget.ref
            .read(categoryActionsProvider)
            .createCategory(
              name: _nameController.text.trim(),
              description: _descriptionController.text.trim(),
              imageUrl: imageUrl,
            );
      }

      if (mounted) {
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
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.category != null;

    return AlertDialog(
      title: Text(isEdit ? 'Editar Categoría' : 'Nueva Categoría'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image picker
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                clipBehavior: Clip.antiAlias,
                child: _imagePreviewBytes != null
                    ? Image.memory(_imagePreviewBytes!, fit: BoxFit.cover)
                    : (isEdit &&
                          widget.category!.imageUrl != null &&
                          widget.category!.imageUrl!.isNotEmpty)
                    ? Image.network(
                        widget.category!.displayImage,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imagePlaceholder(),
                      )
                    : _imagePlaceholder(),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Toca para cambiar la imagen',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEdit ? 'Actualizar' : 'Crear'),
        ),
      ],
    );
  }

  Widget _imagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate_outlined,
          size: 36,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 6),
        Text(
          'Agregar imagen',
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
      ],
    );
  }
}

/// Pantalla mejorada de gestión de pedidos con cambios de estado
// ============================================================
// HELPERS: Shipping type detection (matches web logic exactly)
// ============================================================

/// Determines type of shipping from shipping_method info
String _getShippingType(
  Map<String, dynamic> order,
  Map<int, Map<String, dynamic>> methodsMap,
) {
  final methodId = order['shipping_method_id'] as int?;
  if (methodId == null) return 'standard';
  final method = methodsMap[methodId];
  if (method == null) return 'standard';

  final name = (method['name'] as String? ?? '').toLowerCase();

  // Pickup
  if (name.contains('recoger') ||
      name.contains('tienda') ||
      method['cost'] == 0) {
    return 'pickup';
  }
  // Express (24-48h)
  if (name.contains('express') ||
      (method['min_days'] != null && (method['min_days'] as int) <= 2)) {
    return 'express';
  }
  return 'standard';
}

/// Sort: paid first (priority 0), then ready/shipped (priority 1). Within same group oldest first.
int _sortByPriorityAndDate(Map<String, dynamic> a, Map<String, dynamic> b) {
  final priorityA = a['status'] == 'paid' ? 0 : 1;
  final priorityB = b['status'] == 'paid' ? 0 : 1;
  if (priorityA != priorityB) return priorityA - priorityB;
  final dateA = DateTime.parse(a['created_at']);
  final dateB = DateTime.parse(b['created_at']);
  return dateA.compareTo(dateB);
}

// ============================================================
// ADMIN ORDERS SCREEN — exact replica of web pedidos.astro
// ============================================================

class AdminOrdersScreenImproved extends ConsumerStatefulWidget {
  const AdminOrdersScreenImproved({super.key});

  @override
  ConsumerState<AdminOrdersScreenImproved> createState() =>
      _AdminOrdersScreenImprovedState();
}

class _AdminOrdersScreenImprovedState
    extends ConsumerState<AdminOrdersScreenImproved> {
  String _completedSearch = '';
  String _completedFilter = '';
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final activeAsync = ref.watch(activeOrdersProvider);
    final completedAsync = ref.watch(completedOrdersProvider);
    final methodsAsync = ref.watch(shippingMethodsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Pedidos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(activeOrdersProvider);
              ref.invalidate(completedOrdersProvider);
              ref.invalidate(shippingMethodsProvider);
            },
          ),
        ],
      ),
      body: activeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (activeOrders) {
          // Build shipping methods map
          final methods = methodsAsync.value ?? [];
          final methodsMap = <int, Map<String, dynamic>>{};
          for (final m in methods) {
            methodsMap[m['id'] as int] = m;
          }

          // Separate orders by shipping type
          final expressOrders =
              activeOrders
                  .where((o) => _getShippingType(o, methodsMap) == 'express')
                  .toList()
                ..sort(_sortByPriorityAndDate);
          final standardOrders =
              activeOrders
                  .where((o) => _getShippingType(o, methodsMap) == 'standard')
                  .toList()
                ..sort(_sortByPriorityAndDate);
          final pickupOrders =
              activeOrders
                  .where((o) => _getShippingType(o, methodsMap) == 'pickup')
                  .toList()
                ..sort(_sortByPriorityAndDate);

          final shippedCount = activeOrders
              .where((o) => o['status'] == 'shipped')
              .length;

          // Completed orders
          final completedOrders = completedAsync.value ?? [];
          final filteredCompleted = completedOrders.where((o) {
            if (_completedFilter.isNotEmpty && o['status'] != _completedFilter)
              return false;
            if (_completedSearch.isNotEmpty) {
              final id = '${o['id'] ?? ''}'.padLeft(5, '0');
              if (!id.contains(_completedSearch.replaceAll('#', '')))
                return false;
            }
            return true;
          }).toList();

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(activeOrdersProvider);
              ref.invalidate(completedOrdersProvider);
              ref.invalidate(shippingMethodsProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ===== STATS CARDS =====
                _buildStatsRow(
                  expressOrders,
                  standardOrders,
                  pickupOrders,
                  shippedCount,
                  completedOrders
                      .where((o) => o['status'] == 'delivered')
                      .length,
                ),
                const SizedBox(height: 24),

                // ===== EXPRESS SECTION =====
                _buildSectionHeader(
                  icon: Icons.flash_on,
                  title: 'Envío Express (24-48h)',
                  count: expressOrders.length,
                  color: Colors.red,
                  badge: 'PRIORIDAD ALTA',
                ),
                const SizedBox(height: 8),
                if (expressOrders.isEmpty)
                  _buildEmptySection('No hay pedidos express pendientes')
                else
                  ...expressOrders.asMap().entries.map(
                    (entry) => _buildOrderCard(
                      entry.value,
                      Colors.red,
                      isExpress: true,
                      isFirst: entry.key == 0,
                    ),
                  ),
                const SizedBox(height: 24),

                // ===== STANDARD SECTION =====
                _buildSectionHeader(
                  icon: Icons.inventory_2,
                  title: 'Envío Estándar (5-7 días)',
                  count: standardOrders.length,
                  color: Colors.blue,
                ),
                const SizedBox(height: 8),
                if (standardOrders.isEmpty)
                  _buildEmptySection('No hay pedidos estándar pendientes')
                else
                  ...standardOrders.map((o) => _buildOrderCard(o, Colors.blue)),
                const SizedBox(height: 24),

                // ===== PICKUP SECTION =====
                _buildSectionHeader(
                  icon: Icons.store,
                  title: 'Recogida en Tienda',
                  count: pickupOrders.length,
                  color: Colors.orange,
                ),
                const SizedBox(height: 8),
                if (pickupOrders.isEmpty)
                  _buildEmptySection('No hay pedidos de recogida pendientes')
                else
                  ...pickupOrders.map(
                    (o) => _buildOrderCard(o, Colors.orange, isPickup: true),
                  ),
                const SizedBox(height: 32),

                // ===== COMPLETED SECTION =====
                Container(
                  padding: const EdgeInsets.only(top: 24),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.green, width: 3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Pedidos Completados',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Entregados o cancelados (${completedOrders.length} pedidos)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Search & filter
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (v) =>
                                  setState(() => _completedSearch = v.trim()),
                              decoration: InputDecoration(
                                hintText: 'Buscar por ID...',
                                prefixIcon: const Icon(Icons.search, size: 20),
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          DropdownButton<String>(
                            value: _completedFilter.isEmpty
                                ? null
                                : _completedFilter,
                            hint: const Text('Estado'),
                            items: const [
                              DropdownMenuItem(value: '', child: Text('Todos')),
                              DropdownMenuItem(
                                value: 'delivered',
                                child: Text('Entregado'),
                              ),
                              DropdownMenuItem(
                                value: 'cancelled',
                                child: Text('Cancelado'),
                              ),
                            ],
                            onChanged: (v) =>
                                setState(() => _completedFilter = v ?? ''),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Completed orders list
                      if (filteredCompleted.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(
                            child: Text('No hay pedidos completados'),
                          ),
                        )
                      else
                        ...filteredCompleted.map(
                          (o) => _buildCompletedOrderTile(o),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  // ========================
  // STATS ROW (5 cards)
  // ========================
  Widget _buildStatsRow(
    List<Map<String, dynamic>> express,
    List<Map<String, dynamic>> standard,
    List<Map<String, dynamic>> pickup,
    int shippedCount,
    int deliveredCount,
  ) {
    final expressPending = express.where((o) => o['status'] == 'paid').length;
    final standardPending = standard.where((o) => o['status'] == 'paid').length;
    final pickupPending = pickup.where((o) => o['status'] == 'paid').length;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _statCard(
            '$expressPending',
            'Express Pendientes',
            Colors.red,
            Icons.flash_on,
          ),
          const SizedBox(width: 8),
          _statCard(
            '$standardPending',
            'Estándar Pendientes',
            Colors.blue,
            Icons.inventory_2,
          ),
          const SizedBox(width: 8),
          _statCard(
            '$pickupPending',
            'Recogida Pendientes',
            Colors.orange,
            Icons.store,
          ),
          const SizedBox(width: 8),
          _statCard(
            '$shippedCount',
            'En Camino',
            Colors.purple,
            Icons.local_shipping,
          ),
          const SizedBox(width: 8),
          _statCard(
            '$deliveredCount',
            'Entregados',
            Colors.green,
            Icons.check_circle,
          ),
        ],
      ),
    );
  }

  Widget _statCard(String value, String label, Color color, IconData icon) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(icon, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ========================
  // SECTION HEADER
  // ========================
  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required int count,
    required Color color,
    String? badge,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '($count)',
          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
        ),
        if (badge != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              badge,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEmptySection(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey[500]),
      ),
    );
  }

  // ========================
  // ORDER CARD (matches web)
  // ========================
  Widget _buildOrderCard(
    Map<String, dynamic> order,
    Color sectionColor, {
    bool isExpress = false,
    bool isPickup = false,
    bool isFirst = false,
  }) {
    final status = order['status'] ?? '';
    final total = (order['total'] ?? 0) / 100.0;
    final items =
        (order['order_items'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final createdAt = DateTime.parse(order['created_at']);
    final orderId = order['id'] as int;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isExpress
              ? sectionColor.withOpacity(0.4)
              : sectionColor.withOpacity(0.2),
          width: isExpress ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: ID + status + date
            Row(
              children: [
                if (isExpress && isFirst && status == 'paid')
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.notifications_active,
                          size: 12,
                          color: Colors.white,
                        ),
                        SizedBox(width: 2),
                        Text(
                          'URGENTE',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                Text(
                  '#${orderId.toString().padLeft(5, '0')}',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1E3A5F),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(child: _buildStatusBadge(status)),
                const SizedBox(width: 8),
                Text(
                  DateFormat('d MMM, HH:mm', 'es').format(createdAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Customer info
            Text(
              order['customer_name'] ?? 'Cliente',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            Text(
              order['customer_email'] ?? '',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),

            // Address block (NOT for pickup)
            if (!isPickup &&
                (order['customer_address'] != null ||
                    order['shipping_address'] != null)) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: sectionColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: sectionColor),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            order['customer_address'] ??
                                order['shipping_address'] ??
                                '',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (order['customer_postal_code'] != null ||
                        order['customer_city'] != null ||
                        order['shipping_postal_code'] != null ||
                        order['shipping_city'] != null)
                      Text(
                        '${order['customer_postal_code'] ?? order['shipping_postal_code'] ?? ''} ${order['customer_city'] ?? order['shipping_city'] ?? ''}'
                            .trim(),
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    if (order['customer_phone'] != null)
                      Text(
                        'Tel: ${order['customer_phone']}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                  ],
                ),
              ),
            ],

            // Phone for pickup
            if (isPickup && order['customer_phone'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Tel: ${order['customer_phone']}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ),

            // Items chips
            if (items.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  ...items
                      .take(3)
                      .map(
                        (item) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${item['product_name'] ?? 'Producto'} x ${item['quantity'] ?? 1}',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                  if (items.length > 3)
                    Text(
                      '+${items.length - 3} más',
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                ],
              ),
            ],

            const SizedBox(height: 12),

            // Bottom row: total + action button
            Row(
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${total.toStringAsFixed(2)} \u20AC',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${items.length} producto(s)',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // ACTION BUTTONS
                if (_isProcessing)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else ...[
                  if (isPickup) ...[
                    // Pickup: paid → "Listo" (ready_for_pickup), ready_for_pickup → "Entregado" (delivered)
                    if (status == 'paid')
                      _actionButton(
                        'Listo',
                        Icons.check,
                        Colors.orange,
                        () => _confirmAction(
                          orderId,
                          'ready_for_pickup',
                          order['customer_email'] ?? '',
                          order['customer_name'] ?? '',
                        ),
                      ),
                    if (status == 'ready_for_pickup')
                      _actionButton(
                        'Entregado',
                        Icons.check_circle,
                        Colors.green,
                        () => _confirmAction(
                          orderId,
                          'delivered',
                          order['customer_email'] ?? '',
                          order['customer_name'] ?? '',
                        ),
                      ),
                  ] else ...[
                    // Express/Standard: paid → "Listo" (opens shipping modal), shipped → "Entregado"
                    if (status == 'paid')
                      _actionButton(
                        'Listo',
                        Icons.check,
                        sectionColor,
                        () => _showShippingDialog(
                          orderId,
                          order['customer_email'] ?? '',
                          order['customer_name'] ?? '',
                        ),
                      ),
                    if (status == 'shipped')
                      _actionButton(
                        'Entregado',
                        Icons.check_circle,
                        Colors.green,
                        () => _confirmAction(
                          orderId,
                          'delivered',
                          order['customer_email'] ?? '',
                          order['customer_name'] ?? '',
                        ),
                      ),
                  ],
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // ========================
  // COMPLETED ORDER TILE
  // ========================
  Widget _buildCompletedOrderTile(Map<String, dynamic> order) {
    final status = order['status'] ?? '';
    final total = (order['total'] ?? 0) / 100.0;
    final items =
        (order['order_items'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final createdAt = DateTime.parse(order['created_at']);
    final orderId = order['id'] as int;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          status == 'delivered' ? Icons.check_circle : Icons.cancel,
          color: status == 'delivered' ? Colors.green : Colors.red,
        ),
        title: Row(
          children: [
            Text(
              '#${orderId.toString().padLeft(5, '0')}',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(child: _buildStatusBadge(status)),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order['customer_name'] ?? 'Cliente',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              DateFormat('dd/MM/yyyy HH:mm').format(createdAt),
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
            if (items.isNotEmpty)
              Text(
                '${items.length} producto(s)',
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
          ],
        ),
        trailing: Text(
          '${total.toStringAsFixed(2)} \u20AC',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        isThreeLine: true,
        onTap: () => _showOrderDetailSheet(order),
      ),
    );
  }

  // ========================
  // STATUS BADGE
  // ========================
  Widget _buildStatusBadge(String status) {
    Color color;
    String label;

    switch (status) {
      case 'pending':
        color = Colors.amber;
        label = 'Pendiente de Pago';
        break;
      case 'paid':
        color = Colors.blue;
        label = 'Pagado - Preparar';
        break;
      case 'ready_for_pickup':
        color = Colors.orange;
        label = 'Listo';
        break;
      case 'shipped':
        color = Colors.purple;
        label = 'Enviado';
        break;
      case 'delivered':
        color = Colors.green;
        label = 'Entregado';
        break;
      case 'cancelled':
        color = Colors.red;
        label = 'Cancelado';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ========================
  // CONFIRM ACTION (direct status change)
  // ========================
  Future<void> _confirmAction(
    int orderId,
    String newStatus,
    String email,
    String name,
  ) async {
    final actionLabels = {
      'ready_for_pickup': 'marcar como listo para recoger',
      'delivered': 'marcar como entregado',
    };

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar actualización'),
        content: Text(
          '¿Confirmar ${actionLabels[newStatus] ?? newStatus}?\n\nSe enviará un email a $email',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isProcessing = true);
    try {
      final emailSent = await ref
          .read(orderActionsProvider)
          .updateOrderStatus(orderId: orderId, newStatus: newStatus);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              emailSent
                  ? 'Pedido actualizado: ${actionLabels[newStatus] ?? newStatus} ✓ Email enviado'
                  : 'Pedido actualizado (sin email - API web no disponible)',
            ),
            backgroundColor: emailSent ? Colors.green : Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  // ========================
  // SHIPPING DIALOG (carrier + tracking number)
  // ========================
  Future<void> _showShippingDialog(
    int orderId,
    String email,
    String name,
  ) async {
    final carriersAsync = ref.read(shippingCarriersProvider);
    final carriers = carriersAsync.value ?? [];

    // If carriers not loaded yet, load them
    if (carriers.isEmpty) {
      final supabase = ref.read(supabaseClientProvider);
      final response = await supabase
          .from('shipping_carriers')
          .select('*')
          .eq('is_active', true)
          .order('display_order');
      carriers.addAll(List<Map<String, dynamic>>.from(response));
    }

    if (!mounted) return;

    int? selectedCarrierId;
    String trackingNumber = '';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.local_shipping, color: Colors.orange[700]),
              const SizedBox(width: 12),
              const Flexible(
                child: Text('Datos de Envío', overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selecciona el transportista y añade el número de seguimiento:',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Transportista',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.local_shipping),
                  ),
                  items: carriers
                      .map(
                        (c) => DropdownMenuItem<int>(
                          value: c['id'] as int,
                          child: Text(c['name'] as String),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setDialogState(() => selectedCarrierId = v),
                  hint: const Text('Seleccionar...'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Número de Seguimiento',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.qr_code),
                    hintText: 'Ej: 1Z999AA10123456784',
                  ),
                  onChanged: (v) => trackingNumber = v,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.amber[800], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'El cliente recibirá un email con estos datos',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.amber[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(ctx, true),
              icon: const Icon(Icons.send, size: 18),
              label: const Text('Confirmar Envío'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isProcessing = true);
    try {
      final emailSent = await ref
          .read(orderActionsProvider)
          .updateOrderStatus(
            orderId: orderId,
            newStatus: 'shipped',
            trackingNumber: trackingNumber.isNotEmpty ? trackingNumber : null,
            shippingCarrierId: selectedCarrierId,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              emailSent
                  ? 'Pedido enviado ✓ Email con tracking enviado al cliente'
                  : 'Pedido enviado (sin email - API web no disponible)',
            ),
            backgroundColor: emailSent ? Colors.green : Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  // ========================
  // ORDER DETAIL BOTTOM SHEET
  // ========================
  void _showOrderDetailSheet(Map<String, dynamic> order) {
    final status = order['status'] ?? '';
    final total = (order['total'] ?? 0) / 100.0;
    final items =
        (order['order_items'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final createdAt = DateTime.parse(order['created_at']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pedido #${order['id']}', style: AppTextStyles.h4),
                        const SizedBox(height: 4),
                        Text(
                          order['customer_name'] ?? '',
                          style: const TextStyle(fontSize: 14),
                        ),
                        if (order['customer_email'] != null)
                          Text(
                            order['customer_email'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd/MM/yyyy HH:mm').format(createdAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(status),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),
              if (items.isNotEmpty) ...[
                Text('Artículos', style: AppTextStyles.labelLarge),
                const SizedBox(height: 12),
                ...items.map<Widget>((item) {
                  final qty = item['quantity'] ?? 1;
                  final unitPrice =
                      (item['price_at_purchase'] ?? item['unit_price'] ?? 0) /
                      100.0;
                  final lineTotal = unitPrice * qty;
                  final size = '${item['size'] ?? ''}';
                  final imgUrl = item['product_image'] as String?;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: imgUrl != null
                              ? Image.network(
                                  imgUrl,
                                  width: 52,
                                  height: 52,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 52,
                                    height: 52,
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      size: 20,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 52,
                                  height: 52,
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.shopping_bag,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['product_name'] ?? 'Producto',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              if (size.isNotEmpty)
                                Text(
                                  'Talla: $size',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              Text(
                                'Cant: $qty',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${lineTotal.toStringAsFixed(2)} \u20AC',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const Divider(),
                const SizedBox(height: 8),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    '${total.toStringAsFixed(2)} \u20AC',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Ver factura
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(sheetCtx);
                  context.push('/invoice/${order['id']}');
                },
                icon: const Icon(Icons.receipt_long),
                label: const Text('Ver Factura'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
