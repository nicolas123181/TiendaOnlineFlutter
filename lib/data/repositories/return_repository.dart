import '../models/return_model.dart';
import '../models/order.dart';
import '../../core/services/supabase_service.dart';
import '../../core/services/pdf_service.dart';

/// Repositorio de devoluciones
class ReturnRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;
  final PdfService _pdfService = PdfService.instance;

  /// Obtiene las devoluciones del usuario actual
  Future<List<Return>> getUserReturns({int limit = 20}) async {
    try {
      return await _supabaseService.getUserReturns(limit: limit);
    } catch (e) {
      return [];
    }
  }

  /// Obtiene una devolución por ID
  Future<Return?> getReturnById(String returnId) async {
    try {
      return await _supabaseService.getReturnById(returnId);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene una devolución por número
  Future<Return?> getReturnByNumber(String returnNumber) async {
    try {
      return await _supabaseService.getReturnByNumber(returnNumber);
    } catch (e) {
      return null;
    }
  }

  /// Crea una solicitud de devolución
  Future<ReturnResult> createReturn({
    required Order order,
    required List<ReturnItem> items,
    required String reason,
    String? comments,
  }) async {
    try {
      // Validar que el pedido permite devoluciones
      if (!order.canRequestReturn) {
        return ReturnResult.error(
          message: 'Este pedido no puede ser devuelto',
        );
      }

      // Calcular el total de la devolución
      final refundAmount = items.fold(
        0,
        (sum, item) => sum + (item.unitPrice * item.quantity),
      );

      final returnRequest = await _supabaseService.createReturn(
        orderId: order.id,
        items: items,
        reason: reason,
        comments: comments,
        refundAmount: refundAmount,
      );

      if (returnRequest != null) {
        return ReturnResult.success(
          returnRequest: returnRequest,
          message: 'Solicitud de devolución creada correctamente',
        );
      } else {
        return ReturnResult.error(message: 'Error al crear la devolución');
      }
    } catch (e) {
      return ReturnResult.error(message: 'Error al crear la devolución: $e');
    }
  }

  /// Cancela una solicitud de devolución
  Future<ReturnResult> cancelReturn(String returnId) async {
    try {
      final returnRequest = await _supabaseService.getReturnById(returnId);

      if (returnRequest == null) {
        return ReturnResult.error(message: 'Devolución no encontrada');
      }

      if (returnRequest.status != ReturnStatus.pending.name) {
        return ReturnResult.error(
          message: 'Solo se pueden cancelar devoluciones pendientes',
        );
      }

      await _supabaseService.updateReturnStatus(
        returnId,
        ReturnStatus.cancelled.name,
      );

      return ReturnResult.success(
        returnRequest: returnRequest.copyWith(
          status: ReturnStatus.cancelled.name,
          updatedAt: DateTime.now(),
        ),
        message: 'Devolución cancelada correctamente',
      );
    } catch (e) {
      return ReturnResult.error(message: 'Error al cancelar la devolución: $e');
    }
  }

  /// Genera etiqueta de devolución
  Future<ReturnResult> generateReturnLabel(String returnId) async {
    try {
      final returnRequest = await _supabaseService.getReturnById(returnId);

      if (returnRequest == null) {
        return ReturnResult.error(message: 'Devolución no encontrada');
      }

      if (returnRequest.status != ReturnStatus.approved.name) {
        return ReturnResult.error(
          message: 'La devolución debe estar aprobada para generar etiqueta',
        );
      }

      // Obtener dirección del cliente
      final order =
          await _supabaseService.getOrderById(returnRequest.orderId.toString());
      if (order == null) {
        return ReturnResult.error(message: 'Pedido no encontrado');
      }

      final pdfBytes = await _pdfService.generateReturnLabelPdf(
        returnNumber: returnRequest.returnNumber,
        customerName: order.customerName,
        customerAddress: order.customerAddress,
        customerCity: order.customerCity,
        customerPostalCode: order.customerPostalCode,
      );

      final fileName = 'etiqueta_${returnRequest.returnNumber}.pdf';
      final filePath = await _pdfService.savePdf(pdfBytes, fileName);

      return ReturnResult.success(
        returnRequest: returnRequest,
        pdfPath: filePath,
        message: 'Etiqueta generada correctamente',
      );
    } catch (e) {
      return ReturnResult.error(message: 'Error al generar etiqueta: $e');
    }
  }

  /// Comparte la etiqueta de devolución
  Future<ReturnResult> shareReturnLabel(String returnId) async {
    try {
      final returnRequest = await _supabaseService.getReturnById(returnId);

      if (returnRequest == null) {
        return ReturnResult.error(message: 'Devolución no encontrada');
      }

      final order =
          await _supabaseService.getOrderById(returnRequest.orderId.toString());
      if (order == null) {
        return ReturnResult.error(message: 'Pedido no encontrado');
      }

      final pdfBytes = await _pdfService.generateReturnLabelPdf(
        returnNumber: returnRequest.returnNumber,
        customerName: order.customerName,
        customerAddress: order.customerAddress,
        customerCity: order.customerCity,
        customerPostalCode: order.customerPostalCode,
      );

      await _pdfService.sharePdf(
          pdfBytes, 'etiqueta_${returnRequest.returnNumber}.pdf');

      return ReturnResult.success(
        returnRequest: returnRequest,
        message: 'Etiqueta compartida',
      );
    } catch (e) {
      return ReturnResult.error(message: 'Error al compartir etiqueta: $e');
    }
  }

  /// Obtiene los motivos de devolución disponibles
  List<String> getReturnReasons() {
    return [
      'Talla incorrecta',
      'No es lo que esperaba',
      'Producto defectuoso',
      'Producto dañado en el envío',
      'Color diferente al mostrado',
      'Pedido duplicado',
      'Cambio de opinión',
      'Otro motivo',
    ];
  }

  // ==================== Admin Methods ====================

  /// Obtiene todas las devoluciones (Admin)
  Future<ReturnsResult> getAllReturns({
    int page = 1,
    int limit = 20,
    String? status,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final result = await _supabaseService.getAllReturns(
        page: page,
        limit: limit,
        status: status,
        searchQuery: searchQuery,
        startDate: startDate,
        endDate: endDate,
      );

      return ReturnsResult.success(
        returns: result['returns'] as List<Return>,
        total: result['total'] as int,
        hasMore: result['hasMore'] as bool,
      );
    } catch (e) {
      return ReturnsResult.error(message: 'Error al cargar devoluciones: $e');
    }
  }

  /// Aprueba una devolución (Admin)
  Future<ReturnResult> approveReturn(
    String returnId, {
    String? adminNotes,
  }) async {
    try {
      await _supabaseService.updateReturnStatus(
        returnId,
        ReturnStatus.approved.name,
        adminNotes: adminNotes,
      );

      final updated = await _supabaseService.getReturnById(returnId);

      return ReturnResult.success(
        returnRequest: updated,
        message: 'Devolución aprobada correctamente',
      );
    } catch (e) {
      return ReturnResult.error(message: 'Error al aprobar la devolución: $e');
    }
  }

  /// Rechaza una devolución (Admin)
  Future<ReturnResult> rejectReturn(
    String returnId, {
    required String reason,
  }) async {
    try {
      await _supabaseService.updateReturnStatus(
        returnId,
        ReturnStatus.rejected.name,
        adminNotes: reason,
      );

      final updated = await _supabaseService.getReturnById(returnId);

      return ReturnResult.success(
        returnRequest: updated,
        message: 'Devolución rechazada',
      );
    } catch (e) {
      return ReturnResult.error(message: 'Error al rechazar la devolución: $e');
    }
  }

  /// Marca devolución como recibida (Admin)
  Future<ReturnResult> markAsReceived(
    String returnId, {
    String? notes,
  }) async {
    try {
      await _supabaseService.updateReturnStatus(
        returnId,
        ReturnStatus.received.name,
        adminNotes: notes,
      );

      final updated = await _supabaseService.getReturnById(returnId);

      return ReturnResult.success(
        returnRequest: updated,
        message: 'Devolución marcada como recibida',
      );
    } catch (e) {
      return ReturnResult.error(
          message: 'Error al actualizar la devolución: $e');
    }
  }

  /// Procesa el reembolso (Admin)
  Future<ReturnResult> processRefund(String returnId) async {
    try {
      final returnRequest = await _supabaseService.getReturnById(returnId);

      if (returnRequest == null) {
        return ReturnResult.error(message: 'Devolución no encontrada');
      }

      if (returnRequest.status != ReturnStatus.received.name) {
        return ReturnResult.error(
          message:
              'La devolución debe estar recibida para procesar el reembolso',
        );
      }

      // TODO: Procesar reembolso con Stripe
      // await _stripeService.refund(returnRequest.orderId, returnRequest.refundAmount);

      await _supabaseService.updateReturnStatus(
        returnId,
        ReturnStatus.refunded.name,
      );

      final updated = await _supabaseService.getReturnById(returnId);

      return ReturnResult.success(
        returnRequest: updated,
        message: 'Reembolso procesado correctamente',
      );
    } catch (e) {
      return ReturnResult.error(message: 'Error al procesar reembolso: $e');
    }
  }

  /// Obtiene estadísticas de devoluciones (Admin)
  Future<ReturnStats> getReturnStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final stats = await _supabaseService.getReturnStats(
        startDate: startDate,
        endDate: endDate,
      );

      return ReturnStats(
        totalReturns: stats['totalReturns'] as int? ?? 0,
        pendingReturns: stats['pendingReturns'] as int? ?? 0,
        approvedReturns: stats['approvedReturns'] as int? ?? 0,
        completedReturns: stats['completedReturns'] as int? ?? 0,
        rejectedReturns: stats['rejectedReturns'] as int? ?? 0,
        totalRefundAmount: stats['totalRefundAmount'] as int? ?? 0,
      );
    } catch (e) {
      return ReturnStats.empty();
    }
  }
}

/// Resultado de operaciones con devoluciones
class ReturnResult {
  final bool isSuccess;
  final Return? returnRequest;
  final String? pdfPath;
  final String? message;

  ReturnResult._({
    required this.isSuccess,
    this.returnRequest,
    this.pdfPath,
    this.message,
  });

  factory ReturnResult.success({
    Return? returnRequest,
    String? pdfPath,
    String? message,
  }) {
    return ReturnResult._(
      isSuccess: true,
      returnRequest: returnRequest,
      pdfPath: pdfPath,
      message: message,
    );
  }

  factory ReturnResult.error({required String message}) {
    return ReturnResult._(
      isSuccess: false,
      message: message,
    );
  }
}

/// Resultado de consulta de devoluciones
class ReturnsResult {
  final bool isSuccess;
  final List<Return> returns;
  final int total;
  final bool hasMore;
  final String? errorMessage;

  ReturnsResult._({
    required this.isSuccess,
    this.returns = const [],
    this.total = 0,
    this.hasMore = false,
    this.errorMessage,
  });

  factory ReturnsResult.success({
    required List<Return> returns,
    required int total,
    required bool hasMore,
  }) {
    return ReturnsResult._(
      isSuccess: true,
      returns: returns,
      total: total,
      hasMore: hasMore,
    );
  }

  factory ReturnsResult.error({required String message}) {
    return ReturnsResult._(
      isSuccess: false,
      errorMessage: message,
    );
  }
}

/// Estadísticas de devoluciones
class ReturnStats {
  final int totalReturns;
  final int pendingReturns;
  final int approvedReturns;
  final int completedReturns;
  final int rejectedReturns;
  final int totalRefundAmount;

  ReturnStats({
    required this.totalReturns,
    required this.pendingReturns,
    required this.approvedReturns,
    required this.completedReturns,
    required this.rejectedReturns,
    required this.totalRefundAmount,
  });

  factory ReturnStats.empty() {
    return ReturnStats(
      totalReturns: 0,
      pendingReturns: 0,
      approvedReturns: 0,
      completedReturns: 0,
      rejectedReturns: 0,
      totalRefundAmount: 0,
    );
  }
}
