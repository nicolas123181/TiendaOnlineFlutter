import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_colors.dart';
import '../../../data/models/cart_item.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/common/badge_widgets.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/dialogs.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/price_display.dart';
import '../../widgets/common/selectors.dart';

/// Pantalla del carrito de compras
class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final _couponController = TextEditingController();
  bool _isApplyingCoupon = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cartProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  Future<void> _applyCoupon() async {
    if (_couponController.text.trim().isEmpty) return;

    setState(() => _isApplyingCoupon = true);

    try {
      await ref
          .read(cartProvider.notifier)
          .applyCoupon(_couponController.text.trim());

      if (mounted) {
        showSuccessSnackBar(context, 'Cupón aplicado correctamente');
        _couponController.clear();
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isApplyingCoupon = false);
      }
    }
  }

  Future<void> _removeItem(String itemId) async {
    final confirm = await ConfirmDialog.show(
      context: context,
      title: 'Eliminar producto',
      message:
          '¿Estás seguro de que deseas eliminar este producto del carrito?',
      confirmText: 'Eliminar',
      isDanger: true,
    );

    if (confirm == true) {
      await ref.read(cartProvider.notifier).removeFromCart(itemId);
    }
  }

  void _proceedToCheckout() {
    final isAuthenticated = ref.read(isAuthenticatedProvider);

    if (!isAuthenticated) {
      // Mostrar diálogo para iniciar sesión
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: const Text('Iniciar sesión'),
          content: const Text(
            'Para continuar con la compra, necesitas iniciar sesión o crear una cuenta.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.push('/login');
              },
              child: const Text('Iniciar sesión'),
            ),
          ],
        ),
      );
      return;
    }

    context.push('/checkout');
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Mi Carrito',
        showBackButton: true,
        actions: [
          if (cartState.cart.items.isNotEmpty)
            TextButton(
              onPressed: () async {
                final confirm = await ConfirmDialog.show(
                  context: context,
                  title: 'Vaciar carrito',
                  message: '¿Estás seguro de que deseas vaciar el carrito?',
                  confirmText: 'Vaciar',
                  isDanger: true,
                );

                if (confirm == true) {
                  await ref.read(cartProvider.notifier).clearCart();
                }
              },
              child: const Text(
                'Vaciar',
                style: TextStyle(color: AppColors.error),
              ),
            ),
        ],
      ),
      body: cartState.isLoading
          ? const LoadingScreen()
          : cartState.cart.items.isEmpty
              ? const EmptyCartWidget()
              : _buildCartContent(cartState),
      bottomNavigationBar:
          cartState.cart.items.isEmpty ? null : _buildBottomBar(cartState),
    );
  }

  Widget _buildCartContent(CartState cartState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 200),
      child: Column(
        children: [
          // Envío gratis
          if (cartState.subtotal < 15000) // 150€ en centavos
            Padding(
              padding: const EdgeInsets.all(16),
              child: FreeShippingThreshold(
                currentAmountInCents: cartState.subtotal,
                thresholdInCents: 15000,
              ),
            ),

          // Lista de productos
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cartState.cart.items.length,
            itemBuilder: (context, index) {
              final item = cartState.cart.items[index];
              return _CartItemTile(
                item: item,
                isUpdating: cartState.isLoading,
                onQuantityChanged: (qty) {
                  ref.read(cartProvider.notifier).updateQuantity(
                        itemId: item.id,
                        quantity: qty,
                      );
                },
                onRemove: () => _removeItem(item.id),
              );
            },
          ),

          const Divider(height: 32),

          // Cupón de descuento
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Código de descuento',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                if (cartState.appliedCoupon != null)
                  CouponAppliedBadge(
                    code: cartState.appliedCoupon!.code,
                    onRemove: () {
                      ref.read(cartProvider.notifier).removeCoupon();
                    },
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _couponController,
                          decoration: InputDecoration(
                            hintText: 'Ingresa tu código',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(color: AppColors.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(color: AppColors.border),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          textCapitalization: TextCapitalization.characters,
                        ),
                      ),
                      const SizedBox(width: 12),
                      CustomButton(
                        text: 'Aplicar',
                        onPressed: _applyCoupon,
                        isLoading: _isApplyingCoupon,
                        isOutlined: true,
                      ),
                    ],
                  ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Resumen de precios
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CartSubtotal(
              subtotalInCents: cartState.subtotal,
              discountInCents: cartState.discount,
              shippingInCents: cartState.subtotal >= 15000 ? 0 : 590, // 5.90€
              totalInCents: cartState.total,
              couponCode: cartState.appliedCoupon?.code,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(CartState cartState) {
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${cartState.itemCount} ${cartState.itemCount == 1 ? 'artículo' : 'artículos'}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    'Total: €${(cartState.total / 100).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: CustomButton(
                  text: 'Finalizar Compra',
                  onPressed: _proceedToCheckout,
                  icon: Icons.lock_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final bool isUpdating;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  const _CartItemTile({
    required this.item,
    required this.isUpdating,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border.withOpacity(0.5)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen
          GestureDetector(
            onTap: () => context.push('/product/${item.productId}'),
            child: Container(
              width: 100,
              height: 130,
              color: AppColors.surfaceLight,
              child: item.productImage != null
                  ? Image.network(
                      item.productImage!,
                      fit: BoxFit.cover,
                    )
                  : const Icon(
                      Icons.image_outlined,
                      color: AppColors.textTertiary,
                    ),
            ),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Talla: ${item.size}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                // Precio
                PriceDisplayInline(
                  priceInCents: item.currentPrice,
                  originalPriceInCents: item.isOnSale && item.salePrice != null
                      ? item.price
                      : null,
                ),
                const SizedBox(height: 12),
                // Cantidad y eliminar
                Row(
                  children: [
                    QuantitySelector(
                      quantity: item.quantity,
                      maxQuantity: item.maxQuantity,
                      compact: true,
                      isLoading: isUpdating,
                      onChanged: onQuantityChanged,
                    ),
                    const Spacer(),
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
    );
  }
}
