import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../shared/widgets/cached_image.dart';
import '../../../../shared/widgets/loaders.dart';
import '../../../../shared/widgets/empty_states.dart';
import '../providers/products_provider.dart';
import '../widgets/add_to_cart_button.dart';

/// Pantalla de detalle de producto
class ProductDetailScreen extends ConsumerWidget {
  final String slug;

  const ProductDetailScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productBySlugProvider(slug));

    return Scaffold(
      body: productAsync.when(
        data: (product) {
          return CustomScrollView(
            slivers: [
              // App Bar con imagen
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height * 0.5,
                pinned: true,
                backgroundColor: AppColors.surface,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back),
                  ),
                  onPressed: () => context.pop(),
                ),
                actions: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.share),
                    ),
                    onPressed: () {
                      // TODO: Compartir producto
                    },
                  ),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite_outline),
                    ),
                    onPressed: () {
                      // TODO: Añadir a favoritos
                    },
                  ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Galería de imágenes (sin Hero para evitar anidamiento)
                      ImageGallery(
                        images: product.images.isNotEmpty
                            ? product.images
                            : [product.mainImage],
                        heroTagPrefix: null, // Desactivar Hero en galería
                      ),

                      // Badges
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Row(
                          children: [
                            if (product.isOnSale)
                              SaleBadge(
                                discountPercentage: product.discountPercentage,
                              ),
                            if (product.isLowStock) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.warning,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '¡Últimas unidades!',
                                  style: AppTextStyles.badge.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Contenido
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Categoría
                      if (product.category != null)
                        Text(
                          product.category!.name.toUpperCase(),
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.textSecondary,
                            letterSpacing: 1,
                          ),
                        ),
                      const SizedBox(height: 8),

                      // Nombre
                      Text(product.name, style: AppTextStyles.h2),
                      const SizedBox(height: 12),

                      // Precios
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (product.isOnSale) ...[
                            Text(
                              '${(product.currentPrice / 100).toStringAsFixed(2)} €',
                              style: AppTextStyles.h3.copyWith(
                                color: AppColors.salePrice,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${(product.price / 100).toStringAsFixed(2)} €',
                              style: AppTextStyles.bodyLarge.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ] else
                            Text(
                              '${(product.currentPrice / 100).toStringAsFixed(2)} €',
                              style: AppTextStyles.h3,
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Stock
                      Row(
                        children: [
                          Icon(
                            product.isInStock
                                ? Icons.check_circle
                                : Icons.cancel,
                            size: 16,
                            color: product.isInStock
                                ? AppColors.success
                                : AppColors.error,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            product.isInStock
                                ? 'En stock (${product.stock} disponibles)'
                                : 'Agotado',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: product.isInStock
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Divider
                      const Divider(),
                      const SizedBox(height: 24),

                      // Añadir al carrito
                      AddToCartButton(product: product),
                      const SizedBox(height: 32),

                      // Descripción
                      Text('Descripción', style: AppTextStyles.h5),
                      const SizedBox(height: 12),
                      Text(
                        product.description ?? 'Sin descripción disponible.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Información adicional
                      _InfoSection(
                        title: 'Envío',
                        icon: Icons.local_shipping_outlined,
                        content: 'Envío gratuito en pedidos superiores a 100€',
                      ),
                      const SizedBox(height: 16),
                      _InfoSection(
                        title: 'Devoluciones',
                        icon: Icons.refresh,
                        content: 'Devolución gratuita en 30 días',
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const ProductDetailShimmer(),
        error: (error, _) => Scaffold(
          appBar: AppBar(),
          body: ErrorState(
            message: error.toString(),
            onRetry: () => ref.invalidate(productBySlugProvider(slug)),
          ),
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final String content;

  const _InfoSection({
    required this.title,
    required this.icon,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.labelLarge),
                const SizedBox(height: 2),
                Text(
                  content,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
