import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/order.dart';
import '../../data/models/cart_item.dart';
import '../../data/models/shipping_address.dart';
import '../../data/models/shipping_method.dart';
import '../../data/models/coupon.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/repositories/shipping_repository.dart';
import 'auth_provider.dart';

/// Provider del repositorio de pedidos
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository();
});

/// Provider del repositorio de envíos
final shippingRepositoryProvider = Provider<ShippingRepository>((ref) {
  return ShippingRepository();
});

/// Provider de los pedidos del usuario
final userOrdersProvider = FutureProvider<List<Order>>((ref) async {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);
  if (!isAuthenticated) return [];

  final repository = ref.watch(orderRepositoryProvider);
  return await repository.getUserOrders(limit: 50);
});

/// Provider de un pedido por ID
final orderByIdProvider =
    FutureProvider.family<Order?, String>((ref, orderId) async {
  final repository = ref.watch(orderRepositoryProvider);
  return await repository.getOrderById(orderId);
});

/// Provider de información de seguimiento
final orderTrackingProvider =
    FutureProvider.family<TrackingInfo?, String>((ref, orderId) async {
  final repository = ref.watch(orderRepositoryProvider);
  return await repository.trackOrder(orderId);
});

/// Provider de métodos de envío
final shippingMethodsProvider =
    FutureProvider<List<ShippingMethod>>((ref) async {
  final repository = ref.watch(shippingRepositoryProvider);
  return await repository.getShippingMethods();
});

/// Provider de direcciones del usuario
final userAddressesProvider =
    FutureProvider<List<ShippingAddress>>((ref) async {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);
  if (!isAuthenticated) return [];

  final repository = ref.watch(shippingRepositoryProvider);
  return await repository.getUserAddresses();
});

/// Provider de la dirección predeterminada
final defaultAddressProvider = FutureProvider<ShippingAddress?>((ref) async {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);
  if (!isAuthenticated) return null;

  final repository = ref.watch(shippingRepositoryProvider);
  return await repository.getDefaultAddress();
});

/// Estado del checkout
class CheckoutState {
  final ShippingAddress? selectedAddress;
  final ShippingMethod? selectedShippingMethod;
  final Coupon? appliedCoupon;
  final List<CartItem> items;
  final int subtotal;
  final int shippingCost;
  final int discount;
  final int taxAmount;
  final int total;
  final bool isLoading;
  final bool isProcessingPayment;
  final String? error;
  final String? successMessage;
  final Order? completedOrder;

  CheckoutState({
    this.selectedAddress,
    this.selectedShippingMethod,
    this.appliedCoupon,
    this.items = const [],
    this.subtotal = 0,
    this.shippingCost = 0,
    this.discount = 0,
    this.taxAmount = 0,
    this.total = 0,
    this.isLoading = false,
    this.isProcessingPayment = false,
    this.error,
    this.successMessage,
    this.completedOrder,
  });

  bool get canProceed =>
      selectedAddress != null &&
      selectedShippingMethod != null &&
      items.isNotEmpty &&
      !isLoading &&
      !isProcessingPayment;

  CheckoutState copyWith({
    ShippingAddress? selectedAddress,
    ShippingMethod? selectedShippingMethod,
    Coupon? appliedCoupon,
    List<CartItem>? items,
    int? subtotal,
    int? shippingCost,
    int? discount,
    int? taxAmount,
    int? total,
    bool? isLoading,
    bool? isProcessingPayment,
    String? error,
    String? successMessage,
    Order? completedOrder,
    bool clearAddress = false,
    bool clearShipping = false,
    bool clearCoupon = false,
    bool clearOrder = false,
  }) {
    return CheckoutState(
      selectedAddress:
          clearAddress ? null : (selectedAddress ?? this.selectedAddress),
      selectedShippingMethod: clearShipping
          ? null
          : (selectedShippingMethod ?? this.selectedShippingMethod),
      appliedCoupon: clearCoupon ? null : (appliedCoupon ?? this.appliedCoupon),
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      shippingCost: shippingCost ?? this.shippingCost,
      discount: clearCoupon ? 0 : (discount ?? this.discount),
      taxAmount: taxAmount ?? this.taxAmount,
      total: total ?? this.total,
      isLoading: isLoading ?? this.isLoading,
      isProcessingPayment: isProcessingPayment ?? this.isProcessingPayment,
      error: error,
      successMessage: successMessage,
      completedOrder:
          clearOrder ? null : (completedOrder ?? this.completedOrder),
    );
  }
}

/// Notifier del checkout
class CheckoutNotifier extends StateNotifier<CheckoutState> {
  final OrderRepository _orderRepository;
  final Ref _ref;

  CheckoutNotifier(this._orderRepository, this._ref) : super(CheckoutState());

  /// Inicializa el checkout con los items del carrito
  void initializeCheckout({
    required List<CartItem> items,
    required int subtotal,
    Coupon? coupon,
    int discount = 0,
  }) {
    _calculateTotals(
      items: items,
      subtotal: subtotal,
      coupon: coupon,
      discount: discount,
    );
  }

  /// Selecciona una dirección de envío
  void selectAddress(ShippingAddress address) {
    state = state.copyWith(selectedAddress: address);
    _recalculateTotals();
  }

  /// Selecciona un método de envío
  void selectShippingMethod(ShippingMethod method) {
    state = state.copyWith(selectedShippingMethod: method);
    _recalculateTotals();
  }

  /// Aplica un cupón
  void applyCoupon(Coupon coupon, int discount) {
    state = state.copyWith(
      appliedCoupon: coupon,
      discount: discount,
    );
    _recalculateTotals();
  }

  /// Elimina el cupón
  void removeCoupon() {
    state = state.copyWith(clearCoupon: true);
    _recalculateTotals();
  }

  void _calculateTotals({
    required List<CartItem> items,
    required int subtotal,
    Coupon? coupon,
    int discount = 0,
  }) {
    state = state.copyWith(
      items: items,
      subtotal: subtotal,
      appliedCoupon: coupon,
      discount: discount,
    );
    _recalculateTotals();
  }

  void _recalculateTotals() {
    final subtotalWithDiscount = state.subtotal - state.discount;

    // Calcular envío
    int shipping = 0;
    if (state.selectedShippingMethod != null) {
      final method = state.selectedShippingMethod!;
      if (method.freeShippingThreshold != null &&
          subtotalWithDiscount >= method.freeShippingThreshold!) {
        shipping = 0;
      } else {
        shipping = method.price;
      }
    }

    // Calcular IVA (21%)
    final taxable = subtotalWithDiscount + shipping;
    final tax = (taxable * 21 / 100).round();

    // Total
    final total = taxable + tax;

    state = state.copyWith(
      shippingCost: shipping,
      taxAmount: tax,
      total: total,
    );
  }

  /// Crea el pedido
  Future<void> createOrder({String? notes}) async {
    if (!state.canProceed) {
      state = state.copyWith(error: 'Por favor, completa todos los datos');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    final result = await _orderRepository.createOrder(
      items: state.items,
      address: state.selectedAddress!,
      shippingMethod: state.selectedShippingMethod!,
      coupon: state.appliedCoupon,
      notes: notes,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        isLoading: false,
        completedOrder: result.order,
        successMessage: 'Pedido creado correctamente',
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }

  /// Procesa el pago del pedido
  Future<void> processPayment(String paymentMethodId) async {
    if (state.completedOrder == null) {
      state = state.copyWith(error: 'No hay pedido para procesar');
      return;
    }

    state = state.copyWith(isProcessingPayment: true, error: null);

    final result = await _orderRepository.processPayment(
      order: state.completedOrder!,
      paymentMethodId: paymentMethodId,
    );

    if (result.isSuccess) {
      // Invalidar los providers relacionados
      _ref.invalidate(userOrdersProvider);

      state = state.copyWith(
        isProcessingPayment: false,
        successMessage: result.message,
      );
    } else {
      state = state.copyWith(
        isProcessingPayment: false,
        error: result.message,
      );
    }
  }

  /// Reinicia el estado del checkout
  void reset() {
    state = CheckoutState();
  }

  /// Limpia los mensajes
  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}

/// Provider del notifier de checkout
final checkoutProvider =
    StateNotifierProvider<CheckoutNotifier, CheckoutState>((ref) {
  final orderRepository = ref.watch(orderRepositoryProvider);
  return CheckoutNotifier(orderRepository, ref);
});

/// Estado de los pedidos del administrador
class AdminOrdersState {
  final List<Order> orders;
  final int total;
  final bool hasMore;
  final bool isLoading;
  final String? statusFilter;
  final String? searchQuery;
  final DateTime? startDate;
  final DateTime? endDate;
  final int page;
  final String? error;

  AdminOrdersState({
    this.orders = const [],
    this.total = 0,
    this.hasMore = false,
    this.isLoading = false,
    this.statusFilter,
    this.searchQuery,
    this.startDate,
    this.endDate,
    this.page = 1,
    this.error,
  });

  AdminOrdersState copyWith({
    List<Order>? orders,
    int? total,
    bool? hasMore,
    bool? isLoading,
    String? statusFilter,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
    int? page,
    String? error,
    bool clearStatus = false,
    bool clearSearch = false,
    bool clearDates = false,
  }) {
    return AdminOrdersState(
      orders: orders ?? this.orders,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      statusFilter: clearStatus ? null : (statusFilter ?? this.statusFilter),
      searchQuery: clearSearch ? null : (searchQuery ?? this.searchQuery),
      startDate: clearDates ? null : (startDate ?? this.startDate),
      endDate: clearDates ? null : (endDate ?? this.endDate),
      page: page ?? this.page,
      error: error,
    );
  }
}

/// Notifier de pedidos para administrador
class AdminOrdersNotifier extends StateNotifier<AdminOrdersState> {
  final OrderRepository _repository;

  AdminOrdersNotifier(this._repository) : super(AdminOrdersState());

  /// Carga los pedidos
  Future<void> loadOrders({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(page: 1, isLoading: true, error: null);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    final result = await _repository.getAllOrders(
      page: state.page,
      limit: 20,
      status: state.statusFilter,
      searchQuery: state.searchQuery,
      startDate: state.startDate,
      endDate: state.endDate,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        orders: refresh ? result.orders : [...state.orders, ...result.orders],
        total: result.total,
        hasMore: result.hasMore,
        isLoading: false,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.errorMessage,
      );
    }
  }

  /// Carga más pedidos
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;
    state = state.copyWith(page: state.page + 1);
    await loadOrders();
  }

  /// Filtra por estado
  Future<void> filterByStatus(String? status) async {
    state = state.copyWith(statusFilter: status, clearStatus: status == null);
    await loadOrders(refresh: true);
  }

  /// Busca pedidos
  Future<void> search(String? query) async {
    state = state.copyWith(
        searchQuery: query, clearSearch: query == null || query.isEmpty);
    await loadOrders(refresh: true);
  }

  /// Filtra por fechas
  Future<void> filterByDates(DateTime? start, DateTime? end) async {
    state = state.copyWith(
      startDate: start,
      endDate: end,
      clearDates: start == null && end == null,
    );
    await loadOrders(refresh: true);
  }

  /// Actualiza el estado de un pedido
  Future<void> updateOrderStatus(
    String orderId,
    OrderStatus status, {
    String? trackingNumber,
    String? trackingUrl,
  }) async {
    final result = await _repository.updateOrderStatus(
      orderId,
      status,
      trackingNumber: trackingNumber,
      trackingUrl: trackingUrl,
    );

    if (result.isSuccess && result.order != null) {
      // Actualizar el pedido en la lista
      final updatedOrders = state.orders.map((order) {
        if (order.id == orderId) {
          return result.order!;
        }
        return order;
      }).toList();

      state = state.copyWith(orders: updatedOrders);
    }
  }
}

/// Provider del notifier de pedidos admin
final adminOrdersProvider =
    StateNotifierProvider<AdminOrdersNotifier, AdminOrdersState>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return AdminOrdersNotifier(repository);
});

/// Provider de estadísticas de pedidos
final orderStatsProvider = FutureProvider<OrderStats>((ref) async {
  final repository = ref.watch(orderRepositoryProvider);
  return await repository.getOrderStats();
});
