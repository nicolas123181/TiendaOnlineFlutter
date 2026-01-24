import '../models/shipping_address.dart';
import '../models/shipping_method.dart';
import '../../core/services/supabase_service.dart';

/// Repositorio de envíos y direcciones
class ShippingRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;

  // ==================== Direcciones de Envío ====================

  /// Obtiene las direcciones de envío del usuario
  Future<List<ShippingAddress>> getUserAddresses() async {
    try {
      return await _supabaseService.getUserAddresses();
    } catch (e) {
      return [];
    }
  }

  /// Obtiene una dirección por ID
  Future<ShippingAddress?> getAddressById(String addressId) async {
    try {
      return await _supabaseService.getAddressById(addressId);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene la dirección predeterminada del usuario
  Future<ShippingAddress?> getDefaultAddress() async {
    try {
      final addresses = await _supabaseService.getUserAddresses();
      return addresses.firstWhere(
        (addr) => addr.isDefault,
        orElse: () => addresses.isNotEmpty
            ? addresses.first
            : throw Exception('No addresses'),
      );
    } catch (e) {
      return null;
    }
  }

  /// Guarda una dirección de envío
  Future<AddressResult> saveAddress(ShippingAddress address) async {
    try {
      ShippingAddress? saved;

      if (address.id == 0) {
        // Crear nueva dirección
        saved = await _supabaseService.createAddress(address);
      } else {
        // Actualizar dirección existente
        saved = await _supabaseService.updateAddress(address);
      }

      if (saved != null) {
        return AddressResult.success(
          address: saved,
          message: 'Dirección guardada correctamente',
        );
      } else {
        return AddressResult.error(message: 'Error al guardar la dirección');
      }
    } catch (e) {
      return AddressResult.error(message: 'Error al guardar la dirección: $e');
    }
  }

  /// Elimina una dirección de envío
  Future<AddressResult> deleteAddress(String addressId) async {
    try {
      await _supabaseService.deleteAddress(addressId);
      return AddressResult.success(
          message: 'Dirección eliminada correctamente');
    } catch (e) {
      return AddressResult.error(message: 'Error al eliminar la dirección: $e');
    }
  }

  /// Establece una dirección como predeterminada
  Future<AddressResult> setDefaultAddress(String addressId) async {
    try {
      await _supabaseService.setDefaultAddress(addressId);

      final address = await _supabaseService.getAddressById(addressId);

      return AddressResult.success(
        address: address,
        message: 'Dirección predeterminada actualizada',
      );
    } catch (e) {
      return AddressResult.error(
        message: 'Error al establecer dirección predeterminada: $e',
      );
    }
  }

  /// Valida una dirección
  AddressValidation validateAddress(ShippingAddress address) {
    final errors = <String>[];

    if (address.fullName.isEmpty) {
      errors.add('El nombre es requerido');
    }
    if (address.street.isEmpty) {
      errors.add('La dirección es requerida');
    }
    if (address.city.isEmpty) {
      errors.add('La ciudad es requerida');
    }
    if (address.postalCode.isEmpty) {
      errors.add('El código postal es requerido');
    }
    if (address.phone.isEmpty) {
      errors.add('El teléfono es requerido');
    }

    // Validar formato de código postal español
    final postalCodeRegex = RegExp(r'^\d{5}$');
    if (address.postalCode.isNotEmpty &&
        !postalCodeRegex.hasMatch(address.postalCode)) {
      errors.add('El código postal no es válido');
    }

    // Validar formato de teléfono español
    final phoneRegex = RegExp(r'^(\+34)?[6789]\d{8}$');
    if (address.phone.isNotEmpty &&
        !phoneRegex.hasMatch(address.phone.replaceAll(' ', ''))) {
      errors.add('El teléfono no es válido');
    }

    return AddressValidation(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  // ==================== Métodos de Envío ====================

  /// Obtiene los métodos de envío disponibles
  Future<List<ShippingMethod>> getShippingMethods() async {
    try {
      return await _supabaseService.getShippingMethods();
    } catch (e) {
      return [];
    }
  }

  /// Obtiene un método de envío por ID
  Future<ShippingMethod?> getShippingMethodById(String methodId) async {
    try {
      return await _supabaseService.getShippingMethodById(methodId);
    } catch (e) {
      return null;
    }
  }

  /// Calcula el coste de envío
  Future<int> calculateShippingCost({
    required String methodId,
    required int subtotal,
    required String postalCode,
  }) async {
    try {
      final method = await _supabaseService.getShippingMethodById(methodId);

      if (method == null) return 0;

      // Envío gratis si supera el mínimo
      if (method.freeShippingThreshold != null &&
          subtotal >= method.freeShippingThreshold!) {
        return 0;
      }

      return method.price;
    } catch (e) {
      return 0;
    }
  }

  /// Obtiene los transportistas disponibles
  Future<List<ShippingCarrier>> getCarriers() async {
    try {
      return await _supabaseService.getCarriers();
    } catch (e) {
      return [];
    }
  }

  /// Estima la fecha de entrega
  DateTime estimateDeliveryDate(ShippingMethod method) {
    final now = DateTime.now();
    final businessDays = method.estimatedDays;

    // Calcular fecha considerando solo días laborables
    int addedDays = 0;
    DateTime deliveryDate = now;

    while (addedDays < businessDays) {
      deliveryDate = deliveryDate.add(const Duration(days: 1));

      // Excluir sábados (6) y domingos (7)
      if (deliveryDate.weekday != DateTime.saturday &&
          deliveryDate.weekday != DateTime.sunday) {
        addedDays++;
      }
    }

    return deliveryDate;
  }

  // ==================== Admin Methods ====================

  /// Obtiene todos los métodos de envío (Admin)
  Future<List<ShippingMethod>> getAllShippingMethods() async {
    try {
      return await _supabaseService.getAllShippingMethods();
    } catch (e) {
      return [];
    }
  }

  /// Crea un método de envío (Admin)
  Future<ShippingResult> createShippingMethod(ShippingMethod method) async {
    try {
      final created = await _supabaseService.createShippingMethod(method);

      if (created != null) {
        return ShippingResult.success(
          method: created,
          message: 'Método de envío creado correctamente',
        );
      } else {
        return ShippingResult.error(message: 'Error al crear método de envío');
      }
    } catch (e) {
      return ShippingResult.error(
          message: 'Error al crear método de envío: $e');
    }
  }

  /// Actualiza un método de envío (Admin)
  Future<ShippingResult> updateShippingMethod(ShippingMethod method) async {
    try {
      final updated = await _supabaseService.updateShippingMethod(method);

      if (updated != null) {
        return ShippingResult.success(
          method: updated,
          message: 'Método de envío actualizado correctamente',
        );
      } else {
        return ShippingResult.error(
            message: 'Error al actualizar método de envío');
      }
    } catch (e) {
      return ShippingResult.error(
          message: 'Error al actualizar método de envío: $e');
    }
  }

  /// Elimina un método de envío (Admin)
  Future<ShippingResult> deleteShippingMethod(String methodId) async {
    try {
      await _supabaseService.deleteShippingMethod(methodId);
      return ShippingResult.success(message: 'Método de envío eliminado');
    } catch (e) {
      return ShippingResult.error(
          message: 'Error al eliminar método de envío: $e');
    }
  }

  /// Activa/desactiva un método de envío (Admin)
  Future<ShippingResult> toggleShippingMethodActive(
    String methodId,
    bool isActive,
  ) async {
    try {
      final method = await _supabaseService.getShippingMethodById(methodId);
      if (method == null) {
        return ShippingResult.error(message: 'Método de envío no encontrado');
      }

      final updated = await _supabaseService.updateShippingMethod(
        method.copyWith(isActive: isActive),
      );

      if (updated != null) {
        return ShippingResult.success(
          method: updated,
          message: isActive ? 'Método activado' : 'Método desactivado',
        );
      } else {
        return ShippingResult.error(message: 'Error al actualizar método');
      }
    } catch (e) {
      return ShippingResult.error(message: 'Error al actualizar método: $e');
    }
  }

  /// Obtiene todos los transportistas (Admin)
  Future<List<ShippingCarrier>> getAllCarriers() async {
    try {
      return await _supabaseService.getAllCarriers();
    } catch (e) {
      return [];
    }
  }

  /// Crea un transportista (Admin)
  Future<CarrierResult> createCarrier(ShippingCarrier carrier) async {
    try {
      final created = await _supabaseService.createCarrier(carrier);

      if (created != null) {
        return CarrierResult.success(
          carrier: created,
          message: 'Transportista creado correctamente',
        );
      } else {
        return CarrierResult.error(message: 'Error al crear transportista');
      }
    } catch (e) {
      return CarrierResult.error(message: 'Error al crear transportista: $e');
    }
  }

  /// Actualiza un transportista (Admin)
  Future<CarrierResult> updateCarrier(ShippingCarrier carrier) async {
    try {
      final updated = await _supabaseService.updateCarrier(carrier);

      if (updated != null) {
        return CarrierResult.success(
          carrier: updated,
          message: 'Transportista actualizado correctamente',
        );
      } else {
        return CarrierResult.error(
            message: 'Error al actualizar transportista');
      }
    } catch (e) {
      return CarrierResult.error(
          message: 'Error al actualizar transportista: $e');
    }
  }

  /// Elimina un transportista (Admin)
  Future<CarrierResult> deleteCarrier(String carrierId) async {
    try {
      await _supabaseService.deleteCarrier(carrierId);
      return CarrierResult.success(message: 'Transportista eliminado');
    } catch (e) {
      return CarrierResult.error(
          message: 'Error al eliminar transportista: $e');
    }
  }
}

/// Resultado de operaciones con direcciones
class AddressResult {
  final bool isSuccess;
  final ShippingAddress? address;
  final String? message;

  AddressResult._({
    required this.isSuccess,
    this.address,
    this.message,
  });

  factory AddressResult.success({ShippingAddress? address, String? message}) {
    return AddressResult._(
      isSuccess: true,
      address: address,
      message: message,
    );
  }

  factory AddressResult.error({required String message}) {
    return AddressResult._(
      isSuccess: false,
      message: message,
    );
  }
}

/// Validación de dirección
class AddressValidation {
  final bool isValid;
  final List<String> errors;

  AddressValidation({
    required this.isValid,
    required this.errors,
  });
}

/// Resultado de operaciones con métodos de envío
class ShippingResult {
  final bool isSuccess;
  final ShippingMethod? method;
  final String? message;

  ShippingResult._({
    required this.isSuccess,
    this.method,
    this.message,
  });

  factory ShippingResult.success({ShippingMethod? method, String? message}) {
    return ShippingResult._(
      isSuccess: true,
      method: method,
      message: message,
    );
  }

  factory ShippingResult.error({required String message}) {
    return ShippingResult._(
      isSuccess: false,
      message: message,
    );
  }
}

/// Resultado de operaciones con transportistas
class CarrierResult {
  final bool isSuccess;
  final ShippingCarrier? carrier;
  final String? message;

  CarrierResult._({
    required this.isSuccess,
    this.carrier,
    this.message,
  });

  factory CarrierResult.success({ShippingCarrier? carrier, String? message}) {
    return CarrierResult._(
      isSuccess: true,
      carrier: carrier,
      message: message,
    );
  }

  factory CarrierResult.error({required String message}) {
    return CarrierResult._(
      isSuccess: false,
      message: message,
    );
  }
}
