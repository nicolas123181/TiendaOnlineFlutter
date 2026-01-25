// Modelos para estadísticas del Admin Dashboard

class AdminStats {
  final double monthlySales;
  final int pendingOrders;
  final String topProduct;
  final int topProductSold;
  final int totalProducts;
  final int totalStock;
  final int lowStockCount;
  final int outOfStockCount;
  final double inventoryValue;
  final List<DailySale> last7DaysSales;

  AdminStats({
    required this.monthlySales,
    required this.pendingOrders,
    required this.topProduct,
    required this.topProductSold,
    required this.totalProducts,
    required this.totalStock,
    required this.lowStockCount,
    required this.outOfStockCount,
    required this.inventoryValue,
    required this.last7DaysSales,
  });

  factory AdminStats.fromJson(Map<String, dynamic> json) {
    return AdminStats(
      monthlySales: (json['monthly_sales'] ?? 0.0).toDouble(),
      pendingOrders: json['pending_orders'] ?? 0,
      topProduct: json['top_product'] ?? '',
      topProductSold: json['top_product_sold'] ?? 0,
      totalProducts: json['total_products'] ?? 0,
      totalStock: json['total_stock'] ?? 0,
      lowStockCount: json['low_stock_count'] ?? 0,
      outOfStockCount: json['out_of_stock_count'] ?? 0,
      inventoryValue: (json['inventory_value'] ?? 0.0).toDouble(),
      last7DaysSales:
          (json['last_7_days_sales'] as List?)
              ?.map((e) => DailySale.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class DailySale {
  final DateTime date;
  final double amount;
  final int orders;

  DailySale({required this.date, required this.amount, required this.orders});

  factory DailySale.fromJson(Map<String, dynamic> json) {
    return DailySale(
      date: DateTime.parse(json['date']),
      amount: (json['amount'] ?? 0.0).toDouble(),
      orders: json['orders'] ?? 0,
    );
  }
}

class UserStats {
  final String email;
  final String name;
  final String? phone;
  final int ordersCount;
  final DateTime lastOrder;
  final DateTime firstOrder;
  final bool isNewsletterSubscriber;

  UserStats({
    required this.email,
    required this.name,
    this.phone,
    required this.ordersCount,
    required this.lastOrder,
    required this.firstOrder,
    required this.isNewsletterSubscriber,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'],
      ordersCount: json['orders_count'] ?? 0,
      lastOrder: DateTime.parse(json['last_order']),
      firstOrder: DateTime.parse(json['first_order']),
      isNewsletterSubscriber: json['is_newsletter_subscriber'] ?? false,
    );
  }
}
