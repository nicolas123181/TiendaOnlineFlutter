import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../shared/widgets/cached_image.dart';
import '../../../../shared/widgets/empty_states.dart';
import '../../data/models/product_model.dart';

/// Tarjeta de producto para grids y listas
class ProductCard extends ConsumerWidget {
  final ProductModel product;
  final bool isCompact;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.isCompact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap ?? () => context.push('/product/${product.slug}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen con badges
          AspectRatio(
            aspectRatio: 3 / 4,
            child: Stack(
              children: [
                // Imagen
                Hero(
                  tag: 'product-${product.id}',
                  child: CachedImage(
                    imageUrl: product.mainImage,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                // Badges
                Positioned(
                  top: 8,
                  left: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.isOnSale)
                        SaleBadge(
                          discountPercentage: product.discountPercentage,
                        ),
                      if (product.isOutOfStock) ...[
                        const SizedBox(height: 4),
                        const OutOfStockBadge(),
                      ],
                    ],
                  ),
                ),

                // Botón de favorito
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_outline, size: 16),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        // TODO: Implementar favoritos
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Añadido a favoritos')),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Contenido con Expanded para prevenir overflow
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre del producto
                Flexible(
                  child: Text(
                    product.name,
                    style: isCompact
                        ? AppTextStyles.labelMedium
                        : AppTextStyles.labelLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),

                // Categoría
                if (product.category != null && !isCompact)
                  Text(
                    product.category!.name,
                    style: AppTextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                // Spacer para empujar precios al fondo
                const Spacer(),

                // Precios
                Row(
                  children: [
                    if (product.isOnSale) ...[
                      Flexible(
                        child: Text(
                          '${(product.currentPrice / 100).toStringAsFixed(2)} €',
                          style: isCompact
                              ? AppTextStyles.priceSmall.copyWith(
                                  color: AppColors.salePrice,
                                )
                              : AppTextStyles.price.copyWith(
                                  color: AppColors.salePrice,
                                ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(product.price / 100).toStringAsFixed(2)} €',
                        style: AppTextStyles.originalPrice,
                      ),
                    ] else
                      Flexible(
                        child: Text(
                          '${(product.currentPrice / 100).toStringAsFixed(2)} €',
                          style: isCompact
                              ? AppTextStyles.priceSmall
                              : AppTextStyles.price,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
  }
}

/// Tarjeta de producto horizontal (para carrito, listas, etc.)
class ProductCardHorizontal extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final Widget? trailing;

  const ProductCardHorizontal({
    super.key,
    required this.product,
    this.onTap,
    this.onRemove,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Row(
          children: [
            // Imagen
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedImage(
                imageUrl: product.mainImage,
                width: 80,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.labelLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (product.category != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      product.category!.name,
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (product.isOnSale) ...[
                        Text(
                          '${(product.currentPrice / 100).toStringAsFixed(2)} €',
                          style: AppTextStyles.priceSmall.copyWith(
                            color: AppColors.salePrice,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(product.price / 100).toStringAsFixed(2)} €',
                          style: AppTextStyles.originalPrice,
                        ),
                      ] else
                        Text(
                          '${(product.currentPrice / 100).toStringAsFixed(2)} €',
                          style: AppTextStyles.priceSmall,
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Trailing widget o botón de eliminar
            if (trailing != null)
              trailing!
            else if (onRemove != null)
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onRemove,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}
