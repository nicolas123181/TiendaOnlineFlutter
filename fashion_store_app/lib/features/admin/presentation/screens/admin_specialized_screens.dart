// Pantallas para Tallas, Devoluciones y Facturas del Admin

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
// import '../../../returns/data/models/return_model.dart';
// import '../../../returns/presentation/providers/returns_provider.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Devoluciones')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_return, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Módulo en desarrollo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'La gestión de devoluciones estará disponible próximamente',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
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
              DateFormat('dd/MM/yyyy').format(invoice.issuedAt),
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
