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
              Text(
                'Error al cargar el pedido',
                style: AppTextStyles.bodyMedium,
              ),
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
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Estado del pedido', style: AppTextStyles.labelLarge),
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
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Realizado el ${DateFormat('dd MMMM yyyy, HH:mm', 'es_ES').format(order.createdAt)}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
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
                    : AppColors.border,
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
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCancelled
            ? AppColors.error
            : isCompleted
            ? AppColors.success
            : AppColors.surface,
        border: Border.all(
          color: isCancelled
              ? AppColors.error
              : isCompleted
              ? AppColors.success
              : AppColors.border,
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
                        style: AppTextStyles.labelMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.trackingNumber!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (order.carrier != null)
                        Text(
                          order.carrier!.name,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
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
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Productos (${items.length})',
              style: AppTextStyles.labelLarge,
            ),
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
                        color: AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: AppTextStyles.labelMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (item.size != null)
                            Text(
                              'Talla: ${item.size}',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          Text(
                            'Cant: ${item.quantity} × ${item.formattedPrice}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(item.formattedTotal, style: AppTextStyles.labelMedium),
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
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumen del pedido', style: AppTextStyles.labelLarge),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold ? AppTextStyles.labelLarge : AppTextStyles.bodyMedium,
          ),
          Text(
            value,
            style: isBold
                ? AppTextStyles.price
                : isDiscount
                ? AppTextStyles.bodyMedium.copyWith(color: AppColors.success)
                : AppTextStyles.bodyMedium,
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
    return Card(
      elevation: 0,
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blue.shade200),
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
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.receipt_long, color: Colors.blue.shade700),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tu Factura', style: AppTextStyles.labelLarge),
                      Text(
                        'Factura disponible para este pedido',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
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
                color: AppColors.textSecondary,
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
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
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
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_shipping, color: AppColors.primary),
                const SizedBox(width: 12),
                Text('Información de Envío', style: AppTextStyles.labelLarge),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
