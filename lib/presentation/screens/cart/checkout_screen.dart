import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_colors.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/misc_widgets.dart';

/// Pantalla principal del checkout con stepper
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int _currentStep = 0;

  final List<String> _steps = [
    'Dirección',
    'Envío',
    'Pago',
    'Confirmar',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Checkout',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Stepper visual
          Padding(
            padding: const EdgeInsets.all(16),
            child: CheckoutStepper(
              steps: _steps,
              currentStep: _currentStep,
            ),
          ),
          const Divider(height: 1),
          // Contenido del paso actual
          Expanded(
            child: IndexedStack(
              index: _currentStep,
              children: [
                _AddressStep(
                  onContinue: () => _goToStep(1),
                ),
                _ShippingStep(
                  onContinue: () => _goToStep(2),
                  onBack: () => _goToStep(0),
                ),
                _PaymentStep(
                  onContinue: () => _goToStep(3),
                  onBack: () => _goToStep(1),
                ),
                _ConfirmStep(
                  onBack: () => _goToStep(2),
                  onConfirm: _placeOrder,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _goToStep(int step) {
    setState(() => _currentStep = step);
  }

  Future<void> _placeOrder() async {
    // TODO: Implementar proceso de pago con Stripe
    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pop(context); // Cerrar loading
      context.go('/order-confirmation/123'); // Ir a confirmación
    }
  }
}

/// Paso 1: Selección de dirección de envío
class _AddressStep extends ConsumerStatefulWidget {
  final VoidCallback onContinue;

  const _AddressStep({required this.onContinue});

  @override
  ConsumerState<_AddressStep> createState() => _AddressStepState();
}

class _AddressStepState extends ConsumerState<_AddressStep> {
  String? _selectedAddressId;

  // Direcciones de ejemplo
  final List<_Address> _addresses = [
    _Address(
      id: '1',
      name: 'Casa',
      recipientName: 'Juan García',
      street: 'Calle Mayor 123',
      city: 'Madrid',
      postalCode: '28001',
      country: 'España',
      phone: '+34 612 345 678',
      isDefault: true,
    ),
    _Address(
      id: '2',
      name: 'Oficina',
      recipientName: 'Juan García',
      street: 'Av. de la Constitución 45, Piso 3',
      city: 'Madrid',
      postalCode: '28014',
      country: 'España',
      phone: '+34 612 345 678',
      isDefault: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Seleccionar dirección por defecto
    final defaultAddress = _addresses.firstWhere(
      (a) => a.isDefault,
      orElse: () => _addresses.first,
    );
    _selectedAddressId = defaultAddress.id;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Dirección de envío',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        // TODO: Navegar a agregar dirección
                        context.push('/addresses/new');
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Nueva'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Lista de direcciones
                ...List.generate(_addresses.length, (index) {
                  final address = _addresses[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _AddressCard(
                      address: address,
                      isSelected: _selectedAddressId == address.id,
                      onTap: () {
                        setState(() => _selectedAddressId = address.id);
                      },
                      onEdit: () {
                        context.push('/addresses/${address.id}/edit');
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        _BottomActions(
          onContinue: _selectedAddressId != null ? widget.onContinue : null,
          continueText: 'Continuar',
        ),
      ],
    );
  }
}

/// Paso 2: Selección de método de envío
class _ShippingStep extends ConsumerStatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const _ShippingStep({
    required this.onContinue,
    required this.onBack,
  });

  @override
  ConsumerState<_ShippingStep> createState() => _ShippingStepState();
}

class _ShippingStepState extends ConsumerState<_ShippingStep> {
  String? _selectedMethodId;

  final List<_ShippingMethod> _methods = [
    _ShippingMethod(
      id: 'standard',
      name: 'Envío Estándar',
      description: 'Entrega en 3-5 días laborables',
      priceInCents: 590, // 5.90€
      isFree: false,
    ),
    _ShippingMethod(
      id: 'express',
      name: 'Envío Express',
      description: 'Entrega en 1-2 días laborables',
      priceInCents: 990, // 9.90€
      isFree: false,
    ),
    _ShippingMethod(
      id: 'free',
      name: 'Envío Gratis',
      description: 'Entrega en 5-7 días laborables',
      priceInCents: 0,
      isFree: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedMethodId = 'standard';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Método de envío',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Selecciona cómo deseas recibir tu pedido',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                // Lista de métodos
                ...List.generate(_methods.length, (index) {
                  final method = _methods[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ShippingMethodCard(
                      method: method,
                      isSelected: _selectedMethodId == method.id,
                      onTap: () {
                        setState(() => _selectedMethodId = method.id);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        _BottomActions(
          onBack: widget.onBack,
          onContinue: _selectedMethodId != null ? widget.onContinue : null,
          continueText: 'Continuar',
        ),
      ],
    );
  }
}

/// Paso 3: Método de pago
class _PaymentStep extends ConsumerStatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const _PaymentStep({
    required this.onContinue,
    required this.onBack,
  });

  @override
  ConsumerState<_PaymentStep> createState() => _PaymentStepState();
}

class _PaymentStepState extends ConsumerState<_PaymentStep> {
  String? _selectedPaymentMethod;

  final List<_PaymentMethod> _paymentMethods = [
    _PaymentMethod(
      id: 'card',
      name: 'Tarjeta de crédito/débito',
      icon: Icons.credit_card,
      description: 'Visa, Mastercard, American Express',
    ),
    _PaymentMethod(
      id: 'paypal',
      name: 'PayPal',
      icon: Icons.account_balance_wallet,
      description: 'Paga con tu cuenta PayPal',
    ),
    _PaymentMethod(
      id: 'bizum',
      name: 'Bizum',
      icon: Icons.phone_android,
      description: 'Pago instantáneo desde tu móvil',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedPaymentMethod = 'card';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Método de pago',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Selecciona cómo deseas pagar',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                // Lista de métodos de pago
                ...List.generate(_paymentMethods.length, (index) {
                  final method = _paymentMethods[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _PaymentMethodCard(
                      method: method,
                      isSelected: _selectedPaymentMethod == method.id,
                      onTap: () {
                        setState(() => _selectedPaymentMethod = method.id);
                      },
                    ),
                  );
                }),
                const SizedBox(height: 24),
                // Tarjetas guardadas (si pago con tarjeta)
                if (_selectedPaymentMethod == 'card') ...[
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Tarjetas guardadas',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SavedCardTile(
                    brand: 'Visa',
                    last4: '4242',
                    expiryMonth: 12,
                    expiryYear: 25,
                    isSelected: true,
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Abrir formulario de nueva tarjeta
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar nueva tarjeta'),
                    style: OutlinedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        _BottomActions(
          onBack: widget.onBack,
          onContinue: _selectedPaymentMethod != null ? widget.onContinue : null,
          continueText: 'Continuar',
        ),
      ],
    );
  }
}

/// Paso 4: Confirmación del pedido
class _ConfirmStep extends ConsumerWidget {
  final VoidCallback onBack;
  final VoidCallback onConfirm;

  const _ConfirmStep({
    required this.onBack,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Resumen del pedido',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Dirección de envío
                _SummarySection(
                  title: 'Dirección de envío',
                  icon: Icons.location_on_outlined,
                  onEdit: () {},
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Juan García'),
                      Text(
                        'Calle Mayor 123\nMadrid, 28001\nEspaña',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Método de envío
                _SummarySection(
                  title: 'Método de envío',
                  icon: Icons.local_shipping_outlined,
                  onEdit: () {},
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Envío Estándar'),
                      Text(
                        'Entrega en 3-5 días laborables',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Método de pago
                _SummarySection(
                  title: 'Método de pago',
                  icon: Icons.credit_card_outlined,
                  onEdit: () {},
                  child: const Row(
                    children: [
                      Text('Visa •••• 4242'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Divider(),
                const SizedBox(height: 16),

                // Productos
                const Text(
                  'Productos',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                // Lista compacta de productos
                ...List.generate(
                  cartState.cart.items.length > 3
                      ? 3
                      : cartState.cart.items.length,
                  (index) {
                    final item = cartState.cart.items[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 65,
                            color: AppColors.surfaceLight,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.productName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Talla: ${item.size} · Cant: ${item.quantity}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '€${(item.currentPrice / 100).toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                if (cartState.cart.items.length > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '+ ${cartState.cart.items.length - 3} productos más',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),

                // Resumen de precios
                _PriceRow(
                  label: 'Subtotal',
                  value: '€${(cartState.subtotal / 100).toStringAsFixed(2)}',
                ),
                if (cartState.discount > 0)
                  _PriceRow(
                    label: 'Descuento',
                    value: '-€${(cartState.discount / 100).toStringAsFixed(2)}',
                    isDiscount: true,
                  ),
                const _PriceRow(
                  label: 'Envío',
                  value: '€5.90',
                ),
                const Divider(height: 32),
                _PriceRow(
                  label: 'Total',
                  value: '€${(cartState.total / 100).toStringAsFixed(2)}',
                  isBold: true,
                ),
              ],
            ),
          ),
        ),
        _BottomActions(
          onBack: onBack,
          onContinue: onConfirm,
          continueText: 'Confirmar Pedido',
          continueIcon: Icons.lock_outlined,
        ),
      ],
    );
  }
}

// =====================
// WIDGETS AUXILIARES
// =====================

class _AddressCard extends StatelessWidget {
  final _Address address;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const _AddressCard({
    required this.address,
    required this.isSelected,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.brandNavy : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.brandNavy : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        address.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      if (address.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          color: AppColors.brandNavy,
                          child: const Text(
                            'Principal',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(address.recipientName),
                  Text(address.street),
                  Text('${address.city}, ${address.postalCode}'),
                  Text(address.country),
                  if (address.phone != null) Text(address.phone!),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 18),
              onPressed: onEdit,
            ),
          ],
        ),
      ),
    );
  }
}

class _ShippingMethodCard extends StatelessWidget {
  final _ShippingMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  const _ShippingMethodCard({
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.brandNavy : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.brandNavy : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.local_shipping_outlined,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    method.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              method.isFree
                  ? 'GRATIS'
                  : '€${(method.priceInCents / 100).toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: method.isFree ? AppColors.success : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final _PaymentMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.brandNavy : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.brandNavy : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Icon(
              method.icon,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    method.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
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
}

class _SavedCardTile extends StatelessWidget {
  final String brand;
  final String last4;
  final int expiryMonth;
  final int expiryYear;
  final bool isSelected;
  final VoidCallback onTap;

  const _SavedCardTile({
    required this.brand,
    required this.last4,
    required this.expiryMonth,
    required this.expiryYear,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.brandNavy : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.brandNavy : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            const Icon(Icons.credit_card, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$brand •••• $last4',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Expira: ${expiryMonth.toString().padLeft(2, '0')}/$expiryYear',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
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
}

class _SummarySection extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onEdit;
  final Widget child;

  const _SummarySection({
    required this.title,
    required this.icon,
    required this.onEdit,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              TextButton(
                onPressed: onEdit,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Editar'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          child,
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
              fontSize: isBold ? 18 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              fontSize: isBold ? 18 : 14,
              color: isDiscount ? AppColors.success : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onContinue;
  final String continueText;
  final IconData? continueIcon;

  const _BottomActions({
    this.onBack,
    this.onContinue,
    required this.continueText,
    this.continueIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          if (onBack != null)
            Expanded(
              child: CustomButton(
                text: 'Atrás',
                onPressed: onBack!,
                isOutlined: true,
              ),
            ),
          if (onBack != null) const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: CustomButton(
              text: continueText,
              onPressed: onContinue,
              icon: continueIcon,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================
// MODELOS AUXILIARES
// =====================

class _Address {
  final String id;
  final String name;
  final String recipientName;
  final String street;
  final String city;
  final String postalCode;
  final String country;
  final String? phone;
  final bool isDefault;

  const _Address({
    required this.id,
    required this.name,
    required this.recipientName,
    required this.street,
    required this.city,
    required this.postalCode,
    required this.country,
    this.phone,
    this.isDefault = false,
  });
}

class _ShippingMethod {
  final String id;
  final String name;
  final String description;
  final int priceInCents;
  final bool isFree;

  const _ShippingMethod({
    required this.id,
    required this.name,
    required this.description,
    required this.priceInCents,
    required this.isFree,
  });
}

class _PaymentMethod {
  final String id;
  final String name;
  final IconData icon;
  final String description;

  const _PaymentMethod({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });
}
