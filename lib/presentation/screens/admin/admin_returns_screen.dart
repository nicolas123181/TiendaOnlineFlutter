import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';

/// Pantalla de gestión de devoluciones del admin
class AdminReturnsScreen extends ConsumerStatefulWidget {
  const AdminReturnsScreen({super.key});

  @override
  ConsumerState<AdminReturnsScreen> createState() => _AdminReturnsScreenState();
}

class _AdminReturnsScreenState extends ConsumerState<AdminReturnsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  final _currencyFormat = NumberFormat.currency(symbol: '€');

  // Datos de ejemplo
  final List<_ReturnData> _returns = [
    _ReturnData(
      id: 'RET-2024-0001',
      orderId: 'VNT-2024-001234',
      customer: 'Carlos García',
      reason: 'Talla incorrecta',
      status: 'pending',
      requestDate: DateTime.now().subtract(const Duration(hours: 5)),
      total: 199.00,
      items: 1,
    ),
    _ReturnData(
      id: 'RET-2024-0002',
      orderId: 'VNT-2024-001230',
      customer: 'María López',
      reason: 'Defecto de fábrica',
      status: 'approved',
      requestDate: DateTime.now().subtract(const Duration(days: 1)),
      total: 89.90,
      items: 1,
    ),
    _ReturnData(
      id: 'RET-2024-0003',
      orderId: 'VNT-2024-001225',
      customer: 'Juan Martínez',
      reason: 'No es lo que esperaba',
      status: 'received',
      requestDate: DateTime.now().subtract(const Duration(days: 3)),
      total: 149.90,
      items: 2,
    ),
    _ReturnData(
      id: 'RET-2024-0004',
      orderId: 'VNT-2024-001220',
      customer: 'Ana Ruiz',
      reason: 'Color diferente al mostrado',
      status: 'refunded',
      requestDate: DateTime.now().subtract(const Duration(days: 5)),
      total: 79.90,
      items: 1,
    ),
    _ReturnData(
      id: 'RET-2024-0005',
      orderId: 'VNT-2024-001215',
      customer: 'Pedro Sánchez',
      reason: 'Producto dañado en envío',
      status: 'rejected',
      requestDate: DateTime.now().subtract(const Duration(days: 7)),
      total: 259.00,
      items: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Devoluciones'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: _exportReturns,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            _buildTab('Todas', _returns.length),
            _buildTab('Pendientes',
                _returns.where((r) => r.status == 'pending').length),
            _buildTab('Aprobadas',
                _returns.where((r) => r.status == 'approved').length),
            _buildTab('Recibidas',
                _returns.where((r) => r.status == 'received').length),
            _buildTab('Completadas',
                _returns.where((r) => r.status == 'refunded').length),
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
                hintText: 'Buscar devoluciones...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),

          // Lista de devoluciones
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildReturnsList(null),
                _buildReturnsList('pending'),
                _buildReturnsList('approved'),
                _buildReturnsList('received'),
                _buildReturnsList('refunded'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int count) {
    return Tab(
      child: Row(
        children: [
          Text(label),
          if (count > 0) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.brandNavy.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReturnsList(String? statusFilter) {
    var returns = _returns.where((r) {
      // Filtrar por búsqueda
      if (_searchController.text.isNotEmpty) {
        final query = _searchController.text.toLowerCase();
        if (!r.id.toLowerCase().contains(query) &&
            !r.orderId.toLowerCase().contains(query) &&
            !r.customer.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Filtrar por estado
      if (statusFilter != null && r.status != statusFilter) {
        return false;
      }

      return true;
    }).toList();

    if (returns.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_return_outlined,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'No hay devoluciones',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: returns.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final returnItem = returns[index];
          return _ReturnCard(
            returnData: returnItem,
            currencyFormat: _currencyFormat,
            onTap: () => _showReturnDetail(returnItem),
            onStatusChange: (newStatus) =>
                _updateReturnStatus(returnItem.id, newStatus),
          );
        },
      ),
    );
  }

  void _showReturnDetail(_ReturnData returnData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => _ReturnDetailSheet(
          returnData: returnData,
          currencyFormat: _currencyFormat,
          scrollController: scrollController,
          onStatusChange: (newStatus) {
            Navigator.pop(context);
            _updateReturnStatus(returnData.id, newStatus);
          },
        ),
      ),
    );
  }

  void _updateReturnStatus(String returnId, String newStatus) {
    setState(() {
      final index = _returns.indexWhere((r) => r.id == returnId);
      if (index != -1) {
        _returns[index] = _ReturnData(
          id: _returns[index].id,
          orderId: _returns[index].orderId,
          customer: _returns[index].customer,
          reason: _returns[index].reason,
          status: newStatus,
          requestDate: _returns[index].requestDate,
          total: _returns[index].total,
          items: _returns[index].items,
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Devolución actualizada: $newStatus')),
    );
  }

  void _exportReturns() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exportando devoluciones...')),
    );
  }
}

// Modelo de datos
class _ReturnData {
  final String id;
  final String orderId;
  final String customer;
  final String reason;
  final String status;
  final DateTime requestDate;
  final double total;
  final int items;

  _ReturnData({
    required this.id,
    required this.orderId,
    required this.customer,
    required this.reason,
    required this.status,
    required this.requestDate,
    required this.total,
    required this.items,
  });
}

// Widgets auxiliares
class _ReturnCard extends StatelessWidget {
  final _ReturnData returnData;
  final NumberFormat currencyFormat;
  final VoidCallback onTap;
  final Function(String) onStatusChange;

  const _ReturnCard({
    required this.returnData,
    required this.currencyFormat,
    required this.onTap,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    // Colores según estado
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (returnData.status) {
      case 'pending':
        statusColor = AppColors.warning;
        statusText = 'Pendiente';
        statusIcon = Icons.hourglass_empty;
        break;
      case 'approved':
        statusColor = AppColors.info;
        statusText = 'Aprobada';
        statusIcon = Icons.check_circle_outline;
        break;
      case 'received':
        statusColor = AppColors.brandNavy;
        statusText = 'Recibida';
        statusIcon = Icons.inventory_2;
        break;
      case 'refunded':
        statusColor = AppColors.success;
        statusText = 'Reembolsada';
        statusIcon = Icons.paid;
        break;
      case 'rejected':
        statusColor = AppColors.error;
        statusText = 'Rechazada';
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = AppColors.textSecondary;
        statusText = returnData.status;
        statusIcon = Icons.info;
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
                      returnData.id,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Pedido: ${returnData.orderId}',
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
                      value: 'approved',
                      child: Text('Aprobar'),
                    ),
                    const PopupMenuItem(
                      value: 'received',
                      child: Text('Marcar recibida'),
                    ),
                    const PopupMenuItem(
                      value: 'refunded',
                      child: Text('Procesar reembolso'),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'rejected',
                      child: Text('Rechazar'),
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

            // Info
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        returnData.customer,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        returnData.reason,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      currencyFormat.format(returnData.total),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      dateFormat.format(returnData.requestDate),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReturnDetailSheet extends StatelessWidget {
  final _ReturnData returnData;
  final NumberFormat currencyFormat;
  final ScrollController scrollController;
  final Function(String) onStatusChange;

  const _ReturnDetailSheet({
    required this.returnData,
    required this.currencyFormat,
    required this.scrollController,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    // Colores según estado
    Color statusColor;
    String statusText;

    switch (returnData.status) {
      case 'pending':
        statusColor = AppColors.warning;
        statusText = 'Pendiente de revisión';
        break;
      case 'approved':
        statusColor = AppColors.info;
        statusText = 'Aprobada - Esperando producto';
        break;
      case 'received':
        statusColor = AppColors.brandNavy;
        statusText = 'Producto recibido';
        break;
      case 'refunded':
        statusColor = AppColors.success;
        statusText = 'Reembolso completado';
        break;
      case 'rejected':
        statusColor = AppColors.error;
        statusText = 'Rechazada';
        break;
      default:
        statusColor = AppColors.textSecondary;
        statusText = returnData.status;
    }

    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Devolución ${returnData.id}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Content
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Estado actual
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      border:
                          Border.all(color: statusColor.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: statusColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                statusText,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                              Text(
                                'Solicitada: ${dateFormat.format(returnData.requestDate)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: statusColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Información del pedido
                  _SectionTitle(title: 'Pedido original'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          returnData.orderId,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            context.push('/admin/orders/${returnData.orderId}');
                          },
                          child: const Text('Ver pedido'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Motivo
                  _SectionTitle(title: 'Motivo de la devolución'),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(returnData.reason),
                  ),
                  const SizedBox(height: 24),

                  // Artículos a devolver
                  _SectionTitle(title: 'Artículos (${returnData.items})'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          color: AppColors.brandNavy.withValues(alpha: 0.1),
                          child: const Center(
                            child: Icon(Icons.image,
                                color: AppColors.textTertiary),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Producto de ejemplo',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'Talla M / Color Navy',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          currencyFormat.format(returnData.total),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Importe a reembolsar
                  _SectionTitle(title: 'Importe a reembolsar'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          currencyFormat.format(returnData.total),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Notas internas
                  _SectionTitle(title: 'Notas internas'),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Añadir notas sobre esta devolución...',
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Bottom actions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  if (returnData.status == 'pending') ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _confirmReject(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: const Text('Rechazar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () => onStatusChange('approved'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: const Text('Aprobar'),
                      ),
                    ),
                  ] else if (returnData.status == 'approved') ...[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => onStatusChange('received'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandNavy,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: const Text('Marcar como recibida'),
                      ),
                    ),
                  ] else if (returnData.status == 'received') ...[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => onStatusChange('refunded'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: const Text('Procesar reembolso'),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: const Text('Cerrar'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmReject(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('Rechazar devolución'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                '¿Estás seguro de rechazar esta devolución? Se notificará al cliente.'),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Motivo del rechazo',
                hintText: 'Explica por qué se rechaza...',
                border: OutlineInputBorder(borderRadius: BorderRadius.zero),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              onStatusChange('rejected');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text('Rechazar'),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
    );
  }
}
