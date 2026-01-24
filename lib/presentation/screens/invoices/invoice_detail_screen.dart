import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/app_colors.dart';
import '../../../data/models/invoice.dart';
import '../../providers/invoice_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/price_display.dart';

/// Pantalla de detalle de factura
class InvoiceDetailScreen extends ConsumerWidget {
  final String invoiceId;

  const InvoiceDetailScreen({
    super.key,
    required this.invoiceId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoiceAsync = ref.watch(invoiceByIdProvider(invoiceId));

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Factura',
        showBackButton: true,
      ),
      body: invoiceAsync.when(
        loading: () => const LoadingScreen(),
        error: (_, __) => const Center(child: Text('Factura no encontrada')),
        data: (invoice) => invoice == null
            ? const Center(child: Text('Factura no encontrada'))
            : _InvoiceDetailContent(invoice: invoice),
      ),
      bottomNavigationBar: invoiceAsync.maybeWhen(
        data: (invoice) {
          if (invoice == null) return null;
          return _InvoiceActions(invoice: invoice);
        },
        orElse: () => null,
      ),
    );
  }
}

class _InvoiceDetailContent extends StatelessWidget {
  final Invoice invoice;

  const _InvoiceDetailContent({required this.invoice});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(invoice: invoice),
          const SizedBox(height: 24),
          const _SectionTitle('Cliente'),
          const SizedBox(height: 8),
          _InfoBlock(
            lines: [
              invoice.customerName,
              invoice.customerEmail,
              if (invoice.customerAddress != null) invoice.customerAddress!,
              if (invoice.customerCity != null ||
                  invoice.customerPostalCode != null)
                '${invoice.customerCity ?? ''} ${invoice.customerPostalCode ?? ''}'
                    .trim(),
              if (invoice.customerPhone != null) invoice.customerPhone!,
            ],
          ),
          const SizedBox(height: 16),
          const _SectionTitle('Empresa'),
          const SizedBox(height: 8),
          _InfoBlock(
            lines: [
              invoice.companyName,
              if (invoice.companyNif != null) 'NIF: ${invoice.companyNif}',
              if (invoice.companyAddress != null) invoice.companyAddress!,
              if (invoice.companyEmail != null) invoice.companyEmail!,
              if (invoice.companyPhone != null) invoice.companyPhone!,
            ],
          ),
          const SizedBox(height: 24),
          const _SectionTitle('Items'),
          const SizedBox(height: 8),
          ...invoice.items.map(
            (item) => _InvoiceItemRow(item: item),
          ),
          const SizedBox(height: 24),
          const _SectionTitle('Totales'),
          const SizedBox(height: 8),
          _TotalRow(label: 'Subtotal', value: invoice.subtotal),
          if (invoice.discount > 0)
            _TotalRow(label: 'Descuento', value: -invoice.discount),
          _TotalRow(label: 'Envío', value: invoice.shippingCost),
          _TotalRow(
              label: 'IVA (${invoice.taxRate.toStringAsFixed(0)}%)',
              value: invoice.taxAmount),
          const Divider(height: 24),
          _TotalRow(label: 'Total', value: invoice.total, isBold: true),
        ],
      ),
    );
  }
}

class _InvoiceActions extends ConsumerWidget {
  final Invoice invoice;

  const _InvoiceActions({required this.invoice});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _download(context, ref),
              icon: const Icon(Icons.download_outlined),
              label: const Text('Descargar'),
              style: OutlinedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _share(context, ref),
              icon: const Icon(Icons.share_outlined),
              label: const Text('Compartir'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandNavy,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _download(BuildContext context, WidgetRef ref) async {
    if (kIsWeb) {
      showInfoSnackBar(context, 'La descarga de PDF no está disponible en web');
      return;
    }
    final repository = ref.read(invoiceRepositoryProvider);
    final result = await repository.downloadInvoicePdf(invoice.id.toString());
    if (result.isSuccess) {
      showSuccessSnackBar(context, result.message ?? 'Factura descargada');
    } else {
      showErrorSnackBar(context, result.message ?? 'Error al descargar');
    }
  }

  Future<void> _share(BuildContext context, WidgetRef ref) async {
    final repository = ref.read(invoiceRepositoryProvider);
    final result = await repository.shareInvoicePdf(invoice.id.toString());
    if (result.isSuccess) {
      showSuccessSnackBar(context, result.message ?? 'Factura compartida');
    } else {
      showErrorSnackBar(context, result.message ?? 'Error al compartir');
    }
  }
}

class _Header extends StatelessWidget {
  final Invoice invoice;

  const _Header({required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Factura #${invoice.invoiceNumber}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _formatDate(invoice.issueDate),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          _StatusPill(status: invoice.status),
        ],
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

class _StatusPill extends StatelessWidget {
  final String status;

  const _StatusPill({required this.status});

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

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final List<String> lines;

  const _InfoBlock({required this.lines});

  @override
  Widget build(BuildContext context) {
    final filtered = lines.where((line) => line.trim().isNotEmpty).toList();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: filtered
            .map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  line,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _InvoiceItemRow extends StatelessWidget {
  final InvoiceItem item;

  const _InvoiceItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border.withOpacity(0.5)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  'Cant: ${item.quantity}  •  ${item.productSize ?? 'N/A'}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          PriceDisplayInline(
            priceInCents: item.lineTotal,
            fontSize: 14,
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final int value;
  final bool isBold;

  const _TotalRow({
    required this.label,
    required this.value,
    this.isBold = false,
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
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          PriceDisplayInline(
            priceInCents: value,
            fontSize: isBold ? 16 : 14,
          ),
        ],
      ),
    );
  }
}
