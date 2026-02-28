// Provider para Admin Dashboard con estadísticas

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/services/supabase_service.dart';
import '../../data/models/admin_stats.dart';

/// Provider para obtener estadísticas del dashboard
final adminStatsProvider = FutureProvider<AdminStats>((ref) async {
  final supabase = ref.read(supabaseClientProvider);

  // Obtener todos los datos necesarios
  final productsResponse = await supabase.from('products').select('*');
  final productSizesResponse = await supabase.from('product_sizes').select('*');
  final ordersResponse = await supabase
      .from('orders')
      .select('*, order_items(*)')
      .gte(
        'created_at',
        DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
      );

  final products = productsResponse as List;
  final productSizes = productSizesResponse as List;
  final orders = ordersResponse as List;

  // Calcular estadísticas
  final totalProducts = products.length;
  final totalStock = products.fold<int>(
    0,
    (sum, p) => sum + ((p['stock'] as num?)?.toInt() ?? 0),
  );

  // Calcular stock por tallas (lo correcto)
  final lowStockCount = productSizes
      .where(
        (ps) =>
            ((ps['stock'] as num?) ?? 0) > 0 &&
            ((ps['stock'] as num?) ?? 0) < 6,
      )
      .length;
  final outOfStockCount = productSizes
      .where((ps) => ((ps['stock'] as num?) ?? 0) < 1)
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

  // ── Returns / Devoluciones ─────────────────────────────────────
  final returnsResponse = await supabase
      .from('returns')
      .select('id, status, refund_amount, created_at')
      .gte(
        'created_at',
        DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
      );

  final returnsList = returnsResponse as List;

  final pendingReturns = returnsList
      .where((r) => r['status'] == 'pending' || r['status'] == 'in_transit')
      .length;

  final monthlyRefunds = returnsList
      .where((r) => r['status'] == 'refunded')
      .fold<double>(0.0, (sum, r) => sum + ((r['refund_amount'] ?? 0) / 100.0));

  final returnsByStatus = <String, int>{};
  for (final r in returnsList) {
    final s = r['status'] as String? ?? 'other';
    returnsByStatus[s] = (returnsByStatus[s] ?? 0) + 1;
  }

  // Devoluciones últimos 7 días
  final last7DaysReturns = <DailySale>[];
  for (int i = 6; i >= 0; i--) {
    final date = DateTime.now().subtract(Duration(days: i));
    final dayReturns = returnsList.where((r) {
      final createdAt = DateTime.parse(r['created_at']);
      return createdAt.year == date.year &&
          createdAt.month == date.month &&
          createdAt.day == date.day;
    }).toList();

    final dayRefundAmount = dayReturns
        .where((r) => r['status'] == 'refunded')
        .fold<double>(
          0.0,
          (sum, r) => sum + ((r['refund_amount'] ?? 0) / 100.0),
        );

    last7DaysReturns.add(
      DailySale(date: date, amount: dayRefundAmount, orders: dayReturns.length),
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
    pendingReturns: pendingReturns,
    monthlyRefunds: monthlyRefunds,
    returnsByStatus: returnsByStatus,
    last7DaysReturns: last7DaysReturns,
  );
});

// ── Chart data provider — parameterised by period ──────────────────────────
// period: 'month:YYYY-MM'  (e.g. 'month:2026-02')
final adminChartDataProvider = FutureProvider.family<ChartPeriodData, String>((
  ref,
  period,
) async {
  final supabase = ref.read(supabaseClientProvider);

  // Parse 'month:YYYY-MM'
  final parts = period.split(':');
  final monthStr = parts.length == 2 ? parts[1] : null;
  DateTime selectedMonth;
  if (monthStr != null) {
    final mp = monthStr.split('-');
    selectedMonth = DateTime(int.parse(mp[0]), int.parse(mp[1]), 1);
  } else {
    final now = DateTime.now();
    selectedMonth = DateTime(now.year, now.month, 1);
  }
  final monthStart = selectedMonth;
  final monthEnd = DateTime(selectedMonth.year, selectedMonth.month + 1, 1);

  var ordersQ = supabase
      .from('orders')
      .select('created_at, total')
      .gte('created_at', monthStart.toIso8601String())
      .lt('created_at', monthEnd.toIso8601String());
  final ordersResp = await ordersQ;

  var returnsQ = supabase
      .from('returns')
      .select('created_at, refund_amount, status')
      .gte('created_at', monthStart.toIso8601String())
      .lt('created_at', monthEnd.toIso8601String());
  final returnsResp = await returnsQ;

  final orders = ordersResp as List;
  final returnsList = returnsResp as List;

  // Always day-by-day for the selected month
  final daysInMonth = monthEnd.difference(monthStart).inDays;
  final sales = <DailySale>[];
  final rets = <DailySale>[];

  for (int i = 0; i < daysInMonth; i++) {
    final date = monthStart.add(Duration(days: i));

    final dayOrders = orders.where((o) {
      final d = DateTime.parse(o['created_at']);
      return d.year == date.year && d.month == date.month && d.day == date.day;
    }).toList();

    final dayReturns = returnsList.where((r) {
      final d = DateTime.parse(r['created_at']);
      return d.year == date.year && d.month == date.month && d.day == date.day;
    }).toList();

    sales.add(
      DailySale(
        date: date,
        amount: dayOrders.fold(0.0, (s, o) => s + ((o['total'] ?? 0) / 100.0)),
        orders: dayOrders.length,
      ),
    );

    rets.add(
      DailySale(
        date: date,
        amount: dayReturns
            .where((r) => r['status'] == 'refunded')
            .fold(0.0, (s, r) => s + ((r['refund_amount'] ?? 0) / 100.0)),
        orders: dayReturns.length,
      ),
    );
  }

  return ChartPeriodData(sales: sales, returns: rets);
});
