import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_colors.dart';
import '../../../data/models/order.dart';
import '../../providers/order_provider.dart';
import '../../widgets/common/badge_widgets.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/loading_indicator.dart';

/// Pantalla de historial de pedidos
class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _scrollController = ScrollController();

  final List<String> _tabs = ['Todos', 'Pendientes', 'Enviados', 'Entregados'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(userOrdersProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Mis Pedidos',
        showBackButton: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.brandNavy,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.brandNavy,
            indicatorWeight: 2,
            tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
          ),
        ),
      ),
      body: ordersAsync.when(
        loading: () => const LoadingScreen(),
        error: (_, __) => _EmptyOrdersState(tabIndex: _tabController.index),
        data: (orders) {
          final filteredOrders = _filterOrders(orders);
          if (filteredOrders.isEmpty) {
            return _EmptyOrdersState(tabIndex: _tabController.index);
          }
          return _buildOrdersList(filteredOrders);
        },
      ),
    );
  }

  List<Order> _filterOrders(List<Order> orders) {
    final filter = switch (_tabController.index) {
      1 => 'pending',
      2 => 'shipped',
      3 => 'delivered',
      _ => null,
    };

    if (filter == null) return orders;
    return orders.where((order) => order.status == filter).toList();
  }

  Widget _buildOrdersList(List<Order> orders) {
    return RefreshIndicator(
      onRefresh: () => ref.refresh(userOrdersProvider.future),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _OrderCard(
              order: order,
              onTap: () => context.push('/orders/${order.id}'),
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const _OrderCard({
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con número de pedido y estado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pedido #${order.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(order.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                OrderStatusBadge(status: order.status),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Productos (preview de primeros 2-3)
            Row(
              children: [
                ...List.generate(
                  order.items.length > 3 ? 3 : order.items.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      width: 60,
                      height: 75,
                      color: AppColors.surfaceLight,
                      child: const Icon(
                        Icons.image_outlined,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                ),
                if (order.items.length > 3)
                  Container(
                    width: 60,
                    height: 75,
                    color: AppColors.surfaceLight,
                    child: Center(
                      child: Text(
                        '+${order.items.length - 3}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Footer con total y cantidad
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${order.totalItemsCount} ${order.totalItemsCount == 1 ? 'artículo' : 'artículos'}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '€${(order.total / 100).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Botón ver detalles
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onTap,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Ver detalles'),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }
}

class _EmptyOrdersState extends StatelessWidget {
  final int tabIndex;

  const _EmptyOrdersState({required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    final (title, message, icon) = switch (tabIndex) {
      1 => (
          'Sin pedidos pendientes',
          'No tienes pedidos pendientes de envío',
          Icons.hourglass_empty,
        ),
      2 => (
          'Sin pedidos enviados',
          'No tienes pedidos en camino',
          Icons.local_shipping_outlined,
        ),
      3 => (
          'Sin pedidos entregados',
          'Aún no has recibido ningún pedido',
          Icons.inventory_2_outlined,
        ),
      _ => (
          'Sin pedidos',
          '¡Realiza tu primera compra!',
          Icons.shopping_bag_outlined,
        ),
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (tabIndex == 0) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandNavy,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text('Explorar productos'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Modelo para resumen de pedido en la lista
class OrderSummary {
  final String id;
  final DateTime createdAt;
  final String status;
  final List<OrderItemSummary> items;
  final int totalAmount;
  final int totalItems;

  const OrderSummary({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.totalItems,
  });
}

class OrderItemSummary {
  final String productId;
  final String? imageUrl;

  const OrderItemSummary({
    required this.productId,
    this.imageUrl,
  });
}
