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
import '../providers/products_provider.dart';

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
                                                child: Text(
                                                  '⭐ Destacado',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors.primary,
                                                  ),
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
                Text('📐 Stock por Tallas', style: AppTextStyles.labelLarge),
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
                Text('🖼️ Imágenes', style: AppTextStyles.labelLarge),
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
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
