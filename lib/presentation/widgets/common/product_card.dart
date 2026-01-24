import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/product.dart';
import '../../../config/app_colors.dart';
import '../../providers/wishlist_provider.dart';
import 'custom_button.dart';

/// Tarjeta de producto para grid
class ProductCard extends ConsumerWidget {
  final Product product;
  final VoidCallback? onTap;
  final bool showWishlistButton;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.showWishlistButton = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInWishlist = ref.watch(isInWishlistProvider(product.id));
    final wishlistState = ref.watch(wishlistProvider);
    final isProcessing = wishlistState.isProcessing(product.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Imagen con badges
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 3 / 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                  ),
                  child: product.images.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: product.images.first,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.surfaceMedium,
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.surfaceMedium,
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : Color(0xFF7B8899),
                              size: 40,
                            ),
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.image_outlined,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : Color(0xFF7B8899),
                            size: 40,
                          ),
                        ),
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
                      _Badge(
                        text: '-${product.discountPercentage}%',
                        color: AppColors.error,
                      ),
                    if (product.isNew) ...[
                      if (product.isOnSale) const SizedBox(height: 4),
                      const _Badge(
                        text: 'NUEVO',
                        color: AppColors.brandNavy,
                      ),
                    ],
                    if (!product.isInStock) ...[
                      const SizedBox(height: 4),
                      _Badge(
                        text: 'AGOTADO',
                        color:
                            isDark ? AppColors.darkBorder : Color(0xFFD1D8E0),
                      ),
                    ],
                  ],
                ),
              ),
              // Botón de wishlist
              if (showWishlistButton)
                Positioned(
                  top: 8,
                  right: 8,
                  child: FavoriteButton(
                    isFavorite: isInWishlist,
                    isLoading: isProcessing,
                    onPressed: () {
                      ref
                          .read(wishlistProvider.notifier)
                          .toggleWishlist(product);
                    },
                    size: 20,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          // Categoría
          if (product.categoryName != null)
            Text(
              product.categoryName!.toUpperCase(),
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: AppColors.brandNavy,
                letterSpacing: 0.8,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          SizedBox(height: product.categoryName != null ? 3 : 0),
          // Nombre
          Expanded(
            child: Text(
              product.name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),
          // Precio
          Row(
            children: [
              if (product.isOnSale) ...[
                Flexible(
                  child: Text(
                    '€${(product.salePrice! / 100).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.error,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    '€${(product.price / 100).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : Color(0xFF7B8899),
                      decoration: TextDecoration.lineThrough,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ] else
                Flexible(
                  child: Text(
                    '€${(product.price / 100).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Tarjeta de producto horizontal (para listas)
class ProductListTile extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final Widget? trailing;

  const ProductListTile({
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
          color: Theme.of(context).cardColor,
          border: Border(
            bottom: BorderSide(
              color: AppColors.border.withOpacity(0.5),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Imagen
            Container(
              width: 80,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
              ),
              child: product.images.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: product.images.first,
                      fit: BoxFit.cover,
                    )
                  : const Icon(
                      Icons.image_outlined,
                      color: AppColors.textTertiary,
                    ),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.categoryName != null)
                    Text(
                      product.categoryName!.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textTertiary,
                        letterSpacing: 1,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (product.isOnSale) ...[
                        Text(
                          '€${(product.salePrice! / 100).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.error,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '€${(product.price / 100).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textTertiary,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ] else
                        Text(
                          '€${(product.price / 100).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // Trailing
            if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing!,
            ] else if (onRemove != null) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                onPressed: onRemove,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Badge para productos
class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Tarjeta de producto pequeña (para carruseles)
class ProductCardSmall extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final double width;

  const ProductCardSmall({
    super.key,
    required this.product,
    this.onTap,
    this.width = 140,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            AspectRatio(
              aspectRatio: 3 / 4,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    product.images.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: product.images.first,
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.image_outlined,
                            color: AppColors.textTertiary,
                          ),
                    if (product.isOnSale)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: _Badge(
                          text: '-${product.discountPercentage}%',
                          color: AppColors.error,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Nombre
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            // Precio
            Text(
              '€${(product.effectivePrice / 100).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color:
                    product.isOnSale ? AppColors.error : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
