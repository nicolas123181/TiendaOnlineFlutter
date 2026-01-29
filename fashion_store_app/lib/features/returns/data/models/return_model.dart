/// Modelo de Devolución
class ReturnRequest {
  final int id;
  final int orderId;
  final String returnNumber;
  final DateTime createdAt;
  final String
  status; // 'pending', 'approved', 'rejected', 'completed', 'cancelled'
  final String reason;
  final String? customerNotes;
  final int refundAmount;
  final String? returnLabelUrl;
  final String? trackingNumber;
  final List<ReturnItem> items;

  const ReturnRequest({
    required this.id,
    required this.orderId,
    required this.returnNumber,
    required this.createdAt,
    required this.status,
    required this.reason,
    this.customerNotes,
    required this.refundAmount,
    this.returnLabelUrl,
    this.trackingNumber,
    this.items = const [],
  });

  factory ReturnRequest.fromJson(Map<String, dynamic> json) {
    final itemsFromReturnItems =
      (json['return_items'] as List<dynamic>?)
        ?.map((e) => ReturnItem.fromJson(e as Map<String, dynamic>))
        .toList();

    final itemsFromArray =
      (json['items'] as List<dynamic>?)
        ?.map((e) => ReturnItem.fromJson(e as Map<String, dynamic>))
        .toList();

    return ReturnRequest(
      id: json['id'] as int,
      orderId: json['order_id'] as int,
      returnNumber: json['return_number'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      status: json['status'] as String,
      reason: json['reason'] as String,
      customerNotes:
        (json['customer_notes'] ?? json['reason_details']) as String?,
      refundAmount: (json['refund_amount'] as int?) ?? 0,
      returnLabelUrl: json['return_label_url'] as String?,
      trackingNumber: json['tracking_number'] as String?,
      items: itemsFromReturnItems ?? itemsFromArray ?? [],
    );
  }

  String get formattedRefund => '${(refundAmount / 100).toStringAsFixed(2)} €';

  String get statusLabel {
    switch (status) {
      case 'pending':
        return 'Pendiente de revisión';
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

  bool get canCancel => status == 'pending';
  bool get hasLabel => returnLabelUrl != null;
}

/// Item de devolución
class ReturnItem {
  final int id;
  final int returnId;
  final int orderItemId;
  final String productName;
  final String? size;
  final int quantity;
  final int refundPrice;

  const ReturnItem({
    required this.id,
    required this.returnId,
    required this.orderItemId,
    required this.productName,
    this.size,
    required this.quantity,
    required this.refundPrice,
  });

  factory ReturnItem.fromJson(Map<String, dynamic> json) {
    final refundPrice =
        (json['refund_price'] as int?) ?? (json['price'] as int?) ?? 0;

    return ReturnItem(
      id: (json['id'] as int?) ?? 0,
      returnId: (json['return_id'] as int?) ?? 0,
      orderItemId: (json['order_item_id'] as int?) ?? 0,
      productName: (json['product_name'] as String?) ?? 'Producto',
      size: json['size'] as String?,
      quantity: (json['quantity'] as int?) ?? 0,
      refundPrice: refundPrice,
    );
  }

  String get formattedRefund => '${(refundPrice / 100).toStringAsFixed(2)} €';
}

/// Razones de devolución disponibles
class ReturnReasons {
  static const List<String> all = [
    'No me queda bien la talla',
    'El producto no es como esperaba',
    'Producto defectuoso',
    'Pedido incorrecto',
    'Cambio de opinión',
    'Otro motivo',
  ];
}
