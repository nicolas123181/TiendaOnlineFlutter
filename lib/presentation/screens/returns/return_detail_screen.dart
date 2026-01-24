import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_colors.dart';
import '../../widgets/common/badge_widgets.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/misc_widgets.dart';

/// Pantalla de detalle de una devolución
class ReturnDetailScreen extends ConsumerStatefulWidget {
  final String returnId;

  const ReturnDetailScreen({
    super.key,
    required this.returnId,
  });

  @override
  ConsumerState<ReturnDetailScreen> createState() => _ReturnDetailScreenState();
}

class _ReturnDetailScreenState extends ConsumerState<ReturnDetailScreen> {
  bool _isLoading = true;
  ReturnDetail? _returnDetail;

  @override
  void initState() {
    super.initState();
    _loadReturnDetail();
  }

  Future<void> _loadReturnDetail() async {
    // Simular carga
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _returnDetail = ReturnDetail(
          id: widget.returnId,
          orderId: 'ORD123',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          status: 'pending',
          reason: 'No me queda bien la talla',
          items: [
            ReturnItem(
              productId: 'prod1',
              productName: 'Camisa Oxford Slim Fit',
              imageUrl: null,
              size: 'M',
              quantity: 1,
              price: 4990,
              reason: 'Talla incorrecta',
            ),
            ReturnItem(
              productId: 'prod2',
              productName: 'Pantalón Chino Classic',
              imageUrl: null,
              size: '32',
              quantity: 1,
              price: 3999,
              reason: 'Talla incorrecta',
            ),
          ],
          subtotal: 8989,
          shippingRefund: 0,
          totalRefund: 8989,
          returnLabel: null,
        );
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Devolución #${widget.returnId}',
        showBackButton: true,
      ),
      body: _isLoading
          ? const LoadingScreen()
          : _returnDetail == null
              ? const Center(child: Text('Devolución no encontrada'))
              : _buildContent(_returnDetail!),
    );
  }

  Widget _buildContent(ReturnDetail detail) {
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
                ReturnStatusBadge(status: detail.status),
                const SizedBox(height: 12),
                Text(
                  _formatDate(detail.createdAt),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Progreso de la devolución
          const SectionHeader(
            title: 'Estado de la devolución',
            showDivider: true,
          ),
          const SizedBox(height: 16),
          _ReturnProgress(status: detail.status),
          const SizedBox(height: 24),

          // Información del pedido
          _InfoCard(
            icon: Icons.receipt_outlined,
            title: 'Pedido original',
            value: '#${detail.orderId}',
            onTap: () => context.push('/orders/${detail.orderId}'),
          ),
          const SizedBox(height: 16),

          // Motivo
          _InfoCard(
            icon: Icons.comment_outlined,
            title: 'Motivo de la devolución',
            value: detail.reason,
          ),
          const SizedBox(height: 24),

          // Productos
          const SectionHeader(
            title: 'Productos a devolver',
            showDivider: true,
          ),
          const SizedBox(height: 12),
          ...detail.items.map((item) => _ReturnItemTile(item: item)),
          const SizedBox(height: 24),

          // Resumen de reembolso
          const SectionHeader(
            title: 'Resumen del reembolso',
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
                  label: 'Subtotal productos',
                  value: '€${(detail.subtotal / 100).toStringAsFixed(2)}',
                ),
                _PriceRow(
                  label: 'Gastos de envío',
                  value: detail.shippingRefund > 0
                      ? '€${(detail.shippingRefund / 100).toStringAsFixed(2)}'
                      : 'No incluido',
                ),
                const Divider(height: 24),
                _PriceRow(
                  label: 'Total a reembolsar',
                  value: '€${(detail.totalRefund / 100).toStringAsFixed(2)}',
                  isBold: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Etiqueta de envío
          if (detail.status == 'approved' && detail.returnLabel != null) ...[
            const SectionHeader(
              title: 'Etiqueta de devolución',
              showDivider: true,
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                border: Border.all(color: AppColors.info.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.qr_code,
                    size: 48,
                    color: AppColors.info,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Imprime la etiqueta y pégala en el paquete',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Descargar etiqueta',
                    onPressed: () {
                      // TODO: Descargar etiqueta
                    },
                    icon: Icons.download,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Instrucciones
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.info_outline, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Instrucciones',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _InstructionItem(
                  number: '1',
                  text: 'Empaca los productos en su embalaje original',
                ),
                _InstructionItem(
                  number: '2',
                  text: 'Imprime y pega la etiqueta de devolución',
                ),
                _InstructionItem(
                  number: '3',
                  text: 'Entrega el paquete en cualquier punto de recogida',
                ),
                _InstructionItem(
                  number: '4',
                  text: 'Recibirás tu reembolso en 5-7 días hábiles',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Acciones
          if (detail.status == 'pending')
            CustomButton(
              text: 'Cancelar devolución',
              onPressed: () {
                // TODO: Cancelar devolución
              },
              isOutlined: true,
              icon: Icons.close,
            ),

          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () {
                // TODO: Abrir ayuda
              },
              child: const Text('¿Necesitas ayuda?'),
            ),
          ),
          const SizedBox(height: 16),
        ],
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

class _ReturnProgress extends StatelessWidget {
  final String status;

  const _ReturnProgress({required this.status});

  int get _currentStep {
    return switch (status) {
      'pending' => 0,
      'approved' => 1,
      'shipped' => 2,
      'received' => 3,
      'refunded' => 4,
      _ => 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      'Solicitada',
      'Aprobada',
      'Enviada',
      'Recibida',
      'Reembolsada'
    ];

    return Column(
      children: List.generate(steps.length, (index) {
        final isCompleted = index < _currentStep;
        final isCurrent = index == _currentStep;

        return Row(
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isCompleted || isCurrent
                        ? AppColors.brandNavy
                        : AppColors.surfaceLight,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted || isCurrent
                          ? AppColors.brandNavy
                          : AppColors.border,
                    ),
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 14)
                      : isCurrent
                          ? Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            )
                          : null,
                ),
                if (index < steps.length - 1)
                  Container(
                    width: 2,
                    height: 24,
                    color: isCompleted ? AppColors.brandNavy : AppColors.border,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text(
                  steps[index],
                  style: TextStyle(
                    fontWeight: isCompleted || isCurrent
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isCompleted || isCurrent
                        ? null
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            if (onTap != null)
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

class _ReturnItemTile extends StatelessWidget {
  final ReturnItem item;

  const _ReturnItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border.withOpacity(0.5)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 75,
            color: AppColors.surfaceLight,
            child: item.imageUrl != null
                ? Image.network(item.imageUrl!, fit: BoxFit.cover)
                : const Icon(Icons.image_outlined,
                    color: AppColors.textTertiary),
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
                Text(
                  'Talla: ${item.size} · Cant: ${item.quantity}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Motivo: ${item.reason}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '€${(item.price / 100).toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isBold = false,
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
            ),
          ),
        ],
      ),
    );
  }
}

class _InstructionItem extends StatelessWidget {
  final String number;
  final String text;

  const _InstructionItem({
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: AppColors.brandNavy,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// Modelos
class ReturnDetail {
  final String id;
  final String orderId;
  final DateTime createdAt;
  final String status;
  final String reason;
  final List<ReturnItem> items;
  final int subtotal;
  final int shippingRefund;
  final int totalRefund;
  final String? returnLabel;

  const ReturnDetail({
    required this.id,
    required this.orderId,
    required this.createdAt,
    required this.status,
    required this.reason,
    required this.items,
    required this.subtotal,
    required this.shippingRefund,
    required this.totalRefund,
    this.returnLabel,
  });
}

class ReturnItem {
  final String productId;
  final String productName;
  final String? imageUrl;
  final String size;
  final int quantity;
  final int price;
  final String reason;

  const ReturnItem({
    required this.productId,
    required this.productName,
    this.imageUrl,
    required this.size,
    required this.quantity,
    required this.price,
    required this.reason,
  });
}
