import 'package:flutter/material.dart';

import '../../../config/app_colors.dart';

/// Badge genérico
class AppBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;
  final EdgeInsets padding;

  const AppBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.brandNavy,
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Badge de estado de pedido
class OrderStatusBadge extends StatelessWidget {
  final String status;

  const OrderStatusBadge({
    super.key,
    required this.status,
  });

  Color get _backgroundColor {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.warning.withOpacity(0.15);
      case 'processing':
        return AppColors.info.withOpacity(0.15);
      case 'shipped':
        return AppColors.brandNavy.withOpacity(0.15);
      case 'delivered':
        return AppColors.success.withOpacity(0.15);
      case 'cancelled':
        return AppColors.error.withOpacity(0.15);
      case 'refunded':
        return AppColors.textSecondary.withOpacity(0.15);
      default:
        return AppColors.surfaceMedium;
    }
  }

  Color get _textColor {
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
      case 'refunded':
        return AppColors.textSecondary;
      default:
        return AppColors.textPrimary;
    }
  }

  String get _displayText {
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
      case 'refunded':
        return 'Reembolsado';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _displayText,
        style: TextStyle(
          color: _textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Badge de estado de devolución
class ReturnStatusBadge extends StatelessWidget {
  final String status;

  const ReturnStatusBadge({
    super.key,
    required this.status,
  });

  Color get _backgroundColor {
    switch (status.toLowerCase()) {
      case 'requested':
        return AppColors.warning.withOpacity(0.15);
      case 'approved':
        return AppColors.info.withOpacity(0.15);
      case 'shipped':
        return AppColors.brandNavy.withOpacity(0.15);
      case 'received':
        return AppColors.brandGold.withOpacity(0.15);
      case 'refunded':
        return AppColors.success.withOpacity(0.15);
      case 'rejected':
        return AppColors.error.withOpacity(0.15);
      default:
        return AppColors.surfaceMedium;
    }
  }

  Color get _textColor {
    switch (status.toLowerCase()) {
      case 'requested':
        return AppColors.warning;
      case 'approved':
        return AppColors.info;
      case 'shipped':
        return AppColors.brandNavy;
      case 'received':
        return AppColors.brandGold;
      case 'refunded':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.textPrimary;
    }
  }

  String get _displayText {
    switch (status.toLowerCase()) {
      case 'requested':
        return 'Solicitada';
      case 'approved':
        return 'Aprobada';
      case 'shipped':
        return 'Enviada';
      case 'received':
        return 'Recibida';
      case 'refunded':
        return 'Reembolsada';
      case 'rejected':
        return 'Rechazada';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _displayText,
        style: TextStyle(
          color: _textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Badge de producto nuevo
class NewBadge extends StatelessWidget {
  const NewBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(
        color: AppColors.brandNavy,
      ),
      child: const Text(
        'NUEVO',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Badge de producto agotado
class SoldOutBadge extends StatelessWidget {
  const SoldOutBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withOpacity(0.9),
      ),
      child: const Text(
        'AGOTADO',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Badge de bajo stock
class LowStockBadge extends StatelessWidget {
  final int quantity;

  const LowStockBadge({
    super.key,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.15),
      ),
      child: Text(
        'Solo quedan $quantity',
        style: const TextStyle(
          color: AppColors.warning,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Badge de oferta
class SaleBadge extends StatelessWidget {
  final int? discountPercentage;

  const SaleBadge({
    super.key,
    this.discountPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(
        color: AppColors.error,
      ),
      child: Text(
        discountPercentage != null ? '-$discountPercentage%' : 'OFERTA',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Badge de envío gratis
class FreeShippingBadge extends StatelessWidget {
  const FreeShippingBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_shipping_outlined,
            size: 12,
            color: AppColors.success,
          ),
          const SizedBox(width: 4),
          const Text(
            'Envío gratis',
            style: TextStyle(
              color: AppColors.success,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge de contador (notificaciones, carrito)
class CounterBadge extends StatelessWidget {
  final int count;
  final Color? backgroundColor;
  final Color? textColor;
  final double size;

  const CounterBadge({
    super.key,
    required this.count,
    this.backgroundColor,
    this.textColor,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    final displayCount = count > 99 ? '99+' : count.toString();

    return Container(
      constraints: BoxConstraints(
        minWidth: size,
        minHeight: size,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.error,
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: Center(
        child: Text(
          displayCount,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: size * 0.6,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// Badge de verificado
class VerifiedBadge extends StatelessWidget {
  final double size;

  const VerifiedBadge({
    super.key,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        color: AppColors.success,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.check,
        color: Colors.white,
        size: size - 4,
      ),
    );
  }
}

/// Badge de cupón aplicado
class CouponAppliedBadge extends StatelessWidget {
  final String code;
  final VoidCallback? onRemove;

  const CouponAppliedBadge({
    super.key,
    required this.code,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
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
            Icons.local_offer,
            size: 16,
            color: AppColors.success,
          ),
          const SizedBox(width: 8),
          Text(
            code.toUpperCase(),
            style: const TextStyle(
              color: AppColors.success,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onRemove,
              child: const Icon(
                Icons.close,
                size: 16,
                color: AppColors.success,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Badge de rol de usuario (admin)
class RoleBadge extends StatelessWidget {
  final String role;

  const RoleBadge({
    super.key,
    required this.role,
  });

  Color get _backgroundColor {
    switch (role.toLowerCase()) {
      case 'admin':
        return AppColors.brandGold;
      case 'staff':
        return AppColors.brandNavy;
      case 'customer':
        return AppColors.textSecondary;
      default:
        return AppColors.surfaceMedium;
    }
  }

  String get _displayText {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'Administrador';
      case 'staff':
        return 'Staff';
      case 'customer':
        return 'Cliente';
      default:
        return role;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _displayText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
