import '../models/invoice.dart';
import '../models/order.dart';
import '../../core/services/supabase_service.dart';
import '../../core/services/pdf_service.dart';

/// Repositorio de facturas
class InvoiceRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;
  final PdfService _pdfService = PdfService.instance;

  /// Obtiene las facturas del usuario actual
  Future<List<Invoice>> getUserInvoices({int limit = 20}) async {
    try {
      return await _supabaseService.getUserInvoices(limit: limit);
    } catch (e) {
      return [];
    }
  }

  /// Obtiene una factura por ID
  Future<Invoice?> getInvoiceById(String invoiceId) async {
    try {
      return await _supabaseService.getInvoiceById(invoiceId);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene una factura por número de factura
  Future<Invoice?> getInvoiceByNumber(String invoiceNumber) async {
    try {
      return await _supabaseService.getInvoiceByNumber(invoiceNumber);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene la factura de un pedido
  Future<Invoice?> getInvoiceByOrderId(String orderId) async {
    try {
      return await _supabaseService.getInvoiceByOrderId(orderId);
    } catch (e) {
      return null;
    }
  }

  /// Genera y descarga el PDF de una factura
  Future<InvoiceResult> downloadInvoicePdf(String invoiceId) async {
    try {
      final invoice = await _supabaseService.getInvoiceById(invoiceId);

      if (invoice == null) {
        return InvoiceResult.error(message: 'Factura no encontrada');
      }

      final pdfBytes = await _pdfService.generateInvoicePdf(invoice);
      final fileName = 'factura_${invoice.invoiceNumber}.pdf';
      final filePath = await _pdfService.savePdf(pdfBytes, fileName);

      return InvoiceResult.success(
        invoice: invoice,
        pdfPath: filePath,
        message: 'Factura descargada correctamente',
      );
    } catch (e) {
      return InvoiceResult.error(message: 'Error al descargar la factura: $e');
    }
  }

  /// Comparte el PDF de una factura
  Future<InvoiceResult> shareInvoicePdf(String invoiceId) async {
    try {
      final invoice = await _supabaseService.getInvoiceById(invoiceId);

      if (invoice == null) {
        return InvoiceResult.error(message: 'Factura no encontrada');
      }

      final pdfBytes = await _pdfService.generateInvoicePdf(invoice);
      await _pdfService.sharePdf(
          pdfBytes, 'factura_${invoice.invoiceNumber}.pdf');

      return InvoiceResult.success(
        invoice: invoice,
        message: 'Factura compartida',
      );
    } catch (e) {
      return InvoiceResult.error(message: 'Error al compartir la factura: $e');
    }
  }

  /// Imprime una factura
  Future<InvoiceResult> printInvoice(String invoiceId) async {
    try {
      final invoice = await _supabaseService.getInvoiceById(invoiceId);

      if (invoice == null) {
        return InvoiceResult.error(message: 'Factura no encontrada');
      }

      final pdfBytes = await _pdfService.generateInvoicePdf(invoice);
      await _pdfService.printPdf(pdfBytes);

      return InvoiceResult.success(
        invoice: invoice,
        message: 'Enviando a impresión',
      );
    } catch (e) {
      return InvoiceResult.error(message: 'Error al imprimir la factura: $e');
    }
  }

  // ==================== Admin Methods ====================

  /// Obtiene todas las facturas (Admin)
  Future<InvoicesResult> getAllInvoices({
    int page = 1,
    int limit = 20,
    String? status,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final result = await _supabaseService.getAllInvoices(
        page: page,
        limit: limit,
        status: status,
        searchQuery: searchQuery,
        startDate: startDate,
        endDate: endDate,
      );

      return InvoicesResult.success(
        invoices: result['invoices'] as List<Invoice>,
        total: result['total'] as int,
        hasMore: result['hasMore'] as bool,
      );
    } catch (e) {
      return InvoicesResult.error(message: 'Error al cargar facturas: $e');
    }
  }

  /// Crea una factura para un pedido (Admin)
  Future<InvoiceResult> createInvoice(Order order) async {
    try {
      // Verificar si ya existe una factura para este pedido
      final existing =
          await _supabaseService.getInvoiceByOrderId(order.id.toString());
      if (existing != null) {
        return InvoiceResult.error(
          message: 'Ya existe una factura para este pedido',
        );
      }

      final invoice = await _supabaseService.createInvoiceFromOrder(order);

      if (invoice != null) {
        return InvoiceResult.success(
          invoice: invoice,
          message: 'Factura creada correctamente',
        );
      } else {
        return InvoiceResult.error(message: 'Error al crear la factura');
      }
    } catch (e) {
      return InvoiceResult.error(message: 'Error al crear la factura: $e');
    }
  }

  /// Actualiza el estado de una factura (Admin)
  Future<InvoiceResult> updateInvoiceStatus(
    String invoiceId,
    String status,
  ) async {
    try {
      await _supabaseService.updateInvoiceStatus(invoiceId, status);

      final updated = await _supabaseService.getInvoiceById(invoiceId);

      return InvoiceResult.success(
        invoice: updated,
        message: 'Estado actualizado correctamente',
      );
    } catch (e) {
      return InvoiceResult.error(message: 'Error al actualizar estado: $e');
    }
  }

  /// Obtiene estadísticas de facturación (Admin)
  Future<InvoiceStats> getInvoiceStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final stats = await _supabaseService.getInvoiceStats(
        startDate: startDate,
        endDate: endDate,
      );

      return InvoiceStats(
        totalInvoices: stats['totalInvoices'] as int? ?? 0,
        paidInvoices: stats['paidInvoices'] as int? ?? 0,
        pendingInvoices: stats['pendingInvoices'] as int? ?? 0,
        totalRevenue: stats['totalRevenue'] as int? ?? 0,
        averageInvoiceValue: stats['averageInvoiceValue'] as int? ?? 0,
      );
    } catch (e) {
      return InvoiceStats.empty();
    }
  }

  /// Genera el siguiente número de factura (Admin)
  Future<String> getNextInvoiceNumber() async {
    try {
      return await _supabaseService.getNextInvoiceNumber();
    } catch (e) {
      // Formato: YYYY-NNNN
      final year = DateTime.now().year;
      return '$year-0001';
    }
  }
}

/// Resultado de operaciones con facturas
class InvoiceResult {
  final bool isSuccess;
  final Invoice? invoice;
  final String? pdfPath;
  final String? message;

  InvoiceResult._({
    required this.isSuccess,
    this.invoice,
    this.pdfPath,
    this.message,
  });

  factory InvoiceResult.success({
    Invoice? invoice,
    String? pdfPath,
    String? message,
  }) {
    return InvoiceResult._(
      isSuccess: true,
      invoice: invoice,
      pdfPath: pdfPath,
      message: message,
    );
  }

  factory InvoiceResult.error({required String message}) {
    return InvoiceResult._(
      isSuccess: false,
      message: message,
    );
  }
}

/// Resultado de consulta de facturas
class InvoicesResult {
  final bool isSuccess;
  final List<Invoice> invoices;
  final int total;
  final bool hasMore;
  final String? errorMessage;

  InvoicesResult._({
    required this.isSuccess,
    this.invoices = const [],
    this.total = 0,
    this.hasMore = false,
    this.errorMessage,
  });

  factory InvoicesResult.success({
    required List<Invoice> invoices,
    required int total,
    required bool hasMore,
  }) {
    return InvoicesResult._(
      isSuccess: true,
      invoices: invoices,
      total: total,
      hasMore: hasMore,
    );
  }

  factory InvoicesResult.error({required String message}) {
    return InvoicesResult._(
      isSuccess: false,
      errorMessage: message,
    );
  }
}

/// Estadísticas de facturación
class InvoiceStats {
  final int totalInvoices;
  final int paidInvoices;
  final int pendingInvoices;
  final int totalRevenue;
  final int averageInvoiceValue;

  InvoiceStats({
    required this.totalInvoices,
    required this.paidInvoices,
    required this.pendingInvoices,
    required this.totalRevenue,
    required this.averageInvoiceValue,
  });

  factory InvoiceStats.empty() {
    return InvoiceStats(
      totalInvoices: 0,
      paidInvoices: 0,
      pendingInvoices: 0,
      totalRevenue: 0,
      averageInvoiceValue: 0,
    );
  }
}
