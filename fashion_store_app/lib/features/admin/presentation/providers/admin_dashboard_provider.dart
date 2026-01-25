// Provider para Admin Dashboard con estadísticas

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/services/supabase_service.dart';
import '../../data/models/admin_stats.dart';

/// Provider para obtener estadísticas del dashboard
final adminStatsProvider = FutureProvider<AdminStats>((ref) async {
  final supabase = ref.read(supabaseClientProvider);

  // Obtener todos los datos necesarios
  final productsResponse = await supabase.from('products').select('*');
  final ordersResponse = await supabase
      .from('orders')
      .select('*, order_items(*)')
      .gte(
        'created_at',
        DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
      );

  final products = productsResponse as List;
  final orders = ordersResponse as List;

  // Calcular estadísticas
  final totalProducts = products.length;
  final totalStock = products.fold<int>(
    0,
    (sum, p) => sum + ((p['stock'] as num?)?.toInt() ?? 0),
  );
  final lowStockCount = products
      .where(
        (p) =>
            ((p['stock'] as num?) ?? 0) > 0 && ((p['stock'] as num?) ?? 0) < 6,
      )
      .length;
  final outOfStockCount = products
      .where((p) => ((p['stock'] as num?) ?? 0) < 1)
      .length;
  final inventoryValue = products.fold<double>(
    0.0,
    (sum, p) =>
        sum +
        (((p['price'] as num?) ?? 0) / 100.0) *
            ((p['stock'] as num?) ?? 0).toDouble(),
  );

  // Ventas del mes
  final monthlySales = orders.fold<double>(
    0.0,
    (sum, o) => sum + ((o['total'] ?? 0) / 100.0),
  );

  // Pedidos pendientes
  final pendingOrders = await supabase.from('orders').select('id').inFilter(
    'status',
    ['paid', 'ready_for_pickup', 'shipped'],
  );
  final pendingCount = (pendingOrders as List).length;

  // Producto más vendido
  final orderItems = orders
      .expand((o) => (o['order_items'] as List? ?? []))
      .toList();
  final productSales = <int, int>{};
  for (var item in orderItems) {
    final productId = item['product_id'] as int?;
    if (productId != null) {
      productSales[productId] =
          (productSales[productId] ?? 0) + (item['quantity'] as int? ?? 0);
    }
  }

  String topProduct = 'N/A';
  int topProductSold = 0;
  if (productSales.isNotEmpty) {
    final topEntry = productSales.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );
    topProductSold = topEntry.value;
    final topProductData = await supabase
        .from('products')
        .select('name')
        .eq('id', topEntry.key)
        .single();
    topProduct = topProductData['name'] ?? 'N/A';
  }

  // Ventas últimos 7 días
  final last7Days = <DailySale>[];
  for (int i = 6; i >= 0; i--) {
    final date = DateTime.now().subtract(Duration(days: i));

    final dayOrders = orders.where((o) {
      final createdAt = DateTime.parse(o['created_at']);
      return createdAt.year == date.year &&
          createdAt.month == date.month &&
          createdAt.day == date.day;
    }).toList();

    final dayAmount = dayOrders.fold<double>(
      0.0,
      (sum, o) => sum + ((o['total'] ?? 0) / 100.0),
    );

    last7Days.add(
      DailySale(date: date, amount: dayAmount, orders: dayOrders.length),
    );
  }

  return AdminStats(
    monthlySales: monthlySales,
    pendingOrders: pendingCount,
    topProduct: topProduct,
    topProductSold: topProductSold,
    totalProducts: totalProducts,
    totalStock: totalStock,
    lowStockCount: lowStockCount,
    outOfStockCount: outOfStockCount,
    inventoryValue: inventoryValue,
    last7DaysSales: last7Days,
  );
});
