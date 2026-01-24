import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_colors.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/dialogs.dart';
import '../../widgets/common/error_widget.dart';

/// Pantalla para solicitar una nueva devolución
class NewReturnScreen extends ConsumerStatefulWidget {
  final String? orderId;

  const NewReturnScreen({
    super.key,
    this.orderId,
  });

  @override
  ConsumerState<NewReturnScreen> createState() => _NewReturnScreenState();
}

class _NewReturnScreenState extends ConsumerState<NewReturnScreen> {
  final _reasonController = TextEditingController();
  String? _selectedReason;
  final Set<String> _selectedItems = {};
  bool _isSubmitting = false;

  // Items del pedido (simulados)
  final List<OrderItemForReturn> _orderItems = [
    OrderItemForReturn(
      id: 'item1',
      productId: 'prod1',
      productName: 'Camisa Oxford Slim Fit',
      imageUrl: null,
      size: 'M',
      quantity: 1,
      price: 4990,
    ),
    OrderItemForReturn(
      id: 'item2',
      productId: 'prod2',
      productName: 'Pantalón Chino Classic',
      imageUrl: null,
      size: '32',
      quantity: 1,
      price: 3999,
    ),
    OrderItemForReturn(
      id: 'item3',
      productId: 'prod3',
      productName: 'Cinturón de Cuero Premium',
      imageUrl: null,
      size: '95',
      quantity: 1,
      price: 2490,
    ),
  ];

  final List<String> _reasons = [
    'Talla incorrecta',
    'No es lo que esperaba',
    'Producto defectuoso',
    'Llegó dañado',
    'Color diferente al mostrado',
    'Cambié de opinión',
    'Otro motivo',
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  int get _refundAmount {
    return _orderItems
        .where((item) => _selectedItems.contains(item.id))
        .fold(0, (sum, item) => sum + item.price);
  }

  Future<void> _submitReturn() async {
    if (_selectedItems.isEmpty) {
      showErrorSnackBar(context, 'Selecciona al menos un producto');
      return;
    }

    if (_selectedReason == null) {
      showErrorSnackBar(context, 'Selecciona un motivo de devolución');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // TODO: Enviar solicitud de devolución
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        await SuccessDialog.show(
          context: context,
          title: '¡Solicitud enviada!',
          message:
              'Tu solicitud de devolución ha sido recibida. Te notificaremos cuando sea aprobada.',
        );
        context.go('/returns');
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Nueva Devolución',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info del pedido
            if (widget.orderId != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: AppColors.surfaceLight,
                child: Row(
                  children: [
                    const Icon(Icons.receipt_outlined, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Pedido #${widget.orderId}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // Selección de productos
            const Text(
              'Selecciona los productos a devolver',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(_orderItems.length, (index) {
              final item = _orderItems[index];
              final isSelected = _selectedItems.contains(item.id);

              return InkWell(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedItems.remove(item.id);
                    } else {
                      _selectedItems.add(item.id);
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          isSelected ? AppColors.brandNavy : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Checkbox
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color:
                              isSelected ? AppColors.brandNavy : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.brandNavy
                                : AppColors.border,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(Icons.check,
                                size: 14, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      // Imagen
                      Container(
                        width: 60,
                        height: 75,
                        color: AppColors.surfaceLight,
                        child: item.imageUrl != null
                            ? Image.network(item.imageUrl!, fit: BoxFit.cover)
                            : const Icon(
                                Icons.image_outlined,
                                color: AppColors.textTertiary,
                              ),
                      ),
                      const SizedBox(width: 12),
                      // Info
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
                              '€${(item.price / 100).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),

            // Motivo de devolución
            const Text(
              'Motivo de la devolución',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedReason,
              decoration: InputDecoration(
                hintText: 'Selecciona un motivo',
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
              items: _reasons
                  .map((reason) => DropdownMenuItem(
                        value: reason,
                        child: Text(reason),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedReason = value);
              },
            ),
            const SizedBox(height: 16),

            // Comentarios adicionales
            const Text(
              'Comentarios adicionales (opcional)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Cuéntanos más detalles...',
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Política de devoluciones
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                border: Border.all(color: AppColors.info.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.info, size: 18),
                      const SizedBox(width: 8),
                      const Text(
                        'Política de devoluciones',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Tienes 30 días desde la recepción para devolver\n'
                    '• Los productos deben estar sin usar y con etiquetas\n'
                    '• El reembolso se procesará en 5-7 días hábiles\n'
                    '• Los gastos de envío de devolución son gratuitos',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Resumen de reembolso
            if (_selectedItems.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Reembolso estimado',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '€${(_refundAmount / 100).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${_selectedItems.length} producto${_selectedItems.length > 1 ? 's' : ''}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // Botón enviar
            CustomButton(
              text: 'Solicitar Devolución',
              onPressed: _submitReturn,
              isLoading: _isSubmitting,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class OrderItemForReturn {
  final String id;
  final String productId;
  final String productName;
  final String? imageUrl;
  final String size;
  final int quantity;
  final int price;

  const OrderItemForReturn({
    required this.id,
    required this.productId,
    required this.productName,
    this.imageUrl,
    required this.size,
    required this.quantity,
    required this.price,
  });
}
