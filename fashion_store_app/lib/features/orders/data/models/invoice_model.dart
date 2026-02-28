/// Modelo de Factura
class Invoice {
  final int id;
  final int orderId;
  final String invoiceNumber;
  final DateTime createdAt;
  final String status; // 'pending', 'paid', 'cancelled', 'refunded'
  final String type; // 'standard' or 'credit_note'
  final int subtotal;
  final int taxAmount;
  final double taxRateValue; // e.g. 21
  final int shippingAmount;
  final int discountAmount;
  final int totalAmount;
  final String? pdfUrl;
  final String? customerName;
  final String? customerEmail;
  final String? customerAddress;
  final String? customerCity;
  final String? customerPostalCode;
  final String? customerPhone;
  final List<InvoiceItem> items;

  const Invoice({
    required this.id,
    required this.orderId,
    required this.invoiceNumber,
    required this.createdAt,
    required this.status,
    this.type = 'standard',
    required this.subtotal,
    required this.taxAmount,
    this.taxRateValue = 21,
    required this.shippingAmount,
    this.discountAmount = 0,
    required this.totalAmount,
    this.pdfUrl,
    this.customerName,
    this.customerEmail,
    this.customerAddress,
    this.customerCity,
    this.customerPostalCode,
    this.customerPhone,
    this.items = const [],
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    // Helper para leer enteros tolerando que Supabase devuelva num/double
    int readInt(String key, {int fallback = 0}) =>
        (json[key] as num?)?.toInt() ?? fallback;

    final createdAtRaw =
        json['created_at'] as String? ?? json['issue_date'] as String?;

    return Invoice(
      id: (json['id'] as num).toInt(),
      orderId: (json['order_id'] as num).toInt(),
      invoiceNumber: json['invoice_number'] as String,
      createdAt: createdAtRaw != null
          ? DateTime.parse(createdAtRaw)
          : DateTime.now(),
      status: json['status'] as String? ?? 'issued',
      type: json['type'] as String? ?? 'standard',
      subtotal: readInt('subtotal'),
      taxAmount: readInt('tax_amount'),
      taxRateValue: (json['tax_rate'] as num?)?.toDouble() ?? 21,
      shippingAmount: readInt('shipping_cost'),
      discountAmount: readInt('discount'),
      totalAmount: readInt('total'),
      pdfUrl: json['pdf_url'] as String?,
      customerName: json['customer_name'] as String?,
      customerEmail: json['customer_email'] as String?,
      customerAddress: json['customer_address'] as String?,
      customerCity: json['customer_city'] as String?,
      customerPostalCode: json['customer_postal_code'] as String?,
      customerPhone: json['customer_phone'] as String?,
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
  static const double defaultTaxRate = 0.21;

  /// Calcular base imponible
  int get netAmount => (totalAmount / (1 + defaultTaxRate)).round();
}

/// Item de factura
class InvoiceItem {
  final int id;
  final int invoiceId;
  final String productName;
  final String? productSize;
  final int quantity;
  final int unitPrice;
  final int totalPrice;

  const InvoiceItem({
    required this.id,
    required this.invoiceId,
    required this.productName,
    this.productSize,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      id: (json['id'] as num).toInt(),
      invoiceId: (json['invoice_id'] as num).toInt(),
      productName: json['product_name'] as String? ?? 'Producto',
      productSize: json['product_size'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unit_price'] as num).toInt(),
      totalPrice: (json['line_total'] as num).toInt(),
    );
  }

  String get formattedUnitPrice => '${(unitPrice / 100).toStringAsFixed(2)} €';
  String get formattedTotal => '${(totalPrice / 100).toStringAsFixed(2)} €';
}
