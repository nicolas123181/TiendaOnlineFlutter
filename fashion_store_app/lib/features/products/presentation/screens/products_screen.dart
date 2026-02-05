import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../shared/widgets/loaders.dart';
import '../../../../shared/widgets/empty_states.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../providers/products_provider.dart';
import '../widgets/product_card.dart';
import '../../../categories/presentation/providers/categories_provider.dart';
import '../../data/models/product_model.dart';

/// Pantalla de listado de productos
class ProductsScreen extends ConsumerStatefulWidget {
  final String? categorySlug;

  const ProductsScreen({super.key, this.categorySlug});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String? _lastPrecacheKey;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentFilter = ref.watch(currentFilterProvider);
    final effectiveFilter = currentFilter.copyWith(
      categorySlug: widget.categorySlug ?? currentFilter.categorySlug,
    );
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategorySlug = effectiveFilter.categorySlug;
    final appBarTitle = selectedCategorySlug == null
        ? 'TIENDA'
        : categoriesAsync.maybeWhen(
            data: (categories) {
              String? resolvedName;
              for (final category in categories) {
                if (category.slug == selectedCategorySlug) {
                  resolvedName = category.name;
                  break;
                }
              }
              final name = resolvedName ?? selectedCategorySlug;
              return name.toUpperCase();
            },
            orElse: () => selectedCategorySlug.toUpperCase(),
          );
    final productsAsync = ref.watch(productsProvider(effectiveFilter));

    return Scaffold(
      appBar: CustomAppBar(
        title: appBarTitle,
        onSearchPressed: () => _showSearchSheet(context),
        additionalActions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () =>
                _showFilterSheet(context, currentFilter: effectiveFilter),
          ),
        ],
      ),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return EmptyState(
              icon: Icons.inventory_2_outlined,
              title: 'Sin productos',
              subtitle: 'No hay productos disponibles en esta categoría.',
              actionText: 'Ver todos',
              onAction: () => context.go('/products'),
            );
          }

          _precacheProductImages(products);

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(productsProvider(effectiveFilter));
            },
            child: GridView.builder(
              key: const PageStorageKey<String>('products-grid'),
              controller: _scrollController,
              cacheExtent: 800,
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return RepaintBoundary(
                  child: ProductCard(
                    product: products[index],
                    heroTag: 'products-grid-${products[index].id}-$index',
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.all(16),
          child: ProductGridShimmer(),
        ),
        error: (error, _) => ErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(productsProvider(effectiveFilter)),
        ),
      ),
    );
  }

  void _precacheProductImages(List<ProductModel> products) {
    if (!mounted) return;
    final images = products
        .take(6)
        .map((product) => product.mainImage)
        .where((url) => url.trim().isNotEmpty)
        .toList();

    if (images.isEmpty) return;
    final key = images.join('|');
    if (key == _lastPrecacheKey) return;
    _lastPrecacheKey = key;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      for (final url in images) {
        precacheImage(CachedNetworkImageProvider(url), context);
      }
    });
  }

  void _showSearchSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Buscar productos...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchController.clear();
                      Navigator.pop(context);
                    },
                  ),
                ),
                onSubmitted: (query) {
                  Navigator.pop(context);
                  // TODO: Implementar búsqueda
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterSheet(
    BuildContext context, {
    required ProductsFilter currentFilter,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        ProductsFilter tempFilter = currentFilter;

        bool isSortSelected(String sortBy, bool ascending) {
          return tempFilter.sortBy == sortBy &&
              tempFilter.ascending == ascending;
        }

        return StatefulBuilder(
          builder: (context, setState) {
            return Consumer(
              builder: (context, ref, _) {
                final categoriesAsync = ref.watch(categoriesProvider);

                return Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Filtros', style: AppTextStyles.h4),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                tempFilter = ProductsFilter(
                                  categorySlug: widget.categorySlug,
                                );
                              });
                              ref
                                  .read(currentFilterProvider.notifier)
                                  .updateFilter(tempFilter);
                              Navigator.pop(context);
                            },
                            child: const Text('Limpiar'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text('Ordenar por', style: AppTextStyles.labelLarge),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _FilterChip(
                            label: 'Más recientes',
                            selected: isSortSelected('created_at', false),
                            onSelected: (value) {
                              if (!value) return;
                              setState(() {
                                tempFilter = tempFilter.copyWith(
                                  sortBy: 'created_at',
                                  ascending: false,
                                );
                              });
                            },
                          ),
                          _FilterChip(
                            label: 'Precio: menor a mayor',
                            selected: isSortSelected('price', true),
                            onSelected: (value) {
                              if (!value) return;
                              setState(() {
                                tempFilter = tempFilter.copyWith(
                                  sortBy: 'price',
                                  ascending: true,
                                );
                              });
                            },
                          ),
                          _FilterChip(
                            label: 'Precio: mayor a menor',
                            selected: isSortSelected('price', false),
                            onSelected: (value) {
                              if (!value) return;
                              setState(() {
                                tempFilter = tempFilter.copyWith(
                                  sortBy: 'price',
                                  ascending: false,
                                );
                              });
                            },
                          ),
                          _FilterChip(
                            label: 'Más vendidos',
                            selected: false,
                            onSelected: (_) {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text('Filtrar', style: AppTextStyles.labelLarge),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _FilterChip(
                            label: 'En oferta',
                            selected: tempFilter.onlyOnSale == true,
                            onSelected: (value) {
                              setState(() {
                                tempFilter = tempFilter.copyWith(
                                  onlyOnSale: value ? true : null,
                                );
                              });
                            },
                          ),
                          _FilterChip(
                            label: 'En stock',
                            selected: tempFilter.onlyInStock == true,
                            onSelected: (value) {
                              setState(() {
                                tempFilter = tempFilter.copyWith(
                                  onlyInStock: value ? true : null,
                                );
                              });
                            },
                          ),
                          _FilterChip(
                            label: 'Destacados',
                            selected: tempFilter.onlyFeatured == true,
                            onSelected: (value) {
                              setState(() {
                                tempFilter = tempFilter.copyWith(
                                  onlyFeatured: value ? true : null,
                                );
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text('Categorías', style: AppTextStyles.labelLarge),
                      const SizedBox(height: 12),
                      categoriesAsync.when(
                        data: (categories) => Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _FilterChip(
                              label: 'Todas',
                              selected: tempFilter.categorySlug == null,
                              onSelected: (value) {
                                if (!value) return;
                                setState(() {
                                  tempFilter = tempFilter.copyWith(
                                    categorySlug: null,
                                  );
                                });
                              },
                            ),
                            ...categories.map(
                              (category) => _FilterChip(
                                label: category.name,
                                selected:
                                    tempFilter.categorySlug == category.slug,
                                onSelected: (value) {
                                  if (!value) return;
                                  setState(() {
                                    tempFilter = tempFilter.copyWith(
                                      categorySlug: category.slug,
                                    );
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        loading: () => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (error, _) => Text(
                          'No se pudieron cargar las categorías',
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            ref
                                .read(currentFilterProvider.notifier)
                                .updateFilter(tempFilter);
                            Navigator.pop(context);
                          },
                          child: const Text('APLICAR FILTROS'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;

  const _FilterChip({
    required this.label,
    this.selected = false,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
    );
  }
}
