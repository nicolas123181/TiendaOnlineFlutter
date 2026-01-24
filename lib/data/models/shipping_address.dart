import 'package:freezed_annotation/freezed_annotation.dart';

part 'shipping_address.freezed.dart';

/// Modelo de Dirección de Envío
@Freezed(toJson: false, fromJson: false)
class ShippingAddress with _$ShippingAddress {
  const ShippingAddress._(); // Constructor privado para permitir métodos

  const factory ShippingAddress({
    required int id,
    required String userId,
    required String fullName,
    required String address,
    required String postalCode,
    required String city,
    required String phone,
    @Default(false) bool isDefault,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ShippingAddress;

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      fullName: json['full_name'] as String,
      address: json['address'] as String,
      postalCode: json['postal_code'] as String,
      city: json['city'] as String,
      phone: json['phone'] as String,
      isDefault: json['is_default'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
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

  /// Dirección completa formateada
  String get fullAddress => '$address, $postalCode $city';

  /// Resumen corto de la dirección
  String get shortAddress => '$address, $city';

  /// Alias de address (para compatibilidad)
  String get street => address;
}
