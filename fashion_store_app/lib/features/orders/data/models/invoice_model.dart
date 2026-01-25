/// Modelo de Factura
class Invoice {
  final int id;
  final int orderId;
  final String invoiceNumber;
  final DateTime createdAt;
  final String status; // 'pending', 'paid', 'cancelled', 'refunded'
  final int subtotal;
  final int taxAmount;
  final int shippingAmount;
  final int discountAmount;
  final int totalAmount;
  final String? pdfUrl;
  final List<InvoiceItem> items;

  const Invoice({
    required this.id,
    required this.orderId,
    required this.invoiceNumber,
    required this.createdAt,
    required this.status,
    required this.subtotal,
    required this.taxAmount,
    required this.shippingAmount,
    this.discountAmount = 0,
    required this.totalAmount,
    this.pdfUrl,
    this.items = const [],
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] as int,
      orderId: json['order_id'] as int,
      invoiceNumber: json['invoice_number'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      status: json['status'] as String? ?? 'pending',
      subtotal: json['subtotal'] as int,
      taxAmount: json['tax_amount'] as int,
      shippingAmount: json['shipping_amount'] as int? ?? 0,
      discountAmount: json['discount_amount'] as int? ?? 0,
      totalAmount: json['total_amount'] as int,
      pdfUrl: json['pdf_url'] as String?,
      items:
          (json['invoice_items'] as List<dynamic>?)
              ?.map((e) => InvoiceItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  String get formattedSubtotal => _formatPrice(subtotal);
  String get formattedTax => _formatPrice(taxAmount);
  String get formattedShipping =>
      shippingAmount == 0 ? 'GRATIS' : _formatPrice(shippingAmount);
  String get formattedDiscount => _formatPrice(discountAmount);
  String get formattedTotal => _formatPrice(totalAmount);

  String _formatPrice(int cents) => '${(cents / 100).toStringAsFixed(2)} €';

  /// IVA rate (21% para España)
  static const double taxRate = 0.21;

  /// Calcular base imponible
  int get netAmount => (totalAmount / (1 + taxRate)).round();
}

/// Item de factura
class InvoiceItem {
  final int id;
  final int invoiceId;
  final String productName;
  final int quantity;
  final int unitPrice;
  final int totalPrice;

  const InvoiceItem({
    required this.id,
    required this.invoiceId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      id: json['id'] as int,
      invoiceId: json['invoice_id'] as int,
      productName: json['product_name'] as String,
      quantity: json['quantity'] as int,
      unitPrice: json['unit_price'] as int,
      totalPrice: json['total_price'] as int,
    );
  }

  String get formattedUnitPrice => '${(unitPrice / 100).toStringAsFixed(2)} €';
  String get formattedTotal => '${(totalPrice / 100).toStringAsFixed(2)} €';
}
