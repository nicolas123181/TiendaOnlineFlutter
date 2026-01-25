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

/// Dashboard Ejecutivo del Admin Panel
class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Ejecutivo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(adminStatsProvider),
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
        data: (stats) => _DashboardContent(stats: stats),
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

  const _DashboardContent({required this.stats});

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
              _KPICard(
                icon: Icons.account_balance_wallet,
                label: 'Valor Inventario',
                value: '${stats.inventoryValue.toStringAsFixed(0)} €',
                color: Colors.blue,
                gradient: const LinearGradient(
                  colors: [Color(0xFF3b82f6), Color(0xFF6366f1)],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Gráfico de Ventas
          _SalesChart(sales: stats.last7DaysSales),
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

class _SalesChart extends StatelessWidget {
  final List<DailySale> sales;

  const _SalesChart({required this.sales});

  @override
  Widget build(BuildContext context) {
    final maxSale = sales.fold<double>(
      0,
      (max, sale) => sale.amount > max ? sale.amount : max,
    );

    final totalSales = sales.fold<double>(0, (sum, sale) => sum + sale.amount);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ventas Últimos 7 Días', style: AppTextStyles.h4),
              Text(
                '${totalSales.toStringAsFixed(2)} €',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                maxY: maxSale * 1.2,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < sales.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              DateFormat('E').format(sales[value.toInt()].date),
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        }
                        return const Text('');
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
                barGroups: sales.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.amount,
                        color: AppColors.primary,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
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

/// Pantalla de productos del admin
class AdminProductsScreen extends StatelessWidget {
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: const Center(child: Text('Lista de productos - En desarrollo')),
    );
  }
}

/// Pantalla de pedidos del admin
class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos')),
      body: const Center(child: Text('Lista de pedidos - En desarrollo')),
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
