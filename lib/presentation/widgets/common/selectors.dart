import 'package:flutter/material.dart';

import '../../../config/app_colors.dart';

/// Selector de cantidad para carrito
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final int minQuantity;
  final int maxQuantity;
  final ValueChanged<int> onChanged;
  final bool isLoading;
  final bool compact;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.minQuantity = 1,
    this.maxQuantity = 99,
    this.isLoading = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _CompactQuantitySelector(
        quantity: quantity,
        minQuantity: minQuantity,
        maxQuantity: maxQuantity,
        onChanged: onChanged,
        isLoading: isLoading,
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QuantityButton(
            icon: Icons.remove,
            onPressed: quantity > minQuantity && !isLoading
                ? () => onChanged(quantity - 1)
                : null,
          ),
          SizedBox(
            width: 50,
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      quantity.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          _QuantityButton(
            icon: Icons.add,
            onPressed: quantity < maxQuantity && !isLoading
                ? () => onChanged(quantity + 1)
                : null,
          ),
        ],
      ),
    );
  }
}

class _CompactQuantitySelector extends StatelessWidget {
  final int quantity;
  final int minQuantity;
  final int maxQuantity;
  final ValueChanged<int> onChanged;
  final bool isLoading;

  const _CompactQuantitySelector({
    required this.quantity,
    required this.minQuantity,
    required this.maxQuantity,
    required this.onChanged,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: quantity > minQuantity && !isLoading
              ? () => onChanged(quantity - 1)
              : null,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(
              Icons.remove,
              size: 16,
              color: quantity > minQuantity && !isLoading
                  ? AppColors.textPrimary
                  : AppColors.textTertiary,
            ),
          ),
        ),
        Container(
          width: 40,
          height: 28,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.border),
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                    ),
                  )
                : Text(
                    quantity.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ),
        GestureDetector(
          onTap: quantity < maxQuantity && !isLoading
              ? () => onChanged(quantity + 1)
              : null,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(
              Icons.add,
              size: 16,
              color: quantity < maxQuantity && !isLoading
                  ? AppColors.textPrimary
                  : AppColors.textTertiary,
            ),
          ),
        ),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _QuantityButton({
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border(
              right: icon == Icons.remove
                  ? BorderSide(color: AppColors.border)
                  : BorderSide.none,
              left: icon == Icons.add
                  ? BorderSide(color: AppColors.border)
                  : BorderSide.none,
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: onPressed != null
                ? AppColors.textPrimary
                : AppColors.textTertiary,
          ),
        ),
      ),
    );
  }
}

/// Selector de talla
class SizeSelector extends StatelessWidget {
  final List<String> sizes;
  final Map<String, int> stockBySize;
  final String? selectedSize;
  final ValueChanged<String> onSelected;
  final bool showStock;

  const SizeSelector({
    super.key,
    required this.sizes,
    required this.onSelected,
    this.stockBySize = const {},
    this.selectedSize,
    this.showStock = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: sizes.map((size) {
        final isSelected = size == selectedSize;
        final stock = stockBySize[size] ?? 0;
        final isOutOfStock = stockBySize.isNotEmpty && stock == 0;
        final isLowStock = stockBySize.isNotEmpty && stock > 0 && stock <= 3;

        // Light mode: Better contrast
        final backgroundColor = isSelected
            ? AppColors.brandNavy // Dark blue background when selected
            : isDark
                ? AppColors.darkSurfaceElevated
                : Color(0xFFF0F4F8); // Light blue background in light mode
        final borderColor = isOutOfStock
            ? (isDark ? AppColors.darkBorder : Color(0xFFD1D8E0))
            : isSelected
                ? AppColors.brandNavy
                : isDark
                    ? AppColors.darkBorder
                    : AppColors.brandNavy; // Blue border always visible
        final textColor = isOutOfStock
            ? (isDark ? AppColors.darkTextSecondary : Color(0xFF9CA3AF))
            : isSelected
                ? Colors.white // White text on dark blue
                : isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.brandNavy; // Dark blue text in light mode

        return GestureDetector(
          onTap: isOutOfStock ? null : () => onSelected(size),
          child: Container(
            constraints: const BoxConstraints(minWidth: 50),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(
                color: borderColor,
                width: isSelected ? 2 : 1.5,
              ),
            ),
            child: Column(
              children: [
                Text(
                  size,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                    decoration: isOutOfStock
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                if (showStock && !isOutOfStock && isLowStock) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Quedan $stock',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white.withOpacity(0.9)
                          : AppColors.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Selector de color
class ColorSelector extends StatelessWidget {
  final List<ColorOption> colors;
  final String? selectedColorId;
  final ValueChanged<String> onSelected;

  const ColorSelector({
    super.key,
    required this.colors,
    required this.onSelected,
    this.selectedColorId,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: colors.map((colorOption) {
        final isSelected = colorOption.id == selectedColorId;
        final isOutOfStock = colorOption.stock == 0;

        return GestureDetector(
          onTap: isOutOfStock ? null : () => onSelected(colorOption.id),
          child: Opacity(
            opacity: isOutOfStock ? 0.5 : 1.0,
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorOption.color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.brandNavy
                          : (isDark ? AppColors.darkBorder : Color(0xFFD1D8E0)),
                      width: isSelected ? 3 : 2,
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: AppColors.brandNavy.withAlpha(80),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: isOutOfStock
                      ? CustomPaint(
                          painter: _DiagonalLinePainter(),
                        )
                      : null,
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 50,
                  child: Text(
                    colorOption.name,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? AppColors.brandNavy
                          : (isDark
                              ? AppColors.darkTextSecondary
                              : Color(0xFF4B5563)),
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class ColorOption {
  final String id;
  final String name;
  final Color color;
  final int stock;

  const ColorOption({
    required this.id,
    required this.name,
    required this.color,
    this.stock = 1,
  });
}

class _DiagonalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.error
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.8),
      Offset(size.width * 0.8, size.height * 0.2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Chips de selección múltiple
class FilterChips extends StatelessWidget {
  final List<FilterChipOption> options;
  final List<String> selectedIds;
  final ValueChanged<List<String>> onChanged;

  const FilterChips({
    super.key,
    required this.options,
    required this.selectedIds,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selectedIds.contains(option.id);

        return FilterChip(
          label: Text(option.label),
          selected: isSelected,
          onSelected: (selected) {
            final newSelection = List<String>.from(selectedIds);
            if (selected) {
              newSelection.add(option.id);
            } else {
              newSelection.remove(option.id);
            }
            onChanged(newSelection);
          },
          selectedColor: AppColors.brandNavy.withOpacity(0.2),
          checkmarkColor: AppColors.brandNavy,
          labelStyle: TextStyle(
            color: isSelected ? AppColors.brandNavy : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(
              color: isSelected ? AppColors.brandNavy : AppColors.border,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class FilterChipOption {
  final String id;
  final String label;
  final int? count;

  const FilterChipOption({
    required this.id,
    required this.label,
    this.count,
  });
}
