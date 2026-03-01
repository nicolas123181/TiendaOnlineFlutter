// Modelo para Facturas - Sincronizado con BD

import '../../../../shared/utils/text_utils.dart';

class Invoice {
  final int id;
  final String invoiceNumber;
  final int orderId;
  final String customerName;
  final String customerEmail;
  final String? customerAddress;
  final String? customerCity;
  final String? customerPostalCode;
  final String? customerPhone;
  final String companyName;
  final String? companyAddress;
  final String? companyNif;
  final String? companyEmail;
  final String? companyPhone;
  final double subtotal;
  final double shippingCost;
  final double discount;
  final double taxRate;
  final double taxAmount;
  final double total;
  final String? paymentMethod;
  final String? paymentStatus;
  final DateTime issueDate;
  final DateTime? dueDate;
  final String status;
  final String? pdfUrl;
  final DateTime? pdfGeneratedAt;
  final String? notes;
  final DateTime createdAt;

  Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.orderId,
    required this.customerName,
    required this.customerEmail,
    this.customerAddress,
    this.customerCity,
    this.customerPostalCode,
    this.customerPhone,
    required this.companyName,
    this.companyAddress,
    this.companyNif,
    this.companyEmail,
    this.companyPhone,
    required this.subtotal,
    required this.shippingCost,
    required this.discount,
    required this.taxRate,
    required this.taxAmount,
    required this.total,
    this.paymentMethod,
    this.paymentStatus,
    required this.issueDate,
    this.dueDate,
    required this.status,
    this.pdfUrl,
    this.pdfGeneratedAt,
    this.notes,
    required this.createdAt,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    // Helper seguro: acepta int, double, o num de Supabase
    int safeInt(dynamic v) => (v as num?)?.toInt() ?? 0;

    return Invoice(
      id: (json['id'] as num).toInt(),
      invoiceNumber: json['invoice_number'] as String? ?? 'SIN-NÚMERO',
      orderId: (json['order_id'] as num).toInt(),
      customerName: TextUtils.fixEncoding(
        json['customer_name'] as String? ?? 'Sin nombre',
      ),
      customerEmail: json['customer_email'] as String? ?? 'Sin email',
      customerAddress: json['customer_address'] as String?,
      customerCity: json['customer_city'] as String?,
      customerPostalCode: json['customer_postal_code'] as String?,
      customerPhone: json['customer_phone'] as String?,
      companyName: json['company_name'] as String? ?? 'Vantage Fashion S.L.',
      companyAddress: json['company_address'] as String?,
      companyNif: json['company_nif'] as String?,
      companyEmail: json['company_email'] as String?,
      companyPhone: json['company_phone'] as String?,
      subtotal: safeInt(json['subtotal']) / 100.0,
      shippingCost: safeInt(json['shipping_cost']) / 100.0,
      discount: safeInt(json['discount']) / 100.0,
      taxRate: (json['tax_rate'] as num?)?.toDouble() ?? 21.0,
      taxAmount: safeInt(json['tax_amount']) / 100.0,
      total: safeInt(json['total']) / 100.0,
      paymentMethod: json['payment_method'] as String?,
      paymentStatus: json['payment_status'] as String?,
      issueDate: json['issue_date'] != null
          ? DateTime.parse(json['issue_date'] as String)
          : (json['created_at'] != null
                ? DateTime.parse(json['created_at'] as String)
                : DateTime.now()),
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
      status: json['status'] as String? ?? 'issued',
      pdfUrl: json['pdf_url'] as String?,
      pdfGeneratedAt: json['pdf_generated_at'] != null
          ? DateTime.parse(json['pdf_generated_at'] as String)
          : null,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
      'subtotal': (subtotal * 100).toInt(),
      'shipping_cost': (shippingCost * 100).toInt(),
      'discount': (discount * 100).toInt(),
      'tax_rate': taxRate,
      'tax_amount': (taxAmount * 100).toInt(),
      'total': (total * 100).toInt(),
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'issue_date': issueDate.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
      'status': status,
      'pdf_url': pdfUrl,
      'pdf_generated_at': pdfGeneratedAt?.toIso8601String(),
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get statusLabel {
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
}
