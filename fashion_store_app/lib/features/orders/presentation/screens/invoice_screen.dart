import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../config/constants/app_constants.dart';
import '../../../../shared/services/supabase_service.dart';
import '../../data/models/invoice_model.dart';

/// Provider para obtener factura por orden
final invoiceByOrderProvider = FutureProvider.family<Invoice?, int>((
  ref,
  orderId,
) async {
  final supabase = ref.read(supabaseClientProvider);

  try {
    final response = await supabase
        .from('invoices')
        .select('*, invoice_items(*)')
        .eq('order_id', orderId)
        .maybeSingle();

    if (response == null) return null;
    return Invoice.fromJson(response);
  } catch (e) {
    return null;
  }
});

/// Pantalla de visualización de factura
class InvoiceScreen extends ConsumerWidget {
  final int orderId;

  const InvoiceScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoiceAsync = ref.watch(invoiceByOrderProvider(orderId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Factura'),
        actions: [
          invoiceAsync.maybeWhen(
            data: (invoice) => invoice != null
                ? IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () {
                      final url =
                          invoice.pdfUrl ??
                          '${AppConstants.webApiBaseUrl}/api/invoice/${invoice.id}/pdf?download=true';
                      _downloadPdf(url);
                    },
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: invoiceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text('Error: $err', style: AppTextStyles.bodyMedium)),
        data: (invoice) => invoice == null
            ? _buildNoInvoice()
            : _buildInvoiceContent(context, invoice),
      ),
    );
  }

  Widget _buildNoInvoice() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text('Factura no disponible', style: AppTextStyles.h4),
          const SizedBox(height: 8),
          Text(
            'La factura se generará cuando se confirme el pago.',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceContent(BuildContext context, Invoice invoice) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header con logo
          _buildInvoiceHeader(invoice),
          const SizedBox(height: 24),

          // Datos de empresa y cliente
          _buildPartyInfo(invoice),
          const SizedBox(height: 24),

          // Tabla de productos
          _buildItemsTable(invoice),
          const SizedBox(height: 24),

          // Totales
          _buildTotals(invoice),
          const SizedBox(height: 32),

          // Botón descargar PDF (usa pdfUrl si existe, si no, abre endpoint web para imprimir/guardar)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                final url =
                    invoice.pdfUrl ??
                    '${AppConstants.webApiBaseUrl}/api/invoice/${invoice.id}/pdf?download=true';
                _downloadPdf(url);
              },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Descargar PDF'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceHeader(Invoice invoice) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Logo VANTAGE
          Text(
            'VANTAGE',
            style: AppTextStyles.h2.copyWith(
              letterSpacing: 4,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Moda Masculina Premium',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 2,
            ),
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('FACTURA', style: AppTextStyles.labelLarge),
                  Text(
                    invoice.invoiceNumber,
                    style: AppTextStyles.h5.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Fecha', style: AppTextStyles.labelSmall),
                  Text(
                    _formatDate(invoice.createdAt),
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPartyInfo(Invoice invoice) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Datos de empresa
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('EMISOR', style: AppTextStyles.labelSmall),
                const SizedBox(height: 8),
                Text('VANTAGE Fashion S.L.', style: AppTextStyles.labelLarge),
                Text('CIF: B12345678', style: AppTextStyles.bodySmall),
                Text('Calle Principal 123', style: AppTextStyles.bodySmall),
                Text('28001 Madrid', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Cliente
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CLIENTE', style: AppTextStyles.labelSmall),
                const SizedBox(height: 8),
                Text(
                  'Cliente #${invoice.orderId}',
                  style: AppTextStyles.labelLarge,
                ),
                // TODO: Mostrar datos reales del cliente desde la orden
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemsTable(Invoice invoice) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(11),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text('Producto', style: AppTextStyles.labelMedium),
                ),
                Expanded(
                  child: Text(
                    'Cant.',
                    style: AppTextStyles.labelMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Precio',
                    style: AppTextStyles.labelMedium,
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Total',
                    style: AppTextStyles.labelMedium,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          // Items
          ...invoice.items.map(
            (item) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.border.withValues(alpha: 0.5),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      item.productName,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${item.quantity}',
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item.formattedUnitPrice,
                      style: AppTextStyles.bodySmall,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item.formattedTotal,
                      style: AppTextStyles.labelLarge,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotals(Invoice invoice) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildTotalRow('Subtotal', invoice.formattedSubtotal),
          if (invoice.discountAmount > 0)
            _buildTotalRow(
              'Descuento',
              '-${invoice.formattedDiscount}',
              isDiscount: true,
            ),
          _buildTotalRow('Envío', invoice.formattedShipping),
          const Divider(height: 16),
          _buildTotalRow(
            'Base imponible',
            '${(invoice.netAmount / 100).toStringAsFixed(2)} €',
          ),
          _buildTotalRow('IVA (21%)', invoice.formattedTax),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('TOTAL', style: AppTextStyles.h5),
              Text(
                invoice.formattedTotal,
                style: AppTextStyles.h4.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDiscount ? AppColors.success : null,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _downloadPdf(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
