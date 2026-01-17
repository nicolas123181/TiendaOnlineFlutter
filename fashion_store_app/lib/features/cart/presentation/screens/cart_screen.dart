import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../shared/widgets/cached_image.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_inputs.dart';
import '../../../../shared/widgets/empty_states.dart';
import '../providers/cart_provider.dart';
import '../../data/models/cart_item_model.dart';

/// Pantalla del carrito de compras
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartItems = cartState.itemsList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
        actions: [
          if (cartItems.isNotEmpty)
            TextButton(
              onPressed: () {
                _showClearCartDialog(context, ref);
              },
              child: const Text('Vaciar'),
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? EmptyCartState(onContinueShopping: () => context.go('/products'))
          : Column(
              children: [
                // Lista de items
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _CartItemCard(
                        item: cartItems[index],
                        onRemove: () {
                          ref
                              .read(cartProvider.notifier)
                              .removeItem(cartItems[index].key);
                        },
                        onUpdateQuantity: (quantity) {
                          ref
                              .read(cartProvider.notifier)
                              .updateQuantity(cartItems[index].key, quantity);
                        },
                      );
                    },
                  ),
                ),

                // Resumen y checkout
                _CartSummary(
                  subtotal: cartState.subtotal,
                  itemCount: cartState.totalItems,
                  onCheckout: () => context.push('/checkout'),
                ),
              ],
            ),
    );
  }

  void _showClearCartDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vaciar carrito'),
        content: const Text(
          '¿Estás seguro de que quieres eliminar todos los productos del carrito?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(cartProvider.notifier).clear();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Vaciar'),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta de item del carrito
class _CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onRemove;
  final ValueChanged<int> onUpdateQuantity;

  const _CartItemCard({
    required this.item,
    required this.onRemove,
    required this.onUpdateQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen
          GestureDetector(
            onTap: () => context.push('/product/${item.slug}'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedImage(
                imageUrl: item.imageUrl,
                width: 80,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTextStyles.labelLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Talla: ${item.size}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),

                // Precio
                Row(
                  children: [
                    if (item.isOnSale && item.salePrice != null) ...[
                      Text(
                        '${(item.currentPrice / 100).toStringAsFixed(2)} €',
                        style: AppTextStyles.priceSmall.copyWith(
                          color: AppColors.salePrice,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(item.price / 100).toStringAsFixed(2)} €',
                        style: AppTextStyles.bodySmall.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ] else
                      Text(
                        '${(item.currentPrice / 100).toStringAsFixed(2)} €',
                        style: AppTextStyles.priceSmall,
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Controles
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Selector de cantidad
                    QuantitySelector(
                      quantity: item.quantity,
                      maxQuantity: item.maxStock,
                      onChanged: onUpdateQuantity,
                      size: 28,
                    ),

                    // Subtotal y eliminar
                    Row(
                      children: [
                        Text(
                          '${(item.subtotal / 100).toStringAsFixed(2)} €',
                          style: AppTextStyles.labelLarge,
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: onRemove,
                          color: AppColors.error,
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 32,
                            minHeight: 32,
                          ),
                        ),
                      ],
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

/// Resumen del carrito
class _CartSummary extends StatelessWidget {
  final int subtotal;
  final int itemCount;
  final VoidCallback onCheckout;

  const _CartSummary({
    required this.subtotal,
    required this.itemCount,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final shippingCost = subtotal >= 10000 ? 0 : 500; // Envío gratis > 100€
    final total = subtotal + shippingCost;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Subtotal
            _SummaryRow(
              label: 'Subtotal ($itemCount productos)',
              value: '${(subtotal / 100).toStringAsFixed(2)} €',
            ),
            const SizedBox(height: 8),

            // Envío
            _SummaryRow(
              label: 'Envío',
              value: shippingCost == 0
                  ? 'GRATIS'
                  : '${(shippingCost / 100).toStringAsFixed(2)} €',
              valueColor: shippingCost == 0 ? AppColors.success : null,
            ),

            // Mensaje de envío gratis
            if (subtotal < 10000) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_shipping_outlined,
                      size: 16,
                      color: AppColors.info,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Añade ${((10000 - subtotal) / 100).toStringAsFixed(2)} € más para envío gratis',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(),
            ),

            // Total
            _SummaryRow(
              label: 'Total',
              value: '${(total / 100).toStringAsFixed(2)} €',
              isTotal: true,
            ),
            const SizedBox(height: 16),

            // Botón checkout
            CustomButton(
              text: 'Continuar con el pago',
              icon: Icons.lock_outline,
              onPressed: onCheckout,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal ? AppTextStyles.labelLarge : AppTextStyles.bodyMedium,
        ),
        Text(
          value,
          style: isTotal
              ? AppTextStyles.h4
              : AppTextStyles.labelLarge.copyWith(color: valueColor),
        ),
      ],
    );
  }
}
