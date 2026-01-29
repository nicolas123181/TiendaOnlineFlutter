import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_inputs.dart';
import '../../../auth/presentation/providers/auth_provider.dart'
    as auth_providers;
import '../../../cart/presentation/providers/cart_provider.dart'
    as cart_providers;
import '../../../profile/presentation/providers/addresses_provider.dart';
import '../providers/checkout_provider.dart';

/// Pantalla completa de checkout con pasos
class CompleteCheckoutScreen extends ConsumerStatefulWidget {
  const CompleteCheckoutScreen({super.key});

  @override
  ConsumerState<CompleteCheckoutScreen> createState() =>
      _CompleteCheckoutScreenState();
}

class _CompleteCheckoutScreenState
    extends ConsumerState<CompleteCheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Prefill user data if logged in
    Future.microtask(() {
      final authState = ref.read(auth_providers.authStateProvider);
      if (authState.value != null) {
        ref.read(checkoutProvider.notifier).prefillUserData(authState.value!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final checkoutState = ref.watch(checkoutProvider);
    final cartItems = ref.watch(cart_providers.cartItemsListProvider);
    final subtotal = ref.watch(cart_providers.cartSubtotalProvider);
    final total =
        subtotal + checkoutState.shippingCost - checkoutState.couponDiscount;

    // Si el carrito está vacío, redirigir
    if (cartItems.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout'), centerTitle: true),
      body: Column(
        children: [
          // Stepper Header
          _buildStepperHeader(checkoutState.currentStep),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Error message
                    if (checkoutState.error != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.error),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: AppColors.error),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                checkoutState.error!,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Step content
                    _buildStepContent(checkoutState, subtotal),

                    const SizedBox(height: 24),

                    // Order Summary Card
                    _buildOrderSummary(
                      cartItems,
                      subtotal,
                      checkoutState,
                      total,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Navigation
          _buildBottomNavigation(checkoutState, total, cartItems, subtotal),
        ],
      ),
    );
  }

  Widget _buildStepperHeader(int currentStep) {
    const steps = [
      {'icon': Icons.person_outline, 'label': 'Información'},
      {'icon': Icons.local_shipping_outlined, 'label': 'Envío'},
      {'icon': Icons.discount_outlined, 'label': 'Descuento'},
      {'icon': Icons.check_circle_outline, 'label': 'Confirmar'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: List.generate(steps.length, (index) {
          final isActive = currentStep == index + 1;
          final isCompleted = currentStep > index + 1;
          final step = steps[index];

          return Expanded(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (index + 1 <= currentStep) {
                      ref.read(checkoutProvider.notifier).goToStep(index + 1);
                    }
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? AppColors.success
                          : isActive
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                    child: Icon(
                      isCompleted ? Icons.check : step['icon'] as IconData,
                      color: isCompleted || isActive
                          ? Colors.white
                          : AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  step['label'] as String,
                  style: AppTextStyles.caption.copyWith(
                    color: isActive
                        ? AppColors.primary
                        : isCompleted
                        ? AppColors.success
                        : AppColors.textSecondary,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepContent(CheckoutState state, int subtotal) {
    switch (state.currentStep) {
      case 1:
        return _buildShippingInfoStep(state);
      case 2:
        return _buildShippingMethodStep(state);
      case 3:
        return _buildCouponStep(state, subtotal);
      case 4:
        return _buildConfirmationStep(state);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildShippingInfoStep(CheckoutState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Información de Envío', style: AppTextStyles.h4),
                // Botón para cargar dirección guardada
                Consumer(
                  builder: (context, ref, _) {
                    final userAddresses = ref.watch(userAddressesProvider);
                    return userAddresses.when(
                      data: (addresses) {
                        if (addresses.isEmpty) return const SizedBox.shrink();
                        return TextButton.icon(
                          onPressed: () {
                            final defaultAddress = addresses.firstWhere(
                              (a) => a.isDefault,
                              orElse: () => addresses.first,
                            );
                            ref
                                .read(checkoutProvider.notifier)
                                .loadSavedAddress(defaultAddress);
                          },
                          icon: const Icon(Icons.location_on, size: 18),
                          label: const Text('Usar guardada'),
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Nombre Completo *',
              initialValue: state.customerName,
              onChanged: (value) =>
                  ref.read(checkoutProvider.notifier).updateCustomerName(value),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Email *',
              initialValue: state.customerEmail,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => ref
                  .read(checkoutProvider.notifier)
                  .updateCustomerEmail(value),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Campo requerido';
                if (!value!.contains('@')) return 'Email inválido';
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Teléfono',
              initialValue: state.customerPhone,
              keyboardType: TextInputType.phone,
              onChanged: (value) => ref
                  .read(checkoutProvider.notifier)
                  .updateCustomerPhone(value),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Dirección *',
              initialValue: state.customerAddress,
              onChanged: (value) => ref
                  .read(checkoutProvider.notifier)
                  .updateCustomerAddress(value),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'Ciudad *',
                    initialValue: state.customerCity,
                    onChanged: (value) => ref
                        .read(checkoutProvider.notifier)
                        .updateCustomerCity(value),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Campo requerido' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    label: 'Código Postal *',
                    initialValue: state.customerPostalCode,
                    keyboardType: TextInputType.number,
                    onChanged: (value) => ref
                        .read(checkoutProvider.notifier)
                        .updateCustomerPostalCode(value),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Campo requerido' : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingMethodStep(CheckoutState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Método de Envío', style: AppTextStyles.h4),
            const SizedBox(height: 16),
            if (state.shippingMethods.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              ...state.shippingMethods.map((method) {
                final isSelected = state.selectedShippingMethod == method;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.05)
                        : Colors.transparent,
                  ),
                  child: RadioListTile(
                    value: method,
                    groupValue: state.selectedShippingMethod,
                    onChanged: (value) {
                      if (value != null) {
                        ref
                            .read(checkoutProvider.notifier)
                            .selectShippingMethod(value);
                      }
                    },
                    title: Text(method.name, style: AppTextStyles.bodyMedium),
                    subtitle: method.description != null
                        ? Text(
                            '${method.description}\n${method.minDays}-${method.maxDays} días laborables',
                            style: AppTextStyles.bodySmall,
                          )
                        : Text(
                            '${method.minDays}-${method.maxDays} días laborables',
                            style: AppTextStyles.bodySmall,
                          ),
                    secondary: Text(
                      _formatPrice(method.cost),
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponStep(CheckoutState state, int subtotal) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Código de Descuento', style: AppTextStyles.h4),
            const SizedBox(height: 8),
            Text(
              '¿Tienes un cupón? Aplícalo aquí (Opcional)',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            if (state.appliedCoupon != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.success),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: AppColors.success),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '¡Cupón aplicado!',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.success,
                            ),
                          ),
                          Text(
                            'Código: ${state.appliedCoupon}',
                            style: AppTextStyles.bodySmall,
                          ),
                          Text(
                            'Descuento: ${_formatPrice(state.couponDiscount)}',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          ref.read(checkoutProvider.notifier).removeCoupon(),
                      icon: Icon(Icons.close, color: AppColors.error),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: 'Código de cupón',
                          initialValue: state.couponCode,
                          onChanged: (value) => ref
                              .read(checkoutProvider.notifier)
                              .updateCouponCode(value),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: state.couponCode.isEmpty || state.isLoading
                            ? null
                            : () => ref
                                  .read(checkoutProvider.notifier)
                                  .applyCoupon(subtotal + state.shippingCost),
                        child: state.isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Aplicar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 20,
                          color: AppColors.info,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Este paso es opcional. Puedes continuar sin cupón.',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.info,
                            ),
                          ),
                        ),
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

  Widget _buildConfirmationStep(CheckoutState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumen del Pedido', style: AppTextStyles.h4),
            const SizedBox(height: 16),
            _buildSummarySection(
              'Información de Envío',
              Icons.location_on,
              [
                state.customerName,
                state.customerEmail,
                if (state.customerPhone.isNotEmpty) state.customerPhone,
                state.customerAddress,
                '${state.customerPostalCode} ${state.customerCity}',
              ],
              onEdit: () => ref.read(checkoutProvider.notifier).goToStep(1),
            ),
            const Divider(height: 32),
            if (state.selectedShippingMethod != null)
              _buildSummarySection(
                'Método de Envío',
                Icons.local_shipping,
                [
                  state.selectedShippingMethod!.name,
                  '${state.selectedShippingMethod!.minDays}-${state.selectedShippingMethod!.maxDays} días laborables',
                  _formatPrice(state.selectedShippingMethod!.cost),
                ],
                onEdit: () => ref.read(checkoutProvider.notifier).goToStep(2),
              ),
            if (state.appliedCoupon != null) ...[
              const Divider(height: 32),
              _buildSummarySection(
                'Descuento Aplicado',
                Icons.discount,
                [
                  'Código: ${state.appliedCoupon}',
                  _formatPrice(state.couponDiscount),
                ],
                onEdit: () => ref.read(checkoutProvider.notifier).goToStep(3),
              ),
            ],
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.lock_outline, color: AppColors.info),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pago Seguro con Stripe',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.info,
                          ),
                        ),
                        Text(
                          'Serás redirigido a Stripe para completar el pago de forma segura',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.info,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection(
    String title,
    IconData icon,
    List<String> items, {
    VoidCallback? onEdit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(title, style: AppTextStyles.labelLarge),
              ],
            ),
            if (onEdit != null)
              TextButton(onPressed: onEdit, child: const Text('Editar')),
          ],
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              item,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummary(
    List items,
    int subtotal,
    CheckoutState state,
    int total,
  ) {
    return Card(
      color: AppColors.primary.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumen', style: AppTextStyles.h4),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal (${items.length} artículos)'),
                Text(_formatPrice(subtotal), style: AppTextStyles.labelMedium),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Envío'),
                Text(
                  state.selectedShippingMethod != null
                      ? _formatPrice(state.shippingCost)
                      : '-',
                  style: AppTextStyles.labelMedium,
                ),
              ],
            ),
            if (state.couponDiscount > 0) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Descuento', style: TextStyle(color: AppColors.success)),
                  Text(
                    '-${_formatPrice(state.couponDiscount)}',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ],
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: AppTextStyles.h4),
                Text(_formatPrice(total), style: AppTextStyles.price),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(
    CheckoutState state,
    int total,
    List cartItems,
    int subtotal,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (state.currentStep > 1)
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      ref.read(checkoutProvider.notifier).previousStep(),
                  child: const Text('Atrás'),
                ),
              ),
            if (state.currentStep > 1) const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: state.canProceed && !state.isLoading
                    ? () => _handleNextStep(state, total, cartItems, subtotal)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.border,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: state.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : Text(
                        state.currentStep == 4
                            ? 'Proceder al Pago'
                            : 'Continuar',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNextStep(
    CheckoutState state,
    int total,
    List cartItems,
    int subtotal,
  ) {
    if (state.currentStep == 1) {
      if (_formKey.currentState?.validate() ?? false) {
        ref.read(checkoutProvider.notifier).nextStep();
      }
    } else if (state.currentStep == 4) {
      _processCheckout(total, cartItems, subtotal, state);
    } else {
      ref.read(checkoutProvider.notifier).nextStep();
    }
  }

  Future<void> _processCheckout(
    int total,
    List cartItems,
    int subtotal,
    CheckoutState state,
  ) async {
    try {
      // Aquí iría la integración con Stripe
      // Por ahora mostrar un diálogo de éxito
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Próximamente'),
          content: const Text(
            'La integración con Stripe se completará en la siguiente fase. '
            'El flujo de checkout está listo para conectar con la pasarela de pago.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/');
              },
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
      );
    }
  }

  String _formatPrice(int cents) {
    return NumberFormat.currency(
      locale: 'es_ES',
      symbol: '€',
    ).format(cents / 100);
  }
}
