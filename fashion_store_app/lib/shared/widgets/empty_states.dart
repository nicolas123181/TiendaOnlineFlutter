import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';

/// Estado vacío genérico
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(title, style: AppTextStyles.h4, textAlign: TextAlign.center),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionText!.toUpperCase()),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Estado de error con opción de reintentar
class ErrorState extends StatelessWidget {
  final String title;
  final String? message;
  final VoidCallback? onRetry;
  final IconData icon;

  const ErrorState({
    super.key,
    this.title = 'Algo salió mal',
    this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(title, style: AppTextStyles.h4, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('REINTENTAR'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Estado sin conexión
class OfflineState extends StatelessWidget {
  final VoidCallback? onRetry;

  const OfflineState({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ErrorState(
      title: 'Sin conexión',
      message: 'Verifica tu conexión a internet e inténtalo de nuevo.',
      icon: Icons.wifi_off,
      onRetry: onRetry,
    );
  }
}

/// Carrito vacío
class EmptyCartState extends StatelessWidget {
  final VoidCallback? onContinueShopping;

  const EmptyCartState({super.key, this.onContinueShopping});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.shopping_bag_outlined,
      title: 'Tu carrito está vacío',
      subtitle: 'Explora nuestra colección y encuentra algo que te encante.',
      actionText: 'Explorar productos',
      onAction: onContinueShopping,
    );
  }
}

/// Sin favoritos
class EmptyFavoritesState extends StatelessWidget {
  final VoidCallback? onExplore;

  const EmptyFavoritesState({super.key, this.onExplore});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.favorite_outline,
      title: 'Sin favoritos aún',
      subtitle: 'Guarda tus productos favoritos para encontrarlos fácilmente.',
      actionText: 'Explorar productos',
      onAction: onExplore,
    );
  }
}

/// Sin pedidos
class EmptyOrdersState extends StatelessWidget {
  final VoidCallback? onExplore;

  const EmptyOrdersState({super.key, this.onExplore});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.receipt_long_outlined,
      title: 'Sin pedidos',
      subtitle: 'Cuando realices una compra, aparecerá aquí.',
      actionText: 'Ir a comprar',
      onAction: onExplore,
    );
  }
}

/// Sin resultados de búsqueda
class NoSearchResultsState extends StatelessWidget {
  final String query;
  final VoidCallback? onClear;

  const NoSearchResultsState({super.key, required this.query, this.onClear});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.search_off,
      title: 'Sin resultados',
      subtitle:
          'No encontramos productos para "$query". Prueba con otros términos.',
      actionText: 'Limpiar búsqueda',
      onAction: onClear,
    );
  }
}

/// Producto agotado
class OutOfStockBadge extends StatelessWidget {
  const OutOfStockBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.textSecondary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'AGOTADO',
        style: AppTextStyles.badge.copyWith(color: Colors.white),
      ),
    );
  }
}

/// Badge de oferta
class SaleBadge extends StatelessWidget {
  final int discountPercentage;

  const SaleBadge({super.key, required this.discountPercentage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.salePrice,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '-$discountPercentage%',
        style: AppTextStyles.badge.copyWith(color: Colors.white),
      ),
    );
  }
}

/// Badge de nuevo
class NewBadge extends StatelessWidget {
  const NewBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'NUEVO',
        style: AppTextStyles.badge.copyWith(color: AppColors.primary),
      ),
    );
  }
}
