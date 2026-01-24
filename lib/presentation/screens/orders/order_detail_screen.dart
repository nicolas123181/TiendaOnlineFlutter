import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../config/app_colors.dart';
import '../../../data/models/order.dart';
import '../../providers/order_provider.dart';
import '../../widgets/common/badge_widgets.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/misc_widgets.dart';
import '../../widgets/common/price_display.dart';

/// Pantalla de detalle de un pedido
class OrderDetailScreen extends ConsumerStatefulWidget {
  final String orderId;

  const OrderDetailScreen({
    super.key,
    required this.orderId,
  });

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final orderAsync = ref.watch(orderByIdProvider(widget.orderId));

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Pedido #${widget.orderId}',
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              Share.share(
                'Mi pedido VANTAGE: #${widget.orderId}',
                subject: 'Pedido VANTAGE',
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            onSelected: (value) {
              switch (value) {
                case 'invoice':
                  // TODO: Descargar factura
                  break;
                case 'support':
                  // TODO: Contactar soporte
                  break;
                case 'return':
                  context.push('/returns/new?orderId=${widget.orderId}');
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'invoice',
                child: Row(
                  children: [
                    Icon(Icons.receipt_outlined, size: 20),
                    SizedBox(width: 12),
                    Text('Descargar factura'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'support',
                child: Row(
                  children: [
                    Icon(Icons.support_agent_outlined, size: 20),
                    SizedBox(width: 12),
                    Text('Contactar soporte'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'return',
                child: Row(
                  children: [
                    Icon(Icons.assignment_return_outlined, size: 20),
                    SizedBox(width: 12),
                    Text('Solicitar devolución'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: orderAsync.when(
        loading: () => const LoadingScreen(),
        error: (_, __) => const Center(child: Text('Pedido no encontrado')),
        data: (order) => order == null
            ? const Center(child: Text('Pedido no encontrado'))
            : _buildContent(order),
      ),
    );
  }

  Widget _buildContent(Order order) {
    final subtotal = _resolveSubtotal(order);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Estado y fecha
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.surfaceLight,
            child: Column(
              children: [
                OrderStatusBadge(status: order.status),
                const SizedBox(height: 12),
                Text(
                  _formatDate(order.createdAt),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Seguimiento del pedido
          if (_shouldShowTracking(order.status)) ...[
            const SectionHeader(
              title: 'Seguimiento del pedido',
              showDivider: true,
            ),
            const SizedBox(height: 16),
            OrderProgressTracker(
              steps: _buildTrackingSteps(order.status),
            ),
            if (order.trackingNumber != null) ...[
              const SizedBox(height: 16),
              _TrackingInfo(
                carrier: order.carrierName ?? 'Transporte',
                trackingNumber: order.trackingNumber!,
              ),
            ],
            const SizedBox(height: 24),
          ],

          // Productos
          const SectionHeader(
            title: 'Productos',
            showDivider: true,
          ),
          const SizedBox(height: 12),
          ...List.generate(order.items.length, (index) {
            final item = order.items[index];
            return _OrderItemTile(
              item: item,
              onTap: item.productId != null
                  ? () => context.push('/product/${item.productId}')
                  : null,
            );
          }),
          const SizedBox(height: 24),

          // Dirección de envío
          const SectionHeader(
            title: 'Dirección de envío',
            showDivider: true,
          ),
          const SizedBox(height: 12),
          _InfoSection(
            icon: Icons.location_on_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.customerName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(order.customerAddress),
                Text(
                  '${order.customerCity}, ${order.customerPostalCode}',
                ),
                if (order.customerPhone != null) Text(order.customerPhone!),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Método de envío
          _InfoSection(
            icon: Icons.local_shipping_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getShippingMethodLabel(order),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  _getShippingDescription(order.shippingMethodId),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Método de pago
          const SectionHeader(
            title: 'Método de pago',
            showDivider: true,
          ),
          const SizedBox(height: 12),
          _InfoSection(
            icon: Icons.credit_card_outlined,
            child: Text(
              _getPaymentMethodLabel(order),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 24),

          // Resumen de pago
          const SectionHeader(
            title: 'Resumen de pago',
            showDivider: true,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _PriceRow(
                  label: 'Subtotal',
                  value: '€${(subtotal / 100).toStringAsFixed(2)}',
                ),
                if (order.discount > 0)
                  _PriceRow(
                    label: 'Descuento',
                    value: '-€${(order.discount / 100).toStringAsFixed(2)}',
                    isDiscount: true,
                  ),
                _PriceRow(
                  label: 'Envío',
                  value: order.shippingCost == 0
                      ? 'GRATIS'
                      : '€${(order.shippingCost / 100).toStringAsFixed(2)}',
                ),
                const Divider(height: 24),
                _PriceRow(
                  label: 'Total',
                  value: '€${(order.total / 100).toStringAsFixed(2)}',
                  isBold: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Acciones
          if (order.status == 'delivered') ...[
            CustomButton(
              text: 'Solicitar devolución',
              onPressed: () {
                context.push('/returns/new?orderId=${widget.orderId}');
              },
              isOutlined: true,
              icon: Icons.assignment_return_outlined,
            ),
            const SizedBox(height: 12),
          ],
          CustomButton(
            text: 'Volver a comprar',
            onPressed: () {
              // TODO: Agregar productos al carrito
              showSuccessSnackBar(context, 'Productos agregados al carrito');
            },
            icon: Icons.refresh,
          ),
          const SizedBox(height: 32),

          // Ayuda
          Center(
            child: TextButton(
              onPressed: () {
                // TODO: Abrir centro de ayuda
              },
              child: const Text('¿Necesitas ayuda con este pedido?'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  bool _shouldShowTracking(String status) {
    return [
      'confirmed',
      'processing',
      'paid',
      'ready_for_pickup',
      'shipped',
      'delivered',
    ].contains(status);
  }

  List<TrackingStep> _buildTrackingSteps(String status) {
    final currentIndex = _getTrackingIndex(status);
    final titles = ['Confirmado', 'Procesando', 'Enviado', 'Entregado'];

    return List.generate(titles.length, (index) {
      return TrackingStep(
        title: titles[index],
        isCompleted: index < currentIndex,
        isCurrent: index == currentIndex,
      );
    });
  }

  int _getTrackingIndex(String status) {
    return switch (status) {
      'confirmed' => 0,
      'processing' || 'paid' || 'ready_for_pickup' => 1,
      'shipped' => 2,
      'delivered' => 3,
      _ => 0,
    };
  }

  int _resolveSubtotal(Order order) {
    if (order.subtotal != null) return order.subtotal!;
    final subtotal = order.total + order.discount - order.shippingCost;
    return subtotal > 0 ? subtotal : 0;
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
    return '${date.day} de ${months[date.month - 1]} de ${date.year} a las ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getShippingMethodLabel(Order order) {
    if (order.shippingMethodId == null) return 'Envío estándar';
    return 'Envío #${order.shippingMethodId}';
  }

  String _getShippingDescription(int? methodId) {
    if (methodId == null) return 'Entrega en 3-7 días laborables';
    return 'Entrega según método #$methodId';
  }

  String _getPaymentMethodLabel(Order order) {
    if (order.stripePaymentIntentId != null) {
      return 'Tarjeta (Stripe)';
    }
    return 'Método de pago no especificado';
  }
}

class _OrderItemTile extends StatelessWidget {
  final OrderItem item;
  final VoidCallback? onTap;

  const _OrderItemTile({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.border.withOpacity(0.5)),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 90,
              color: AppColors.surfaceLight,
              child: const Icon(
                Icons.image_outlined,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (item.size != null)
                    Text(
                      'Talla: ${item.size}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  Text(
                    'Cantidad: ${item.quantity}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  PriceDisplayInline(
                    priceInCents: item.productPrice,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackingInfo extends StatelessWidget {
  final String carrier;
  final String trackingNumber;

  const _TrackingInfo({
    required this.carrier,
    required this.trackingNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.brandNavy.withOpacity(0.05),
        border: Border.all(color: AppColors.brandNavy.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_shipping,
            color: AppColors.brandNavy,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  carrier,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Seguimiento: $trackingNumber',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Abrir URL de seguimiento
            },
            child: const Text('Rastrear'),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final IconData icon;
  final Widget child;

  const _InfoSection({
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final bool isDiscount;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.isDiscount = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              fontSize: isBold ? 16 : 14,
              color: isDiscount ? AppColors.success : null,
            ),
          ),
        ],
      ),
    );
  }
}

/// Modelo de detalle de pedido
class OrderDetail {
  final String id;
  final DateTime createdAt;
  final String status;
  final List<OrderItemDetail> items;
  final AddressInfo shippingAddress;
  final String shippingMethod;
  final String paymentMethod;
  final String? trackingNumber;
  final String? shippingCarrier;
  final int subtotal;
  final int discount;
  final int shippingCost;
  final int total;

  const OrderDetail({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.items,
    required this.shippingAddress,
    required this.shippingMethod,
    required this.paymentMethod,
    this.trackingNumber,
    this.shippingCarrier,
    required this.subtotal,
    required this.discount,
    required this.shippingCost,
    required this.total,
  });
}

class OrderItemDetail {
  final String productId;
  final String productName;
  final String? imageUrl;
  final String? size;
  final int quantity;
  final int price;

  const OrderItemDetail({
    required this.productId,
    required this.productName,
    this.imageUrl,
    this.size,
    required this.quantity,
    required this.price,
  });
}

class AddressInfo {
  final String recipientName;
  final String street;
  final String city;
  final String postalCode;
  final String country;
  final String? phone;

  const AddressInfo({
    required this.recipientName,
    required this.street,
    required this.city,
    required this.postalCode,
    required this.country,
    this.phone,
  });
}
