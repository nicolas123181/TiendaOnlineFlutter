import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../shared/widgets/loaders.dart';
import '../../../../shared/widgets/empty_states.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../products/presentation/providers/products_provider.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../../categories/presentation/providers/categories_provider.dart';
import '../../../products/presentation/widgets/product_card.dart';
import '../../../products/presentation/widgets/flash_offers_section.dart';

/// Pantalla principal (Home)
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(featuredProductsProvider);
          ref.invalidate(saleProductsProvider);
          ref.invalidate(flashOffersEnabledProvider);
        },
        child: CustomScrollView(
          slivers: [
            // App Bar con logo
            SliverAppBar(
              floating: true,
              pinned: true,
              expandedHeight: 60,
              backgroundColor: AppColors.surface,
              leading: Consumer(
                builder: (context, ref, _) {
                  final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
                  return IconButton(
                    icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                    onPressed: () =>
                        ref.read(themeModeProvider.notifier).toggleTheme(),
                    tooltip: isDark ? 'Modo claro' : 'Modo oscuro',
                  );
                },
              ),
              title: Text(
                'VANTAGE',
                style: AppTextStyles.h3.copyWith(
                  letterSpacing: 6,
                  fontWeight: FontWeight.w400,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _showSearchSheet(context),
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined),
                  onPressed: () => context.push('/cart'),
                ),
                const SizedBox(width: 8),
              ],
            ),

            // Banner hero
            SliverToBoxAdapter(child: _HeroBanner()),

            // Sección de ofertas flash (real-time)
            const SliverToBoxAdapter(child: FlashOffersSection()),

            // Productos destacados
            SliverToBoxAdapter(
              child: _SectionHeader(
                title: 'Destacados',
                onViewAll: () => context.push('/products?featured=true'),
              ),
            ),
            SliverToBoxAdapter(child: _FeaturedProducts()),

            // Categorías
            SliverToBoxAdapter(
              child: _SectionHeader(
                title: 'Categorías',
                onViewAll: () => context.push('/categories'),
              ),
            ),
            SliverToBoxAdapter(child: _CategoriesGrid()),

            // Productos recientes
            SliverToBoxAdapter(
              child: _SectionHeader(
                title: 'Novedades',
                onViewAll: () => context.push('/products'),
              ),
            ),
            const SliverToBoxAdapter(child: _RecentProducts()),

            // Espaciado final
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  void _showSearchSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Buscar productos...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                    filled: true,
                    fillColor: AppColors.backgroundSecondary,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (query) {
                    Navigator.pop(context);
                    context.push('/products?search=$query');
                  },
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    Text(
                      'Búsquedas populares',
                      style: AppTextStyles.labelLarge,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['Camisas', 'Trajes', 'Pantalones', 'Abrigos']
                          .map((search) {
                            return ActionChip(
                              label: Text(search),
                              onPressed: () {
                                Navigator.pop(context);
                                context.push('/products?search=$search');
                              },
                            );
                          })
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Banner hero con imagen y CTA
class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=800',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: AppColors.darkOverlay,
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NUEVA\nCOLECCIÓN',
              style: AppTextStyles.h1.copyWith(
                color: Colors.white,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Elegancia atemporal',
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.push('/products'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
              ),
              child: const Text('EXPLORAR'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Header de sección
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const _SectionHeader({required this.title, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.h4),
          if (onViewAll != null)
            TextButton(onPressed: onViewAll, child: const Text('Ver todo')),
        ],
      ),
    );
  }
}

/// Grid de productos destacados
class _FeaturedProducts extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(featuredProductsProvider);

    return productsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 160,
                child: ProductCard(product: products[index], isCompact: true),
              );
            },
          ),
        );
      },
      loading: () => const CarouselShimmer(),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}

/// Grid de categorías
class _CategoriesGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      data: (categories) {
        return SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () => context.push('/category/${category.slug}'),
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundSecondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getCategoryIcon(category.slug),
                        size: 32,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category.name,
                        style: AppTextStyles.labelMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const CarouselShimmer(height: 120),
      error: (error, _) => const SizedBox.shrink(),
    );
  }

  IconData _getCategoryIcon(String slug) {
    switch (slug) {
      case 'camisas':
        return Icons.dry_cleaning;
      case 'camisetas':
        return Icons.checkroom;
      case 'pantalones':
        return Icons.straighten;
      case 'trajes':
        return Icons.business_center;
      case 'chalecos':
        return Icons.layers;
      case 'abrigos':
        return Icons.ac_unit;
      default:
        return Icons.category;
    }
  }
}

/// Productos recientes
class _RecentProducts extends ConsumerWidget {
  const _RecentProducts();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(
      productsProvider(const ProductsFilter(limit: 6)),
    );

    return productsAsync.when(
      data: (products) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(product: products[index]);
            },
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ProductGridShimmer(itemCount: 4),
      ),
      error: (error, _) => ErrorState(
        message: error.toString(),
        onRetry: () => ref.invalidate(productsProvider),
      ),
    );
  }
}
