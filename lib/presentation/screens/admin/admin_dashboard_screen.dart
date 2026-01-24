import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';
import '../../providers/dashboard_stats_provider.dart';

/// Dashboard principal del panel de administración
class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  final _currencyFormat = NumberFormat.currency(symbol: '€');
  String _selectedPeriod = 'Hoy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => _showNotifications(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/admin/settings'),
          ),
        ],
      ),
      drawer: _buildAdminDrawer(context),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(dashboardStatsProvider.notifier).refresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Saludo y fecha
              _buildHeader(),
              const SizedBox(height: 24),

              // Selector de período
              _buildPeriodSelector(),
              const SizedBox(height: 16),

              // Tarjetas de estadísticas principales
              _buildStatsGrid(),
              const SizedBox(height: 24),

              // Gráfico de ventas
              _buildSalesChart(),
              const SizedBox(height: 24),

              // Pedidos recientes
              _buildRecentOrders(),
              const SizedBox(height: 24),

              // Productos más vendidos
              _buildTopProducts(),
              const SizedBox(height: 24),

              // Acciones rápidas
              _buildQuickActions(),
              const SizedBox(height: 24),

              // Alertas y notificaciones
              _buildAlerts(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminDrawer(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.brandNavy),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.admin_panel_settings,
                      color: Colors.white, size: 32),
                ),
                const SizedBox(height: 12),
                const Text(
                  'VANTAGE Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'admin@vantage.com',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _DrawerItem(
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            isSelected: true,
            onTap: () => Navigator.pop(context),
          ),
          _DrawerItem(
            icon: Icons.inventory_2_outlined,
            title: 'Productos',
            onTap: () {
              Navigator.pop(context);
              context.push('/admin/products');
            },
          ),
          _DrawerItem(
            icon: Icons.shopping_bag_outlined,
            title: 'Pedidos',
            badge: '5',
            onTap: () {
              Navigator.pop(context);
              context.push('/admin/orders');
            },
          ),
          _DrawerItem(
            icon: Icons.assignment_return_outlined,
            title: 'Devoluciones',
            badge: '2',
            onTap: () {
              Navigator.pop(context);
              context.push('/admin/returns');
            },
          ),
          _DrawerItem(
            icon: Icons.category_outlined,
            title: 'Categorías',
            onTap: () {
              Navigator.pop(context);
              context.push('/admin/categories');
            },
          ),
          _DrawerItem(
            icon: Icons.local_offer_outlined,
            title: 'Cupones',
            onTap: () {
              Navigator.pop(context);
              context.push('/admin/coupons');
            },
          ),
          const Divider(),
          _DrawerItem(
            icon: Icons.people_outline,
            title: 'Clientes',
            onTap: () {
              Navigator.pop(context);
              context.push('/admin/customers');
            },
          ),
          _DrawerItem(
            icon: Icons.email_outlined,
            title: 'Newsletter',
            onTap: () {
              Navigator.pop(context);
              context.push('/admin/newsletter');
            },
          ),
          _DrawerItem(
            icon: Icons.local_shipping_outlined,
            title: 'Envíos',
            onTap: () {
              Navigator.pop(context);
              context.push('/admin/shipping');
            },
          ),
          const Divider(),
          _DrawerItem(
            icon: Icons.analytics_outlined,
            title: 'Informes',
            onTap: () {
              Navigator.pop(context);
              context.push('/admin/reports');
            },
          ),
          _DrawerItem(
            icon: Icons.settings_outlined,
            title: 'Configuración',
            onTap: () {
              Navigator.pop(context);
              context.push('/admin/settings');
            },
          ),
          const Divider(),
          _DrawerItem(
            icon: Icons.storefront_outlined,
            title: 'Ver tienda',
            onTap: () {
              Navigator.pop(context);
              context.go('/');
            },
          ),
          _DrawerItem(
            icon: Icons.logout,
            title: 'Cerrar sesión',
            onTap: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE, d MMMM yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getGreeting(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          dateFormat.format(now),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días, Admin';
    if (hour < 18) return 'Buenas tardes, Admin';
    return 'Buenas noches, Admin';
  }

  Widget _buildPeriodSelector() {
    final periods = ['Hoy', '7 días', '30 días', 'Este año'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: periods.map((period) {
          final isSelected = _selectedPeriod == period;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(period),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedPeriod = period);
              },
              backgroundColor: Theme.of(context).cardColor,
              selectedColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              side: BorderSide.none,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatsGrid() {
    final dashboardStats = ref.watch(dashboardStatsProvider);

    if (dashboardStats.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    final stats = [
      _StatData(
        title: 'Ventas Totales',
        value: _currencyFormat.format(dashboardStats.totalSales / 100),
        change: '',
        isPositive: true,
        icon: Icons.euro,
        color: Theme.of(context)
            .colorScheme
            .primary, // Usar primary en lugar de brandGold
      ),
      _StatData(
        title: 'Pedidos',
        value: '${dashboardStats.totalOrders}',
        change: '${dashboardStats.pendingOrders} pendientes',
        isPositive: true,
        icon: Icons.shopping_bag,
        color: AppColors
            .success, // Mantener colores semánticos pero tal vez necesitarían ajuste
      ),
      _StatData(
        title: 'Stock Bajo',
        value: '${dashboardStats.lowStockProducts}',
        change: 'productos',
        isPositive: dashboardStats.lowStockProducts == 0,
        icon: Icons.inventory_2,
        color: dashboardStats.lowStockProducts > 0
            ? Theme.of(context)
                .colorScheme
                .tertiary // Usar tertiary (naranja/ámbar en tema)
            : Theme.of(context).colorScheme.secondary,
      ),
      _StatData(
        title: 'Devoluciones',
        value: '${dashboardStats.pendingReturns}',
        change: 'pendientes',
        isPositive: dashboardStats.pendingReturns == 0,
        icon: Icons.assignment_return,
        color: dashboardStats.pendingReturns > 0
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.secondary,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) => _StatCard(data: stats[index]),
    );
  }

  Widget _buildSalesChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ventas',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () => context.push('/admin/reports'),
                child: const Text('Ver informes'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Gráfico simplificado - barras
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final heights = [0.4, 0.6, 0.5, 0.8, 0.7, 0.9, 0.75];
                final days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 160 * heights[index],
                          decoration: BoxDecoration(
                            color: index == 5
                                ? AppColors.brandGold
                                : AppColors.brandNavy.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          days[index],
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrders() {
    final dashboardStats = ref.watch(dashboardStatsProvider);
    final recentOrders = dashboardStats.recentOrders;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pedidos recientes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () => context.push('/admin/orders'),
                child: const Text('Ver todos'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (recentOrders.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No hay pedidos recientes'),
            )
          else
            ...recentOrders.map((order) => _RecentOrderTileReal(order: order)),
        ],
      ),
    );
  }

  Widget _buildTopProducts() {
    final dashboardStats = ref.watch(dashboardStatsProvider);
    final topProducts = dashboardStats.topProducts;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Productos más vendidos',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () => context.push('/admin/products'),
                child: const Text('Ver productos'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (topProducts.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No hay datos de ventas'),
            )
          else
            ...topProducts.asMap().entries.map((entry) {
              final index = entry.key;
              final product = entry.value;
              return _TopProductTileReal(product: product, rank: index + 1);
            }),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      _QuickAction(
        icon: Icons.add_box_outlined,
        label: 'Nuevo producto',
        onTap: () => context.push('/admin/products/new'),
      ),
      _QuickAction(
        icon: Icons.confirmation_num_outlined,
        label: 'Crear cupón',
        onTap: () => context.push('/admin/coupons/new'),
      ),
      _QuickAction(
        icon: Icons.campaign_outlined,
        label: 'Enviar newsletter',
        onTap: () => context.push('/admin/newsletter/new'),
      ),
      _QuickAction(
        icon: Icons.bar_chart_outlined,
        label: 'Ver informes',
        onTap: () => context.push('/admin/reports'),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones rápidas',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: actions.map((action) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _QuickActionCard(action: action),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAlerts() {
    final dashboardStats = ref.watch(dashboardStatsProvider);
    final alerts = <_AlertData>[];

    if (dashboardStats.lowStockProducts > 0) {
      alerts.add(_AlertData(
        message: '${dashboardStats.lowStockProducts} productos con stock bajo',
        route: '/admin/products?filter=low-stock',
      ));
    }

    if (dashboardStats.pendingReturns > 0) {
      alerts.add(_AlertData(
        message: '${dashboardStats.pendingReturns} devoluciones pendientes',
        route: '/admin/returns',
      ));
    }

    if (dashboardStats.pendingOrders > 0) {
      alerts.add(_AlertData(
        message: '${dashboardStats.pendingOrders} pedidos pendientes',
        route: '/admin/orders?status=pending',
      ));
    }

    if (alerts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber, color: AppColors.warning),
              const SizedBox(width: 8),
              Text(
                'Alertas',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...alerts.map((alert) => _AlertItem(
                message: alert.message,
                onTap: () => context.push(alert.route),
              )),
        ],
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notificaciones',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.success,
                child: Icon(Icons.shopping_bag, color: Colors.white, size: 20),
              ),
              title: const Text('Nuevo pedido recibido'),
              subtitle: const Text('VNT-2024-001234 • Hace 2 horas'),
              onTap: () {
                Navigator.pop(context);
                context.push('/admin/orders/VNT-2024-001234');
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.warning,
                child: Icon(Icons.inventory_2, color: Colors.white, size: 20),
              ),
              title: const Text('Stock bajo'),
              subtitle: const Text('Chaqueta Premium Navy • 3 unidades'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}

// Modelos de datos auxiliares
class _StatData {
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final IconData icon;
  final Color color;

  _StatData({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
    required this.color,
  });
}

class _QuickAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

// Widgets auxiliares
class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? badge;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    this.badge,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).iconTheme.color,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      trailing: badge != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badge!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      selected: isSelected,
      selectedTileColor: AppColors.brandNavy.withValues(alpha: 0.1),
      onTap: onTap,
    );
  }
}

class _StatCard extends StatelessWidget {
  final _StatData data;

  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: data.color.withValues(alpha: 0.1),
                ),
                child: Icon(data.icon, color: data.color, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: data.isPositive
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.error.withValues(alpha: 0.1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      data.isPositive
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      size: 12,
                      color:
                          data.isPositive ? AppColors.success : AppColors.error,
                    ),
                    Text(
                      data.change,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: data.isPositive
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                data.title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final _QuickAction action;

  const _QuickActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action.onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          children: [
            Icon(action.icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 4),
            Text(
              action.label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertItem extends StatelessWidget {
  final String message;
  final VoidCallback onTap;

  const _AlertItem({required this.message, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            const Icon(Icons.circle, size: 6, color: AppColors.warning),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
            const Icon(Icons.chevron_right,
                size: 20, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

// Clase para alertas dinámicas
class _AlertData {
  final String message;
  final String route;

  _AlertData({required this.message, required this.route});
}

// Widget para pedidos recientes con datos reales
class _RecentOrderTileReal extends StatelessWidget {
  final RecentOrder order;

  const _RecentOrderTileReal({required this.order});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '€');

    Color statusColor;

    switch (order.status) {
      case 'pending':
        statusColor = AppColors.warning;
        break;
      case 'paid':
        statusColor = AppColors.info;
        break;
      case 'shipped':
        statusColor = AppColors.success;
        break;
      case 'delivered':
        statusColor = AppColors.success;
        break;
      case 'cancelled':
        statusColor = AppColors.error;
        break;
      default:
        statusColor = Theme.of(context).colorScheme.onSurfaceVariant;
    }

    return InkWell(
      onTap: () => context.push('/admin/orders/${order.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#${order.id}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    order.customerName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currencyFormat.format(order.total / 100),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  color: statusColor.withValues(alpha: 0.1),
                  child: Text(
                    order.statusText,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
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

// Widget para productos top con datos reales
class _TopProductTileReal extends StatelessWidget {
  final TopProduct product;
  final int rank;

  const _TopProductTileReal({required this.product, required this.rank});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '€');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: rank == 1
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: Text(
              '$rank',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: rank == 1
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${product.totalSold} ventas',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Text(
            currencyFormat.format(product.revenue / 100),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
