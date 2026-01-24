import 'package:freezed_annotation/freezed_annotation.dart';

part 'invoice.freezed.dart';

/// Item de factura
@Freezed(toJson: false, fromJson: false)
class InvoiceItem with _$InvoiceItem {
  const InvoiceItem._(); // Constructor privado para permitir métodos

  const factory InvoiceItem({
    required int id,
    required int invoiceId,
    int? productId,
    required String productName,
    String? productSku,
    String? productSize,
    required int quantity,
    required int unitPrice, // En centavos
    @Default(0.0) double discountPercent,
    required int lineTotal, // En centavos
    required DateTime createdAt,
  }) = _InvoiceItem;

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      id: json['id'] as int,
      invoiceId: json['invoice_id'] as int,
      productId: json['product_id'] as int?,
      productName: json['product_name'] as String,
      productSku: json['product_sku'] as String?,
      productSize: json['product_size'] as String?,
      quantity: json['quantity'] as int,
      unitPrice: json['unit_price'] as int,
      discountPercent: (json['discount_percent'] as num?)?.toDouble() ?? 0,
      lineTotal: json['line_total'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoice_id': invoiceId,
      'product_id': productId,
      'product_name': productName,
      'product_sku': productSku,
      'product_size': productSize,
      'quantity': quantity,
      'unit_price': unitPrice,
      'discount_percent': discountPercent,
      'line_total': lineTotal,
    };
  }
}

/// Modelo de Factura
@Freezed(toJson: false, fromJson: false)
class Invoice with _$Invoice {
  const Invoice._(); // Constructor privado para permitir métodos

  const factory Invoice({
    required int id,
    required String invoiceNumber,
    required int orderId,
    // Datos del cliente
    required String customerName,
    required String customerEmail,
    String? customerAddress,
    String? customerCity,
    String? customerPostalCode,
    String? customerPhone,
    // Datos de la empresa
    @Default('Vantage Fashion S.L.') String companyName,
    String? companyAddress,
    String? companyNif,
    String? companyEmail,
    String? companyPhone,
    // Importes
    required int subtotal, // En centavos
    @Default(0) int shippingCost, // En centavos
    @Default(0) int discount, // En centavos
    @Default(21.0) double taxRate,
    required int taxAmount, // En centavos
    required int total, // En centavos
    // Pago
    @Default('Tarjeta de crédito') String paymentMethod,
    @Default('paid') String paymentStatus,
    // Fechas
    required DateTime issueDate,
    DateTime? dueDate,
    // Estado y PDF
    @Default('issued') String status,
    String? pdfUrl,
    DateTime? pdfGeneratedAt,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<InvoiceItem> items,
  }) = _Invoice;

  factory Invoice.fromJson(Map<String, dynamic> json) {
    // Parsear items si vienen incluidos
    List<InvoiceItem> itemsList = [];
    if (json['invoice_items'] != null && json['invoice_items'] is List) {
      itemsList = (json['invoice_items'] as List)
          .map((e) => InvoiceItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return Invoice(
      id: json['id'] as int,
      invoiceNumber: json['invoice_number'] as String,
      orderId: json['order_id'] as int,
      customerName: json['customer_name'] as String,
      customerEmail: json['customer_email'] as String,
      customerAddress: json['customer_address'] as String?,
      customerCity: json['customer_city'] as String?,
      customerPostalCode: json['customer_postal_code'] as String?,
      customerPhone: json['customer_phone'] as String?,
      companyName: json['company_name'] as String? ?? 'Vantage Fashion S.L.',
      companyAddress: json['company_address'] as String?,
      companyNif: json['company_nif'] as String?,
      companyEmail: json['company_email'] as String?,
      companyPhone: json['company_phone'] as String?,
      subtotal: json['subtotal'] as int,
      shippingCost: json['shipping_cost'] as int? ?? 0,
      discount: json['discount'] as int? ?? 0,
      taxRate: (json['tax_rate'] as num?)?.toDouble() ?? 21.0,
      taxAmount: json['tax_amount'] as int,
      total: json['total'] as int,
      paymentMethod: json['payment_method'] as String? ?? 'Tarjeta de crédito',
      paymentStatus: json['payment_status'] as String? ?? 'paid',
      issueDate: DateTime.parse(json['issue_date'] as String),
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
      status: json['status'] as String? ?? 'issued',
      pdfUrl: json['pdf_url'] as String?,
      pdfGeneratedAt: json['pdf_generated_at'] != null
          ? DateTime.parse(json['pdf_generated_at'] as String)
          : null,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      items: itemsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoice_number': invoiceNumber,
      'order_id': orderId,
      'customer_name': customerName,
      'customer_email': customerEmail,
      'customer_address': customerAddress,
      'customer_city': customerCity,
      'customer_postal_code': customerPostalCode,
      'customer_phone': customerPhone,
      'company_name': companyName,
      'company_address': companyAddress,
      'company_nif': companyNif,
      'company_email': companyEmail,
      'company_phone': companyPhone,
      'subtotal': subtotal,
      'shipping_cost': shippingCost,
      'discount': discount,
      'tax_rate': taxRate,
      'tax_amount': taxAmount,
      'total': total,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'issue_date': issueDate.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
      'status': status,
      'pdf_url': pdfUrl,
      'notes': notes,
    };
  }

  /// Texto del estado en español
  String get statusText {
    switch (status) {
      case 'draft':
        return 'Borrador';
      case 'issued':
        return 'Emitida';
      case 'sent':
        return 'Enviada';
      case 'paid':
        return 'Pagada';
      case 'cancelled':
        return 'Cancelada';
      default:
        return status;
    }
  }

  /// Verifica si tiene PDF generado
  bool get hasPdf => pdfUrl != null && pdfUrl!.isNotEmpty;

  /// Base imponible (subtotal - descuento + envío)
  int get taxableBase => subtotal - discount + shippingCost;
}
