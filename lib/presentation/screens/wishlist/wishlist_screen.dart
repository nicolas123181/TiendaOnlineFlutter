import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../config/app_colors.dart';
import '../../../data/models/wishlist_item.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/dialogs.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/price_display.dart';

/// Pantalla de lista de deseos
class WishlistScreen extends ConsumerStatefulWidget {
  const WishlistScreen({super.key});

  @override
  ConsumerState<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends ConsumerState<WishlistScreen> {
  bool _isGridView = true;
  bool _isSelectionMode = false;
  final Set<int> _selectedItems = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(wishlistProvider.notifier).loadWishlist();
    });
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedItems.clear();
      }
    });
  }

  void _toggleItemSelection(int itemId) {
    setState(() {
      if (_selectedItems.contains(itemId)) {
        _selectedItems.remove(itemId);
      } else {
        _selectedItems.add(itemId);
      }
    });
  }

  Future<void> _removeSelected() async {
    if (_selectedItems.isEmpty) return;

    final confirm = await ConfirmDialog.show(
      context: context,
      title: 'Eliminar productos',
      message:
          '¿Estás seguro de que deseas eliminar ${_selectedItems.length} producto${_selectedItems.length > 1 ? 's' : ''} de tu lista de deseos?',
      confirmText: 'Eliminar',
      isDanger: true,
    );

    if (confirm == true) {
      for (final id in _selectedItems) {
        await ref.read(wishlistProvider.notifier).removeFromWishlist(id);
      }
      setState(() {
        _selectedItems.clear();
        _isSelectionMode = false;
      });
    }
  }

  Future<void> _addAllToCart() async {
    final items = _selectedItems.isEmpty
        ? ref.read(wishlistProvider).items
        : ref.read(wishlistProvider).items.where(
              (item) => _selectedItems.contains(item.productId),
            );

    final productRepository = ref.read(productRepositoryProvider);
    int addedCount = 0;

    for (final item in items) {
      final product =
          await productRepository.getProductById(item.productId.toString());
      if (product == null) continue;

      await ref.read(cartProvider.notifier).addToCart(
            product: product,
            quantity: 1,
            size: item.size,
          );
      addedCount++;
    }

    if (mounted) {
      showSuccessSnackBar(
        context,
        '$addedCount producto${addedCount == 1 ? '' : 's'} agregado${addedCount == 1 ? '' : 's'} al carrito',
      );
    }
  }

  void _shareWishlist() {
    final wishlist = ref.read(wishlistProvider);
    final productNames =
        wishlist.items.map((i) => '• ${i.productName}').join('\n');

    Share.share(
      'Mi lista de deseos VANTAGE:\n\n$productNames\n\nDescubre más en vantage-fashion.com',
      subject: 'Mi lista de deseos VANTAGE',
    );
  }

  @override
  Widget build(BuildContext context) {
    final wishlistState = ref.watch(wishlistProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: _isSelectionMode
            ? '${_selectedItems.length} seleccionados'
            : 'Lista de Deseos',
        showBackButton: true,
        actions: [
          if (_isSelectionMode)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _toggleSelectionMode,
            ),
          if (wishlistState.items.isNotEmpty) ...[
            if (!_isSelectionMode) ...[
              IconButton(
                icon: Icon(
                  _isGridView ? Icons.view_list : Icons.grid_view,
                ),
                onPressed: () {
                  setState(() => _isGridView = !_isGridView);
                },
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: _shareWishlist,
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                onSelected: (value) {
                  switch (value) {
                    case 'select':
                      _toggleSelectionMode();
                      break;
                    case 'clear':
                      _showClearDialog();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'select',
                    child: Row(
                      children: [
                        Icon(Icons.check_box_outlined, size: 20),
                        SizedBox(width: 12),
                        Text('Seleccionar'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'clear',
                    child: Row(
                      children: [
                        Icon(Icons.delete_sweep_outlined,
                            size: 20, color: AppColors.error),
                        SizedBox(width: 12),
                        Text('Vaciar lista',
                            style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ],
              ),
            ] else ...[
              TextButton(
                onPressed: () {
                  setState(() {
                    if (_selectedItems.length == wishlistState.items.length) {
                      _selectedItems.clear();
                    } else {
                      _selectedItems.addAll(
                        wishlistState.items.map((i) => i.productId),
                      );
                    }
                  });
                },
                child: Text(
                  _selectedItems.length == wishlistState.items.length
                      ? 'Deseleccionar'
                      : 'Seleccionar todo',
                ),
              ),
            ],
          ],
        ],
      ),
      body: wishlistState.isLoading
          ? const LoadingScreen()
          : wishlistState.items.isEmpty
              ? const _EmptyWishlist()
              : _buildContent(wishlistState),
      bottomNavigationBar: wishlistState.items.isNotEmpty
          ? _buildBottomBar(wishlistState)
          : null,
    );
  }

  Widget _buildContent(WishlistState wishlistState) {
    if (_isGridView) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
        ),
        itemCount: wishlistState.items.length,
        itemBuilder: (context, index) {
          final item = wishlistState.items[index];
          return _WishlistGridItem(
            item: item,
            isSelectionMode: _isSelectionMode,
            isSelected: _selectedItems.contains(item.productId),
            onTap: () {
              if (_isSelectionMode) {
                _toggleItemSelection(item.productId);
              } else {
                context.push('/product/${item.productId}');
              }
            },
            onLongPress: () {
              if (!_isSelectionMode) {
                _toggleSelectionMode();
                _toggleItemSelection(item.productId);
              }
            },
            onRemove: () => _removeItem(item.productId),
          );
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: wishlistState.items.length,
      itemBuilder: (context, index) {
        final item = wishlistState.items[index];
        return _WishlistListItem(
          item: item,
          isSelectionMode: _isSelectionMode,
          isSelected: _selectedItems.contains(item.productId),
          onTap: () {
            if (_isSelectionMode) {
              _toggleItemSelection(item.productId);
            } else {
              context.push('/product/${item.productId}');
            }
          },
          onLongPress: () {
            if (!_isSelectionMode) {
              _toggleSelectionMode();
              _toggleItemSelection(item.productId);
            }
          },
          onRemove: () => _removeItem(item.productId),
          onAddToCart: () => _addItemToCart(item),
        );
      },
    );
  }

  Widget _buildBottomBar(WishlistState wishlistState) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          if (_isSelectionMode && _selectedItems.isNotEmpty) ...[
            Expanded(
              child: CustomButton(
                text: 'Eliminar',
                onPressed: _removeSelected,
                isOutlined: true,
                icon: Icons.delete_outline,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: _isSelectionMode && _selectedItems.isNotEmpty ? 2 : 1,
            child: CustomButton(
              text: _isSelectionMode && _selectedItems.isNotEmpty
                  ? 'Agregar al carrito (${_selectedItems.length})'
                  : 'Agregar todo al carrito',
              onPressed: _addAllToCart,
              icon: Icons.shopping_cart_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _removeItem(int productId) async {
    await ref.read(wishlistProvider.notifier).removeFromWishlist(productId);
    if (mounted) {
      showSuccessSnackBar(context, 'Producto eliminado de la lista');
    }
  }

  Future<void> _addItemToCart(WishlistItem item) async {
    final productRepository = ref.read(productRepositoryProvider);
    final product =
        await productRepository.getProductById(item.productId.toString());
    if (product == null) return;

    await ref.read(cartProvider.notifier).addToCart(
          product: product,
          quantity: 1,
          size: item.size,
        );
    if (mounted) {
      showSuccessSnackBar(context, 'Producto agregado al carrito');
    }
  }

  Future<void> _showClearDialog() async {
    final confirm = await ConfirmDialog.show(
      context: context,
      title: 'Vaciar lista de deseos',
      message:
          '¿Estás seguro de que deseas eliminar todos los productos de tu lista de deseos?',
      confirmText: 'Vaciar',
      isDanger: true,
    );

    if (confirm == true) {
      await ref.read(wishlistProvider.notifier).clearWishlist();
    }
  }
}

class _WishlistGridItem extends StatelessWidget {
  final WishlistItem item;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onRemove;

  const _WishlistGridItem({
    required this.item,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? AppColors.brandNavy : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: AppColors.surfaceLight,
                    child: item.productImage != null
                        ? Image.network(item.productImage!, fit: BoxFit.cover)
                        : const Icon(
                            Icons.image_outlined,
                            color: AppColors.textTertiary,
                            size: 40,
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName ?? 'Producto',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      PriceDisplayInline(
                        priceInCents: item.currentPrice ?? 0,
                        originalPriceInCents:
                            item.hasDiscount ? item.productPrice : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isSelectionMode)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.brandNavy : Colors.white,
                  border: Border.all(
                    color: isSelected ? AppColors.brandNavy : AppColors.border,
                  ),
                ),
                child: Icon(
                  Icons.check,
                  size: 16,
                  color: isSelected ? Colors.white : Colors.transparent,
                ),
              ),
            ),
          if (!isSelectionMode)
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                onPressed: onRemove,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _WishlistListItem extends StatelessWidget {
  final WishlistItem item;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;

  const _WishlistListItem({
    required this.item,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    required this.onRemove,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.brandNavy : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Checkbox
            if (isSelectionMode)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.brandNavy : Colors.white,
                    border: Border.all(
                      color:
                          isSelected ? AppColors.brandNavy : AppColors.border,
                    ),
                  ),
                  child: Icon(
                    Icons.check,
                    size: 14,
                    color: isSelected ? Colors.white : Colors.transparent,
                  ),
                ),
              ),
            // Imagen
            Container(
              width: 80,
              height: 100,
              color: AppColors.surfaceLight,
              child: item.productImage != null
                  ? Image.network(item.productImage!, fit: BoxFit.cover)
                  : const Icon(Icons.image_outlined,
                      color: AppColors.textTertiary),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName ?? 'Producto',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  PriceDisplayInline(
                    priceInCents: item.currentPrice ?? 0,
                    originalPriceInCents:
                        item.hasDiscount ? item.productPrice : null,
                  ),
                  const SizedBox(height: 8),
                  if (!isSelectionMode)
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: onAddToCart,
                            style: OutlinedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            child: const Text(
                              'Añadir al carrito',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: onRemove,
                        ),
                      ],
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

class _EmptyWishlist extends StatelessWidget {
  const _EmptyWishlist();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite_outline,
              size: 80,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 24),
            const Text(
              'Tu lista de deseos está vacía',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Guarda tus productos favoritos para comprarlos más tarde',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandNavy,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('Explorar productos'),
            ),
          ],
        ),
      ),
    );
  }
}
