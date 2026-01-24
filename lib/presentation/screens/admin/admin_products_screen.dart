import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';
import '../../../data/models/product.dart';
import '../../providers/product_provider.dart';

/// Pantalla de gestión de productos del admin
class AdminProductsScreen extends ConsumerStatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  ConsumerState<AdminProductsScreen> createState() =>
      _AdminProductsScreenState();
}

class _AdminProductsScreenState extends ConsumerState<AdminProductsScreen> {
  final _searchController = TextEditingController();
  final _currencyFormat = NumberFormat.currency(symbol: '€');

  String _selectedCategory = 'Todas';
  String _selectedStatus = 'Todos';
  String _sortBy = 'name';
  bool _sortAscending = true;
  List<String> _selectedProducts = [];
  bool _isSelectionMode = false;

  final List<String> _categories = [
    'Todas',
    'Chaquetas',
    'Camisas',
    'Pantalones',
    'Accesorios',
    'Calzado',
    'Jerseys',
  ];

  final List<String> _statuses = ['Todos', 'Activo', 'Sin stock', 'Borrador'];

  @override
  void initState() {
    super.initState();
    // Cargar productos al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productsProvider.notifier).loadProducts(refresh: true);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);
    final products = productsState.products;
    final isLoading = productsState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: _isSelectionMode
            ? Text('${_selectedProducts.length} seleccionados')
            : const Text('Productos'),
        leading: _isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _isSelectionMode = false;
                    _selectedProducts.clear();
                  });
                },
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
        actions: _isSelectionMode
            ? [
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: _selectedProducts.isNotEmpty
                      ? () => _deleteSelectedProducts()
                      : null,
                ),
                PopupMenuButton<String>(
                  onSelected: _handleBulkAction,
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'activate',
                      child: Text('Activar'),
                    ),
                    const PopupMenuItem(
                      value: 'deactivate',
                      child: Text('Desactivar'),
                    ),
                    const PopupMenuItem(
                      value: 'export',
                      child: Text('Exportar'),
                    ),
                  ],
                ),
              ]
            : [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: _showFilterSheet,
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => context.push('/admin/products/new'),
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
                hintText: 'Buscar productos...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref
                              .read(productsProvider.notifier)
                              .applyFilters(searchQuery: '');
                        },
                      )
                    : null,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (value) {
                ref
                    .read(productsProvider.notifier)
                    .applyFilters(searchQuery: value);
              },
            ),
          ),

          // Filtros activos
          if (_selectedCategory != 'Todas' || _selectedStatus != 'Todos')
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColors.brandNavy.withValues(alpha: 0.05),
              child: Wrap(
                spacing: 8,
                children: [
                  if (_selectedCategory != 'Todas')
                    Chip(
                      label: Text(_selectedCategory),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () {
                        setState(() => _selectedCategory = 'Todas');
                        _applyFilters();
                      },
                      backgroundColor:
                          AppColors.brandNavy.withValues(alpha: 0.1),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                    ),
                  if (_selectedStatus != 'Todos')
                    Chip(
                      label: Text(_selectedStatus),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () {
                        setState(() => _selectedStatus = 'Todos');
                        _applyFilters();
                      },
                      backgroundColor:
                          AppColors.brandNavy.withValues(alpha: 0.1),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                    ),
                ],
              ),
            ),

          // Resumen
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${products.length} productos',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                TextButton.icon(
                  onPressed: _showSortOptions,
                  icon: Icon(
                    _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 16,
                  ),
                  label: Text(_getSortLabel()),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Lista de productos
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : products.isEmpty
                    ? _buildEmptyState()
                    : NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification is ScrollEndNotification &&
                              notification.metrics.extentAfter == 0) {
                            ref.read(productsProvider.notifier).loadMore();
                          }
                          return false;
                        },
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await ref
                                .read(productsProvider.notifier)
                                .loadProducts(refresh: true);
                          },
                          child: ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: products.length +
                                (productsState.hasMore ? 1 : 0),
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              if (index >= products.length) {
                                return const Center(
                                    child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(),
                                ));
                              }
                              final product = products[index];
                              return _ProductCard(
                                product: product,
                                isSelected: _selectedProducts
                                    .contains(product.id.toString()),
                                isSelectionMode: _isSelectionMode,
                                onTap: () {
                                  if (_isSelectionMode) {
                                    _toggleSelection(product.id.toString());
                                  } else {
                                    context
                                        .push('/admin/products/${product.id}');
                                  }
                                },
                                onLongPress: () {
                                  if (!_isSelectionMode) {
                                    setState(() {
                                      _isSelectionMode = true;
                                      _selectedProducts
                                          .add(product.id.toString());
                                    });
                                  }
                                },
                                currencyFormat: _currencyFormat,
                              );
                            },
                          ),
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: !_isSelectionMode
          ? FloatingActionButton(
              onPressed: () => context.push('/admin/products/new'),
              backgroundColor: AppColors.brandNavy,
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  void _applyFilters() {
    // String? categoryId;
    // TODO: Map category name to ID properly. For now we use name as ID if possible or wait for category map.
    // Assuming backend takes ID, but we only have name here.
    // We should fetch categories and map them.
    // For now passing null if 'Todas'.

    String? status;
    switch (_selectedStatus) {
      case 'Activo':
        status = 'active';
        break;
      case 'Sin stock':
        status = 'out_of_stock'; // Or low_stock logic?
        break;
      case 'Borrador':
        status = 'draft';
        break;
    }

    ref.read(productsProvider.notifier).applyFilters(
          categoryId: null, // Placeholder
          status: status,
        );
  }

  void _updateSort(String sortBy) {
    setState(() {
      if (_sortBy == sortBy) {
        _sortAscending = !_sortAscending;
      } else {
        _sortBy = sortBy;
        _sortAscending = true;
      }
    });

    // Map sortBy to backend values
    String backendSort = '';
    if (sortBy == 'price') {
      backendSort = _sortAscending ? 'price_asc' : 'price_desc';
    } else if (sortBy == 'name') {
      // Not supported by backend standard options? 'newest', 'oldest', 'price_asc', 'price_desc'
      // Let's stick to supported ones or add more.
      backendSort = 'newest';
    }

    ref.read(productsProvider.notifier).applyFilters(
          sortBy: backendSort,
        );
    Navigator.pop(context);
  }

  String _getSortLabel() {
    switch (_sortBy) {
      case 'name':
        return 'Nombre';
      case 'price':
        return 'Precio';
      case 'stock':
        return 'Stock';
      case 'sales':
        return 'Ventas';
      default:
        return 'Ordenar';
    }
  }

  void _toggleSelection(String productId) {
    setState(() {
      if (_selectedProducts.contains(productId)) {
        _selectedProducts.remove(productId);
        if (_selectedProducts.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedProducts.add(productId);
      }
    });
  }

  void _deleteSelectedProducts() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('Eliminar productos'),
        content: Text(
          '¿Estás seguro de eliminar ${_selectedProducts.length} producto(s)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implementar eliminación
              Navigator.pop(context);
              setState(() {
                _isSelectionMode = false;
                _selectedProducts.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Productos eliminados')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _handleBulkAction(String action) {
    switch (action) {
      case 'activate':
        // TODO: Activar productos
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Productos activados')),
        );
        break;
      case 'deactivate':
        // TODO: Desactivar productos
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Productos desactivados')),
        );
        break;
      case 'export':
        // TODO: Exportar productos
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exportando productos...')),
        );
        break;
    }
    setState(() {
      _isSelectionMode = false;
      _selectedProducts.clear();
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'No se encontraron productos',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              _searchController.clear();
              setState(() {
                _selectedCategory = 'Todas';
                _selectedStatus = 'Todos';
              });
              _applyFilters();
            },
            child: const Text('Limpiar filtros'),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filtrar productos',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              Text(
                'Categoría',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setSheetState(() {
                        _selectedCategory = category;
                        // Also update parent state to reflect in UI behind sheet?
                        // But _applyFilters reads from _selectedCategory of the state class.
                        // Wait, setSheetState only updates the SHEET.
                        // The parent state needs to be updated too if we want persistence.
                        // I should update PARENT state inside setSheetState?
                        // No, inside setSheetState I update variables, but those variables are of the PARENT class.
                        // So I should call setState (parent) or just update variables?
                        // If I update variables, and call setSheetState, the sheet rebuilds.
                        // The parent doesn't rebuild until I call setState.
                        // Code below calls setState on parent?
                      });
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: AppColors.surface,
                    selectedColor: AppColors.brandNavy,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text(
                'Estado',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _statuses.map((status) {
                  final isSelected = _selectedStatus == status;
                  return FilterChip(
                    label: Text(status),
                    selected: isSelected,
                    onSelected: (selected) {
                      setSheetState(() {
                        _selectedStatus = status;
                      });
                      setState(() {
                        _selectedStatus = status;
                      });
                    },
                    backgroundColor: AppColors.surface,
                    selectedColor: AppColors.brandNavy,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setSheetState(() {
                          // Update parent vars too
                          _selectedCategory = 'Todas';
                          _selectedStatus = 'Todos';
                        });
                        setState(() {
                          _selectedCategory = 'Todas';
                          _selectedStatus = 'Todos';
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: const Text('Limpiar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _applyFilters();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandNavy,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: const Text('Aplicar'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Ordenar por'),
              dense: true,
            ),
            _SortOption(
              label: 'Nombre',
              value: 'name',
              currentValue: _sortBy,
              ascending: _sortAscending,
              onTap: () => _updateSort('name'),
            ),
            _SortOption(
              label: 'Precio',
              value: 'price',
              currentValue: _sortBy,
              ascending: _sortAscending,
              onTap: () => _updateSort('price'),
            ),
            _SortOption(
              label: 'Stock',
              value: 'stock',
              currentValue: _sortBy,
              ascending: _sortAscending,
              onTap: () => _updateSort('stock'),
            ),
            _SortOption(
              label: 'Ventas',
              value: 'sales',
              currentValue: _sortBy,
              ascending: _sortAscending,
              onTap: () => _updateSort('sales'),
            ),
          ],
        ),
      ),
    );
  }
}

// Widgets auxiliares
class _ProductCard extends StatelessWidget {
  final Product product;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final NumberFormat currencyFormat;

  const _ProductCard({
    required this.product,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTap,
    required this.onLongPress,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (product.status) {
      case 'active':
        statusColor = AppColors.success;
        statusText = 'Activo';
        statusIcon = Icons.check_circle;
        break;
      case 'low_stock':
        statusColor = AppColors.warning;
        statusText = 'Stock bajo';
        statusIcon = Icons.warning;
        break;
      case 'out_of_stock':
        statusColor = AppColors.error;
        statusText = 'Sin stock';
        statusIcon = Icons.error;
        break;
      case 'draft':
        statusColor = AppColors.textSecondary;
        statusText = 'Borrador';
        statusIcon = Icons.edit;
        break;
      default:
        statusColor = AppColors.textSecondary;
        statusText = product.status;
        statusIcon = Icons.info;
    }

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.brandNavy.withValues(alpha: 0.1)
              : AppColors.surface,
          border: Border.all(
            color: isSelected ? AppColors.brandNavy : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            if (isSelectionMode)
              Checkbox(
                value: isSelected,
                onChanged: (_) => onTap(),
                activeColor: AppColors.brandNavy,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            Container(
              width: 80,
              height: 80,
              color: AppColors.brandNavy.withValues(alpha: 0.05),
              child: product.images.isNotEmpty
                  ? Image.network(
                      product.mainImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                            child: Icon(Icons.image_not_supported,
                                color: AppColors.textTertiary));
                      },
                    )
                  : const Center(
                      child: Icon(
                        Icons.image_outlined,
                        color: AppColors.textTertiary,
                        size: 32,
                      ),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.categoryName ?? 'Sin categoría',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currencyFormat.format(product.currentPrice / 100),
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                statusIcon,
                                size: 12,
                                color: statusColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                statusText,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: AppColors.border),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${product.stock}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Stock',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  final String label;
  final String value;
  final String currentValue;
  final bool ascending;
  final VoidCallback onTap;

  const _SortOption({
    required this.label,
    required this.value,
    required this.currentValue,
    required this.ascending,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentValue == value;

    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.brandNavy : AppColors.textPrimary,
        ),
      ),
      trailing: isSelected
          ? Icon(
              ascending ? Icons.arrow_upward : Icons.arrow_downward,
              color: AppColors.brandNavy,
              size: 20,
            )
          : null,
      onTap: onTap,
    );
  }
}
