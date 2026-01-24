import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_colors.dart';
import '../../providers/product_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/dialogs.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/product_card.dart';
import '../../widgets/common/selectors.dart';

/// Pantalla de catálogo de productos
class ProductsScreen extends ConsumerStatefulWidget {
  final String? category;
  final String? collection;
  final bool? isNew;
  final bool? isFeatured;
  final bool? onSale;
  final String? searchQuery;

  const ProductsScreen({
    super.key,
    this.category,
    this.collection,
    this.isNew,
    this.isFeatured,
    this.onSale,
    this.searchQuery,
  });

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final ScrollController _scrollController = ScrollController();
  String _sortBy = 'newest';
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Cargar productos con filtros iniciales
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProducts();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Cargar más productos
      ref.read(productsProvider.notifier).loadMore();
    }
  }

  void _loadProducts() {
    ref.read(productsProvider.notifier).applyFilters(
          categoryId: widget.category,
          sortBy: _sortBy,
          onSale: widget.onSale,
          featured: widget.isFeatured,
          searchQuery: widget.searchQuery,
        );
  }

  void _applySorting(String sortBy) {
    setState(() => _sortBy = sortBy);
    ref.read(productsProvider.notifier).setSort(sortBy);
  }

  String get _screenTitle {
    if (widget.searchQuery != null) return 'Búsqueda';
    if (widget.category != null) return widget.category!;
    if (widget.isNew == true) return 'Nuevas Llegadas';
    if (widget.isFeatured == true) return 'Destacados';
    if (widget.onSale == true) return 'Ofertas';
    return 'Catálogo';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productsProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: _screenTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de filtros y ordenar
          _FilterBar(
            productCount: state.total,
            sortBy: _sortBy,
            isGridView: _isGridView,
            onSortChanged: _applySorting,
            onViewChanged: (isGrid) => setState(() => _isGridView = isGrid),
            onFilterPressed: () => _showFilters(context),
          ),

          // Lista de productos
          Expanded(
            child: _buildProductList(state),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(ProductsState state) {
    if (state.isLoading && state.products.isEmpty) {
      return _isGridView
          ? const ProductGridShimmer()
          : ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) => const ListItemShimmer(),
            );
    }

    if (state.products.isEmpty) {
      return EmptySearchWidget(
        query: widget.searchQuery ?? '',
      );
    }

    if (_isGridView) {
      return GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.55,
          crossAxisSpacing: 16,
          mainAxisSpacing: 24,
        ),
        itemCount: state.products.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.products.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }

          final product = state.products[index];
          return ProductCard(
            product: product,
            onTap: () => context.push('/product/${product.id}'),
          );
        },
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: state.products.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.products.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        final product = state.products[index];
        return ProductListTile(
          product: product,
          onTap: () => context.push('/product/${product.id}'),
        );
      },
    );
  }

  void _showFilters(BuildContext context) {
    FilterBottomSheet.show(
      context: context,
      title: 'Filtros',
      sections: [
        FilterSection(
          key: 'price_range',
          title: 'Rango de Precio',
          builder: (context, value, onChanged) {
            return _PriceRangeFilter(
              currentRange: value as RangeValues? ?? const RangeValues(0, 1000),
              onChanged: onChanged,
            );
          },
        ),
        FilterSection(
          key: 'sizes',
          title: 'Tallas',
          builder: (context, value, onChanged) {
            return SizeSelector(
              sizes: const ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
              selectedSize: value as String?,
              onSelected: (size) => onChanged(size),
            );
          },
        ),
        FilterSection(
          key: 'availability',
          title: 'Disponibilidad',
          builder: (context, value, onChanged) {
            return FilterChips(
              options: const [
                FilterChipOption(id: 'in_stock', label: 'En stock'),
                FilterChipOption(id: 'on_sale', label: 'En oferta'),
                FilterChipOption(id: 'new', label: 'Nuevo'),
              ],
              selectedIds: (value as List<String>?) ?? [],
              onChanged: onChanged,
            );
          },
        ),
      ],
      onReset: () {
        // Resetear filtros
      },
    ).then((filters) {
      if (filters != null) {
        // Aplicar filtros
        // TODO: Implementar aplicación de filtros
      }
    });
  }
}

class _FilterBar extends StatelessWidget {
  final int productCount;
  final String sortBy;
  final bool isGridView;
  final ValueChanged<String> onSortChanged;
  final ValueChanged<bool> onViewChanged;
  final VoidCallback onFilterPressed;

  const _FilterBar({
    required this.productCount,
    required this.sortBy,
    required this.isGridView,
    required this.onSortChanged,
    required this.onViewChanged,
    required this.onFilterPressed,
  });

  String get _sortLabel {
    switch (sortBy) {
      case 'newest':
        return 'Más recientes';
      case 'price_asc':
        return 'Precio: menor a mayor';
      case 'price_desc':
        return 'Precio: mayor a menor';
      case 'name_asc':
        return 'A-Z';
      case 'name_desc':
        return 'Z-A';
      default:
        return 'Ordenar';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          // Contador
          Text(
            '$productCount productos',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          // Filtros
          GestureDetector(
            onTap: onFilterPressed,
            child: Row(
              children: [
                const Icon(
                  Icons.tune,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                const Text(
                  'Filtros',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Ordenar
          GestureDetector(
            onTap: () => _showSortOptions(context),
            child: Row(
              children: [
                const Icon(
                  Icons.sort,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  _sortLabel,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Vista
          GestureDetector(
            onTap: () => onViewChanged(!isGridView),
            child: Icon(
              isGridView ? Icons.grid_view : Icons.view_list,
              size: 20,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    OptionsBottomSheet.show(
      context: context,
      title: 'Ordenar por',
      options: const [
        OptionItem(label: 'Más recientes', value: 'newest'),
        OptionItem(label: 'Precio: menor a mayor', value: 'price_asc'),
        OptionItem(label: 'Precio: mayor a menor', value: 'price_desc'),
        OptionItem(label: 'Nombre: A-Z', value: 'name_asc'),
        OptionItem(label: 'Nombre: Z-A', value: 'name_desc'),
      ],
    ).then((value) {
      if (value != null) {
        onSortChanged(value);
      }
    });
  }
}

class _PriceRangeFilter extends StatefulWidget {
  final RangeValues currentRange;
  final ValueChanged<RangeValues> onChanged;

  const _PriceRangeFilter({
    required this.currentRange,
    required this.onChanged,
  });

  @override
  State<_PriceRangeFilter> createState() => _PriceRangeFilterState();
}

class _PriceRangeFilterState extends State<_PriceRangeFilter> {
  late RangeValues _currentRange;

  @override
  void initState() {
    super.initState();
    _currentRange = widget.currentRange;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '€${_currentRange.start.toInt()}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '€${_currentRange.end.toInt()}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        RangeSlider(
          values: _currentRange,
          min: 0,
          max: 1000,
          divisions: 20,
          activeColor: AppColors.brandNavy,
          inactiveColor: AppColors.border,
          onChanged: (values) {
            setState(() => _currentRange = values);
            widget.onChanged(values);
          },
        ),
      ],
    );
  }
}
