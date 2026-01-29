import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../data/models/product_model.dart';
import '../providers/product_sizes_provider.dart';

/// Botón de añadir al carrito con manejo de stock por tallas
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

  List<String> _resolveSizeOptions(Map<String, int>? sizesStock) {
    if (sizesStock != null && sizesStock.isNotEmpty) {
      final sizes = sizesStock.keys.toList();
      sizes.sort((a, b) {
        final ai = int.tryParse(a);
        final bi = int.tryParse(b);
        if (ai != null && bi != null) return ai.compareTo(bi);
        if (ai != null) return -1;
        if (bi != null) return 1;
        return a.compareTo(b);
      });
      return sizes;
    }

    return _availableSizes;
  }

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

  int _getMaxQuantityForSize(Map<String, int>? sizesStock) {
    if (_selectedSize == null || sizesStock == null)
      return widget.product.stock;
    return sizesStock[_selectedSize] ?? 0;
  }

  bool _canAddToCart(Map<String, int>? sizesStock) {
    if (_selectedSize == null && widget.showSizeSelector) return false;
    final maxQty = _getMaxQuantityForSize(sizesStock);
    return maxQty > 0 && _quantity <= maxQty;
  }

  void _handleAddToCart(Map<String, int>? sizesStock) {
    if (!_canAddToCart(sizesStock)) return;

    setState(() => _isAdding = true);

    _animationController.forward().then((_) => _animationController.reverse());

    ref
        .read(cartProvider.notifier)
        .addItem(
          product: widget.product,
          size: _selectedSize ?? 'Única',
          quantity: _quantity,
        );

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
        setState(() => _isAdding = false);
        widget.onAdded?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizesStockAsync = ref.watch(
      productSizesMapProvider(widget.product.id),
    );

    return sizesStockAsync.when(
      data: (sizesStock) => _buildContent(sizesStock),
      loading: () => _buildContent(null),
      error: (_, __) => _buildContent(null),
    );
  }

  Widget _buildContent(Map<String, int>? sizesStock) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final sizeOptions = _resolveSizeOptions(sizesStock);
    if (widget.isCompact) {
      return _buildCompactButton(sizesStock);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Selector de talla con stock individual
        if (widget.showSizeSelector) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Talla', style: textTheme.labelLarge),
              TextButton.icon(
                onPressed: () => _showSizeGuide(context),
                icon: const Icon(Icons.straighten, size: 16),
                label: const Text('Guía de tallas'),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.onSurface.withValues(alpha: 0.7),
                  textStyle: textTheme.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: sizeOptions.map((size) {
              final stockForSize = sizesStock?[size] ?? 0;
              final isSelected = _selectedSize == size;
              final isAvailable = stockForSize > 0;
              final isLowStock = stockForSize > 0 && stockForSize <= 3;

              return GestureDetector(
                onTap: isAvailable
                    ? () {
                        setState(() {
                          _selectedSize = size;
                          // Reset quantity if exceeds new max
                          if (_quantity > stockForSize) {
                            _quantity = stockForSize;
                          }
                        });
                      }
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: !isAvailable
                        ? colorScheme.surface.withValues(alpha: 0.6)
                        : isSelected
                        ? colorScheme.primary
                        : colorScheme.surface,
                    border: Border.all(
                      color: !isAvailable
                          ? Theme.of(context).dividerColor
                          : isSelected
                          ? colorScheme.primary
                          : isLowStock
                          ? AppColors.warning
                          : Theme.of(context).dividerColor,
                      width: isSelected || isLowStock ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            size,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: !isAvailable
                                  ? colorScheme.onSurface.withValues(alpha: 0.4)
                                  : isSelected
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              decoration: !isAvailable
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          if (isAvailable && isLowStock)
                            Text(
                              '($stockForSize)',
                              style: AppTextStyles.caption.copyWith(
                                color: isSelected
                                    ? colorScheme.onPrimary.withValues(
                                        alpha: 0.8,
                                      )
                                    : AppColors.warning,
                                fontSize: 10,
                              ),
                            ),
                        ],
                      ),
                      // Badge de agotado
                      if (!isAvailable)
                        Positioned(
                          top: 2,
                          right: 2,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              size: 10,
                              color: AppColors.error,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Aviso de pocas unidades
          if (_selectedSize != null)
            Builder(
              builder: (context) {
                final stockForSelected = sizesStock?[_selectedSize] ?? 0;
                if (stockForSelected > 0 && stockForSelected <= 5) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.warning.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: AppColors.warning,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            stockForSelected == 1
                                ? '¡Última unidad! No te quedes sin ella'
                                : '¡Solo quedan $stockForSelected unidades! Date prisa',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.warning,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
        ],

        // Selector de cantidad
        Row(
          children: [
            Text('Cantidad', style: textTheme.labelLarge),
            const Spacer(),
            _QuantityControl(
              quantity: _quantity,
              maxQuantity: _getMaxQuantityForSize(sizesStock),
              onChanged: (value) => setState(() => _quantity = value),
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
                : _getMaxQuantityForSize(sizesStock) <= 0
                ? 'Talla agotada'
                : _isAdding
                ? 'Añadiendo...'
                : 'Añadir al carrito',
            icon:
                widget.product.isOutOfStock ||
                    _getMaxQuantityForSize(sizesStock) <= 0
                ? Icons.block
                : _isAdding
                ? null
                : Icons.shopping_bag_outlined,
            onPressed: _canAddToCart(sizesStock)
                ? () => _handleAddToCart(sizesStock)
                : null,
            isLoading: _isAdding,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactButton(Map<String, int>? sizesStock) {
    final colorScheme = Theme.of(context).colorScheme;
    return ScaleTransition(
      scale: _scaleAnimation,
      child: CustomIconButton(
        icon: widget.product.isOutOfStock
            ? Icons.block
            : Icons.add_shopping_cart,
        onPressed: widget.product.isInStock
            ? () => _showAddToCartSheet(context, sizesStock)
            : null,
        backgroundColor: colorScheme.primary,
        iconColor: colorScheme.onPrimary,
        size: 36,
        tooltip: widget.product.isOutOfStock ? 'Agotado' : 'Añadir al carrito',
      ),
    );
  }

  void _showSizeGuide(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SizeGuideSheet(),
    );
  }

  void _showAddToCartSheet(BuildContext context, Map<String, int>? sizesStock) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddToCartSheet(
        product: widget.product,
        sizesStock: sizesStock ?? {},
        onAddToCart: (size, quantity) {
          setState(() {
            _selectedSize = size;
            _quantity = quantity;
          });
          _handleAddToCart(sizesStock);
          Navigator.pop(context);
        },
      ),
    );
  }
}

/// Sheet para añadir al carrito (versión compacta)
class _AddToCartSheet extends StatefulWidget {
  final ProductModel product;
  final Map<String, int> sizesStock;
  final void Function(String size, int quantity) onAddToCart;

  const _AddToCartSheet({
    required this.product,
    required this.sizesStock,
    required this.onAddToCart,
  });

  @override
  State<_AddToCartSheet> createState() => _AddToCartSheetState();
}

class _AddToCartSheetState extends State<_AddToCartSheet> {
  String? _selectedSize;
  int _quantity = 1;

  static const List<String> _availableSizes = [
    'XS',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
  ];

  List<String> _resolveSizeOptions() {
    if (widget.sizesStock.isNotEmpty) {
      final sizes = widget.sizesStock.keys.toList();
      sizes.sort((a, b) {
        final ai = int.tryParse(a);
        final bi = int.tryParse(b);
        if (ai != null && bi != null) return ai.compareTo(bi);
        if (ai != null) return -1;
        if (bi != null) return 1;
        return a.compareTo(b);
      });
      return sizes;
    }

    return _availableSizes;
  }

  int get _maxQuantity {
    if (_selectedSize == null) return 0;
    return widget.sizesStock[_selectedSize] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final sizeOptions = _resolveSizeOptions();
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
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
                color: Theme.of(context).dividerColor,
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
                  errorBuilder: (_, __, ___) => Container(
                    width: 60,
                    height: 80,
                    color: colorScheme.surface,
                    child: Icon(
                      Icons.image_not_supported,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: textTheme.labelLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(widget.product.currentPrice / 100).toStringAsFixed(2)} €',
                      style: AppTextStyles.price.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Tallas con stock
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Talla', style: textTheme.labelLarge),
              TextButton.icon(
                onPressed: () => _showSizeGuide(context),
                icon: const Icon(Icons.straighten, size: 14),
                label: const Text('Guía'),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.onSurface.withValues(alpha: 0.7),
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: sizeOptions.map((size) {
              final stockForSize = widget.sizesStock[size] ?? 0;
              final isSelected = _selectedSize == size;
              final isAvailable = stockForSize > 0;
              final isLowStock = stockForSize > 0 && stockForSize <= 3;

              return GestureDetector(
                onTap: isAvailable
                    ? () {
                        setState(() {
                          _selectedSize = size;
                          if (_quantity > stockForSize) {
                            _quantity = stockForSize;
                          }
                        });
                      }
                    : null,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: !isAvailable
                        ? colorScheme.surface.withValues(alpha: 0.6)
                        : isSelected
                        ? colorScheme.primary
                        : colorScheme.surface,
                    border: Border.all(
                      color: !isAvailable
                          ? Theme.of(context).dividerColor
                          : isSelected
                          ? colorScheme.primary
                          : isLowStock
                          ? AppColors.warning
                          : Theme.of(context).dividerColor,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        size,
                        style: TextStyle(
                          color: !isAvailable
                              ? colorScheme.onSurface.withValues(alpha: 0.4)
                              : isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                          decoration: !isAvailable
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      if (isAvailable && isLowStock)
                        Text(
                          '($stockForSize)',
                          style: TextStyle(
                            color: isSelected
                                ? colorScheme.onPrimary.withValues(alpha: 0.8)
                                : AppColors.warning,
                            fontSize: 9,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          // Aviso de pocas unidades
          if (_selectedSize != null &&
              _maxQuantity > 0 &&
              _maxQuantity <= 5) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: AppColors.warning,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _maxQuantity == 1
                        ? '¡Última unidad!'
                        : '¡Solo quedan $_maxQuantity!',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Botón
          CustomButton(
            text: _selectedSize == null
                ? 'Selecciona una talla'
                : 'Añadir al carrito',
            onPressed: _selectedSize != null && _maxQuantity > 0
                ? () => widget.onAddToCart(_selectedSize!, _quantity)
                : null,
            icon: Icons.shopping_bag_outlined,
          ),
        ],
      ),
    );
  }

  void _showSizeGuide(BuildContext context) {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SizeGuideSheet(),
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
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
            child: Text(
              quantity.toString(),
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
          _QuantityButton(
            icon: Icons.add,
            onPressed: maxQuantity > 0 && quantity < maxQuantity
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
    final colorScheme = Theme.of(context).colorScheme;
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
          color: onPressed != null
              ? colorScheme.primary
              : Theme.of(context).dividerColor,
        ),
      ),
    );
  }
}

/// Guía de tallas interactiva
class SizeGuideSheet extends StatefulWidget {
  const SizeGuideSheet({super.key});

  @override
  State<SizeGuideSheet> createState() => _SizeGuideSheetState();
}

class _SizeGuideSheetState extends State<SizeGuideSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'tops';

  // Datos de tallas
  static const Map<String, List<Map<String, dynamic>>> _sizeData = {
    'tops': [
      {'size': 'XS', 'chest': '82-86', 'waist': '62-66', 'hip': '88-92'},
      {'size': 'S', 'chest': '86-90', 'waist': '66-70', 'hip': '92-96'},
      {'size': 'M', 'chest': '90-94', 'waist': '70-74', 'hip': '96-100'},
      {'size': 'L', 'chest': '94-98', 'waist': '74-78', 'hip': '100-104'},
      {'size': 'XL', 'chest': '98-102', 'waist': '78-82', 'hip': '104-108'},
      {'size': 'XXL', 'chest': '102-106', 'waist': '82-86', 'hip': '108-112'},
    ],
    'bottoms': [
      {'size': 'XS', 'waist': '62-66', 'hip': '88-92', 'inseam': '76'},
      {'size': 'S', 'waist': '66-70', 'hip': '92-96', 'inseam': '76'},
      {'size': 'M', 'waist': '70-74', 'hip': '96-100', 'inseam': '78'},
      {'size': 'L', 'waist': '74-78', 'hip': '100-104', 'inseam': '78'},
      {'size': 'XL', 'waist': '78-82', 'hip': '104-108', 'inseam': '80'},
      {'size': 'XXL', 'waist': '82-86', 'hip': '108-112', 'inseam': '80'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Título
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Guía de tallas', style: AppTextStyles.h4),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Tabs
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'Parte superior'),
              Tab(text: 'Parte inferior'),
            ],
            onTap: (index) {
              setState(() {
                _selectedCategory = index == 0 ? 'tops' : 'bottoms';
              });
            },
          ),

          // Contenido
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildSizeTable('tops'), _buildSizeTable('bottoms')],
            ),
          ),

          // Cómo medirse
          Padding(
            padding: const EdgeInsets.all(24),
            child: _buildMeasurementGuide(),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeTable(String category) {
    final data = _sizeData[category]!;
    final isTop = category == 'tops';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Medidas en centímetros',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),

          // Tabla
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Table(
                border: TableBorder.symmetric(
                  inside: BorderSide(color: AppColors.border),
                ),
                columnWidths: const {0: FixedColumnWidth(60)},
                children: [
                  // Header
                  TableRow(
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                    ),
                    children: [
                      _tableCell('Talla', isHeader: true),
                      if (isTop) _tableCell('Pecho', isHeader: true),
                      _tableCell('Cintura', isHeader: true),
                      _tableCell('Cadera', isHeader: true),
                      if (!isTop) _tableCell('Largo', isHeader: true),
                    ],
                  ),
                  // Data rows
                  ...data.map(
                    (row) => TableRow(
                      children: [
                        _tableCell(row['size'], isSize: true),
                        if (isTop) _tableCell(row['chest']),
                        _tableCell(row['waist']),
                        _tableCell(row['hip']),
                        if (!isTop) _tableCell(row['inseam']),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Consejo
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline, color: AppColors.info),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Si estás entre dos tallas, te recomendamos elegir la más grande para mayor comodidad.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.info,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableCell(String text, {bool isHeader = false, bool isSize = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.bodySmall.copyWith(
          fontWeight: isHeader || isSize ? FontWeight.w600 : FontWeight.normal,
          color: isHeader ? AppColors.primary : AppColors.text,
        ),
      ),
    );
  }

  Widget _buildMeasurementGuide() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('¿Cómo medirte?', style: AppTextStyles.labelLarge),
          const SizedBox(height: 12),
          _measurementTip(
            Icons.accessibility_new,
            'Pecho',
            'Mide alrededor de la parte más ancha del pecho',
          ),
          const SizedBox(height: 8),
          _measurementTip(
            Icons.height,
            'Cintura',
            'Mide alrededor de la parte más estrecha de la cintura',
          ),
          const SizedBox(height: 8),
          _measurementTip(
            Icons.fiber_manual_record_outlined,
            'Cadera',
            'Mide alrededor de la parte más ancha de las caderas',
          ),
        ],
      ),
    );
  }

  Widget _measurementTip(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.labelMedium),
              Text(
                description,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
