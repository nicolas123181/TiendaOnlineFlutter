import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../shared/widgets/empty_states.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/wishlist_provider.dart';
import '../../data/models/wishlist_item_model.dart';

/// Pantalla de favoritos (wishlist)
class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  String? _lastPrecacheKey;
  late final ProviderSubscription<AsyncValue<List<WishlistItemModel>>>
  _wishlistSub;

  @override
  void initState() {
    super.initState();
    _wishlistSub = ref.listenManual<AsyncValue<List<WishlistItemModel>>>(
      wishlistProvider,
      (previous, next) => next.whenData(_precacheWishlistImages),
    );
  }

  @override
  void dispose() {
    _wishlistSub.close();
    super.dispose();
  }

  void _precacheWishlistImages(List<WishlistItemModel> items) {
    if (!mounted) return;
    final images = items
        .map((item) => item.firstImage)
        .whereType<String>()
        .where((url) => url.trim().isNotEmpty)
        .take(6)
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    if (!isAuthenticated) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'FAVORITOS'),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_outline,
                  size: 80,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(height: 24),
                Text(
                  'Inicia sesión para ver tus favoritos',
                  style: textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => context.push('/auth/login'),
                  child: const Text('INICIAR SESIÓN'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final wishlistAsync = ref.watch(wishlistProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'FAVORITOS',
        additionalActions: [
          wishlistAsync.when(
            data: (items) => items.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Center(
                      child: Text(
                        '${items.length}',
                        style: textTheme.labelLarge,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: wishlistAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return EmptyFavoritesState(onExplore: () => context.go('/'));
          }

          return ListView.builder(
            key: const PageStorageKey<String>('favorites-list'),
            padding: const EdgeInsets.all(16),
            cacheExtent: 600,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: item.firstImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: item.firstImage!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.image_not_supported),
                          ),
                        )
                      : Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image),
                        ),
                  title: Text(
                    item.productName ?? 'Producto',
                    style: textTheme.labelLarge,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Talla: ${item.size}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      Row(
                        children: [
                          if (item.productIsOnSale &&
                              item.productSalePrice != null) ...[
                            Text(
                              '€${(item.productPrice! / 100).toStringAsFixed(2)}',
                              style: AppTextStyles.bodySmall.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '€${(item.productSalePrice! / 100).toStringAsFixed(2)}',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '-${item.discountPercentage}%',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                          if (!item.productIsOnSale ||
                              item.productSalePrice == null)
                            Text(
                              '€${(item.productPrice! / 100).toStringAsFixed(2)}',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                        ],
                      ),
                      if (!item.hasStock)
                        Text(
                          'Sin stock',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.error,
                          ),
                        )
                      else if (item.isLowStock)
                        Text(
                          '¡Solo ${item.sizeStock} disponibles!',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.orange,
                          ),
                        ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
                    ),
                    onPressed: () async {
                      await ref
                          .read(wishlistActionsProvider.notifier)
                          .removeFromWishlist(item.id);
                    },
                  ),
                  onTap: () {
                    if (item.productSlug != null) {
                      context.push('/product/${item.productSlug}');
                    }
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 80,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar favoritos',
                  style: textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(wishlistProvider),
                  child: const Text('REINTENTAR'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
