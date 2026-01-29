// Pantallas para Tallas, Devoluciones y Facturas del Admin

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../returns/data/models/return_model.dart';
import '../../../returns/presentation/providers/returns_admin_provider.dart';
import '../providers/sizes_provider.dart';
import '../providers/invoices_provider.dart';
import '../../data/models/invoice.dart';
import '../../data/models/product_size.dart';

/// Pantalla de Gestión de Tallas
class AdminSizesScreen extends ConsumerWidget {
  const AdminSizesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lowStockAsync = ref.watch(lowStockSizesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Tallas')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📐 Sistemas de Tallas', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Text(
              'Cada categoría tiene un sistema de tallas predefinido',
              style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Sistemas de tallas
            ...SizeSystems.systems.entries.map((entry) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.value.name, style: AppTextStyles.labelLarge),
                      const SizedBox(height: 4),
                      Text(
                        entry.value.description,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: entry.value.sizes.map((size) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.primary),
                            ),
                            child: Text(
                              size,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 32),

            // Stock bajo
            Text('⚠️ Stock Bajo por Talla', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Text(
              'Tallas con menos de 5 unidades disponibles',
              style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            lowStockAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 48,
                              color: Colors.green,
                            ),
                            SizedBox(height: 16),
                            Text('✅ Todas las tallas tienen stock suficiente'),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return Column(
                  children: items.map((item) {
                    // item es ProductSize, no un Map
                    final productSize = item;
                    final stock = productSize.stock;
                    final size = productSize.size;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      color: stock == 0 ? Colors.red[50] : Colors.orange[50],
                      child: ListTile(
                        leading: const Icon(Icons.checkroom, size: 40),
                        title: Text('Producto ID: ${productSize.productId}'),
                        subtitle: Text('Talla: $size'),

                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: stock == 0 ? Colors.red : Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            stock == 0 ? 'AGOTADO' : '$stock uds',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pantalla de Gestión de Devoluciones
/// Pantalla de Gestión de Devoluciones
/// TODO: Implementar cuando el módulo de returns esté completo
class AdminReturnsScreen extends ConsumerWidget {
  const AdminReturnsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final returnsAsync = ref.watch(returnsAdminProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Devoluciones')),
      body: returnsAsync.when(
        data: (returns) {
          if (returns.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_return, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No hay devoluciones registradas'),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: returns.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = returns[index];

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Devolución ${item.returnNumber}',
                              style: AppTextStyles.labelLarge,
                            ),
                          ),
                          _AdminReturnStatusBadge(status: item.status),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pedido #${item.orderId}',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Motivo: ${item.reason}',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Reembolso: ${item.formattedRefund}',
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: 12),

                      Wrap(
                        spacing: 8,
                        children: [
                          _ReturnActionButton(
                            label: 'Recibida',
                            color: AppColors.info,
                            onPressed: () => _updateReturnStatus(
                              context,
                              ref,
                              item,
                              'received',
                            ),
                          ),
                          _ReturnActionButton(
                            label: 'Reembolsada',
                            color: AppColors.success,
                            onPressed: () => _showRefundDialog(
                              context,
                              ref,
                              item,
                            ),
                          ),
                          _ReturnActionButton(
                            label: 'Rechazada',
                            color: AppColors.error,
                            onPressed: () => _showRejectDialog(
                              context,
                              ref,
                              item,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Future<void> _updateReturnStatus(
    BuildContext context,
    WidgetRef ref,
    ReturnRequest item,
    String status, {
    String? adminNotes,
    int? refundAmount,
  }) async {
    try {
      await ref.read(returnAdminActionsProvider).updateReturnStatus(
        returnId: item.id,
        status: status,
        adminNotes: adminNotes,
        refundAmount: refundAmount,
      );

      ref.invalidate(returnsAdminProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Devolución actualizada a "$status"'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error actualizando devolución: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _showRefundDialog(
    BuildContext context,
    WidgetRef ref,
    ReturnRequest item,
  ) async {
    final controller = TextEditingController(
      text: item.refundAmount.toString(),
    );
    final notesController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Procesar reembolso'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Importe en céntimos',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notas admin (opcional)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reembolsar'),
          ),
        ],
      ),
    );

    if (result == true) {
      final refundAmount = int.tryParse(controller.text.trim());
      await _updateReturnStatus(
        context,
        ref,
        item,
        'refunded',
        adminNotes: notesController.text.trim().isEmpty
            ? null
            : notesController.text.trim(),
        refundAmount: refundAmount,
      );
    }
  }

  Future<void> _showRejectDialog(
    BuildContext context,
    WidgetRef ref,
    ReturnRequest item,
  ) async {
    final notesController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rechazar devolución'),
        content: TextField(
          controller: notesController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Motivo del rechazo',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Rechazar'),
          ),
        ],
      ),
    );

    if (result == true) {
      await _updateReturnStatus(
        context,
        ref,
        item,
        'rejected',
        adminNotes: notesController.text.trim().isEmpty
            ? null
            : notesController.text.trim(),
      );
    }
  }
}

class _ReturnActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ReturnActionButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

class _AdminReturnStatusBadge extends StatelessWidget {
  final String status;

  const _AdminReturnStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case 'pending':
        bgColor = AppColors.warning.withValues(alpha: 0.1);
        textColor = AppColors.warning;
        break;
      case 'received':
        bgColor = AppColors.info.withValues(alpha: 0.1);
        textColor = AppColors.info;
        break;
      case 'refunded':
        bgColor = AppColors.success.withValues(alpha: 0.1);
        textColor = AppColors.success;
        break;
      case 'rejected':
      case 'cancelled':
        bgColor = AppColors.error.withValues(alpha: 0.1);
        textColor = AppColors.error;
        break;
      default:
        bgColor = AppColors.backgroundSecondary;
        textColor = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _statusLabel(status),
        style: AppTextStyles.labelSmall.copyWith(color: textColor),
      ),
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'received':
        return 'Recibida';
      case 'refunded':
        return 'Reembolsada';
      case 'rejected':
        return 'Rechazada';
      case 'cancelled':
        return 'Cancelada';
      default:
        return status;
    }
  }
}

/// Pantalla de Gestión de Facturas
class AdminInvoicesScreen extends ConsumerWidget {
  const AdminInvoicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(invoicesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Facturas')),
      body: invoicesAsync.when(
        data: (invoices) => invoices.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No hay facturas generadas'),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: invoices.length,
                itemBuilder: (context, index) {
                  return _InvoiceCard(invoice: invoices[index]);
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  final Invoice invoice;

  const _InvoiceCard({required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.receipt, color: Colors.blue),
        ),
        title: Text(
          invoice.invoiceNumber,
          style: AppTextStyles.labelLarge.copyWith(fontFamily: 'monospace'),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(invoice.customerName),
            Text(invoice.customerEmail, style: AppTextStyles.bodySmall),
            Text(
              DateFormat('dd/MM/yyyy').format(invoice.issueDate),
              style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${invoice.total.toStringAsFixed(2)} €',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (invoice.pdfUrl != null)
              const Icon(Icons.picture_as_pdf, color: Colors.red, size: 16),
          ],
        ),
      ),
    );
  }
}
