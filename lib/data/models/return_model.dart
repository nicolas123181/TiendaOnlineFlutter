import 'package:freezed_annotation/freezed_annotation.dart';

part 'return_model.freezed.dart';

/// Estados posibles de una devolución
enum ReturnStatus {
  pending,
  approved,
  in_transit,
  received,
  refunded,
  rejected,
  cancelled;

  /// Obtiene el texto en español del estado
  String get displayName {
    switch (this) {
      case ReturnStatus.pending:
        return 'Pendiente';
      case ReturnStatus.approved:
        return 'Aprobado';
      case ReturnStatus.in_transit:
        return 'En tránsito';
      case ReturnStatus.received:
        return 'Recibido';
      case ReturnStatus.refunded:
        return 'Reembolsado';
      case ReturnStatus.rejected:
        return 'Rechazado';
      case ReturnStatus.cancelled:
        return 'Cancelado';
    }
  }

  /// Crea desde string de la base de datos
  static ReturnStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return ReturnStatus.pending;
      case 'approved':
        return ReturnStatus.approved;
      case 'in_transit':
        return ReturnStatus.in_transit;
      case 'received':
        return ReturnStatus.received;
      case 'refunded':
        return ReturnStatus.refunded;
      case 'rejected':
        return ReturnStatus.rejected;
      case 'cancelled':
        return ReturnStatus.cancelled;
      default:
        return ReturnStatus.pending;
    }
  }
}

/// Item de devolución
@Freezed(toJson: false, fromJson: false)
class ReturnItem with _$ReturnItem {
  const ReturnItem._(); // Constructor privado para permitir métodos

  const factory ReturnItem({
    required int productId,
    required String productName,
    String? size,
    required int quantity,
    required int price,
  }) = _ReturnItem;

  factory ReturnItem.fromJson(Map<String, dynamic> json) {
    return ReturnItem(
      productId: json['product_id'] as int,
      productName: json['product_name'] as String,
      size: json['size'] as String?,
      quantity: json['quantity'] as int,
      price: json['price'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'size': size,
      'quantity': quantity,
      'price': price,
    };
  }

  /// Total del item
  int get totalPrice => price * quantity;

  /// Alias de price (para compatibilidad)
  int get unitPrice => price;
}

/// Modelo de Devolución
@Freezed(toJson: false, fromJson: false)
class Return with _$Return {
  const Return._(); // Constructor privado para permitir métodos

  const factory Return({
    required int id,
    required String returnNumber,
    required int orderId,
    required String customerEmail,
    required String customerName,
    required String reason,
    String? reasonDetails,
    @Default([]) List<ReturnItem> items,
    @Default('pending') String status,
    int? refundAmount, // En centavos
    String? trackingNumber,
    String? adminNotes,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? receivedAt,
    DateTime? refundedAt,
    String? stripeRefundId,
  }) = _Return;

  /// Factory personalizado para manejar items como JSON anidado
  factory Return.fromJson(Map<String, dynamic> json) {
    // Parsear items
    List<ReturnItem> itemsList = [];
    if (json['items'] != null && json['items'] is List) {
      itemsList = (json['items'] as List)
          .map((e) => ReturnItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return Return(
      id: json['id'] as int,
      returnNumber: json['return_number'] as String,
      orderId: json['order_id'] as int,
      customerEmail: json['customer_email'] as String,
      customerName: json['customer_name'] as String,
      reason: json['reason'] as String,
      reasonDetails: json['reason_details'] as String?,
      items: itemsList,
      status: json['status'] as String? ?? 'pending',
      refundAmount: json['refund_amount'] as int?,
      trackingNumber: json['tracking_number'] as String?,
      adminNotes: json['admin_notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      receivedAt: json['received_at'] != null
          ? DateTime.parse(json['received_at'] as String)
          : null,
      refundedAt: json['refunded_at'] != null
          ? DateTime.parse(json['refunded_at'] as String)
          : null,
      stripeRefundId: json['stripe_refund_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'return_number': returnNumber,
      'order_id': orderId,
      'customer_email': customerEmail,
      'customer_name': customerName,
      'reason': reason,
      'reason_details': reasonDetails,
      'items': items.map((e) => e.toJson()).toList(),
      'status': status,
      'refund_amount': refundAmount,
      'tracking_number': trackingNumber,
      'admin_notes': adminNotes,
    };
  }

  /// Texto del estado en español
  String get statusText {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'in_transit':
        return 'En tránsito';
      case 'received':
        return 'Recibido';
      case 'refunded':
        return 'Reembolsado';
      case 'rejected':
        return 'Rechazado';
      default:
        return status;
    }
  }

  /// Texto del motivo en español
  String get reasonText {
    switch (reason) {
      case 'wrong_size':
        return 'Talla incorrecta';
      case 'not_as_expected':
        return 'No es como esperaba';
      case 'defective':
        return 'Producto defectuoso';
      case 'wrong_item':
        return 'Producto incorrecto';
      case 'changed_mind':
        return 'He cambiado de opinión';
      case 'arrived_late':
        return 'Llegó tarde';
      case 'other':
        return 'Otro motivo';
      default:
        return reason;
    }
  }

  /// Total de los items a devolver
  int get totalItemsPrice =>
      items.fold(0, (sum, item) => sum + item.totalPrice);

  /// Cantidad total de items
  int get totalItemsCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Verifica si está pendiente
  bool get isPending => status == 'pending';

  /// Verifica si está en proceso
  bool get isInProgress =>
      status == 'pending' || status == 'in_transit' || status == 'received';

  /// Verifica si fue completado (reembolsado o rechazado)
  bool get isCompleted => status == 'refunded' || status == 'rejected';

  /// Verifica si fue reembolsado
  bool get isRefunded => status == 'refunded';

  /// Verifica si fue rechazado
  bool get isRejected => status == 'rejected';

  /// Verifica si tiene tracking
  bool get hasTracking => trackingNumber != null && trackingNumber!.isNotEmpty;
}
