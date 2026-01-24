import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../config/app_colors.dart';

/// Card para categoría
class CategoryCard extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const CategoryCard({
    super.key,
    required this.name,
    this.imageUrl,
    this.onTap,
    this.width = 120,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Imagen de fondo
            if (imageUrl != null)
              CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.surfaceMedium,
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.surfaceMedium,
                ),
              )
            else
              Container(
                color: AppColors.brandNavy,
              ),
            // Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
            // Nombre
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Text(
                name.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card para sección informativa
class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.brandNavy.withOpacity(0.1),
              ),
              child: Icon(
                icon,
                color: AppColors.brandNavy,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else if (onTap != null)
              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}

/// Card para dirección
class AddressCard extends StatelessWidget {
  final String name;
  final String address;
  final String city;
  final String postalCode;
  final String? phone;
  final bool isDefault;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AddressCard({
    super.key,
    required this.name,
    required this.address,
    required this.city,
    required this.postalCode,
    this.phone,
    this.isDefault = false,
    this.isSelected = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.brandNavy.withOpacity(0.05)
              : Theme.of(context).cardColor,
          border: Border.all(
            color: isSelected ? AppColors.brandNavy : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.brandNavy,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Predeterminada',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.brandNavy,
                    size: 24,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              address,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$postalCode, $city',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            if (phone != null) ...[
              const SizedBox(height: 4),
              Text(
                phone!,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            if (onEdit != null || onDelete != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (onEdit != null)
                    TextButton(
                      onPressed: onEdit,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Editar',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.brandNavy,
                        ),
                      ),
                    ),
                  if (onEdit != null && onDelete != null)
                    const SizedBox(width: 16),
                  if (onDelete != null)
                    TextButton(
                      onPressed: onDelete,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Eliminar',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Card para método de envío
class ShippingMethodCard extends StatelessWidget {
  final String name;
  final String description;
  final int priceInCents;
  final String estimatedDays;
  final bool isSelected;
  final VoidCallback? onTap;

  const ShippingMethodCard({
    super.key,
    required this.name,
    required this.description,
    required this.priceInCents,
    required this.estimatedDays,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.brandNavy.withOpacity(0.05)
              : Theme.of(context).cardColor,
          border: Border.all(
            color: isSelected ? AppColors.brandNavy : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.brandNavy : AppColors.border,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.brandNavy,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$description • $estimatedDays',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              priceInCents == 0
                  ? 'GRATIS'
                  : '€${(priceInCents / 100).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: priceInCents == 0
                    ? AppColors.success
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card para método de pago
class PaymentMethodCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final String? lastDigits;
  final bool isSelected;
  final VoidCallback? onTap;

  const PaymentMethodCard({
    super.key,
    required this.name,
    required this.icon,
    this.lastDigits,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.brandNavy.withOpacity(0.05)
              : Theme.of(context).cardColor,
          border: Border.all(
            color: isSelected ? AppColors.brandNavy : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.brandNavy : AppColors.border,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.brandNavy,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Icon(
              icon,
              size: 28,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (lastDigits != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      '•••• $lastDigits',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card para orden en historial
class OrderHistoryCard extends StatelessWidget {
  final String orderId;
  final DateTime date;
  final String status;
  final int totalInCents;
  final int itemCount;
  final String? imageUrl;
  final VoidCallback? onTap;

  const OrderHistoryCard({
    super.key,
    required this.orderId,
    required this.date,
    required this.status,
    required this.totalInCents,
    required this.itemCount,
    this.imageUrl,
    this.onTap,
  });

  String get _statusText {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pendiente';
      case 'processing':
        return 'Procesando';
      case 'shipped':
        return 'Enviado';
      case 'delivered':
        return 'Entregado';
      case 'cancelled':
        return 'Cancelado';
      default:
        return status;
    }
  }

  Color get _statusColor {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.warning;
      case 'processing':
        return AppColors.info;
      case 'shipped':
        return AppColors.brandNavy;
      case 'delivered':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Imagen
            Container(
              width: 70,
              height: 70,
              color: AppColors.surfaceLight,
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                    )
                  : const Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColors.textTertiary,
                    ),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pedido #$orderId',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}/${date.month}/${date.year} • $itemCount ${itemCount == 1 ? 'artículo' : 'artículos'}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _statusText,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _statusColor,
                          ),
                        ),
                      ),
                      Text(
                        '€${(totalInCents / 100).toStringAsFixed(2)}',
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
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
