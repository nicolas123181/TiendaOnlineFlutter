import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

import '../../data/models/invoice.dart';
import '../../config/app_constants.dart';

/// Servicio de generación de PDFs
class PdfService {
  PdfService._();

  static final PdfService _instance = PdfService._();
  static PdfService get instance => _instance;

  /// Formateador de precios
  String _formatPrice(int cents) {
    return '€${(cents / 100).toStringAsFixed(2)}';
  }

  /// Formateador de fechas
  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Genera un PDF de factura
  Future<Uint8List> generateInvoicePdf(Invoice invoice) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header con logo y datos de empresa
              _buildInvoiceHeader(invoice),
              pw.SizedBox(height: 30),

              // Datos del cliente
              _buildCustomerInfo(invoice),
              pw.SizedBox(height: 30),

              // Tabla de productos
              _buildItemsTable(invoice),
              pw.SizedBox(height: 20),

              // Totales
              _buildTotals(invoice),
              pw.SizedBox(height: 30),

              // Notas y condiciones
              _buildFooter(invoice),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildInvoiceHeader(Invoice invoice) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Logo y datos de empresa
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'VANTAGE',
              style: pw.TextStyle(
                fontSize: 28,
                fontWeight: pw.FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              invoice.companyName,
              style: const pw.TextStyle(fontSize: 10),
            ),
            if (invoice.companyAddress != null)
              pw.Text(
                invoice.companyAddress!,
                style: const pw.TextStyle(fontSize: 10),
              ),
            if (invoice.companyNif != null)
              pw.Text(
                'NIF: ${invoice.companyNif}',
                style: const pw.TextStyle(fontSize: 10),
              ),
            if (invoice.companyEmail != null)
              pw.Text(
                invoice.companyEmail!,
                style: const pw.TextStyle(fontSize: 10),
              ),
            if (invoice.companyPhone != null)
              pw.Text(
                invoice.companyPhone!,
                style: const pw.TextStyle(fontSize: 10),
              ),
          ],
        ),

        // Información de la factura
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Container(
              padding:
                  const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: PdfColors.grey800,
              child: pw.Text(
                'FACTURA',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            pw.SizedBox(height: 12),
            pw.Text(
              'Nº: ${invoice.invoiceNumber}',
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'Fecha: ${_formatDate(invoice.issueDate)}',
              style: const pw.TextStyle(fontSize: 10),
            ),
            if (invoice.dueDate != null)
              pw.Text(
                'Vencimiento: ${_formatDate(invoice.dueDate!)}',
                style: const pw.TextStyle(fontSize: 10),
              ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildCustomerInfo(Invoice invoice) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'DATOS DEL CLIENTE',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey600,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  invoice.customerName,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  invoice.customerEmail,
                  style: const pw.TextStyle(fontSize: 10),
                ),
                if (invoice.customerAddress != null)
                  pw.Text(
                    invoice.customerAddress!,
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                if (invoice.customerCity != null &&
                    invoice.customerPostalCode != null)
                  pw.Text(
                    '${invoice.customerPostalCode} ${invoice.customerCity}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                if (invoice.customerPhone != null)
                  pw.Text(
                    'Tel: ${invoice.customerPhone}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
              ],
            ),
          ),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'DATOS DEL PEDIDO',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey600,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Pedido #${invoice.orderId}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.Text(
                  'Método de pago: ${invoice.paymentMethod}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.Text(
                  'Estado: ${invoice.paymentStatus == 'paid' ? 'Pagado' : invoice.paymentStatus}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildItemsTable(Invoice invoice) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      columnWidths: {
        0: const pw.FlexColumnWidth(4),
        1: const pw.FlexColumnWidth(1.5),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(1.5),
        4: const pw.FlexColumnWidth(1.5),
      },
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey800),
          children: [
            _tableHeader('PRODUCTO'),
            _tableHeader('TALLA'),
            _tableHeader('CANT.'),
            _tableHeader('P. UNIT.'),
            _tableHeader('TOTAL'),
          ],
        ),
        // Items
        ...invoice.items.map((item) => pw.TableRow(
              children: [
                _tableCell(item.productName),
                _tableCell(item.productSize ?? '-'),
                _tableCell(item.quantity.toString(), center: true),
                _tableCell(_formatPrice(item.unitPrice), right: true),
                _tableCell(_formatPrice(item.lineTotal), right: true),
              ],
            )),
      ],
    );
  }

  pw.Widget _tableHeader(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _tableCell(String text, {bool center = false, bool right = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 9),
        textAlign: right
            ? pw.TextAlign.right
            : center
                ? pw.TextAlign.center
                : pw.TextAlign.left,
      ),
    );
  }

  pw.Widget _buildTotals(Invoice invoice) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Container(
          width: 200,
          child: pw.Column(
            children: [
              _totalRow('Subtotal', invoice.subtotal),
              if (invoice.discount > 0)
                _totalRow('Descuento', -invoice.discount),
              if (invoice.shippingCost > 0)
                _totalRow('Envío', invoice.shippingCost),
              _totalRow('IVA (${invoice.taxRate.toStringAsFixed(0)}%)',
                  invoice.taxAmount),
              pw.Divider(color: PdfColors.grey300),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'TOTAL',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    _formatPrice(invoice.total),
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _totalRow(String label, int amount) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.Text(
            _formatPrice(amount),
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(Invoice invoice) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
          pw.Text(
            'Notas:',
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            invoice.notes!,
            style: const pw.TextStyle(fontSize: 9),
          ),
          pw.SizedBox(height: 16),
        ],
        pw.Divider(color: PdfColors.grey300),
        pw.SizedBox(height: 8),
        pw.Text(
          'Gracias por su compra en VANTAGE',
          style: pw.TextStyle(
            fontSize: 10,
            fontStyle: pw.FontStyle.italic,
            color: PdfColors.grey600,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Para cualquier consulta: ${AppConstants.companyEmail}',
          style: const pw.TextStyle(
            fontSize: 8,
            color: PdfColors.grey500,
          ),
        ),
      ],
    );
  }

  /// Genera un PDF de etiqueta de devolución
  Future<Uint8List> generateReturnLabelPdf({
    required String returnNumber,
    required String customerName,
    required String customerAddress,
    required String customerCity,
    required String customerPostalCode,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        margin: const pw.EdgeInsets.all(30),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Header
              pw.Text(
                'ETIQUETA DE DEVOLUCIÓN',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),

              // Número de devolución
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 2),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      returnNumber,
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.BarcodeWidget(
                      barcode: pw.Barcode.code128(),
                      data: returnNumber,
                      width: 200,
                      height: 60,
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 30),

              // Dirección de destino
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'DESTINATARIO:',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      AppConstants.companyName,
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      AppConstants.companyAddress,
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Remitente
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'REMITENTE:',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      customerName,
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.Text(
                      customerAddress,
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                    pw.Text(
                      '$customerPostalCode $customerCity',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
              pw.Spacer(),

              // Instrucciones
              pw.Text(
                'Pegue esta etiqueta en el exterior del paquete',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Guarda un PDF en el dispositivo
  Future<String> savePdf(Uint8List bytes, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  /// Imprime un PDF
  Future<void> printPdf(Uint8List bytes) async {
    await Printing.layoutPdf(onLayout: (_) => bytes);
  }

  /// Comparte un PDF
  Future<void> sharePdf(Uint8List bytes, String fileName) async {
    await Printing.sharePdf(bytes: bytes, filename: fileName);
  }
}
