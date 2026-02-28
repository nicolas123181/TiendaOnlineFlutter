import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../config/constants/app_constants.dart';
import '../../../../shared/services/supabase_service.dart';
import '../../data/models/invoice_model.dart';

/// Provider para obtener factura por orden.
/// Si no existe, la crea directamente en Supabase.
final invoiceByOrderProvider = FutureProvider.family<Invoice?, int>((
  ref,
  orderId,
) async {
  final supabase = ref.read(supabaseClientProvider);

  debugPrint('🧾 Buscando factura para order_id: $orderId');

  // 1. Intentar obtener la factura existente
  var response = await supabase
      .from('invoices')
      .select('*, invoice_items(*)')
      .eq('order_id', orderId)
      .maybeSingle();

  if (response != null) {
    debugPrint('🧾 Factura encontrada en BD');
    return Invoice.fromJson(response);
  }

  // 2. No existe → obtener datos del pedido para crearla
  debugPrint('🧾 No existe factura, creando directamente en Supabase...');
  try {
    final orderRes = await supabase
        .from('orders')
        .select('*, order_items(*)')
        .eq('id', orderId)
        .maybeSingle();

    if (orderRes == null) {
      debugPrint('🧾 Pedido $orderId no encontrado');
      return null;
    }

    final status = orderRes['status'] as String? ?? '';
    if (status == 'pending' || status == 'cancelled') {
      debugPrint('🧾 No se genera factura para estado: $status');
      return null;
    }

    // Generar número de factura
    String invoiceNumber;
    try {
      final rpcResult = await supabase.rpc('generate_invoice_number');
      invoiceNumber = rpcResult as String;
    } catch (_) {
      final ts = DateTime.now().millisecondsSinceEpoch.toString();
      invoiceNumber =
          'VNT-${DateTime.now().year}-${ts.substring(ts.length - 7)}';
    }

    // Calcular importes
    final items = (orderRes['order_items'] as List?) ?? [];
    final calculatedSubtotal = items.fold<int>(0, (sum, item) {
      final price = (item['product_price'] as num?)?.toInt() ?? 0;
      final qty = (item['quantity'] as num?)?.toInt() ?? 1;
      return sum + price * qty;
    });

    final subtotal =
        (orderRes['subtotal'] as num?)?.toInt() ?? calculatedSubtotal;
    final discount = (orderRes['discount'] as num?)?.toInt() ?? 0;
    final shippingCost = (orderRes['shipping_cost'] as num?)?.toInt() ?? 0;

    const taxRate = 21.0;
    final subtotalConDescuento = subtotal - discount;
    final baseImponible = (subtotalConDescuento / (1 + taxRate / 100)).round();
    final taxAmount = subtotalConDescuento - baseImponible;
    final total = subtotalConDescuento + shippingCost;

    // Insertar factura
    final invoiceInsert = await supabase
        .from('invoices')
        .insert({
          'invoice_number': invoiceNumber,
          'order_id': orderId,
          'customer_name': orderRes['customer_name'] ?? 'Cliente',
          'customer_email': orderRes['customer_email'] ?? '',
          'customer_address': orderRes['customer_address'],
          'customer_city': orderRes['customer_city'],
          'customer_postal_code': orderRes['customer_postal_code'],
          'customer_phone': orderRes['customer_phone'],
          'company_name': 'Vantage Fashion S.L.',
          'company_address': 'Calle de la Moda 123, 28001 Madrid, España',
          'company_nif': 'B-12345678',
          'company_email': 'facturas@vantage.com',
          'company_phone': '+34 900 123 456',
          'subtotal': subtotal,
          'shipping_cost': shippingCost,
          'discount': discount,
          'tax_rate': taxRate,
          'tax_amount': taxAmount,
          'total': total,
          'payment_method': 'Tarjeta de crédito',
          'payment_status': 'paid',
          'status': 'issued',
          'type': 'standard',
        })
        .select()
        .single();

    final invoiceId = (invoiceInsert['id'] as num).toInt();
    debugPrint('🧾 Factura creada con id: $invoiceId');

    // Insertar líneas de factura
    if (items.isNotEmpty) {
      final invoiceItems = items.map((item) {
        final unitPrice = (item['product_price'] as num?)?.toInt() ?? 0;
        final qty = (item['quantity'] as num?)?.toInt() ?? 1;
        return <String, dynamic>{
          'invoice_id': invoiceId,
          'product_id': item['product_id'],
          'product_name': item['product_name'] ?? 'Producto',
          'product_size': item['size'],
          'quantity': qty,
          'unit_price': unitPrice,
          'line_total': unitPrice * qty,
        };
      }).toList();

      await supabase.from('invoice_items').insert(invoiceItems);
    }

    // Re-leer la factura completa con sus items
    response = await supabase
        .from('invoices')
        .select('*, invoice_items(*)')
        .eq('id', invoiceId)
        .single();

    return Invoice.fromJson(response);
  } catch (e) {
    debugPrint('🧾 Error creando factura: $e');
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
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar la factura',
                  style: AppTextStyles.h4,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  err.toString(),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () =>
                      ref.invalidate(invoiceByOrderProvider(orderId)),
                  icon: const Icon(Icons.refresh),
                  label: const Text('REINTENTAR'),
                ),
              ],
            ),
          ),
        ),
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
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Header con logo y gradiente
          _buildInvoiceHeader(invoice),

          // Información de empresa y cliente
          Container(
            color: _InvoiceColors.cream,
            child: _buildPartyInfo(invoice),
          ),

          // Fechas y estado
          _buildDatesSection(invoice),

          // Tabla de productos
          _buildItemsTable(invoice),

          // Totales
          _buildTotals(invoice),
          const SizedBox(height: 32),

          // Footer
          _buildFooter(),
          const SizedBox(height: 24),

          // Botón descargar PDF
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                final url =
                    invoice.pdfUrl ??
                    '${AppConstants.webApiBaseUrl}/api/invoice/${invoice.id}/pdf?download=true';
                _downloadPdf(url);
              },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('DESCARGAR PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _InvoiceColors.navy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceHeader(Invoice invoice) {
    return Container(
      padding: const EdgeInsets.all(36),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_InvoiceColors.navy, _InvoiceColors.navyLight],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'VANTAGE',
                style: AppTextStyles.h2.copyWith(
                  color: _InvoiceColors.gold,
                  letterSpacing: 4,
                  fontWeight: FontWeight.w300,
                  fontSize: 26,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                invoice.type == 'credit_note'
                    ? 'FACTURA RECTIFICATIVA'
                    : 'FACTURA',
                style: AppTextStyles.h2.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                invoice.invoiceNumber,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPartyInfo(Invoice invoice) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cliente (Facturar a)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('FACTURAR A', style: _InvoiceTextStyles.label),
                const SizedBox(height: 16),
                Text(
                  invoice.customerName ?? 'Cliente #${invoice.orderId}',
                  style: _InvoiceTextStyles.bodyBold,
                ),
                if (invoice.customerAddress != null)
                  Text(
                    invoice.customerAddress!,
                    style: _InvoiceTextStyles.body,
                  ),
                if (invoice.customerPostalCode != null ||
                    invoice.customerCity != null)
                  Text(
                    '${invoice.customerPostalCode ?? ''} ${invoice.customerCity ?? ''}'
                        .trim(),
                    style: _InvoiceTextStyles.body,
                  ),
                Text(
                  invoice.customerEmail ?? '',
                  style: _InvoiceTextStyles.body,
                ),
                if (invoice.customerPhone != null)
                  Text(invoice.customerPhone!, style: _InvoiceTextStyles.body),
              ],
            ),
          ),
          const SizedBox(width: 28),
          // Empresa (Datos de la empresa)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('DATOS DE LA EMPRESA', style: _InvoiceTextStyles.label),
                const SizedBox(height: 16),
                const Text(
                  'VANTAGE Fashion S.L.',
                  style: _InvoiceTextStyles.bodyBold,
                ),
                const Text(
                  'Calle Principal 123',
                  style: _InvoiceTextStyles.body,
                ),
                const Text('NIF: B12345678', style: _InvoiceTextStyles.body),
                const Text(
                  'facturas@vantage.com',
                  style: _InvoiceTextStyles.body,
                ),
                const Text('+34 900 123 456', style: _InvoiceTextStyles.body),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatesSection(Invoice invoice) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Wrap(
        spacing: 24,
        runSpacing: 12,
        alignment: WrapAlignment.spaceBetween,
        children: [
          _buildDateItem('Fecha de emisión:', _formatDate(invoice.createdAt)),
          _buildDateItem('Pedido:', '#${invoice.orderId}'),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Estado:',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  invoice.type == 'credit_note' ? 'REEMBOLSADO' : 'PAGADO',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateItem(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: const Color(0xFF6B7280),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: _InvoiceColors.navy,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildItemsTable(Invoice invoice) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          // Header Tabla
          Container(
            color: _InvoiceColors.navy,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'DESCRIPCIÓN',
                    style: _InvoiceTextStyles.tableHeader,
                  ),
                ),
                Expanded(
                  child: Text(
                    'CANTIDAD',
                    style: _InvoiceTextStyles.tableHeader,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'PRECIO UNIT.',
                    style: _InvoiceTextStyles.tableHeader,
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  child: Text(
                    'TOTAL',
                    style: _InvoiceTextStyles.tableHeader,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          // Items
          ...invoice.items.map(
            (item) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName,
                          style: const TextStyle(
                            color: _InvoiceColors.navy,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (item.productSize != null)
                          Text(
                            'Talla: ${item.productSize}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${item.quantity}',
                      style: const TextStyle(color: Color(0xFF4A4A4A)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item.formattedUnitPrice,
                      style: const TextStyle(color: Color(0xFF4A4A4A)),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item.formattedTotal,
                      style: const TextStyle(
                        color: _InvoiceColors.navy,
                        fontWeight: FontWeight.w600,
                      ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          _buildTotalRow(
            'Base imponible',
            '${(invoice.netAmount / 100).toStringAsFixed(2)} €',
          ),
          _buildTotalRow(
            'IVA incluido (${invoice.taxRateValue.toStringAsFixed(0)}%)',
            invoice.formattedTax,
          ),
          const Divider(height: 24, color: Color(0xFFE5E7EB)),
          _buildTotalRow('Subtotal productos', invoice.formattedSubtotal),
          if (invoice.shippingAmount > 0)
            _buildTotalRow('Envío', invoice.formattedShipping),
          if (invoice.discountAmount > 0)
            _buildTotalRow('Descuento', '-${invoice.formattedDiscount}'),
          const SizedBox(height: 12),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: _InvoiceColors.navy, width: 2),
              ),
            ),
            padding: const EdgeInsets.only(top: 20, bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TOTAL',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _InvoiceColors.navy,
                  ),
                ),
                Text(
                  invoice.formattedTotal,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _InvoiceColors.navy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4A4A4A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      color: _InvoiceColors.navy,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            '¡Gracias por confiar en Vantage!',
            style: const TextStyle(
              color: _InvoiceColors.gold,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Esta factura ha sido generada electrónicamente y es válida sin firma.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
              height: 1.8,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'www.vantage.com • facturas@vantage.com',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
              height: 1.8,
            ),
            textAlign: TextAlign.center,
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

class _InvoiceColors {
  static const navy = Color(0xFF1A2744);
  static const navyLight = Color(0xFF2D3F5F);
  static const gold = Color(0xFFB8860B);
  static const cream = Color(0xFFFAF8F5);
}

class _InvoiceTextStyles {
  static const label = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: Color(0xFF6B7280),
    letterSpacing: 1.1,
  );

  static const body = TextStyle(
    fontSize: 14,
    color: _InvoiceColors.navy,
    height: 1.9,
  );

  static const bodyBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: _InvoiceColors.navy,
    height: 1.9,
  );

  static const tableHeader = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.55,
  );
}
