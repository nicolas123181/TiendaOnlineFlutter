import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/constants/app_constants.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../shared/services/supabase_service.dart';
import '../../../returns/data/models/return_model.dart';
import '../../../returns/presentation/screens/return_screens.dart';
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
      case 'refunded':
        return AppColors.success;
      case 'return_pending':
      case 'return_in_transit':
      case 'return_received':
        return AppColors.warning;
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
          if (order.status != 'pending') _InvoiceCard(order: order),

          // Productos
          _ProductsCard(items: order.items),
          const SizedBox(height: 16),

          // Información de envío
          _ShippingInfoCard(order: order),
          const SizedBox(height: 16),

          // Resumen del pedido
          _SummaryCard(order: order),

          // Cancelar pedido (solo si está en 'paid')
          if (order.status == 'paid') ...[
            const SizedBox(height: 16),
            _CancelOrderCard(order: order),
          ],

          // Solicitar devolución (solo si está en 'delivered')
          if (order.status == 'delivered') ...[
            const SizedBox(height: 16),
            _RequestReturnCard(order: order),
          ],

          const SizedBox(height: 24),
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

    if (status == 'refunded') {
      return Row(
        children: [
          for (int i = 0; i < 5; i++) ...[
            _TimelineStep(
              isCompleted: true,
              isCurrent: i == 4,
              isCancelled: false,
            ),
            if (i < 4)
              Expanded(child: Container(height: 2, color: AppColors.success)),
          ],
        ],
      );
    }

    if (status == 'return_pending' ||
        status == 'return_in_transit' ||
        status == 'return_received') {
      return Row(
        children: [
          for (int i = 0; i < 5; i++) ...[
            _TimelineStep(
              isCompleted: i <= 4,
              isCurrent: i == 4,
              isCancelled: false,
            ),
            if (i < 4)
              Expanded(child: Container(height: 2, color: AppColors.success)),
          ],
        ],
      );
    }

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
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  final trackingUrl = order.carrier?.getTrackingUrl(
                    order.trackingNumber,
                  );
                  if (trackingUrl != null) {
                    final uri = Uri.parse(trackingUrl);
                    try {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    } catch (_) {
                      await launchUrl(uri);
                    }
                  } else {
                    // Fallback: buscar por carrier genéricos
                    final query = Uri.encodeComponent(
                      order.trackingNumber ?? '',
                    );
                    final fallbackUrl =
                        'https://www.google.com/search?q=seguimiento+envio+$query';
                    final uri = Uri.parse(fallbackUrl);
                    try {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    } catch (_) {
                      await launchUrl(uri);
                    }
                  }
                },
                icon: const Icon(Icons.open_in_new),
                label: Text(
                  order.carrier != null
                      ? 'Seguir envío en ${order.carrier!.name}'
                      : 'Seguir envío',
                ),
              ),
            ),
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

/// Card de factura — descarga directa del PDF sin previsualización
class _InvoiceCard extends ConsumerStatefulWidget {
  final UserOrder order;

  const _InvoiceCard({required this.order});

  @override
  ConsumerState<_InvoiceCard> createState() => _InvoiceCardState();
}

class _InvoiceCardState extends ConsumerState<_InvoiceCard> {
  bool _loading = false;

  bool get _isCancelledOrRefunded {
    final s = widget.order.status;
    return s == 'cancelled' || s == 'refunded' || s == 'return_received';
  }

  Future<void> _downloadInvoicePdf() async {
    setState(() => _loading = true);
    try {
      final supabase = ref.read(supabaseClientProvider);
      final orderId = widget.order.id;

      // Buscar todas las facturas de este pedido
      final allInvoices = await supabase
          .from('invoices')
          .select('id, type, total')
          .eq('order_id', orderId)
          .order('created_at', ascending: false);

      final invoices = List<Map<String, dynamic>>.from(allInvoices);

      Map<String, dynamic>? selected;

      if (_isCancelledOrRefunded) {
        // Buscar factura rectificativa (credit_note o total negativo)
        for (final inv in invoices) {
          final t = inv['type'] as String?;
          final total = (inv['total'] as num?)?.toInt() ?? 0;
          if (t == 'credit_note' || total < 0) {
            selected = inv;
            break;
          }
        }
        // Fallback: la más reciente
        selected ??= invoices.isNotEmpty ? invoices.first : null;
      } else {
        // Buscar factura estándar (type != credit_note y total >= 0)
        for (final inv in invoices) {
          final t = inv['type'] as String?;
          final total = (inv['total'] as num?)?.toInt() ?? 0;
          if (t != 'credit_note' && total >= 0) {
            selected = inv;
            break;
          }
        }
        // Fallback: la más reciente
        selected ??= invoices.isNotEmpty ? invoices.first : null;
      }

      if (selected != null) {
        final invoiceId = (selected['id'] as num).toInt();
        final url =
            '${AppConstants.webApiBaseUrl}/api/invoice/$invoiceId/pdf?download=true';
        final uri = Uri.parse(url);
        try {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } catch (_) {
          await launchUrl(uri);
        }
      } else {
        // No existe aún → abrir pantalla que la crea
        if (mounted) context.push('/invoice/$orderId');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al obtener factura: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

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
                      Text(
                        _isCancelledOrRefunded
                            ? 'Factura Rectificativa'
                            : 'Tu Factura',
                        style: AppTextStyles.labelLarge,
                      ),
                      Text(
                        _isCancelledOrRefunded
                            ? 'Nota de crédito disponible'
                            : 'Factura disponible para este pedido',
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
              _isCancelledOrRefunded
                  ? 'Descarga la factura rectificativa (nota de crédito) de este pedido.'
                  : 'Pulsa el botón para descargar la factura de este pedido en formato PDF.',
              style: AppTextStyles.bodySmall.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _loading ? null : _downloadInvoicePdf,
                icon: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.picture_as_pdf),
                label: Text(
                  _loading
                      ? 'Descargando...'
                      : _isCancelledOrRefunded
                      ? 'Descargar Nota de Crédito'
                      : 'Descargar Factura',
                ),
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

/// Card para cancelar pedido (solo visible si status == 'paid')
class _CancelOrderCard extends ConsumerStatefulWidget {
  final UserOrder order;

  const _CancelOrderCard({required this.order});

  @override
  ConsumerState<_CancelOrderCard> createState() => _CancelOrderCardState();
}

class _CancelOrderCardState extends ConsumerState<_CancelOrderCard> {
  bool _isCancelling = false;

  Future<void> _cancelOrder() async {
    // Mostrar diálogo de confirmación
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancelar Pedido'),
        content: const Text(
          '¿Estás seguro de que deseas cancelar este pedido?\n\n'
          'Recibirás el reembolso en tu método de pago original en 5-10 días hábiles.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('No, mantener'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isCancelling = true);

    try {
      final supabase = ref.read(supabaseClientProvider);
      final session = supabase.auth.currentSession;

      final headers = <String, String>{'Content-Type': 'application/json'};
      if (session?.accessToken != null) {
        headers['Authorization'] = 'Bearer ${session!.accessToken}';
      }

      final response = await http.post(
        Uri.parse('${AppConstants.webApiBaseUrl}/api/orders/cancel'),
        headers: headers,
        body: jsonEncode({'orderId': widget.order.id}),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Pedido cancelado correctamente. Recibirás tu reembolso pronto.',
              ),
              backgroundColor: AppColors.success,
            ),
          );
          // Invalidar cache y volver atrás
          ref.invalidate(userOrdersProvider);
          ref.invalidate(orderByIdProvider(widget.order.id));
          return;
        }
      }

      // Error
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      final errorMsg = body is Map && body['error'] is String
          ? body['error'] as String
          : 'Error al cancelar el pedido';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: AppColors.error),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCancelling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.error.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.error.withValues(alpha: 0.2)),
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
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.cancel_outlined,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¿Deseas cancelar el pedido?',
                        style: AppTextStyles.labelLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tu pedido aún no ha sido enviado. Puedes cancelarlo y recibirás el reembolso en 5-10 días hábiles.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isCancelling ? null : _cancelOrder,
                icon: _isCancelling
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.delete_outline),
                label: Text(
                  _isCancelling ? 'Cancelando...' : 'Cancelar Pedido',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
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

/// Card para solicitar devolución (solo visible si status == 'delivered')
class _RequestReturnCard extends StatelessWidget {
  final UserOrder order;

  const _RequestReturnCard({required this.order});

  @override
  Widget build(BuildContext context) {
    // Comprobar si ya existe una devolución
    return Consumer(
      builder: (context, ref, _) {
        final existingReturn = ref.watch(returnByOrderProvider(order.id));

        return existingReturn.when(
          data: (returnReq) {
            // Si ya hay una devolución activa, mostrar su estado
            if (returnReq != null) {
              return _ExistingReturnCard(returnRequest: returnReq);
            }
            // Si no, mostrar botón para solicitar
            return _NewReturnCard(orderId: order.id);
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => _NewReturnCard(orderId: order.id),
        );
      },
    );
  }
}

class _NewReturnCard extends StatelessWidget {
  final int orderId;

  const _NewReturnCard({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.warning.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.warning.withValues(alpha: 0.2)),
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
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.assignment_return,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¿Necesitas devolver algo?',
                        style: AppTextStyles.labelLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tienes 30 días desde la entrega para solicitar una devolución.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.push('/return/$orderId'),
                icon: const Icon(Icons.assignment_return),
                label: const Text('Solicitar Devolución'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.warning,
                  side: const BorderSide(color: AppColors.warning),
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

class _ExistingReturnCard extends StatelessWidget {
  final ReturnRequest returnRequest;

  const _ExistingReturnCard({required this.returnRequest});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (returnRequest.status) {
      case 'pending':
      case 'in_transit':
        statusColor = AppColors.warning;
        statusText = 'Devolución en proceso';
        statusIcon = Icons.hourglass_empty;
        break;
      case 'received':
        statusColor = AppColors.info;
        statusText = 'Devolución recibida - En revisión';
        statusIcon = Icons.inbox;
        break;
      case 'refunded':
        statusColor = AppColors.success;
        statusText = 'Reembolso procesado';
        statusIcon = Icons.check_circle;
        break;
      case 'rejected':
        statusColor = AppColors.error;
        statusText = 'Devolución rechazada';
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = AppColors.textSecondary;
        statusText = returnRequest.status;
        statusIcon = Icons.info;
    }

    return Card(
      elevation: 0,
      color: statusColor.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: statusColor.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(statusIcon, color: statusColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(statusText, style: AppTextStyles.labelLarge),
                  const SizedBox(height: 4),
                  Text(
                    'Ref: ${returnRequest.returnNumber}',
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                returnRequest.statusLabel,
                style: AppTextStyles.caption.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
