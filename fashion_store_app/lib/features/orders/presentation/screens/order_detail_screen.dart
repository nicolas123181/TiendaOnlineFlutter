import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../providers/user_orders_provider.dart';

/// Pantalla de detalle del pedido
class OrderDetailScreen extends ConsumerWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final orderAsync = ref.watch(orderByIdProvider(orderId));

    return Scaffold(
      appBar: AppBar(title: Text('Pedido #$orderId')),
      body: orderAsync.when(
        data: (order) {
          if (order == null) {
            return const Center(child: Text('Pedido no encontrado'));
          }
          return _OrderDetailContent(order: order);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text('Error al cargar el pedido', style: textTheme.bodyMedium),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.invalidate(orderByIdProvider(orderId)),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderDetailContent extends StatelessWidget {
  final UserOrder order;

  const _OrderDetailContent({required this.order});

  Color _getStatusColor() {
    switch (order.status) {
      case 'delivered':
        return AppColors.success;
      case 'shipped':
        return AppColors.info;
      case 'cancelled':
        return AppColors.error;
      case 'pending':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Estado del pedido
          _StatusCard(order: order, statusColor: _getStatusColor()),
          const SizedBox(height: 16),

          // Tracking (si hay)
          if (order.trackingNumber != null && order.status == 'shipped') ...[
            _TrackingCard(order: order),
            const SizedBox(height: 16),
          ],

          // Factura
          if (order.status != 'pending' && order.status != 'cancelled')
            _InvoiceCard(order: order),

          // Productos
          _ProductsCard(items: order.items),
          const SizedBox(height: 16),

          // Información de envío
          _ShippingInfoCard(order: order),
          const SizedBox(height: 16),

          // Resumen del pedido
          _SummaryCard(order: order),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final UserOrder order;
  final Color statusColor;

  const _StatusCard({required this.order, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Estado del pedido', style: textTheme.labelLarge),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.statusLabel,
                    style: AppTextStyles.caption.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Timeline de estados
            _StatusTimeline(status: order.status),

            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 8),
                Text(
                  'Realizado el ${DateFormat('dd MMMM yyyy, HH:mm', 'es_ES').format(order.createdAt)}',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusTimeline extends StatelessWidget {
  final String status;

  const _StatusTimeline({required this.status});

  @override
  Widget build(BuildContext context) {
    final dividerColor = Theme.of(context).dividerColor;
    final statuses = [
      'pending',
      'paid',
      'ready_for_pickup',
      'shipped',
      'delivered',
    ];
    final currentIndex = statuses.indexOf(status);
    final isCancelled = status == 'cancelled';

    return Row(
      children: [
        for (int i = 0; i < statuses.length; i++) ...[
          _TimelineStep(
            isCompleted: !isCancelled && i <= currentIndex,
            isCurrent: !isCancelled && i == currentIndex,
            isCancelled: isCancelled,
          ),
          if (i < statuses.length - 1)
            Expanded(
              child: Container(
                height: 2,
                color: !isCancelled && i < currentIndex
                    ? AppColors.success
                    : dividerColor,
              ),
            ),
        ],
      ],
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final bool isCompleted;
  final bool isCurrent;
  final bool isCancelled;

  const _TimelineStep({
    required this.isCompleted,
    required this.isCurrent,
    required this.isCancelled,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCancelled
            ? AppColors.error
            : isCompleted
            ? AppColors.success
            : colorScheme.surface,
        border: Border.all(
          color: isCancelled
              ? AppColors.error
              : isCompleted
              ? AppColors.success
              : Theme.of(context).dividerColor,
          width: 2,
        ),
      ),
      child: isCompleted || isCancelled
          ? Icon(
              isCancelled ? Icons.close : Icons.check,
              size: 14,
              color: Colors.white,
            )
          : null,
    );
  }
}

class _TrackingCard extends StatelessWidget {
  final UserOrder order;

  const _TrackingCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      color: AppColors.info.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_shipping, color: AppColors.info),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Número de seguimiento',
                        style: textTheme.labelMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.trackingNumber!,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (order.carrier != null)
                        Text(
                          order.carrier!.name,
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.copy, color: colorScheme.onSurface),
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: order.trackingNumber!),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Número copiado')),
                    );
                  },
                ),
              ],
            ),
            if (order.carrier?.getTrackingUrl(order.trackingNumber) !=
                null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final url = order.carrier!.getTrackingUrl(
                      order.trackingNumber,
                    )!;
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    }
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Seguir envío'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProductsCard extends StatelessWidget {
  final List<OrderItem> items;

  const _ProductsCard({required this.items});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Productos (${items.length})', style: textTheme.labelLarge),
            const SizedBox(height: 16),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: textTheme.labelMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (item.size != null)
                            Text(
                              'Talla: ${item.size}',
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                          Text(
                            'Cant: ${item.quantity} × ${item.formattedPrice}',
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(item.formattedTotal, style: textTheme.labelMedium),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final UserOrder order;

  const _SummaryCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumen del pedido', style: textTheme.labelLarge),
            const SizedBox(height: 16),
            if (order.subtotal != null)
              _SummaryRow(
                label: 'Subtotal',
                value: '${(order.subtotal! / 100).toStringAsFixed(2)} €',
              ),
            if (order.shippingCost != null)
              _SummaryRow(
                label: 'Envío',
                value: order.shippingCost == 0
                    ? 'Gratis'
                    : '${(order.shippingCost! / 100).toStringAsFixed(2)} €',
              ),
            if (order.discount != null && order.discount! > 0)
              _SummaryRow(
                label: 'Descuento',
                value: '-${(order.discount! / 100).toStringAsFixed(2)} €',
                isDiscount: true,
              ),
            const Divider(),
            _SummaryRow(
              label: 'Total',
              value: order.formattedTotal,
              isBold: true,
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
  final bool isBold;
  final bool isDiscount;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.isDiscount = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold ? textTheme.labelLarge : textTheme.bodyMedium,
          ),
          Text(
            value,
            style: isBold
                ? AppTextStyles.price.copyWith(color: colorScheme.onSurface)
                : isDiscount
                ? textTheme.bodyMedium?.copyWith(color: AppColors.success)
                : textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

/// Card de factura
class _InvoiceCard extends StatelessWidget {
  final UserOrder order;

  const _InvoiceCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.receipt_long, color: colorScheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tu Factura', style: AppTextStyles.labelLarge),
                      Text(
                        'Factura disponible para este pedido',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Puedes ver y descargar tu factura para este pedido. '
              'La factura se genera automáticamente después de que el pago sea confirmado.',
              style: AppTextStyles.bodySmall.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navegar a pantalla de factura
                  context.push('/invoice/${order.id}');
                },
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Ver Factura (PDF)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card de información de envío
class _ShippingInfoCard extends StatelessWidget {
  final UserOrder order;

  const _ShippingInfoCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_shipping, color: colorScheme.primary),
                const SizedBox(width: 12),
                Text('Información de Envío', style: textTheme.labelLarge),
              ],
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.person,
              label: 'Destinatario',
              value: order.customerName,
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.email,
              label: 'Email',
              value: order.customerEmail,
            ),
            if (order.customerPhone != null) ...[
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.phone,
                label: 'Teléfono',
                value: order.customerPhone!,
              ),
            ],
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.location_on,
              label: 'Dirección',
              value:
                  '${order.customerAddress}\n'
                  '${order.customerPostalCode} ${order.customerCity}',
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 2),
              Text(value, style: textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
