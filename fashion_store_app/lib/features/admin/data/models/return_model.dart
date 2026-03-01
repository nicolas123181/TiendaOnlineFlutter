// Modelo para Devoluciones

import '../../../../shared/utils/text_utils.dart';

class ReturnModel {
  final int id;
  final String returnNumber;
  final int orderId;
  final String customerEmail;
  final String customerName;
  final String reason;
  final String? reasonDetails;
  final List<ReturnItem> items;
  final String status;
  final int? refundAmount;
  final String? trackingNumber;
  final String? adminNotes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? receivedAt;
  final DateTime? refundedAt;
  final String? stripeRefundId;

  ReturnModel({
    required this.id,
    required this.returnNumber,
    required this.orderId,
    required this.customerEmail,
    required this.customerName,
    required this.reason,
    this.reasonDetails,
    required this.items,
    required this.status,
    this.refundAmount,
    this.trackingNumber,
    this.adminNotes,
    required this.createdAt,
    this.updatedAt,
    this.receivedAt,
    this.refundedAt,
    this.stripeRefundId,
  });

  factory ReturnModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'];
    List<ReturnItem> items = [];
    if (itemsJson != null) {
      if (itemsJson is List) {
        items = itemsJson
            .map((e) => ReturnItem.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }

    return ReturnModel(
      id: json['id'] as int,
      returnNumber: json['return_number'] as String? ?? 'RET-???',
      orderId: json['order_id'] as int,
      customerEmail: json['customer_email'] as String? ?? '',
      customerName: TextUtils.fixEncoding(
        json['customer_name'] as String? ?? 'Sin nombre',
      ),
      reason: json['reason'] as String? ?? 'other',
      reasonDetails: json['reason_details'] as String?,
      items: items,
      status: json['status'] as String? ?? 'pending',
      refundAmount: json['refund_amount'] as int?,
      trackingNumber: json['tracking_number'] as String?,
      adminNotes: json['admin_notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      receivedAt: json['received_at'] != null
          ? DateTime.parse(json['received_at'] as String)
          : null,
      refundedAt: json['refunded_at'] != null
          ? DateTime.parse(json['refunded_at'] as String)
          : null,
      stripeRefundId: json['stripe_refund_id'] as String?,
    );
  }

  String get statusLabel {
    switch (status) {
      case 'pending':
        return 'Pendiente de envío';
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

  String get reasonLabel {
    switch (reason) {
      case 'wrong_size':
        return 'Talla incorrecta';
      case 'not_as_expected':
        return 'No es lo que esperaba';
      case 'defective':
        return 'Producto defectuoso';
      case 'changed_mind':
        return 'Cambio de opinión';
      case 'other':
        return 'Otro motivo';
      default:
        return reason;
    }
  }

  double get refundAmountInEuros => (refundAmount ?? 0) / 100.0;
}

class ReturnItem {
  final int productId;
  final String productName;
  final String? size;
  final int quantity;
  final int unitPrice;

  ReturnItem({
    required this.productId,
    required this.productName,
    this.size,
    required this.quantity,
    required this.unitPrice,
  });

  factory ReturnItem.fromJson(Map<String, dynamic> json) {
    return ReturnItem(
      productId: json['product_id'] as int? ?? 0,
      productName: TextUtils.fixEncoding(
        json['product_name'] as String? ?? 'Producto',
      ),
      size: json['size'] as String?,
      quantity: json['quantity'] as int? ?? 1,
      unitPrice: json['unit_price'] as int? ?? 0,
    );
  }
}
