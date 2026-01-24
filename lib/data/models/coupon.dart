import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon.freezed.dart';

/// Modelo de Cupón de descuento
@Freezed(toJson: false, fromJson: false)
class Coupon with _$Coupon {
  const Coupon._(); // Constructor privado para permitir métodos

  const factory Coupon({
    required int id,
    required String code,
    required String discountType, // 'percentage' o 'fixed'
    required int discountValue, // Porcentaje o cantidad en centavos
    int? maxUses,
    @Default(0) int usedCount,
    int? maxUsesPerUser,
    int? minPurchase, // Monto mínimo en centavos
    required DateTime startDate,
    DateTime? endDate,
    @Default(true) bool isActive,
    required DateTime createdAt,
  }) = _Coupon;

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'] as int,
      code: json['code'] as String,
      discountType: json['discount_type'] as String,
      discountValue: json['discount_value'] as int,
      maxUses: json['max_uses'] as int?,
      usedCount: json['used_count'] as int? ?? 0,
      maxUsesPerUser: json['max_uses_per_user'] as int?,
      minPurchase: json['min_purchase'] as int?,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'discount_type': discountType,
      'discount_value': discountValue,
      'max_uses': maxUses,
      'max_uses_per_user': maxUsesPerUser,
      'min_purchase': minPurchase,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_active': isActive,
    };
  }

  /// Verifica si el cupón está vigente
  bool get isValid {
    if (!isActive) return false;

    final now = DateTime.now();

    // Verificar fecha de inicio
    if (now.isBefore(startDate)) return false;

    // Verificar fecha de fin
    if (endDate != null && now.isAfter(endDate!)) return false;

    // Verificar usos máximos
    if (maxUses != null && usedCount >= maxUses!) return false;

    return true;
  }

  /// Verifica si el cupón está próximo a expirar (7 días)
  bool get isExpiringSoon {
    if (endDate == null) return false;
    final daysUntilExpiry = endDate!.difference(DateTime.now()).inDays;
    return daysUntilExpiry >= 0 && daysUntilExpiry <= 7;
  }

  /// Días restantes hasta expirar
  int? get daysUntilExpiry {
    if (endDate == null) return null;
    final days = endDate!.difference(DateTime.now()).inDays;
    return days >= 0 ? days : 0;
  }

  /// Usos restantes
  int? get remainingUses {
    if (maxUses == null) return null;
    return maxUses! - usedCount;
  }

  /// Verifica si el cupón está expirado
  bool get isExpired => endDate != null && DateTime.now().isAfter(endDate!);

  /// Alias de usedCount (para compatibilidad)
  int get usageCount => usedCount;

  /// Calcula el descuento para un monto dado
  int calculateDiscount(int amount) {
    if (!isValid) return 0;

    // Verificar monto mínimo
    if (minPurchase != null && amount < minPurchase!) return 0;

    if (discountType == 'percentage') {
      return ((amount * discountValue) / 100).round();
    } else {
      // Fixed
      return discountValue > amount ? amount : discountValue;
    }
  }

  /// Valida el cupón para un monto dado
  CouponValidationResult validate(int amount) {
    if (!isActive) {
      return const CouponValidationResult.invalid('Cupón inactivo');
    }

    final now = DateTime.now();
    if (now.isBefore(startDate)) {
      return const CouponValidationResult.invalid(
        'El cupón aún no está disponible',
      );
    }

    if (endDate != null && now.isAfter(endDate!)) {
      return const CouponValidationResult.invalid('Cupón expirado');
    }

    if (maxUses != null && usedCount >= maxUses!) {
      return const CouponValidationResult.invalid('Cupón agotado');
    }

    if (minPurchase != null && amount < minPurchase!) {
      return CouponValidationResult.invalid(
        'Compra mínima: €${(minPurchase! / 100).toStringAsFixed(2)}',
      );
    }

    return const CouponValidationResult.valid();
  }

  /// Texto descriptivo del descuento
  String get discountText {
    if (discountType == 'percentage') {
      return '$discountValue%';
    } else {
      return '€${(discountValue / 100).toStringAsFixed(2)}';
    }
  }

  /// Estado del cupón en texto
  String get statusText {
    if (!isActive) return 'Inactivo';
    if (!isValid) {
      if (endDate != null && DateTime.now().isAfter(endDate!)) {
        return 'Expirado';
      }
      if (maxUses != null && usedCount >= maxUses!) {
        return 'Agotado';
      }
      return 'No disponible';
    }
    return 'Activo';
  }
}

/// Resultado de validación de cupón
class CouponValidationResult {
  final bool isValid;
  final String? message;

  const CouponValidationResult._(this.isValid, this.message);

  const CouponValidationResult.valid() : this._(true, null);

  const CouponValidationResult.invalid(String message) : this._(false, message);
}
