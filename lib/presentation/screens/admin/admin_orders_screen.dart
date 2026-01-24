import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';
import '../../../data/models/order.dart';
import '../../providers/order_provider.dart';

/// Pantalla de gestión de pedidos del admin
class AdminOrdersScreen extends ConsumerStatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  ConsumerState<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends ConsumerState<AdminOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  final _currencyFormat = NumberFormat.currency(symbol: '€', locale: 'es_ES');

  String _sortBy = 'date';
  bool _sortAscending = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    // Cargar pedidos iniciales
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminOrdersProvider.notifier).loadOrders(refresh: true);
    });

    // Escuchar cambios en tabs para filtrar
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final index = _tabController.index;
        String? status;
        switch (index) {
          case 1:
            status = 'pending';
            break;
          case 2:
            status = 'processing';
            break;
          case 3:
            status = 'shipped';
            break;
          case 4:
            status = 'delivered';
            break;
          default:
            status = null;
        }
        ref.read(adminOrdersProvider.notifier).filterByStatus(status);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(adminOrdersProvider);
    final isLoading = ordersState.isLoading;
    final orders = ordersState.orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: _exportOrders,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            _buildTab('Todos'),
            _buildTab('Pendientes'),
            _buildTab('En proceso'),
            _buildTab('Enviados'),
            _buildTab('Entregados'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar pedidos...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(adminOrdersProvider.notifier).search(null);
                        },
                      )
                    : null,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (value) {
                ref.read(adminOrdersProvider.notifier).search(value);
              },
            ),
          ),

          // Filtros activos
          if (ordersState.startDate != null || ordersState.endDate != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColors.brandNavy.withValues(alpha: 0.05),
              child: Chip(
                label: Text(
                  '${DateFormat('dd/MM').format(ordersState.startDate ?? DateTime.now())} - ${DateFormat('dd/MM').format(ordersState.endDate ?? DateTime.now())}',
                ),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () {
                  ref
                      .read(adminOrdersProvider.notifier)
                      .filterByDates(null, null);
                },
                backgroundColor: AppColors.brandNavy.withValues(alpha: 0.1),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero),
              ),
            ),

          // Resumen
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${ordersState.total} pedidos',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                TextButton.icon(
                  onPressed: _showSortOptions,
                  icon: Icon(
                    _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 16,
                  ),
                  label: Text(_getSortLabel()),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Lista de pedidos
          Expanded(
            child: isLoading && orders.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _buildOrdersList(orders),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label) {
    return Tab(
      child: Text(label),
    );
  }

  Widget _buildOrdersList(List<Order> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'No hay pedidos',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      );
    }

    // Apply local sort if needed
    final sortedOrders = List<Order>.from(orders);
    sortedOrders.sort((a, b) {
      int result;
      switch (_sortBy) {
        case 'date':
          result = a.createdAt.compareTo(b.createdAt);
          break;
        case 'total':
          result = a.total.compareTo(b.total);
          break;
        case 'customer':
          result = a.customerName.compareTo(b.customerName);
          break;
        default:
          result = 0;
      }
      return _sortAscending ? result : -result;
    });

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter == 0) {
          ref.read(adminOrdersProvider.notifier).loadMore();
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(adminOrdersProvider.notifier)
              .loadOrders(refresh: true);
        },
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: sortedOrders.length +
              (ref.watch(adminOrdersProvider).hasMore ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == sortedOrders.length) {
              return const Center(
                  child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ));
            }
            final order = sortedOrders[index];
            return _OrderCard(
              order: order,
              currencyFormat: _currencyFormat,
              onTap: () => context.push('/admin/orders/${order.id}'),
              onStatusChange: (newStatus) {
                // Map string status back to OrderStatus enum if needed
                // Currently updateOrderStatus takes OrderStatus enum
                // But _OrderCard popup passes String value
                // We need to convert String to OrderStatus
                try {
                  final statusEnum = OrderStatus.values.firstWhere(
                    (e) => e.name == newStatus,
                    orElse: () => OrderStatus.pending,
                  );
                  _updateOrderStatus(order.id.toString(), statusEnum);
                } catch (e) {
                  // handle error
                }
              },
            );
          },
        ),
      ),
    );
  }

  void _showFilterSheet() {
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
              'Filtrar pedidos',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text('Rango de fechas'),
              subtitle: ref.watch(adminOrdersProvider).startDate != null
                  ? Text(
                      '${DateFormat('dd/MM/yyyy').format(ref.watch(adminOrdersProvider).startDate!)} - ${DateFormat('dd/MM/yyyy').format(ref.watch(adminOrdersProvider).endDate!)}')
                  : const Text('Seleccionar'),
              onTap: () async {
                Navigator.pop(context);
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  initialDateRange:
                      ref.read(adminOrdersProvider).startDate != null
                          ? DateTimeRange(
                              start: ref.read(adminOrdersProvider).startDate!,
                              end: ref.read(adminOrdersProvider).endDate!)
                          : null,
                );
                if (range != null) {
                  ref
                      .read(adminOrdersProvider.notifier)
                      .filterByDates(range.start, range.end);
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ref
                          .read(adminOrdersProvider.notifier)
                          .filterByDates(null, null);
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text('Limpiar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandNavy,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text('Aplicar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text('Ordenar por'),
              dense: true,
            ),
            _SortOption(
              label: 'Fecha',
              value: 'date',
              currentValue: _sortBy,
              ascending: _sortAscending,
              onTap: () => _updateSort('date'),
            ),
            _SortOption(
              label: 'Total',
              value: 'total',
              currentValue: _sortBy,
              ascending: _sortAscending,
              onTap: () => _updateSort('total'),
            ),
            _SortOption(
              label: 'Cliente',
              value: 'customer',
              currentValue: _sortBy,
              ascending: _sortAscending,
              onTap: () => _updateSort('customer'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateSort(String sortBy) {
    setState(() {
      if (_sortBy == sortBy) {
        _sortAscending = !_sortAscending;
      } else {
        _sortBy = sortBy;
        _sortAscending = true;
      }
    });
    Navigator.pop(context);
  }

  String _getSortLabel() {
    switch (_sortBy) {
      case 'date':
        return 'Fecha';
      case 'total':
        return 'Total';
      case 'customer':
        return 'Cliente';
      default:
        return 'Ordenar';
    }
  }

  void _exportOrders() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exportando pedidos...')),
    );
  }

  void _updateOrderStatus(String orderId, OrderStatus newStatus) {
    ref
        .read(adminOrdersProvider.notifier)
        .updateOrderStatus(orderId, newStatus);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Pedido actualizado a: ${newStatus.name}')), // Display simplified name
    );
  }
}

// Widgets auxiliares
class _OrderCard extends StatelessWidget {
  final Order order;
  final NumberFormat currencyFormat;
  final VoidCallback onTap;
  final Function(String) onStatusChange;

  const _OrderCard({
    required this.order,
    required this.currencyFormat,
    required this.onTap,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    // Colores según estado
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (order.status) {
      case 'pending':
        statusColor = AppColors.warning;
        statusText = 'Pendiente';
        statusIcon = Icons.hourglass_empty;
        break;
      case 'processing':
        statusColor = AppColors.info;
        statusText = 'Procesando';
        statusIcon = Icons.sync;
        break;
      case 'shipped':
        statusColor = AppColors.brandNavy;
        statusText = 'Enviado';
        statusIcon = Icons.local_shipping;
        break;
      case 'delivered':
        statusColor = AppColors.success;
        statusText = 'Entregado';
        statusIcon = Icons.check_circle;
        break;
      case 'cancelled':
        statusColor = AppColors.error;
        statusText = 'Cancelado';
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = AppColors.textSecondary;
        statusText = order.status;
        statusIcon = Icons.info;
    }

    // Payment Info (Simplified/Inferred)
    // Order model doesn't specify payment status, assuming paid if not pending/cancelled?
    Color paymentColor;
    String paymentText;

    // Logic: if status is pending -> payment pending? If paid -> paid.
    // We can use status for now.
    if (order.status == 'pending') {
      paymentColor = AppColors.warning;
      paymentText = 'Pago pendiente';
    } else if (order.status == 'cancelled') {
      paymentColor = AppColors.error;
      paymentText = 'Cancelado';
    } else {
      paymentColor = AppColors.success;
      paymentText = 'Pagado';
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${order.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateFormat.format(order.createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
                PopupMenuButton<String>(
                  onSelected: onStatusChange,
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'pending',
                      child: Text('Marcar pendiente'),
                    ),
                    const PopupMenuItem(
                      value: 'processing',
                      child: Text('Marcar en proceso'),
                    ),
                    const PopupMenuItem(
                      value: 'shipped',
                      child: Text('Marcar enviado'),
                    ),
                    const PopupMenuItem(
                      value: 'delivered',
                      child: Text('Marcar entregado'),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'cancelled',
                      child: Text('Cancelar pedido'),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 14, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_drop_down,
                            size: 16, color: statusColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Cliente
            Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.brandNavy,
                  child: Icon(Icons.person, size: 18, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.customerName,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        order.customerEmail,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      color: paymentColor.withValues(alpha: 0.1),
                      child: Text(
                        paymentText,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: paymentColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${order.totalItemsCount} artículo${order.totalItemsCount != 1 ? 's' : ''}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
                Text(
                  currencyFormat.format(order.total / 100),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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

class _SortOption extends StatelessWidget {
  final String label;
  final String value;
  final String currentValue;
  final bool ascending;
  final VoidCallback onTap;

  const _SortOption({
    required this.label,
    required this.value,
    required this.currentValue,
    required this.ascending,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentValue == value;

    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.brandNavy : AppColors.textPrimary,
        ),
      ),
      trailing: isSelected
          ? Icon(
              ascending ? Icons.arrow_upward : Icons.arrow_downward,
              color: AppColors.brandNavy,
              size: 20,
            )
          : null,
      onTap: onTap,
    );
  }
}
