import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Estado de las estadísticas del dashboard
class DashboardStats {
  final int totalSales; // En centavos
  final int totalOrders;
  final int pendingOrders;
  final int lowStockProducts;
  final int pendingReturns;
  final List<RecentOrder> recentOrders;
  final List<TopProduct> topProducts;
  final List<DailySales> weeklySales;
  final bool isLoading;
  final String? error;

  const DashboardStats({
    this.totalSales = 0,
    this.totalOrders = 0,
    this.pendingOrders = 0,
    this.lowStockProducts = 0,
    this.pendingReturns = 0,
    this.recentOrders = const [],
    this.topProducts = const [],
    this.weeklySales = const [],
    this.isLoading = true,
    this.error,
  });

  DashboardStats copyWith({
    int? totalSales,
    int? totalOrders,
    int? pendingOrders,
    int? lowStockProducts,
    int? pendingReturns,
    List<RecentOrder>? recentOrders,
    List<TopProduct>? topProducts,
    List<DailySales>? weeklySales,
    bool? isLoading,
    String? error,
  }) {
    return DashboardStats(
      totalSales: totalSales ?? this.totalSales,
      totalOrders: totalOrders ?? this.totalOrders,
      pendingOrders: pendingOrders ?? this.pendingOrders,
      lowStockProducts: lowStockProducts ?? this.lowStockProducts,
      pendingReturns: pendingReturns ?? this.pendingReturns,
      recentOrders: recentOrders ?? this.recentOrders,
      topProducts: topProducts ?? this.topProducts,
      weeklySales: weeklySales ?? this.weeklySales,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class RecentOrder {
  final int id;
  final String customerName;
  final String customerEmail;
  final int total;
  final String status;
  final DateTime createdAt;

  RecentOrder({
    required this.id,
    required this.customerName,
    required this.customerEmail,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  factory RecentOrder.fromJson(Map<String, dynamic> json) {
    return RecentOrder(
      id: json['id'] as int,
      customerName: json['customer_name'] as String,
      customerEmail: json['customer_email'] as String,
      total: json['total'] as int,
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  String get statusText {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'paid':
        return 'Pagado';
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
}

class TopProduct {
  final int id;
  final String name;
  final int totalSold;
  final int revenue;

  TopProduct({
    required this.id,
    required this.name,
    required this.totalSold,
    required this.revenue,
  });
}

class DailySales {
  final DateTime date;
  final int total;
  final int orderCount;

  DailySales({
    required this.date,
    required this.total,
    required this.orderCount,
  });
}

/// Notifier para las estadísticas del dashboard
class DashboardStatsNotifier extends StateNotifier<DashboardStats> {
  final SupabaseClient _supabase;

  DashboardStatsNotifier(this._supabase) : super(const DashboardStats()) {
    loadStats();
  }

  Future<void> loadStats() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Cargar todas las estadísticas en paralelo
      final results = await Future.wait([
        _loadOrderStats(),
        _loadRecentOrders(),
        _loadTopProducts(),
        _loadWeeklySales(),
        _loadLowStockCount(),
        _loadPendingReturns(),
      ]);

      final orderStats = results[0] as Map<String, int>;
      final recentOrders = results[1] as List<RecentOrder>;
      final topProducts = results[2] as List<TopProduct>;
      final weeklySales = results[3] as List<DailySales>;
      final lowStockCount = results[4] as int;
      final pendingReturns = results[5] as int;

      state = state.copyWith(
        totalSales: orderStats['totalSales'] ?? 0,
        totalOrders: orderStats['totalOrders'] ?? 0,
        pendingOrders: orderStats['pendingOrders'] ?? 0,
        lowStockProducts: lowStockCount,
        pendingReturns: pendingReturns,
        recentOrders: recentOrders,
        topProducts: topProducts,
        weeklySales: weeklySales,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar estadísticas: $e',
      );
    }
  }

  Future<Map<String, int>> _loadOrderStats() async {
    try {
      // Total de ventas y pedidos
      final ordersResponse = await _supabase
          .from('orders')
          .select('total, status')
          .neq('status', 'cancelled');

      int totalSales = 0;
      int pendingOrders = 0;

      for (final order in ordersResponse as List) {
        totalSales += (order['total'] as int?) ?? 0;
        if (order['status'] == 'pending') {
          pendingOrders++;
        }
      }

      return {
        'totalSales': totalSales,
        'totalOrders': ordersResponse.length,
        'pendingOrders': pendingOrders,
      };
    } catch (e) {
      return {'totalSales': 0, 'totalOrders': 0, 'pendingOrders': 0};
    }
  }

  Future<List<RecentOrder>> _loadRecentOrders() async {
    try {
      final response = await _supabase
          .from('orders')
          .select(
              'id, customer_name, customer_email, total, status, created_at')
          .order('created_at', ascending: false)
          .limit(5);

      return (response as List)
          .map((json) => RecentOrder.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<TopProduct>> _loadTopProducts() async {
    try {
      // Obtener productos más vendidos desde order_items
      final response = await _supabase
          .from('order_items')
          .select('product_id, product_name, product_price, quantity');

      // Agrupar por producto
      final Map<int, TopProduct> productMap = {};

      for (final item in response as List) {
        final productId = item['product_id'] as int?;
        if (productId == null) continue;

        final quantity = item['quantity'] as int? ?? 0;
        final price = item['product_price'] as int? ?? 0;
        final name = item['product_name'] as String? ?? 'Producto';

        if (productMap.containsKey(productId)) {
          final existing = productMap[productId]!;
          productMap[productId] = TopProduct(
            id: productId,
            name: name,
            totalSold: existing.totalSold + quantity,
            revenue: existing.revenue + (price * quantity),
          );
        } else {
          productMap[productId] = TopProduct(
            id: productId,
            name: name,
            totalSold: quantity,
            revenue: price * quantity,
          );
        }
      }

      // Ordenar por cantidad vendida
      final sorted = productMap.values.toList()
        ..sort((a, b) => b.totalSold.compareTo(a.totalSold));

      return sorted.take(5).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<DailySales>> _loadWeeklySales() async {
    try {
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));

      final response = await _supabase
          .from('orders')
          .select('total, created_at')
          .gte('created_at', weekAgo.toIso8601String())
          .neq('status', 'cancelled');

      // Agrupar por día
      final Map<String, DailySales> dailyMap = {};

      // Inicializar los últimos 7 días
      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final key =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        dailyMap[key] = DailySales(
          date: DateTime(date.year, date.month, date.day),
          total: 0,
          orderCount: 0,
        );
      }

      for (final order in response as List) {
        final createdAt = DateTime.parse(order['created_at'] as String);
        final key =
            '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';

        if (dailyMap.containsKey(key)) {
          final existing = dailyMap[key]!;
          dailyMap[key] = DailySales(
            date: existing.date,
            total: existing.total + ((order['total'] as int?) ?? 0),
            orderCount: existing.orderCount + 1,
          );
        }
      }

      return dailyMap.values.toList();
    } catch (e) {
      return [];
    }
  }

  Future<int> _loadLowStockCount() async {
    try {
      final response = await _supabase
          .from('products')
          .select('id')
          .lte('stock', 5)
          .gt('stock', 0);

      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }

  Future<int> _loadPendingReturns() async {
    try {
      final response =
          await _supabase.from('returns').select('id').eq('status', 'pending');

      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }

  Future<void> refresh() async {
    await loadStats();
  }
}

/// Provider para las estadísticas del dashboard
final dashboardStatsProvider =
    StateNotifierProvider<DashboardStatsNotifier, DashboardStats>((ref) {
  final supabase = Supabase.instance.client;
  return DashboardStatsNotifier(supabase);
});
