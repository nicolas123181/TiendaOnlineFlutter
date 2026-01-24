import 'package:flutter/material.dart';

import '../../../config/app_colors.dart';

/// Widget para mostrar precio con formato
class PriceDisplay extends StatelessWidget {
  final int priceInCents;
  final int? originalPriceInCents;
  final String currency;
  final double fontSize;
  final bool showCurrencySymbol;
  final CrossAxisAlignment alignment;

  const PriceDisplay({
    super.key,
    required this.priceInCents,
    this.originalPriceInCents,
    this.currency = 'EUR',
    this.fontSize = 16,
    this.showCurrencySymbol = true,
    this.alignment = CrossAxisAlignment.start,
  });

  String _formatPrice(int cents) {
    final euros = cents / 100;
    final symbol = showCurrencySymbol ? _getCurrencySymbol() : '';
    return '$symbol${euros.toStringAsFixed(2)}';
  }

  String _getCurrencySymbol() {
    switch (currency.toUpperCase()) {
      case 'EUR':
        return '€';
      case 'USD':
        return '\$';
      case 'GBP':
        return '£';
      default:
        return currency;
    }
  }

  bool get _hasDiscount =>
      originalPriceInCents != null && originalPriceInCents! > priceInCents;

  @override
  Widget build(BuildContext context) {
    if (_hasDiscount) {
      return Column(
        crossAxisAlignment: alignment,
        children: [
          Text(
            _formatPrice(priceInCents),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _formatPrice(originalPriceInCents!),
            style: TextStyle(
              fontSize: fontSize * 0.75,
              color: AppColors.textTertiary,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      );
    }

    return Text(
      _formatPrice(priceInCents),
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }
}

/// Widget para mostrar precio en línea (horizontal)
class PriceDisplayInline extends StatelessWidget {
  final int priceInCents;
  final int? originalPriceInCents;
  final String currency;
  final double fontSize;

  const PriceDisplayInline({
    super.key,
    required this.priceInCents,
    this.originalPriceInCents,
    this.currency = 'EUR',
    this.fontSize = 14,
  });

  String _formatPrice(int cents) {
    final euros = cents / 100;
    return '€${euros.toStringAsFixed(2)}';
  }

  bool get _hasDiscount =>
      originalPriceInCents != null && originalPriceInCents! > priceInCents;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _formatPrice(priceInCents),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: _hasDiscount ? AppColors.error : AppColors.textPrimary,
          ),
        ),
        if (_hasDiscount) ...[
          const SizedBox(width: 8),
          Text(
            _formatPrice(originalPriceInCents!),
            style: TextStyle(
              fontSize: fontSize * 0.85,
              color: AppColors.textTertiary,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ],
    );
  }
}

/// Widget para mostrar subtotal del carrito
class CartSubtotal extends StatelessWidget {
  final int subtotalInCents;
  final int? discountInCents;
  final int? shippingInCents;
  final int totalInCents;
  final String? couponCode;

  const CartSubtotal({
    super.key,
    required this.subtotalInCents,
    this.discountInCents,
    this.shippingInCents,
    required this.totalInCents,
    this.couponCode,
  });

  String _formatPrice(int cents) {
    final euros = cents / 100;
    return '€${euros.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PriceRow(
          label: 'Subtotal',
          value: _formatPrice(subtotalInCents),
        ),
        if (discountInCents != null && discountInCents! > 0) ...[
          const SizedBox(height: 8),
          _PriceRow(
            label: couponCode != null ? 'Descuento ($couponCode)' : 'Descuento',
            value: '-${_formatPrice(discountInCents!)}',
            valueColor: AppColors.success,
          ),
        ],
        if (shippingInCents != null) ...[
          const SizedBox(height: 8),
          _PriceRow(
            label: 'Envío',
            value: shippingInCents == 0
                ? 'GRATIS'
                : _formatPrice(shippingInCents!),
            valueColor: shippingInCents == 0 ? AppColors.success : null,
          ),
        ],
        const SizedBox(height: 16),
        const Divider(height: 1),
        const SizedBox(height: 16),
        _PriceRow(
          label: 'Total',
          value: _formatPrice(totalInCents),
          isBold: true,
          fontSize: 18,
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;
  final double fontSize;

  const _PriceRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

/// Badge de descuento
class DiscountBadge extends StatelessWidget {
  final int percentage;
  final bool large;

  const DiscountBadge({
    super.key,
    required this.percentage,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 12 : 8,
        vertical: large ? 6 : 4,
      ),
      decoration: const BoxDecoration(
        color: AppColors.error,
      ),
      child: Text(
        '-$percentage%',
        style: TextStyle(
          color: Colors.white,
          fontSize: large ? 14 : 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Widget para mostrar ahorro
class SavingsDisplay extends StatelessWidget {
  final int savingsInCents;

  const SavingsDisplay({
    super.key,
    required this.savingsInCents,
  });

  @override
  Widget build(BuildContext context) {
    final euros = savingsInCents / 100;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_offer_outlined,
            size: 16,
            color: AppColors.success,
          ),
          const SizedBox(width: 8),
          Text(
            '¡Ahorras €${euros.toStringAsFixed(2)}!',
            style: const TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget de umbral de envío gratis
class FreeShippingThreshold extends StatelessWidget {
  final int currentAmountInCents;
  final int thresholdInCents;

  const FreeShippingThreshold({
    super.key,
    required this.currentAmountInCents,
    required this.thresholdInCents,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = thresholdInCents - currentAmountInCents;
    final progress = (currentAmountInCents / thresholdInCents).clamp(0.0, 1.0);
    final achieved = remaining <= 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: achieved
            ? AppColors.success.withOpacity(0.1)
            : AppColors.surfaceLight,
        border: Border.all(
          color:
              achieved ? AppColors.success.withOpacity(0.3) : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                achieved ? Icons.check_circle : Icons.local_shipping_outlined,
                color: achieved ? AppColors.success : AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  achieved
                      ? '¡Envío gratis conseguido!'
                      : 'Te faltan €${(remaining / 100).toStringAsFixed(2)} para envío gratis',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: achieved ? FontWeight.w600 : FontWeight.normal,
                    color: achieved ? AppColors.success : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          if (!achieved) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress > 0.7 ? AppColors.success : AppColors.brandNavy,
                ),
                minHeight: 4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
