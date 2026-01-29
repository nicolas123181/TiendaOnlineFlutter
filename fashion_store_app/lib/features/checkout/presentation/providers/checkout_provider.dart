import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/services/supabase_service.dart';
import '../../data/models/shipping_method_model.dart';

/// Estado del checkout (sin freezed para evitar errores de generación)
class CheckoutState {
  final int currentStep;
  final bool isLoading;
  final List<ShippingMethod> shippingMethods;
  final ShippingMethod? selectedShippingMethod;
  final String couponCode;
  final int couponDiscount;
  final String? appliedCoupon;
  final String? error;
  // Form data
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String customerAddress;
  final String customerCity;
  final String customerPostalCode;

  const CheckoutState({
    this.currentStep = 1,
    this.isLoading = false,
    this.shippingMethods = const [],
    this.selectedShippingMethod,
    this.couponCode = '',
    this.couponDiscount = 0,
    this.appliedCoupon,
    this.error,
    this.customerName = '',
    this.customerEmail = '',
    this.customerPhone = '',
    this.customerAddress = '',
    this.customerCity = '',
    this.customerPostalCode = '',
  });

  /// Total de pasos
  static const int totalSteps = 4;

  /// Costo de envío seleccionado
  int get shippingCost => selectedShippingMethod?.cost ?? 0;

  /// ¿Puede continuar al siguiente paso?
  bool get canProceed {
    switch (currentStep) {
      case 1:
        return customerName.isNotEmpty &&
            customerEmail.isNotEmpty &&
            customerAddress.isNotEmpty &&
            customerCity.isNotEmpty &&
            customerPostalCode.isNotEmpty;
      case 2:
        return selectedShippingMethod != null;
      case 3:
        return true; // Cupón es opcional
      case 4:
        return true;
      default:
        return false;
    }
  }

  CheckoutState copyWith({
    int? currentStep,
    bool? isLoading,
    List<ShippingMethod>? shippingMethods,
    ShippingMethod? selectedShippingMethod,
    String? couponCode,
    int? couponDiscount,
    String? appliedCoupon,
    String? error,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? customerAddress,
    String? customerCity,
    String? customerPostalCode,
    bool clearAppliedCoupon = false,
    bool clearError = false,
    bool clearSelectedShipping = false,
  }) {
    return CheckoutState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      shippingMethods: shippingMethods ?? this.shippingMethods,
      selectedShippingMethod: clearSelectedShipping
          ? selectedShippingMethod
          : (selectedShippingMethod ?? this.selectedShippingMethod),
      couponCode: couponCode ?? this.couponCode,
      couponDiscount: couponDiscount ?? this.couponDiscount,
      appliedCoupon: clearAppliedCoupon
          ? appliedCoupon
          : (appliedCoupon ?? this.appliedCoupon),
      error: clearError ? error : (error ?? this.error),
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      customerCity: customerCity ?? this.customerCity,
      customerPostalCode: customerPostalCode ?? this.customerPostalCode,
    );
  }
}

/// Provider de checkout
final checkoutProvider = NotifierProvider<CheckoutNotifier, CheckoutState>(
  () => CheckoutNotifier(),
);

/// Notifier de checkout
class CheckoutNotifier extends Notifier<CheckoutState> {
  @override
  CheckoutState build() {
    // Cargar datos de forma asíncrona después de la inicialización
    Future.microtask(() {
      _loadShippingMethods();
      _prefillUserData();
    });

    return const CheckoutState();
  }

  // ============================================
  // NAVEGACIÓN
  // ============================================

  void nextStep() {
    if (!state.canProceed) return;
    if (state.currentStep < CheckoutState.totalSteps) {
      state = state.copyWith(
        currentStep: state.currentStep + 1,
        error: null,
        clearError: true,
      );
    }
  }

  void previousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(
        currentStep: state.currentStep - 1,
        error: null,
        clearError: true,
      );
    }
  }

  void goToStep(int step) {
    if (step >= 1 && step <= state.currentStep) {
      state = state.copyWith(currentStep: step, error: null, clearError: true);
    }
  }

  // ============================================
  // FORMULARIO
  // ============================================

  void updateCustomerName(String value) {
    state = state.copyWith(customerName: value);
  }

  void updateCustomerEmail(String value) {
    state = state.copyWith(customerEmail: value);
  }

  void updateCustomerPhone(String value) {
    state = state.copyWith(customerPhone: value);
  }

  void updateCustomerAddress(String value) {
    state = state.copyWith(customerAddress: value);
  }

  void updateCustomerCity(String value) {
    state = state.copyWith(customerCity: value);
  }

  void updateCustomerPostalCode(String value) {
    state = state.copyWith(customerPostalCode: value);
  }

  // ============================================
  // ENVÍO
  // ============================================

  Future<void> _loadShippingMethods() async {
    try {
      final supabase = ref.read(supabaseClientProvider);
      final response = await supabase
          .from('shipping_methods')
          .select()
          .eq('is_active', true)
          .order('cost');

      final methods = (response as List)
          .map(
            (json) => ShippingMethod.fromJson({
              'id': json['id'],
              'name': json['name'],
              'description': json['description'],
              'cost': json['cost'],
              'minDays': json['min_days'],
              'maxDays': json['max_days'],
              'isActive': json['is_active'],
            }),
          )
          .toList();

      state = state.copyWith(
        shippingMethods: methods,
        selectedShippingMethod: methods.isNotEmpty ? methods.first : null,
      );
    } catch (e) {
      state = state.copyWith(error: 'Error cargando métodos de envío');
    }
  }

  void selectShippingMethod(ShippingMethod method) {
    state = state.copyWith(selectedShippingMethod: method);
  }

  // ============================================
  // CUPONES
  // ============================================

  void updateCouponCode(String value) {
    state = state.copyWith(couponCode: value.toUpperCase());
  }

  Future<void> applyCoupon(int subtotal) async {
    if (state.couponCode.isEmpty) return;

    state = state.copyWith(isLoading: true, error: null, clearError: true);

    try {
      // Validación local de cupones de ejemplo
      await Future.delayed(const Duration(milliseconds: 300));

      if (state.couponCode == 'DESCUENTO10') {
        final discount = (subtotal * 0.1).round();
        state = state.copyWith(
          couponDiscount: discount,
          appliedCoupon: state.couponCode,
          isLoading: false,
        );
      } else if (state.couponCode == 'ENVIOGRATIS') {
        state = state.copyWith(
          couponDiscount: state.shippingCost,
          appliedCoupon: state.couponCode,
          isLoading: false,
        );
      } else {
        state = state.copyWith(error: 'Cupón no válido', isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(error: 'Error al validar cupón', isLoading: false);
    }
  }

  void removeCoupon() {
    state = state.copyWith(
      couponCode: '',
      couponDiscount: 0,
      appliedCoupon: null,
      clearAppliedCoupon: true,
    );
  }

  // ============================================
  // USUARIO
  // ============================================

  void _prefillUserData() {
    final user = ref.read(supabaseClientProvider).auth.currentUser;
    if (user != null) {
      state = state.copyWith(
        customerEmail: user.email ?? '',
        customerName: user.userMetadata?['full_name'] ?? '',
        customerPhone: user.userMetadata?['phone'] ?? '',
      );
    }
  }

  // Método público para pre-llenar datos del usuario
  void prefillUserData(dynamic user) {
    if (user != null) {
      state = state.copyWith(
        customerEmail: user.email ?? '',
        customerName: user.displayName ?? user.email?.split('@')[0] ?? '',
      );
    }
  }

  // Método para cargar dirección guardada
  void loadSavedAddress(dynamic address) {
    state = state.copyWith(
      customerName: address.fullName ?? state.customerName,
      customerPhone: address.phone ?? state.customerPhone,
      customerAddress: address.address ?? state.customerAddress,
      customerCity: address.city ?? state.customerCity,
      customerPostalCode: address.postalCode ?? state.customerPostalCode,
    );
  }

  // ============================================
  // CHECKOUT
  // ============================================

  void setError(String message) {
    state = state.copyWith(error: message);
  }

  void clearError() {
    state = state.copyWith(error: null, clearError: true);
  }

  void reset() {
    state = const CheckoutState();
    _loadShippingMethods();
    _prefillUserData();
  }
}
