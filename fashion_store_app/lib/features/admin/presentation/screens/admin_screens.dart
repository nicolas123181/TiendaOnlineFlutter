// Pantallas de Admin Panel - Sistema Completo

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../categories/presentation/providers/categories_provider.dart';
import '../../data/models/admin_stats.dart';
import '../providers/admin_dashboard_provider.dart';
import '../providers/orders_admin_provider.dart';
import '../providers/products_provider.dart';

/// Dashboard Ejecutivo del Admin Panel
class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  // 'month:YYYY-MM'
  late String _period;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _period = 'month:${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(adminStatsProvider);
    final chartAsync = ref.watch(adminChartDataProvider(_period));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Ejecutivo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(adminStatsProvider);
              ref.invalidate(adminChartDataProvider(_period));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authActionsProvider.notifier).signOut();
              if (context.mounted) {
                context.go('/');
              }
            },
          ),
        ],
      ),
      drawer: const _AdminDrawer(),
      body: statsAsync.when(
        data: (stats) => _DashboardContent(
          stats: stats,
          chartAsync: chartAsync,
          period: _period,
          onPeriodChanged: (p) => setState(() => _period = p),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $err'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(adminStatsProvider),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final AdminStats stats;
  final AsyncValue<ChartPeriodData> chartAsync;
  final String period;
  final ValueChanged<String> onPeriodChanged;

  const _DashboardContent({
    required this.stats,
    required this.chartAsync,
    required this.period,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPIs de Negocio
          Text('Métricas Clave', style: AppTextStyles.h3),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.3,
            children: [
              _KPICard(
                icon: Icons.euro_symbol,
                label: 'Ventas del Mes',
                value: '${stats.monthlySales.toStringAsFixed(2)} €',
                color: Colors.green,
                gradient: const LinearGradient(
                  colors: [Color(0xFF10b981), Color(0xFF14b8a6)],
                ),
              ),
              _KPICard(
                icon: Icons.pending_actions,
                label: 'Pedidos Pendientes',
                value: '${stats.pendingOrders}',
                color: Colors.orange,
                gradient: const LinearGradient(
                  colors: [Color(0xFFf59e0b), Color(0xFFf97316)],
                ),
              ),
              _KPICard(
                icon: Icons.star,
                label: 'Producto Top',
                value: stats.topProduct.length > 15
                    ? '${stats.topProduct.substring(0, 15)}...'
                    : stats.topProduct,
                subtitle: '${stats.topProductSold} vendidos',
                color: Colors.purple,
                gradient: const LinearGradient(
                  colors: [Color(0xFFa855f7), Color(0xFF8b5cf6)],
                ),
              ),
              // 4º KPI — Devoluciones (igual que la web)
              _KPICard(
                icon: Icons.assignment_return,
                label: 'Devoluciones',
                value: '${stats.pendingReturns}',
                subtitle: stats.monthlyRefunds > 0
                    ? '-${stats.monthlyRefunds.toStringAsFixed(2)} €'
                    : 'Pendientes',
                color: Colors.red,
                gradient: const LinearGradient(
                  colors: [Color(0xFFf43f5e), Color(0xFFef4444)],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Month picker
          _MonthPicker(period: period, onChanged: onPeriodChanged),
          const SizedBox(height: 16),

          // Gráficos: Ventas vs Reembolsos + Devoluciones por estado
          chartAsync.when(
            data: (chartData) {
              final totalSales = chartData.sales.fold<double>(
                0,
                (s, e) => s + e.amount,
              );
              final totalRefunds = chartData.returns.fold<double>(
                0,
                (s, e) => s + e.amount,
              );
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _SalesVsReturnsChart(
                          sales: chartData.sales,
                          returns: chartData.returns,
                          period: period,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _ReturnsDonutChart(
                          returnsByStatus: stats.returnsByStatus,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Balance card
                  _BalanceSummaryCard(
                    totalSales: totalSales,
                    totalRefunds: totalRefunds,
                  ),
                ],
              );
            },
            loading: () => const SizedBox(
              height: 260,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => SizedBox(
              height: 80,
              child: Center(
                child: Text(
                  'Error al cargar gráficos: $e',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Estado del Inventario
          Text('Estado del Inventario', style: AppTextStyles.h3),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _InventoryCard(
                icon: Icons.inventory_2,
                label: 'Total Productos',
                value: '${stats.totalProducts}',
                color: Colors.blue,
              ),
              _InventoryCard(
                icon: Icons.warehouse,
                label: 'Stock Total',
                value: '${stats.totalStock}',
                color: Colors.green,
              ),
              _InventoryCard(
                icon: Icons.warning_amber,
                label: 'Stock Bajo',
                value: '${stats.lowStockCount}',
                color: Colors.orange,
              ),
              _InventoryCard(
                icon: Icons.error_outline,
                label: 'Sin Stock',
                value: '${stats.outOfStockCount}',
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Month picker dropdown (last 18 months)
class _MonthPicker extends StatelessWidget {
  final String period;
  final ValueChanged<String> onChanged;

  const _MonthPicker({required this.period, required this.onChanged});

  static List<DateTime> _buildMonths() {
    final now = DateTime.now();
    return List.generate(18, (i) {
      return DateTime(now.year, now.month - i, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final months = _buildMonths();
    return Row(
      children: [
        const Icon(Icons.calendar_month, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        DropdownButton<String>(
          value: period,
          underline: const SizedBox(),
          style: AppTextStyles.labelLarge.copyWith(fontSize: 14),
          items: months.map((m) {
            final key = 'month:${m.year}-${m.month.toString().padLeft(2, '0')}';
            final label = DateFormat('MMMM yyyy', 'es').format(m);
            return DropdownMenuItem(value: key, child: Text(label));
          }).toList(),
          onChanged: (v) => v != null ? onChanged(v) : null,
        ),
      ],
    );
  }
}

/// Balance summary card shown below charts
class _BalanceSummaryCard extends StatelessWidget {
  final double totalSales;
  final double totalRefunds;

  const _BalanceSummaryCard({
    required this.totalSales,
    required this.totalRefunds,
  });

  @override
  Widget build(BuildContext context) {
    final net = totalSales - totalRefunds;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: _BalanceItem(
              label: 'Ventas',
              value: '${totalSales.toStringAsFixed(2)} €',
              color: const Color(0xFF10b981),
              icon: Icons.arrow_upward,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey[200]),
          Expanded(
            child: _BalanceItem(
              label: 'Reembolsos',
              value: '-${totalRefunds.toStringAsFixed(2)} €',
              color: const Color(0xFFf43f5e),
              icon: Icons.arrow_downward,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey[200]),
          Expanded(
            child: _BalanceItem(
              label: 'Balance neto',
              value: '${net.toStringAsFixed(2)} €',
              color: net >= 0 ? AppColors.primary : Colors.red,
              icon: net >= 0 ? Icons.trending_up : Icons.trending_down,
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _BalanceItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.labelLarge.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Drawer del Admin Panel
class _AdminDrawer extends StatelessWidget {
  const _AdminDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VANTAGE',
                    style: AppTextStyles.h3.copyWith(
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Panel de Administración',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _DrawerItem(
                    icon: Icons.dashboard,
                    label: 'Dashboard',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/admin');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.inventory_2,
                    label: 'Productos',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/admin/products');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.shopping_bag,
                    label: 'Pedidos',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/admin/orders');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.people,
                    label: 'Usuarios',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/admin/users');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.local_offer,
                    label: 'Cupones',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/admin/coupons');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.category,
                    label: 'Categorías',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/admin/categories');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.straighten,
                    label: 'Tallas',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/admin/sizes');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.warning_amber,
                    label: 'Alertas Stock',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/admin/low-stock');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.assignment_return,
                    label: 'Devoluciones',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/admin/returns');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.receipt_long,
                    label: 'Facturas',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/admin/invoices');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.email,
                    label: 'Newsletter',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/admin/newsletter');
                    },
                  ),
                  const Divider(),
                  _DrawerItem(
                    icon: Icons.settings,
                    label: 'Configuración',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/admin/settings');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.store,
                    label: 'Ver Tienda',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(leading: Icon(icon), title: Text(label), onTap: onTap);
  }
}

// Widgets de KPIs y gráficos
class _KPICard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;
  final Color color;
  final LinearGradient gradient;

  const _KPICard({
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
    required this.color,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _InventoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InventoryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}

class _SalesVsReturnsChart extends StatelessWidget {
  final List<DailySale> sales;
  final List<DailySale> returns;
  final String period;

  const _SalesVsReturnsChart({
    required this.sales,
    required this.returns,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    final allValues = [
      ...sales.map((s) => s.amount),
      ...returns.map((r) => r.amount),
    ];
    final maxVal = allValues.fold<double>(0.0, (m, v) => v > m ? v : m) * 1.3;
    final safeMax = maxVal < 1 ? 10.0 : maxVal;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ventas vs Reembolsos', style: AppTextStyles.h4),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                maxY: safeMax,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => Colors.black87,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final label = rodIndex == 0 ? 'Ventas' : 'Reimb.';
                      return BarTooltipItem(
                        '$label\n${rod.toY.toStringAsFixed(2)} €',
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= sales.length) return const Text('');
                        // Show only every 5th day to avoid overlap
                        if (idx % 5 != 0) return const Text('');
                        final date = sales[idx].date;
                        final label = DateFormat('d').format(date);
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            label,
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                groupsSpace: 4,
                barGroups: sales.asMap().entries.map((entry) {
                  final i = entry.key;
                  final saleAmt = entry.value.amount;
                  final retAmt = i < returns.length ? returns[i].amount : 0.0;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: saleAmt,
                        color: const Color(0xFF10b981),
                        width: 10,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      BarChartRodData(
                        toY: retAmt,
                        color: const Color(0xFFf43f5e),
                        width: 10,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReturnsDonutChart extends StatelessWidget {
  final Map<String, int> returnsByStatus;

  const _ReturnsDonutChart({required this.returnsByStatus});

  static const _colors = {
    'pending': Color(0xFFf59e0b),
    'in_transit': Color(0xFF3b82f6),
    'received': Color(0xFF8b5cf6),
    'refunded': Color(0xFF10b981),
    'rejected': Color(0xFFef4444),
  };

  static const _labels = {
    'pending': 'Pendiente',
    'in_transit': 'En tránsito',
    'received': 'Recibida',
    'refunded': 'Reembolsada',
    'rejected': 'Rechazada',
  };

  @override
  Widget build(BuildContext context) {
    final total = returnsByStatus.values.fold(0, (s, v) => s + v);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Devoluciones por Estado', style: AppTextStyles.h4),
          const SizedBox(height: 4),
          Text(
            total == 0
                ? 'Sin devoluciones este mes'
                : '$total en el último mes',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          if (total == 0)
            const SizedBox(
              height: 120,
              child: Center(
                child: Icon(
                  Icons.assignment_return_outlined,
                  size: 48,
                  color: Colors.grey,
                ),
              ),
            )
          else
            SizedBox(
              height: 120,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 32,
                  sections: returnsByStatus.entries.map((entry) {
                    final color = _colors[entry.key] ?? Colors.grey;
                    return PieChartSectionData(
                      value: entry.value.toDouble(),
                      color: color,
                      radius: 30,
                      showTitle: false,
                    );
                  }).toList(),
                ),
              ),
            ),
          const SizedBox(height: 10),
          ...returnsByStatus.entries.map((entry) {
            final color = _colors[entry.key] ?? Colors.grey;
            final label = _labels[entry.key] ?? entry.key;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  _LegendDot(color: color, label: label),
                  const Spacer(),
                  Text(
                    '${entry.value}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}

/// Pantalla de productos del admin
class AdminProductsScreen extends ConsumerStatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  ConsumerState<AdminProductsScreen> createState() =>
      _AdminProductsScreenState();
}

class _AdminProductsScreenState extends ConsumerState<AdminProductsScreen> {
  String _searchQuery = '';
  String _filterCategory = 'all';

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsListProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go('/admin/products/new'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda y filtros
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar productos...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
                const SizedBox(height: 12),
                // Filtro por categoría
                categoriesAsync.when(
                  data: (categories) => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChip(
                          label: const Text('Todas'),
                          selected: _filterCategory == 'all',
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _filterCategory = 'all';
                              });
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                        ...categories.map(
                          (cat) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(cat.name),
                              selected: _filterCategory == cat.id.toString(),
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _filterCategory = cat.id.toString();
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Lista de productos
          Expanded(
            child: productsAsync.when(
              data: (products) {
                // Filtrar productos
                var filteredProducts = products.where((p) {
                  final matchesSearch =
                      _searchQuery.isEmpty ||
                      p['name'].toString().toLowerCase().contains(_searchQuery);
                  final matchesCategory =
                      _filterCategory == 'all' ||
                      p['category_id'].toString() == _filterCategory;
                  return matchesSearch && matchesCategory;
                }).toList();

                if (filteredProducts.isEmpty) {
                  return const Center(
                    child: Text('No se encontraron productos'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    final images = product['images'] as List?;
                    final imageUrl = images != null && images.isNotEmpty
                        ? images[0]
                        : '';
                    final price = (product['price'] ?? 0) / 100.0;
                    final stock = product['stock'] ?? 0;
                    final productSizes =
                        product['product_sizes'] as List? ?? [];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => _showProductDetails(context, product),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: imageUrl.isNotEmpty
                                        ? Image.network(
                                            imageUrl,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Container(
                                                    width: 80,
                                                    height: 80,
                                                    color: Colors.grey[300],
                                                    child: const Icon(
                                                      Icons.image,
                                                    ),
                                                  );
                                                },
                                          )
                                        : Container(
                                            width: 80,
                                            height: 80,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.image),
                                          ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product['name'] ?? '',
                                          style: AppTextStyles.labelLarge,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (product['is_active'] == false)
                                          Container(
                                            margin: const EdgeInsets.only(
                                              top: 2,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: const Text(
                                              'Inactivo',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${price.toStringAsFixed(2)} €',
                                          style: AppTextStyles.h4.copyWith(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: stock > 0
                                                    ? Colors.green.withOpacity(
                                                        0.1,
                                                      )
                                                    : Colors.red.withOpacity(
                                                        0.1,
                                                      ),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                'Stock total: $stock',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: stock > 0
                                                      ? Colors.green[700]
                                                      : Colors.red[700],
                                                ),
                                              ),
                                            ),
                                            if (product['featured'] ==
                                                true) ...[
                                              const SizedBox(width: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      size: 12,
                                                      color: AppColors.primary,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      'Destacado',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 20),
                                        onPressed: () {
                                          context.go(
                                            '/admin/products/${product['id']}/edit',
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red[400],
                                          size: 20,
                                        ),
                                        onPressed: () => _confirmDelete(
                                          context,
                                          ref,
                                          product,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // Stock por tallas
                              if (productSizes.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                const Divider(height: 1),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.straighten,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Stock por tallas:',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const Spacer(),
                                    _buildSizeStockIndicators(productSizes),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: $err'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(productsListProvider),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeStockIndicators(List<dynamic> sizes) {
    return Wrap(
      spacing: 6,
      children: sizes.take(6).map((sizeData) {
        final size = sizeData['size'] ?? '';
        final stock = sizeData['stock'] ?? 0;
        Color bgColor;
        Color textColor;

        if (stock == 0) {
          bgColor = Colors.red[100]!;
          textColor = Colors.red[700]!;
        } else if (stock <= 5) {
          bgColor = Colors.orange[100]!;
          textColor = Colors.orange[700]!;
        } else {
          bgColor = Colors.green[100]!;
          textColor = Colors.green[700]!;
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '$size: $stock',
            style: TextStyle(
              fontSize: 10,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showProductDetails(BuildContext context, Map<String, dynamic> product) {
    final productSizes = product['product_sizes'] as List? ?? [];
    final images = product['images'] as List? ?? [];
    final price = (product['price'] ?? 0) / 100.0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(product['name'] ?? '', style: AppTextStyles.h3),
              const SizedBox(height: 8),
              Text(
                '${price.toStringAsFixed(2)} €',
                style: AppTextStyles.h4.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 24),

              // Stock por tallas
              if (productSizes.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(Icons.straighten, size: 16),
                    const SizedBox(width: 6),
                    Text('Stock por Tallas', style: AppTextStyles.labelLarge),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: productSizes.map((sizeData) {
                    final size = sizeData['size'] ?? '';
                    final stock = sizeData['stock'] ?? 0;
                    Color bgColor;
                    Color textColor;
                    String label;

                    if (stock == 0) {
                      bgColor = Colors.red[100]!;
                      textColor = Colors.red[700]!;
                      label = 'AGOTADO';
                    } else if (stock <= 5) {
                      bgColor = Colors.orange[100]!;
                      textColor = Colors.orange[700]!;
                      label = '$stock uds';
                    } else {
                      bgColor = Colors.green[100]!;
                      textColor = Colors.green[700]!;
                      label = '$stock uds';
                    }

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: textColor.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            size,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            label,
                            style: TextStyle(fontSize: 11, color: textColor),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
              ],

              // Imágenes
              if (images.isNotEmpty) ...[
                Row(
                  children: [
                    const Icon(Icons.photo_library, size: 16),
                    const SizedBox(width: 6),
                    Text('Imágenes', style: AppTextStyles.labelLarge),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            images[index],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Acciones
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        context.go('/admin/products/${product['id']}/edit');
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> product,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text(
          '¿Estás seguro de que quieres eliminar "${product['name']}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(productActionsProvider).deleteProduct(product['id']);
        ref.invalidate(productsListProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Producto eliminado con éxito')),
          );
        }
      } catch (e) {
        if (mounted) {
          await showDialog(
            context: context,
            builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.lock_outline, color: Colors.orange[700]),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('No se puede eliminar')),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Este producto tiene pedidos asociados y no puede eliminarse para preservar el historial.',
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          size: 16,
                          color: Colors.amber[700],
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Puedes desactivarlo desde la pantalla de edición para ocultarlo del catálogo sin perder datos.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Entendido'),
                ),
              ],
            ),
          );
        }
      }
    }
  }
}

/// Pantalla de pedidos del admin
class AdminOrdersScreen extends ConsumerStatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  ConsumerState<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends ConsumerState<AdminOrdersScreen> {
  String _searchQuery = '';
  // 'all' | 'pending' | 'paid' | 'ready_for_pickup' | 'shipped' | 'delivered' | 'cancelled'
  String _statusFilter = 'all';

  static const _statusLabels = {
    'pending': 'Pendiente',
    'paid': 'Pagado',
    'ready_for_pickup': 'Listo',
    'shipped': 'Enviado',
    'delivered': 'Entregado',
    'cancelled': 'Cancelado',
  };

  static const _statusColors = {
    'pending': Color(0xFFf59e0b),
    'paid': Color(0xFF10b981),
    'ready_for_pickup': Color(0xFF8b5cf6),
    'shipped': Color(0xFF3b82f6),
    'delivered': Color(0xFF10b981),
    'cancelled': Color(0xFFef4444),
  };

  static const _statusIcons = {
    'pending': Icons.hourglass_empty,
    'paid': Icons.credit_card,
    'ready_for_pickup': Icons.storefront,
    'shipped': Icons.local_shipping,
    'delivered': Icons.check_circle_outline,
    'cancelled': Icons.cancel_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(ordersListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(ordersListProvider),
          ),
        ],
      ),
      body: ordersAsync.when(
        data: (orders) {
          final q = _searchQuery.toLowerCase();
          final filtered = orders.where((o) {
            final matchSearch =
                q.isEmpty ||
                (o['customer_name'] as String? ?? '').toLowerCase().contains(
                  q,
                ) ||
                o['id'].toString().contains(q);
            final matchStatus =
                _statusFilter == 'all' ||
                (o['status'] as String? ?? '') == _statusFilter;
            return matchSearch && matchStatus;
          }).toList();

          return Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                child: TextField(
                  onChanged: (v) => setState(() => _searchQuery = v.trim()),
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre o nº pedido…',
                    prefixIcon: const Icon(Icons.search, size: 18),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    isDense: true,
                  ),
                ),
              ),
              // Status filter chips
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ..._statusLabels.entries.map((entry) {
                        final key = entry.key;
                        final label = entry.value;
                        final color = _statusColors[key] ?? Colors.grey;
                        final icon = _statusIcons[key] ?? Icons.circle_outlined;
                        final selected = _statusFilter == key;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(label),
                            selected: selected,
                            showCheckmark: false,
                            avatar: Icon(
                              icon,
                              size: 16,
                              color: selected ? color : Colors.grey[500],
                            ),
                            selectedColor: color.withOpacity(0.15),
                            labelStyle: TextStyle(
                              color: selected ? color : null,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                            onSelected: (on) => setState(
                              () => _statusFilter = on ? key : 'all',
                            ),
                          ),
                        );
                      }),
                      if (_statusFilter != 'all')
                        IconButton(
                          onPressed: () =>
                              setState(() => _statusFilter = 'all'),
                          icon: const Icon(Icons.close, size: 18),
                          tooltip: 'Limpiar filtro',
                          style: IconButton.styleFrom(
                            foregroundColor: Colors.grey[600],
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(32, 32),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1),
              // Orders list
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _searchQuery.isNotEmpty || _statusFilter != 'all'
                                  ? 'Sin resultados para la búsqueda'
                                  : 'No hay pedidos',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          return _OrderCard(order: filtered[index]);
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text('Error: $e'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.invalidate(ordersListProvider),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;

  const _OrderCard({required this.order});

  static const _statusLabels = {
    'pending': 'Pendiente',
    'paid': 'Pagado',
    'ready_for_pickup': 'Listo recogida',
    'shipped': 'Enviado',
    'delivered': 'Entregado',
    'cancelled': 'Cancelado',
  };

  static const _statusColors = {
    'pending': Color(0xFFf59e0b),
    'paid': Color(0xFF10b981),
    'ready_for_pickup': Color(0xFF8b5cf6),
    'shipped': Color(0xFF3b82f6),
    'delivered': Color(0xFF10b981),
    'cancelled': Color(0xFFef4444),
  };

  @override
  Widget build(BuildContext context) {
    final status = order['status'] as String? ?? 'pending';
    final color = _statusColors[status] ?? Colors.grey;
    final label = _statusLabels[status] ?? status;
    final orderId = order['id'] as int? ?? 0;
    final customerName = order['customer_name'] as String? ?? '—';
    final total = ((order['total'] as num?) ?? 0) / 100.0;
    final createdAt = order['created_at'] != null
        ? DateTime.tryParse(order['created_at'] as String)
        : null;
    final items = (order['order_items'] as List?)?.length ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#${orderId.toString().padLeft(5, '0')}',
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(customerName, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (createdAt != null)
                        Text(
                          DateFormat('dd/MM/yyyy HH:mm').format(createdAt),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      const SizedBox(height: 2),
                      Text(
                        '$items artículo${items != 1 ? 's' : ''}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${total.toStringAsFixed(2)} €',
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Pantalla de gestión de categorías
class AdminCategoriesScreen extends ConsumerWidget {
  const AdminCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Implementar crear categoría
            },
          ),
        ],
      ),
      body: categoriesAsync.when(
        data: (categories) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(category.name, style: AppTextStyles.labelLarge),
                subtitle: Text(category.description ?? ''),
                trailing: const Icon(Icons.edit),
                onTap: () {
                  // TODO: Editar categoría
                },
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

/// Pantalla de configuración del admin
class AdminSettingsScreen extends ConsumerWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Flash Offers Switch
          _SettingsTile(
            icon: Icons.bolt,
            title: 'Ofertas Flash',
            subtitle: 'Activar/desactivar ofertas en la tienda',
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // TODO: Implementar toggle
              },
            ),
          ),
          const Divider(),
          _SettingsTile(
            icon: Icons.email,
            title: 'Newsletter',
            subtitle: 'Configurar suscripciones',
            trailing: const Icon(Icons.chevron_right),
          ),
          const Divider(),
          _SettingsTile(
            icon: Icons.palette,
            title: 'Apariencia',
            subtitle: 'Temas y colores',
            trailing: const Icon(Icons.chevron_right),
          ),
          const Divider(),
          _SettingsTile(
            icon: Icons.inventory,
            title: 'Umbral de Stock Bajo',
            subtitle: 'Actualmente: 5 unidades',
            trailing: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.labelLarge),
      subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
      trailing: trailing,
    );
  }
}
