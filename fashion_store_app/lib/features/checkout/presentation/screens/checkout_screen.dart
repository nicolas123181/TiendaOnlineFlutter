// Pantallas placeholder - Se completarán en las siguientes fases

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';

// Checkout Screen
class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: const Center(child: Text('Pantalla de checkout - En desarrollo')),
    );
  }
}

// Checkout Success Screen
class CheckoutSuccessScreen extends StatelessWidget {
  final int orderId;

  const CheckoutSuccessScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 80, color: AppColors.success),
            const SizedBox(height: 24),
            Text('¡Pedido confirmado!', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            Text('Pedido #$orderId', style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }
}
