import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_colors.dart';
import '../../../data/models/invoice.dart';
import '../../providers/invoice_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/price_display.dart';

/// Pantalla de listado de facturas
class InvoicesScreen extends ConsumerWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(userInvoicesProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Mis Facturas',
        showBackButton: true,
      ),
      body: invoicesAsync.when(
        loading: () => const LoadingScreen(),
        error: (_, __) => _buildEmptyState(context),
        data: (invoices) {
          if (invoices.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () => ref.refresh(userInvoicesProvider.future),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: invoices.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final invoice = invoices[index];
                return _InvoiceCard(
                  invoice: invoice,
                  onTap: () => context.push('/invoice/${invoice.id}'),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.receipt_long_outlined,
      title: 'No tienes facturas aún',
      subtitle: 'Cuando completes una compra, aparecerán aquí',
      actionText: 'Explorar productos',
      onAction: () => context.go('/home'),
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  final Invoice invoice;
  final VoidCallback onTap;

  const _InvoiceCard({
    required this.invoice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Factura #${invoice.invoiceNumber}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(invoice.issueDate),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                _InvoiceStatusBadge(status: invoice.status),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pedido #${invoice.orderId}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
                PriceDisplayInline(
                  priceInCents: invoice.total,
                  fontSize: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }
}

class _InvoiceStatusBadge extends StatelessWidget {
  final String status;

  const _InvoiceStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status.toLowerCase()) {
      'issued' => ('Emitida', AppColors.orderShipped),
      'paid' => ('Pagada', AppColors.orderDelivered),
      'pending' => ('Pendiente', AppColors.orderPending),
      'cancelled' => ('Cancelada', AppColors.orderCancelled),
      _ => ('Estado', AppColors.textTertiary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
