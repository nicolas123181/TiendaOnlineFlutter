import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../shared/widgets/empty_states.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../providers/user_orders_provider.dart';

/// Pantalla de pedidos del usuario
class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(userOrdersProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'MIS PEDIDOS'),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const EmptyOrdersState();
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(userOrdersProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = orders[index];
                return _OrderCard(order: order);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text('Error al cargar pedidos', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.invalidate(userOrdersProvider),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final UserOrder order;

  const _OrderCard({required this.order});

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

  IconData _getStatusIcon() {
    switch (order.status) {
      case 'delivered':
        return Icons.check_circle;
      case 'shipped':
        return Icons.local_shipping;
      case 'cancelled':
        return Icons.cancel;
      case 'pending':
        return Icons.hourglass_empty;
      case 'paid':
        return Icons.payment;
      case 'ready_for_pickup':
        return Icons.inventory;
      default:
        return Icons.shopping_bag;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () => context.push('/order/${order.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Número y estado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pedido #${order.id}', style: AppTextStyles.labelLarge),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(),
                          size: 14,
                          color: _getStatusColor(),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          order.statusLabel,
                          style: AppTextStyles.caption.copyWith(
                            color: _getStatusColor(),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Fecha
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat(
                      'dd MMM yyyy, HH:mm',
                      'es_ES',
                    ).format(order.createdAt),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Items preview
              if (order.items.isNotEmpty) ...[
                Text(
                  order.items.length == 1
                      ? '${order.items.first.productName}${order.items.first.size != null ? ' - ${order.items.first.size}' : ''}'
                      : '${order.items.length} artículos',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
              ],

              const Divider(),
              const SizedBox(height: 8),

              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: AppTextStyles.bodyMedium),
                  Text(
                    order.formattedTotal,
                    style: AppTextStyles.price.copyWith(fontSize: 16),
                  ),
                ],
              ),

              // Tracking
              if (order.trackingNumber != null &&
                  order.status == 'shipped') ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_shipping,
                        size: 16,
                        color: AppColors.info,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Seguimiento: ${order.trackingNumber}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.info,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: AppColors.info,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
