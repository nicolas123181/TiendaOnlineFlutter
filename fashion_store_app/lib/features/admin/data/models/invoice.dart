// Modelo para Facturas

class Invoice {
  final int id;
  final int orderId;
  final String invoiceNumber;
  final String customerName;
  final String customerEmail;
  final String? customerPhone;
  final String? customerAddress;
  final String? customerCity;
  final String? customerPostalCode;
  final double subtotal;
  final double tax;
  final double shipping;
  final double discount;
  final double total;
  final DateTime issuedAt;
  final String? pdfUrl;

  Invoice({
    required this.id,
    required this.orderId,
    required this.invoiceNumber,
    required this.customerName,
    required this.customerEmail,
    this.customerPhone,
    this.customerAddress,
    this.customerCity,
    this.customerPostalCode,
    required this.subtotal,
    required this.tax,
    required this.shipping,
    required this.discount,
    required this.total,
    required this.issuedAt,
    this.pdfUrl,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      orderId: json['order_id'],
      invoiceNumber: json['invoice_number'],
      customerName: json['customer_name'],
      customerEmail: json['customer_email'],
      customerPhone: json['customer_phone'],
      customerAddress: json['customer_address'],
      customerCity: json['customer_city'],
      customerPostalCode: json['customer_postal_code'],
      subtotal: (json['subtotal'] ?? 0) / 100.0,
      tax: (json['tax'] ?? 0) / 100.0,
      shipping: (json['shipping'] ?? 0) / 100.0,
      discount: (json['discount'] ?? 0) / 100.0,
      total: (json['total'] ?? 0) / 100.0,
      issuedAt: DateTime.parse(json['issued_at']),
      pdfUrl: json['pdf_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'invoice_number': invoiceNumber,
      'customer_name': customerName,
      'customer_email': customerEmail,
      'customer_phone': customerPhone,
      'customer_address': customerAddress,
      'customer_city': customerCity,
      'customer_postal_code': customerPostalCode,
      'subtotal': (subtotal * 100).toInt(),
      'tax': (tax * 100).toInt(),
      'shipping': (shipping * 100).toInt(),
      'discount': (discount * 100).toInt(),
      'total': (total * 100).toInt(),
      'issued_at': issuedAt.toIso8601String(),
      'pdf_url': pdfUrl,
    };
  }
}
