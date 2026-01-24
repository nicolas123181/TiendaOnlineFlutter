import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../config/app_colors.dart';
import 'custom_button.dart';

/// Widget de estado vacío genérico
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final String? lottieAsset;
  final String? actionText;
  final VoidCallback? onAction;
  final double iconSize;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.lottieAsset,
    this.actionText,
    this.onAction,
    this.iconSize = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (lottieAsset != null)
              Lottie.asset(
                lottieAsset!,
                width: 200,
                height: 200,
                repeat: true,
              )
            else if (icon != null)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: iconSize,
                  color: AppColors.textTertiary,
                ),
              ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              CustomButton(
                text: actionText!,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget de carrito vacío
class EmptyCartWidget extends StatelessWidget {
  final VoidCallback? onBrowseProducts;

  const EmptyCartWidget({
    super.key,
    this.onBrowseProducts,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.shopping_bag_outlined,
      title: 'Tu carrito está vacío',
      subtitle: 'Añade productos para comenzar tu compra',
      actionText: 'Explorar productos',
      onAction: onBrowseProducts,
    );
  }
}

/// Widget de wishlist vacía
class EmptyWishlistWidget extends StatelessWidget {
  final VoidCallback? onBrowseProducts;

  const EmptyWishlistWidget({
    super.key,
    this.onBrowseProducts,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.favorite_border,
      title: 'Tu lista de deseos está vacía',
      subtitle: 'Guarda tus productos favoritos para comprarlos más tarde',
      actionText: 'Explorar productos',
      onAction: onBrowseProducts,
    );
  }
}

/// Widget de sin pedidos
class EmptyOrdersWidget extends StatelessWidget {
  final VoidCallback? onBrowseProducts;

  const EmptyOrdersWidget({
    super.key,
    this.onBrowseProducts,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.receipt_long_outlined,
      title: 'Aún no tienes pedidos',
      subtitle: 'Cuando realices un pedido, aparecerá aquí',
      actionText: 'Hacer mi primer pedido',
      onAction: onBrowseProducts,
    );
  }
}

/// Widget de sin direcciones
class EmptyAddressesWidget extends StatelessWidget {
  final VoidCallback? onAddAddress;

  const EmptyAddressesWidget({
    super.key,
    this.onAddAddress,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.location_on_outlined,
      title: 'No tienes direcciones guardadas',
      subtitle: 'Añade una dirección para agilizar tus compras',
      actionText: 'Añadir dirección',
      onAction: onAddAddress,
    );
  }
}

/// Widget de búsqueda sin resultados
class EmptySearchWidget extends StatelessWidget {
  final String query;
  final VoidCallback? onClearSearch;

  const EmptySearchWidget({
    super.key,
    required this.query,
    this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.search_off,
      title: 'Sin resultados',
      subtitle: 'No encontramos productos para "$query"',
      actionText: 'Limpiar búsqueda',
      onAction: onClearSearch,
    );
  }
}

/// Widget de categoría vacía
class EmptyCategoryWidget extends StatelessWidget {
  final String categoryName;
  final VoidCallback? onBrowseOther;

  const EmptyCategoryWidget({
    super.key,
    required this.categoryName,
    this.onBrowseOther,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.inventory_2_outlined,
      title: 'Categoría vacía',
      subtitle: 'No hay productos en $categoryName por el momento',
      actionText: 'Ver otras categorías',
      onAction: onBrowseOther,
    );
  }
}

/// Widget de sin facturas
class EmptyInvoicesWidget extends StatelessWidget {
  const EmptyInvoicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateWidget(
      icon: Icons.description_outlined,
      title: 'No tienes facturas',
      subtitle: 'Las facturas de tus pedidos aparecerán aquí',
    );
  }
}

/// Widget de sin devoluciones
class EmptyReturnsWidget extends StatelessWidget {
  const EmptyReturnsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateWidget(
      icon: Icons.assignment_return_outlined,
      title: 'No tienes devoluciones',
      subtitle: 'El historial de tus devoluciones aparecerá aquí',
    );
  }
}

/// Widget de sin notificaciones
class EmptyNotificationsWidget extends StatelessWidget {
  const EmptyNotificationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateWidget(
      icon: Icons.notifications_none,
      title: 'Sin notificaciones',
      subtitle: 'No tienes notificaciones nuevas',
    );
  }
}
