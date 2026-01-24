import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../config/app_colors.dart';
import '../../widgets/common/custom_button.dart';

/// Pantalla de confirmación de pedido exitoso
class OrderConfirmationScreen extends ConsumerWidget {
  final String orderId;

  const OrderConfirmationScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Animación de éxito
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 80,
                ),
              ),
              const SizedBox(height: 32),

              // Título
              const Text(
                '¡Pedido Confirmado!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Gracias por tu compra',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Número de pedido
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Número de pedido',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '#$orderId',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy_outlined),
                          onPressed: () {
                            // TODO: Copiar al portapapeles
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Número copiado'),
                              ),
                            );
                          },
                          tooltip: 'Copiar',
                        ),
                        IconButton(
                          icon: const Icon(Icons.share_outlined),
                          onPressed: () {
                            Share.share(
                              'Mi pedido VANTAGE: #$orderId',
                              subject: 'Pedido VANTAGE',
                            );
                          },
                          tooltip: 'Compartir',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Pasos siguientes
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '¿Qué sigue?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _NextStepItem(
                      icon: Icons.email_outlined,
                      title: 'Confirmación por email',
                      description:
                          'Recibirás un email con los detalles de tu pedido',
                    ),
                    const SizedBox(height: 12),
                    _NextStepItem(
                      icon: Icons.inventory_2_outlined,
                      title: 'Preparación',
                      description:
                          'Prepararemos tu pedido en las próximas 24 horas',
                    ),
                    const SizedBox(height: 12),
                    _NextStepItem(
                      icon: Icons.local_shipping_outlined,
                      title: 'Envío',
                      description:
                          'Te notificaremos cuando tu pedido sea enviado',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Estimación de entrega
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                color: AppColors.brandNavy.withOpacity(0.05),
                child: Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      color: AppColors.brandNavy,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Entrega estimada',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getEstimatedDelivery(),
                            style: const TextStyle(
                              color: AppColors.brandNavy,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Botones de acción
              CustomButton(
                text: 'Ver mi pedido',
                onPressed: () {
                  context.push('/orders/$orderId');
                },
                icon: Icons.receipt_long_outlined,
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Seguir comprando',
                onPressed: () {
                  context.go('/home');
                },
                isOutlined: true,
              ),
              const SizedBox(height: 40),

              // Soporte
              const Text(
                '¿Necesitas ayuda?',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  // TODO: Abrir soporte
                },
                child: const Text('Contactar soporte'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getEstimatedDelivery() {
    final now = DateTime.now();
    final minDate = now.add(const Duration(days: 3));
    final maxDate = now.add(const Duration(days: 5));

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

    return '${minDate.day}-${maxDate.day} de ${months[minDate.month - 1]}';
  }
}

class _NextStepItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _NextStepItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.brandNavy.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 18,
            color: AppColors.brandNavy,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
