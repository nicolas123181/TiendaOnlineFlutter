import 'package:freezed_annotation/freezed_annotation.dart';

part 'shipping_method.freezed.dart';

/// Modelo de Método de Envío
@Freezed(toJson: false, fromJson: false)
class ShippingMethod with _$ShippingMethod {
  const ShippingMethod._(); // Constructor privado para permitir métodos

  const factory ShippingMethod({
    required int id,
    required String name,
    String? description,
    required int cost, // En centavos
    required int minDays,
    required int maxDays,
    int? minOrderAmount,
    int? maxWeightGrams,
    @Default(true) bool isActive,
    @Default(0) int displayOrder,
    required DateTime createdAt,
  }) = _ShippingMethod;

  factory ShippingMethod.fromJson(Map<String, dynamic> json) {
    return ShippingMethod(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      cost: json['cost'] as int,
      minDays: json['min_days'] as int,
      maxDays: json['max_days'] as int,
      minOrderAmount: json['min_order_amount'] as int?,
      maxWeightGrams: json['max_weight_grams'] as int?,
      isActive: json['is_active'] as bool? ?? true,
      displayOrder: json['display_order'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'cost': cost,
      'min_days': minDays,
      'max_days': maxDays,
      'min_order_amount': minOrderAmount,
      'max_weight_grams': maxWeightGrams,
      'is_active': isActive,
      'display_order': displayOrder,
    };
  }

  /// Texto de tiempo de entrega
  String get deliveryTimeText {
    if (minDays == maxDays) {
      if (minDays == 0) return 'Mismo día';
      if (minDays == 1) return '1 día';
      return '$minDays días';
    }
    return '$minDays-$maxDays días';
  }

  /// Verifica si es gratis
  bool get isFree => cost == 0;

  /// Texto de costo
  String get costText {
    if (isFree) return 'Gratis';
    return '€${(cost / 100).toStringAsFixed(2)}';
  }

  /// Verifica si está disponible para un monto dado
  bool isAvailableForAmount(int orderAmount) {
    if (!isActive) return false;
    if (minOrderAmount != null && orderAmount < minOrderAmount!) return false;
    return true;
  }

  /// Alias de cost (para compatibilidad)
  int get price => cost;

  /// Alias de minOrderAmount (umbral para envío gratis)
  int? get freeShippingThreshold => minOrderAmount;

  /// Días estimados de entrega (promedio)
  int get estimatedDays => (minDays + maxDays) ~/ 2;
}

/// Modelo de Transportista
@Freezed(toJson: false, fromJson: false)
class ShippingCarrier with _$ShippingCarrier {
  const ShippingCarrier._(); // Constructor privado para permitir métodos

  const factory ShippingCarrier({
    required int id,
    required String name,
    required String code,
    String? trackingUrlTemplate,
    String? logoUrl,
    @Default(true) bool isActive,
    @Default(0) int displayOrder,
    required DateTime createdAt,
  }) = _ShippingCarrier;

  factory ShippingCarrier.fromJson(Map<String, dynamic> json) {
    return ShippingCarrier(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
      trackingUrlTemplate: json['tracking_url_template'] as String?,
      logoUrl: json['logo_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      displayOrder: json['display_order'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'tracking_url_template': trackingUrlTemplate,
      'logo_url': logoUrl,
      'is_active': isActive,
      'display_order': displayOrder,
    };
  }

  /// Genera la URL de tracking para un número específico
  String? getTrackingUrl(String trackingNumber) {
    if (trackingUrlTemplate == null || trackingUrlTemplate!.isEmpty) {
      return null;
    }
    return trackingUrlTemplate!.replaceAll('{tracking_number}', trackingNumber);
  }
}
