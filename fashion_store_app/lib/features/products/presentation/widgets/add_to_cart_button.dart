import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../data/models/product_model.dart';

/// Botón de añadir al carrito
class AddToCartButton extends ConsumerStatefulWidget {
  final ProductModel product;
  final String? preselectedSize;
  final bool showSizeSelector;
  final bool isCompact;
  final VoidCallback? onAdded;

  const AddToCartButton({
    super.key,
    required this.product,
    this.preselectedSize,
    this.showSizeSelector = true,
    this.isCompact = false,
    this.onAdded,
  });

  @override
  ConsumerState<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends ConsumerState<AddToCartButton>
    with SingleTickerProviderStateMixin {
  String? _selectedSize;
  int _quantity = 1;
  bool _isAdding = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  static const List<String> _availableSizes = [
    'XS',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
  ];

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.preselectedSize;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool get _canAddToCart =>
      widget.product.isInStock &&
      (_selectedSize != null || !widget.showSizeSelector);

  void _handleAddToCart() {
    if (!_canAddToCart) return;

    setState(() {
      _isAdding = true;
    });

    // Animación
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    // Añadir al carrito
    ref
        .read(cartProvider.notifier)
        .addItem(
          product: widget.product,
          size: _selectedSize ?? 'Única',
          quantity: _quantity,
        );

    // Feedback visual
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${widget.product.name} añadido al carrito',
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'VER CARRITO',
          textColor: AppColors.accent,
          onPressed: () => context.push('/cart'),
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isAdding = false;
        });
        widget.onAdded?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isCompact) {
      return _buildCompactButton();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Selector de talla
        if (widget.showSizeSelector) ...[
          Text('Talla', style: AppTextStyles.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableSizes.map((size) {
              final isSelected = _selectedSize == size;
              return GestureDetector(
                onTap: widget.product.isInStock
                    ? () {
                        setState(() {
                          _selectedSize = size;
                        });
                      }
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    size,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isSelected ? Colors.white : AppColors.primary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],

        // Selector de cantidad
        Row(
          children: [
            Text('Cantidad', style: AppTextStyles.labelLarge),
            const Spacer(),
            _QuantityControl(
              quantity: _quantity,
              maxQuantity: widget.product.stock,
              onChanged: (value) {
                setState(() {
                  _quantity = value;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Botón de añadir
        ScaleTransition(
          scale: _scaleAnimation,
          child: CustomButton(
            text: widget.product.isOutOfStock
                ? 'Agotado'
                : (_selectedSize == null && widget.showSizeSelector)
                ? 'Selecciona una talla'
                : _isAdding
                ? 'Añadiendo...'
                : 'Añadir al carrito',
            icon: widget.product.isOutOfStock
                ? Icons.block
                : _isAdding
                ? null
                : Icons.shopping_bag_outlined,
            onPressed: _canAddToCart ? _handleAddToCart : null,
            isLoading: _isAdding,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactButton() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: CustomIconButton(
        icon: widget.product.isOutOfStock
            ? Icons.block
            : Icons.add_shopping_cart,
        onPressed: widget.product.isInStock
            ? () => _showAddToCartSheet(context)
            : null,
        backgroundColor: AppColors.primary,
        iconColor: Colors.white,
        size: 36,
        tooltip: widget.product.isOutOfStock ? 'Agotado' : 'Añadir al carrito',
      ),
    );
  }

  void _showAddToCartSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Producto info
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.product.mainImage,
                    width: 60,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: AppTextStyles.labelLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(widget.product.currentPrice / 100).toStringAsFixed(2)} €',
                        style: AppTextStyles.price,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Add to cart form
            StatefulBuilder(
              builder: (context, setModalState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Tallas
                    Text('Talla', style: AppTextStyles.labelLarge),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableSizes.map((size) {
                        final isSelected = _selectedSize == size;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              _selectedSize = size;
                            });
                            setState(() {});
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.surface,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              size,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Botón
                    CustomButton(
                      text: _selectedSize == null
                          ? 'Selecciona una talla'
                          : 'Añadir al carrito',
                      onPressed: _selectedSize != null
                          ? () {
                              _handleAddToCart();
                              Navigator.pop(context);
                            }
                          : null,
                      icon: Icons.shopping_bag_outlined,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Control de cantidad
class _QuantityControl extends StatelessWidget {
  final int quantity;
  final int maxQuantity;
  final ValueChanged<int> onChanged;

  const _QuantityControl({
    required this.quantity,
    required this.maxQuantity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QuantityButton(
            icon: Icons.remove,
            onPressed: quantity > 1 ? () => onChanged(quantity - 1) : null,
          ),
          Container(
            width: 48,
            alignment: Alignment.center,
            child: Text(quantity.toString(), style: AppTextStyles.labelLarge),
          ),
          _QuantityButton(
            icon: Icons.add,
            onPressed: quantity < maxQuantity
                ? () => onChanged(quantity + 1)
                : null,
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _QuantityButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 18,
          color: onPressed != null ? AppColors.primary : AppColors.border,
        ),
      ),
    );
  }
}
