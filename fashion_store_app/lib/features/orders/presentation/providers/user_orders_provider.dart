import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/services/supabase_service.dart'
    hide currentUserProvider;
import '../../../auth/presentation/providers/auth_provider.dart'
    show currentUserProvider;

/// Modelo de pedido del usuario
class UserOrder {
  final int id;
  final String status;
  final int total;
  final int? subtotal;
  final int? discount;
  final int? shippingCost;
  final String? trackingNumber;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<OrderItem> items;
  final ShippingCarrier? carrier;
  // Información del cliente
  final String customerName;
  final String customerEmail;
  final String? customerPhone;
  final String customerAddress;
  final String customerCity;
  final String customerPostalCode;

  UserOrder({
    required this.id,
    required this.status,
    required this.total,
    this.subtotal,
    this.discount,
    this.shippingCost,
    this.trackingNumber,
    required this.createdAt,
    this.updatedAt,
    required this.items,
    this.carrier,
    required this.customerName,
    required this.customerEmail,
    this.customerPhone,
    required this.customerAddress,
    required this.customerCity,
    required this.customerPostalCode,
  });

  factory UserOrder.fromJson(Map<String, dynamic> json) {
    final itemsList = json['order_items'] as List? ?? [];
    final carrierData = json['shipping_carriers'];

    return UserOrder(
      id: json['id'] as int,
      status: json['status'] as String? ?? 'pending',
      total: json['total'] as int? ?? 0,
      subtotal: json['subtotal'] as int?,
      discount: json['discount'] as int?,
      shippingCost: json['shipping_cost'] as int?,
      trackingNumber: json['tracking_number'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      items: itemsList.map((item) => OrderItem.fromJson(item)).toList(),
      carrier: carrierData != null
          ? ShippingCarrier.fromJson(carrierData)
          : null,
      customerName: json['customer_name'] as String? ?? 'Cliente',
      customerEmail: json['customer_email'] as String? ?? '',
      customerPhone: json['customer_phone'] as String?,
      customerAddress: json['customer_address'] as String? ?? '',
      customerCity: json['customer_city'] as String? ?? '',
      customerPostalCode: json['customer_postal_code'] as String? ?? '',
    );
  }

  String get statusLabel {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'paid':
        return 'Pagado';
      case 'ready_for_pickup':
        return 'Preparando';
      case 'shipped':
        return 'Enviado';
      case 'delivered':
        return 'Entregado';
      case 'cancelled':
        return 'Cancelado';
      default:
        return status;
    }
  }

  String get formattedTotal => '${(total / 100).toStringAsFixed(2)} €';
}

class OrderItem {
  final int id;
  final int? productId;
  final String productName;
  final int productPrice;
  final int quantity;
  final String? size;

  OrderItem({
    required this.id,
    this.productId,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    this.size,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as int,
      productId: json['product_id'] as int?,
      productName: json['product_name'] as String? ?? 'Producto',
      productPrice: json['product_price'] as int? ?? 0,
      quantity: json['quantity'] as int? ?? 1,
      size: json['size'] as String?,
    );
  }

  String get formattedPrice => '${(productPrice / 100).toStringAsFixed(2)} €';
  String get formattedTotal =>
      '${((productPrice * quantity) / 100).toStringAsFixed(2)} €';
}

class ShippingCarrier {
  final int id;
  final String name;
  final String code;
  final String? trackingUrlTemplate;

  ShippingCarrier({
    required this.id,
    required this.name,
    required this.code,
    this.trackingUrlTemplate,
  });

  factory ShippingCarrier.fromJson(Map<String, dynamic> json) {
    return ShippingCarrier(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      trackingUrlTemplate: json['tracking_url_template'] as String?,
    );
  }

  String? getTrackingUrl(String? trackingNumber) {
    if (trackingUrlTemplate == null || trackingNumber == null) return null;
    return trackingUrlTemplate!.replaceAll('{tracking}', trackingNumber);
  }
}

/// Provider para obtener los pedidos del usuario actual
final userOrdersProvider = FutureProvider<List<UserOrder>>((ref) async {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return [];

  final supabase = ref.watch(supabaseClientProvider);

  final response = await supabase
      .from('orders')
      .select('''
        id,
        status,
        total,
        subtotal,
        discount,
        shipping_cost,
        tracking_number,
        created_at,
        updated_at,
        customer_name,
        customer_email,
        customer_phone,
        customer_address,
        customer_city,
        customer_postal_code,
        order_items(
          id,
          product_id,
          product_name,
          product_price,
          quantity,
          size
        ),
        shipping_carriers(
          id,
          name,
          code,
          tracking_url_template
        )
      ''')
      .eq('customer_email', user.email)
      .order('created_at', ascending: false);

  return (response as List).map((json) => UserOrder.fromJson(json)).toList();
});

/// Provider para un pedido específico
final orderByIdProvider = FutureProvider.family<UserOrder?, int>((
  ref,
  orderId,
) async {
  final orders = await ref.watch(userOrdersProvider.future);
  return orders.where((o) => o.id == orderId).firstOrNull;
});
