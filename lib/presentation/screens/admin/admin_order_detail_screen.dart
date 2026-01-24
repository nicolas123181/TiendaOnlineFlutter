import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../config/app_colors.dart';

/// Pantalla de detalle de pedido para admin
class AdminOrderDetailScreen extends ConsumerStatefulWidget {
  final String orderId;

  const AdminOrderDetailScreen({super.key, required this.orderId});

  @override
  ConsumerState<AdminOrderDetailScreen> createState() =>
      _AdminOrderDetailScreenState();
}

class _AdminOrderDetailScreenState
    extends ConsumerState<AdminOrderDetailScreen> {
  final _currencyFormat = NumberFormat.currency(symbol: '€');
  final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  bool _isLoading = false;

  // Datos de ejemplo
  late _OrderDetail _order;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  void _loadOrder() {
    // TODO: Cargar desde repositorio
    _order = _OrderDetail(
      id: widget.orderId,
      status: 'processing',
      paymentStatus: 'paid',
      paymentMethod: 'Tarjeta de crédito (**** 4242)',
      customer: _CustomerInfo(
        name: 'Carlos García',
        email: 'carlos@email.com',
        phone: '+34 612 345 678',
      ),
      shippingAddress: _AddressInfo(
        name: 'Carlos García',
        street: 'Calle Mayor 123, 2º A',
        city: 'Madrid',
        postalCode: '28001',
        country: 'España',
        phone: '+34 612 345 678',
      ),
      billingAddress: _AddressInfo(
        name: 'Carlos García',
        street: 'Calle Mayor 123, 2º A',
        city: 'Madrid',
        postalCode: '28001',
        country: 'España',
        phone: '+34 612 345 678',
      ),
      items: [
        _OrderItem(
          id: 'ITEM-001',
          productId: 'PROD-001',
          name: 'Chaqueta Premium Navy',
          variant: 'M / Navy',
          price: 199.00,
          quantity: 1,
          imageUrl: 'https://example.com/jacket.jpg',
        ),
        _OrderItem(
          id: 'ITEM-002',
          productId: 'PROD-002',
          name: 'Camisa Oxford Blanca',
          variant: 'L / Blanco',
          price: 89.90,
          quantity: 1,
          imageUrl: 'https://example.com/shirt.jpg',
        ),
      ],
      subtotal: 288.90,
      shippingCost: 0.00,
      discount: 28.89,
      couponCode: 'VANTAGE10',
      total: 260.01,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      notes: 'Por favor, entregar por la tarde.',
      tracking: _TrackingInfo(
        carrier: 'MRW',
        trackingNumber: 'MRW123456789',
        estimatedDelivery: DateTime.now().add(const Duration(days: 3)),
      ),
      timeline: [
        _TimelineEvent(
          status: 'created',
          date: DateTime.now().subtract(const Duration(hours: 5)),
          description: 'Pedido creado',
        ),
        _TimelineEvent(
          status: 'paid',
          date: DateTime.now().subtract(const Duration(hours: 5)),
          description: 'Pago confirmado',
        ),
        _TimelineEvent(
          status: 'processing',
          date: DateTime.now().subtract(const Duration(hours: 2)),
          description: 'Pedido en preparación',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido ${widget.orderId}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print_outlined),
            onPressed: _printOrder,
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'invoice',
                child: Text('Generar factura'),
              ),
              const PopupMenuItem(
                value: 'email',
                child: Text('Enviar email al cliente'),
              ),
              const PopupMenuItem(
                value: 'refund',
                child: Text('Procesar reembolso'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'cancel',
                child: Text('Cancelar pedido'),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Estado y acciones rápidas
                  _buildStatusSection(),
                  const SizedBox(height: 24),

                  // Timeline
                  _buildTimelineSection(),
                  const SizedBox(height: 24),

                  // Artículos
                  _buildItemsSection(),
                  const SizedBox(height: 24),

                  // Resumen de pago
                  _buildPaymentSummary(),
                  const SizedBox(height: 24),

                  // Información del cliente
                  _buildCustomerSection(),
                  const SizedBox(height: 24),

                  // Direcciones
                  _buildAddressesSection(),
                  const SizedBox(height: 24),

                  // Envío
                  if (_order.tracking != null) ...[
                    _buildShippingSection(),
                    const SizedBox(height: 24),
                  ],

                  // Notas
                  if (_order.notes != null && _order.notes!.isNotEmpty) ...[
                    _buildNotesSection(),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildStatusSection() {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (_order.status) {
      case 'pending':
        statusColor = AppColors.warning;
        statusText = 'Pendiente';
        statusIcon = Icons.hourglass_empty;
        break;
      case 'processing':
        statusColor = AppColors.info;
        statusText = 'En preparación';
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
        statusText = _order.status;
        statusIcon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Actualizado: ${_dateFormat.format(_order.updatedAt)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: _changeStatus,
            style: OutlinedButton.styleFrom(
              foregroundColor: statusColor,
              side: BorderSide(color: statusColor),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text('Cambiar'),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection() {
    return _SectionCard(
      title: 'Historial',
      child: Column(
        children: _order.timeline.asMap().entries.map((entry) {
          final index = entry.key;
          final event = entry.value;
          final isLast = index == _order.timeline.length - 1;

          return _TimelineItem(
            event: event,
            isLast: isLast,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildItemsSection() {
    return _SectionCard(
      title: 'Artículos (${_order.items.length})',
      child: Column(
        children: _order.items.map((item) {
          return _OrderItemTile(
            item: item,
            currencyFormat: _currencyFormat,
            onTap: () => context.push('/admin/products/${item.productId}'),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return _SectionCard(
      title: 'Resumen de pago',
      child: Column(
        children: [
          // Método de pago
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _order.paymentStatus == 'paid'
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.warning.withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    Icons.credit_card,
                    color: _order.paymentStatus == 'paid'
                        ? AppColors.success
                        : AppColors.warning,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _order.paymentMethod,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        _order.paymentStatus == 'paid'
                            ? 'Pagado'
                            : 'Pago pendiente',
                        style: TextStyle(
                          fontSize: 12,
                          color: _order.paymentStatus == 'paid'
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Desglose
          _PriceRow(label: 'Subtotal', value: _order.subtotal),
          if (_order.discount > 0) ...[
            const SizedBox(height: 8),
            _PriceRow(
              label:
                  'Descuento${_order.couponCode != null ? ' (${_order.couponCode})' : ''}',
              value: -_order.discount,
              isDiscount: true,
            ),
          ],
          const SizedBox(height: 8),
          _PriceRow(
            label: 'Envío',
            value: _order.shippingCost,
            isFree: _order.shippingCost == 0,
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          _PriceRow(label: 'Total', value: _order.total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildCustomerSection() {
    return _SectionCard(
      title: 'Cliente',
      trailing: TextButton(
        onPressed: () {
          // TODO: Ver perfil del cliente
        },
        child: const Text('Ver perfil'),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.brandNavy,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _order.customer.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.email_outlined,
                        size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      _order.customer.email,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.phone_outlined,
                        size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      _order.customer.phone,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.email_outlined),
                onPressed: () {
                  // TODO: Enviar email
                },
              ),
              IconButton(
                icon: const Icon(Icons.phone_outlined),
                onPressed: () {
                  // TODO: Llamar
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressesSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _SectionCard(
            title: 'Dirección de envío',
            child: _AddressDisplay(address: _order.shippingAddress),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SectionCard(
            title: 'Dirección de facturación',
            child: _AddressDisplay(address: _order.billingAddress),
          ),
        ),
      ],
    );
  }

  Widget _buildShippingSection() {
    final tracking = _order.tracking!;

    return _SectionCard(
      title: 'Información de envío',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.brandNavy.withValues(alpha: 0.1),
                ),
                child: const Icon(
                  Icons.local_shipping,
                  color: AppColors.brandNavy,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tracking.carrier,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          tracking.trackingNumber,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: tracking.trackingNumber),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Número de seguimiento copiado'),
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.copy,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  // TODO: Abrir tracking externo
                },
                style: OutlinedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text('Rastrear'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            color: AppColors.success.withValues(alpha: 0.1),
            child: Row(
              children: [
                const Icon(Icons.schedule, color: AppColors.success, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Entrega estimada: ${DateFormat('dd/MM/yyyy').format(tracking.estimatedDelivery)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return _SectionCard(
      title: 'Notas del cliente',
      child: Container(
        padding: const EdgeInsets.all(12),
        color: AppColors.brandGold.withValues(alpha: 0.1),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.note_outlined, color: AppColors.brandGold),
            const SizedBox(width: 12),
            Expanded(child: Text(_order.notes!)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _addTrackingInfo,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text('Añadir tracking'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _markAsShipped,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandNavy,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text('Marcar enviado'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeStatus() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Cambiar estado',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _StatusOption(
              status: 'pending',
              label: 'Pendiente',
              icon: Icons.hourglass_empty,
              color: AppColors.warning,
              isSelected: _order.status == 'pending',
              onTap: () => _updateStatus('pending'),
            ),
            _StatusOption(
              status: 'processing',
              label: 'En preparación',
              icon: Icons.sync,
              color: AppColors.info,
              isSelected: _order.status == 'processing',
              onTap: () => _updateStatus('processing'),
            ),
            _StatusOption(
              status: 'shipped',
              label: 'Enviado',
              icon: Icons.local_shipping,
              color: AppColors.brandNavy,
              isSelected: _order.status == 'shipped',
              onTap: () => _updateStatus('shipped'),
            ),
            _StatusOption(
              status: 'delivered',
              label: 'Entregado',
              icon: Icons.check_circle,
              color: AppColors.success,
              isSelected: _order.status == 'delivered',
              onTap: () => _updateStatus('delivered'),
            ),
            const Divider(),
            _StatusOption(
              status: 'cancelled',
              label: 'Cancelar pedido',
              icon: Icons.cancel,
              color: AppColors.error,
              isSelected: _order.status == 'cancelled',
              onTap: () => _confirmCancel(),
            ),
          ],
        ),
      ),
    );
  }

  void _updateStatus(String newStatus) {
    Navigator.pop(context);
    setState(() {
      _order = _OrderDetail(
        id: _order.id,
        status: newStatus,
        paymentStatus: _order.paymentStatus,
        paymentMethod: _order.paymentMethod,
        customer: _order.customer,
        shippingAddress: _order.shippingAddress,
        billingAddress: _order.billingAddress,
        items: _order.items,
        subtotal: _order.subtotal,
        shippingCost: _order.shippingCost,
        discount: _order.discount,
        couponCode: _order.couponCode,
        total: _order.total,
        createdAt: _order.createdAt,
        updatedAt: DateTime.now(),
        notes: _order.notes,
        tracking: _order.tracking,
        timeline: [
          ..._order.timeline,
          _TimelineEvent(
            status: newStatus,
            date: DateTime.now(),
            description: 'Estado actualizado a $newStatus',
          ),
        ],
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Estado actualizado')),
    );
  }

  void _confirmCancel() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('Cancelar pedido'),
        content: const Text(
          '¿Estás seguro de cancelar este pedido? Se notificará al cliente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, volver'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updateStatus('cancelled');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );
  }

  void _printOrder() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preparando impresión...')),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'invoice':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Generando factura...')),
        );
        break;
      case 'email':
        // TODO: Enviar email
        break;
      case 'refund':
        _showRefundDialog();
        break;
      case 'cancel':
        _confirmCancel();
        break;
    }
  }

  void _showRefundDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('Procesar reembolso'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Total del pedido: ${_currencyFormat.format(_order.total)}'),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Cantidad a reembolsar',
                prefixText: '€ ',
                border: OutlineInputBorder(borderRadius: BorderRadius.zero),
              ),
              keyboardType: TextInputType.number,
              initialValue: _order.total.toStringAsFixed(2),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reembolso procesado')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandNavy,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text('Reembolsar'),
          ),
        ],
      ),
    );
  }

  void _addTrackingInfo() {
    final carrierController = TextEditingController();
    final trackingController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text('Añadir información de envío'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Transportista',
                border: OutlineInputBorder(borderRadius: BorderRadius.zero),
              ),
              items: const [
                DropdownMenuItem(value: 'MRW', child: Text('MRW')),
                DropdownMenuItem(value: 'SEUR', child: Text('SEUR')),
                DropdownMenuItem(value: 'GLS', child: Text('GLS')),
                DropdownMenuItem(value: 'DHL', child: Text('DHL')),
                DropdownMenuItem(value: 'UPS', child: Text('UPS')),
              ],
              onChanged: (value) => carrierController.text = value ?? '',
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: trackingController,
              decoration: const InputDecoration(
                labelText: 'Número de seguimiento',
                border: OutlineInputBorder(borderRadius: BorderRadius.zero),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tracking añadido')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandNavy,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _markAsShipped() {
    _updateStatus('shipped');
  }
}

// Modelos de datos
class _OrderDetail {
  final String id;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final _CustomerInfo customer;
  final _AddressInfo shippingAddress;
  final _AddressInfo billingAddress;
  final List<_OrderItem> items;
  final double subtotal;
  final double shippingCost;
  final double discount;
  final String? couponCode;
  final double total;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? notes;
  final _TrackingInfo? tracking;
  final List<_TimelineEvent> timeline;

  _OrderDetail({
    required this.id,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.customer,
    required this.shippingAddress,
    required this.billingAddress,
    required this.items,
    required this.subtotal,
    required this.shippingCost,
    required this.discount,
    this.couponCode,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
    this.tracking,
    required this.timeline,
  });
}

class _CustomerInfo {
  final String name;
  final String email;
  final String phone;

  _CustomerInfo({
    required this.name,
    required this.email,
    required this.phone,
  });
}

class _AddressInfo {
  final String name;
  final String street;
  final String city;
  final String postalCode;
  final String country;
  final String phone;

  _AddressInfo({
    required this.name,
    required this.street,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.phone,
  });
}

class _OrderItem {
  final String id;
  final String productId;
  final String name;
  final String variant;
  final double price;
  final int quantity;
  final String imageUrl;

  _OrderItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.variant,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}

class _TrackingInfo {
  final String carrier;
  final String trackingNumber;
  final DateTime estimatedDelivery;

  _TrackingInfo({
    required this.carrier,
    required this.trackingNumber,
    required this.estimatedDelivery,
  });
}

class _TimelineEvent {
  final String status;
  final DateTime date;
  final String description;

  _TimelineEvent({
    required this.status,
    required this.date,
    required this.description,
  });
}

// Widgets auxiliares
class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _SectionCard({
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final _TimelineEvent event;
  final bool isLast;

  const _TimelineItem({required this.event, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.brandNavy,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.description,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                dateFormat.format(event.date),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              if (!isLast) const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class _OrderItemTile extends StatelessWidget {
  final _OrderItem item;
  final NumberFormat currencyFormat;
  final VoidCallback onTap;

  const _OrderItemTile({
    required this.item,
    required this.currencyFormat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              color: AppColors.brandNavy.withValues(alpha: 0.1),
              child: const Center(
                child: Icon(Icons.image, color: AppColors.textTertiary),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    item.variant,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currencyFormat.format(item.price),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'x${item.quantity}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
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

class _PriceRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isTotal;
  final bool isDiscount;
  final bool isFree;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isTotal = false,
    this.isDiscount = false,
    this.isFree = false,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '€');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
        Text(
          isFree
              ? 'Gratis'
              : isDiscount
                  ? '-${currencyFormat.format(value.abs())}'
                  : currencyFormat.format(value),
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
            color: isDiscount
                ? AppColors.success
                : isFree
                    ? AppColors.success
                    : null,
          ),
        ),
      ],
    );
  }
}

class _AddressDisplay extends StatelessWidget {
  final _AddressInfo address;

  const _AddressDisplay({required this.address});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          address.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(address.street),
        Text('${address.postalCode} ${address.city}'),
        Text(address.country),
        const SizedBox(height: 4),
        Text(
          address.phone,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }
}

class _StatusOption extends StatelessWidget {
  final String status;
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusOption({
    required this.status,
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: color)
          : const Icon(Icons.chevron_right, color: AppColors.textTertiary),
      onTap: onTap,
    );
  }
}
