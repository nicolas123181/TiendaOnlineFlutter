import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../config/app_colors.dart';
import '../../../data/models/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/common/badge_widgets.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/image_carousel.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/misc_widgets.dart';
import '../../widgets/common/price_display.dart';
import '../../widgets/common/selectors.dart';

/// Pantalla de detalle de producto
class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  String? _selectedSize;
  int _quantity = 1;
  bool _isAddingToCart = false;

  Future<void> _addToCart(Product product) async {
    if (_selectedSize == null && product.sizes.isNotEmpty) {
      showErrorSnackBar(context, 'Por favor selecciona una talla');
      return;
    }

    final String size = product.sizes.isNotEmpty
        ? (_selectedSize ?? product.sizes.first.size)
        : 'Única';

    setState(() => _isAddingToCart = true);

    try {
      await ref.read(cartProvider.notifier).addToCart(
            product: product,
            quantity: _quantity,
            size: size,
          );

      if (mounted) {
        showSuccessSnackBar(context, 'Producto añadido al carrito');
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, 'Error al añadir al carrito');
      }
    } finally {
      if (mounted) {
        setState(() => _isAddingToCart = false);
      }
    }
  }

  void _shareProduct(Product product) {
    Share.share(
      '¡Mira este producto de VANTAGE! ${product.name} - €${(product.currentPrice / 100).toStringAsFixed(2)}\n\nhttps://vantagefashion.com/product/${product.id}',
      subject: product.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productByIdProvider(widget.productId));
    final parsedProductId = int.tryParse(widget.productId);
    final isInWishlist = parsedProductId == null
        ? false
        : ref.watch(isInWishlistProvider(parsedProductId));
    final wishlistState = ref.watch(wishlistProvider);
    final isProcessingWishlist = parsedProductId != null
        ? wishlistState.isProcessing(parsedProductId)
        : false;
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      body: productAsync.when(
        data: (product) {
          if (product == null) {
            return const NotFoundWidget(
              message: 'El producto que buscas no existe o ha sido eliminado.',
            );
          }

          final sizeOptions = product.sizes.map((s) => s.size).toList();
          final stockBySize = {
            for (final s in product.sizes) s.size: s.stock,
          };

          return CustomScrollView(
            slivers: [
              // AppBar con imagen
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height * 0.5,
                pinned: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.brandNavy,
                      size: 20,
                    ),
                  ),
                  onPressed: () => context.pop(),
                ),
                actions: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.share_outlined,
                        color: AppColors.brandNavy,
                        size: 20,
                      ),
                    ),
                    onPressed: () => _shareProduct(product),
                  ),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: isProcessingWishlist
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(
                              isInWishlist
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isInWishlist
                                  ? AppColors.error
                                  : AppColors.brandNavy,
                              size: 20,
                            ),
                    ),
                    onPressed: isProcessingWishlist
                        ? null
                        : () => ref
                            .read(wishlistProvider.notifier)
                            .toggleWishlist(product),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.shopping_bag_outlined,
                            color: AppColors.brandNavy,
                            size: 20,
                          ),
                        ),
                        onPressed: () => context.push('/cart'),
                      ),
                      if (cartState.itemCount > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: CounterBadge(count: cartState.itemCount),
                        ),
                    ],
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: ImageCarousel(
                    images: product.images,
                    aspectRatio: 1,
                    showThumbnails: false,
                  ),
                ),
              ),

              // Contenido
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badges
                      Row(
                        children: [
                          if (product.isNew) ...[
                            const NewBadge(),
                            const SizedBox(width: 8),
                          ],
                          if (product.isOnSale)
                            SaleBadge(
                              discountPercentage: product.discountPercentage,
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Categoría
                      if (product.categoryName != null)
                        Text(
                          product.categoryName!.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.brandNavy,
                            letterSpacing: 1.5,
                          ),
                        ),
                      const SizedBox(height: 8),

                      // Nombre
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Precio
                      PriceDisplayInline(
                        priceInCents: product.currentPrice,
                        originalPriceInCents:
                            product.isOnSale ? product.price : null,
                        fontSize: 22,
                      ),

                      // Ahorro
                      if (product.hasActiveDiscount) ...[
                        const SizedBox(height: 12),
                        SavingsDisplay(
                          savingsInCents: product.price - product.currentPrice,
                        ),
                      ],
                      const SizedBox(height: 24),

                      // Selector de talla
                      if (product.sizes.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Talla',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _showSizeGuide(context),
                              child: Text(
                                'Guía de tallas',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.brandNavy,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.brandNavy,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizeSelector(
                          sizes: sizeOptions,
                          selectedSize: _selectedSize,
                          stockBySize: stockBySize,
                          showStock: true,
                          onSelected: (size) =>
                              setState(() => _selectedSize = size),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Cantidad
                      Row(
                        children: [
                          const Text(
                            'Cantidad',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 24),
                          QuantitySelector(
                            quantity: _quantity,
                            maxQuantity: product.stock,
                            onChanged: (qty) => setState(() => _quantity = qty),
                          ),
                        ],
                      ),

                      // Stock info
                      if (product.stock > 0 && product.stock <= 5) ...[
                        const SizedBox(height: 12),
                        LowStockBadge(quantity: product.stock),
                      ],
                      const SizedBox(height: 32),

                      // Descripción
                      ExpandablePanel(
                        title: 'Descripción',
                        initiallyExpanded: true,
                        child: Text(
                          product.description ?? 'Sin descripción disponible.',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4B5563),
                            height: 1.6,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      // Envío y devoluciones
                      ExpandablePanel(
                        title: 'Envío y Devoluciones',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _InfoRow(
                              icon: Icons.local_shipping_outlined,
                              title: 'Envío gratis',
                              subtitle: 'En pedidos superiores a €150',
                            ),
                            const SizedBox(height: 12),
                            _InfoRow(
                              icon: Icons.refresh,
                              title: 'Devolución gratuita',
                              subtitle: '30 días para cambios y devoluciones',
                            ),
                            const SizedBox(height: 12),
                            _InfoRow(
                              icon: Icons.verified_outlined,
                              title: 'Garantía de autenticidad',
                              subtitle: '100% productos originales',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100), // Espacio para botón fijo
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const ProductDetailShimmer(),
        error: (error, stack) => ServerErrorWidget(
          onRetry: () => ref.invalidate(productByIdProvider(widget.productId)),
        ),
      ),
      bottomNavigationBar: productAsync.when(
        data: (product) {
          if (product == null) return null;

          return Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(context).padding.bottom + 12,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              children: [
                // Precio
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '€${((product.currentPrice * _quantity) / 100).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                // Botón
                Expanded(
                  child: CustomButton(
                    text: product.isInStock ? 'Añadir al Carrito' : 'Sin Stock',
                    onPressed:
                        product.isInStock ? () => _addToCart(product) : null,
                    isLoading: _isAddingToCart,
                    icon: Icons.shopping_bag_outlined,
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => null,
        error: (_, __) => null,
      ),
    );
  }

  void _showSizeGuide(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textTertiary.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Guía de Tallas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Table(
                      border: TableBorder.all(color: AppColors.border),
                      children: [
                        const TableRow(
                          decoration:
                              BoxDecoration(color: AppColors.surfaceLight),
                          children: [
                            _TableCell(text: 'Talla', isHeader: true),
                            _TableCell(text: 'Pecho (cm)', isHeader: true),
                            _TableCell(text: 'Cintura (cm)', isHeader: true),
                            _TableCell(text: 'Cadera (cm)', isHeader: true),
                          ],
                        ),
                        const TableRow(
                          children: [
                            _TableCell(text: 'XS'),
                            _TableCell(text: '86-91'),
                            _TableCell(text: '71-76'),
                            _TableCell(text: '86-91'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            _TableCell(text: 'S'),
                            _TableCell(text: '91-97'),
                            _TableCell(text: '76-81'),
                            _TableCell(text: '91-97'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            _TableCell(text: 'M'),
                            _TableCell(text: '97-102'),
                            _TableCell(text: '81-86'),
                            _TableCell(text: '97-102'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            _TableCell(text: 'L'),
                            _TableCell(text: '102-107'),
                            _TableCell(text: '86-91'),
                            _TableCell(text: '102-107'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            _TableCell(text: 'XL'),
                            _TableCell(text: '107-112'),
                            _TableCell(text: '91-97'),
                            _TableCell(text: '107-112'),
                          ],
                        ),
                        const TableRow(
                          children: [
                            _TableCell(text: 'XXL'),
                            _TableCell(text: '112-117'),
                            _TableCell(text: '97-102'),
                            _TableCell(text: '112-117'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.brandNavy,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool isHeader;

  const _TableCell({
    required this.text,
    this.isHeader = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isHeader ? FontWeight.w600 : FontWeight.normal,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
