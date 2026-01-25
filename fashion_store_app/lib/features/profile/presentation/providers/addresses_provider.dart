import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/services/supabase_service.dart' hide currentUserProvider;
import '../../../auth/presentation/providers/auth_provider.dart' show currentUserProvider;

/// Modelo de dirección de envío
class ShippingAddress {
  final int id;
  final String userId;
  final String fullName;
  final String address;
  final String postalCode;
  final String city;
  final String phone;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ShippingAddress({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.address,
    required this.postalCode,
    required this.city,
    required this.phone,
    required this.isDefault,
    required this.createdAt,
    this.updatedAt,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      fullName: json['full_name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      postalCode: json['postal_code'] as String? ?? '',
      city: json['city'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      isDefault: json['is_default'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'full_name': fullName,
      'address': address,
      'postal_code': postalCode,
      'city': city,
      'phone': phone,
      'is_default': isDefault,
    };
  }

  ShippingAddress copyWith({
    int? id,
    String? userId,
    String? fullName,
    String? address,
    String? postalCode,
    String? city,
    String? phone,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ShippingAddress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      postalCode: postalCode ?? this.postalCode,
      city: city ?? this.city,
      phone: phone ?? this.phone,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get shortAddress => '$address, $postalCode $city';
}

/// Provider para las direcciones del usuario
final userAddressesProvider = FutureProvider<List<ShippingAddress>>((ref) async {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return [];
  
  final supabase = ref.watch(supabaseClientProvider);
  
  final response = await supabase
      .from('user_shipping_addresses')
      .select()
      .eq('user_id', user.id)
      .order('is_default', ascending: false)
      .order('created_at', ascending: false);
  
  return (response as List)
      .map((json) => ShippingAddress.fromJson(json))
      .toList();
});

/// Provider para la dirección por defecto
final defaultAddressProvider = FutureProvider<ShippingAddress?>((ref) async {
  final addresses = await ref.watch(userAddressesProvider.future);
  return addresses.where((a) => a.isDefault).firstOrNull ?? addresses.firstOrNull;
});

/// Notifier para gestionar direcciones
class AddressesNotifier extends Notifier<AddressesActionState> {
  @override
  AddressesActionState build() => const AddressesActionState();

  Future<void> addAddress({
    required String fullName,
    required String address,
    required String postalCode,
    required String city,
    required String phone,
    bool isDefault = false,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final user = ref.read(currentUserProvider).value;
    if (user == null) {
      state = state.copyWith(isLoading: false, error: 'Usuario no autenticado');
      return;
    }
    
    final supabase = ref.read(supabaseClientProvider);
    
    try {
      // Si es default, quitar default de las demás
      if (isDefault) {
        await supabase
            .from('user_shipping_addresses')
            .update({'is_default': false})
            .eq('user_id', user.id);
      }
      
      await supabase.from('user_shipping_addresses').insert({
        'user_id': user.id,
        'full_name': fullName,
        'address': address,
        'postal_code': postalCode,
        'city': city,
        'phone': phone,
        'is_default': isDefault,
      });
      
      ref.invalidate(userAddressesProvider);
      state = state.copyWith(isLoading: false, successMessage: 'Dirección añadida');
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Error al añadir dirección: $e');
    }
  }

  Future<void> updateAddress({
    required int id,
    String? fullName,
    String? address,
    String? postalCode,
    String? city,
    String? phone,
    bool? isDefault,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final user = ref.read(currentUserProvider).value;
    if (user == null) {
      state = state.copyWith(isLoading: false, error: 'Usuario no autenticado');
      return;
    }
    
    final supabase = ref.read(supabaseClientProvider);
    
    try {
      // Si es default, quitar default de las demás
      if (isDefault == true) {
        await supabase
            .from('user_shipping_addresses')
            .update({'is_default': false})
            .eq('user_id', user.id);
      }
      
      final updates = <String, dynamic>{};
      if (fullName != null) updates['full_name'] = fullName;
      if (address != null) updates['address'] = address;
      if (postalCode != null) updates['postal_code'] = postalCode;
      if (city != null) updates['city'] = city;
      if (phone != null) updates['phone'] = phone;
      if (isDefault != null) updates['is_default'] = isDefault;
      updates['updated_at'] = DateTime.now().toIso8601String();
      
      await supabase
          .from('user_shipping_addresses')
          .update(updates)
          .eq('id', id);
      
      ref.invalidate(userAddressesProvider);
      state = state.copyWith(isLoading: false, successMessage: 'Dirección actualizada');
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Error al actualizar dirección: $e');
    }
  }

  Future<void> deleteAddress(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final supabase = ref.read(supabaseClientProvider);
    
    try {
      await supabase
          .from('user_shipping_addresses')
          .delete()
          .eq('id', id);
      
      ref.invalidate(userAddressesProvider);
      state = state.copyWith(isLoading: false, successMessage: 'Dirección eliminada');
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Error al eliminar dirección: $e');
    }
  }

  Future<void> setAsDefault(int id) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final user = ref.read(currentUserProvider).value;
    if (user == null) {
      state = state.copyWith(isLoading: false, error: 'Usuario no autenticado');
      return;
    }
    
    final supabase = ref.read(supabaseClientProvider);
    
    try {
      // Quitar default de todas
      await supabase
          .from('user_shipping_addresses')
          .update({'is_default': false})
          .eq('user_id', user.id);
      
      // Poner default a la seleccionada
      await supabase
          .from('user_shipping_addresses')
          .update({'is_default': true})
          .eq('id', id);
      
      ref.invalidate(userAddressesProvider);
      state = state.copyWith(isLoading: false, successMessage: 'Dirección predeterminada actualizada');
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Error al establecer dirección predeterminada: $e');
    }
  }
  
  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}

/// Estado para las acciones de direcciones
class AddressesActionState {
  final bool isLoading;
  final String? error;
  final String? successMessage;
  
  const AddressesActionState({
    this.isLoading = false,
    this.error,
    this.successMessage,
  });
  
  AddressesActionState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
  }) {
    return AddressesActionState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
    );
  }
}

final addressesNotifierProvider = NotifierProvider<AddressesNotifier, AddressesActionState>(() {
  return AddressesNotifier();
});
