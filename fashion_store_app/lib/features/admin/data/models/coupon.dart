// Modelo para Cupones

class Coupon {
  final int id;
  final String code;
  final String discountType; // 'percentage' o 'fixed'
  final int discountValue; // porcentaje o céntimos
  final int minPurchase; // en céntimos
  final int? maxUses;
  final int? maxUsesPerUser;
  final int currentUses;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isActive;
  final DateTime createdAt;

  Coupon({
    required this.id,
    required this.code,
    required this.discountType,
    required this.discountValue,
    required this.minPurchase,
    this.maxUses,
    this.maxUsesPerUser,
    required this.currentUses,
    this.startDate,
    this.endDate,
    required this.isActive,
    required this.createdAt,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'],
      code: json['code'],
      discountType: json['discount_type'],
      discountValue: json['discount_value'],
      minPurchase: json['min_purchase'] ?? 0,
      maxUses: json['max_uses'],
      maxUsesPerUser: json['max_uses_per_user'],
      currentUses: json['current_uses'] ?? 0,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : null,
      isActive: json['is_active'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'discount_type': discountType,
      'discount_value': discountValue,
      'min_purchase': minPurchase,
      'max_uses': maxUses,
      'max_uses_per_user': maxUsesPerUser,
      'current_uses': currentUses,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }

  bool get isExpired {
    if (endDate == null) return false;
    return DateTime.now().isAfter(endDate!);
  }

  bool get hasStarted {
    if (startDate == null) return true;
    return DateTime.now().isAfter(startDate!);
  }

  bool get isAvailable {
    return isActive && hasStarted && !isExpired;
  }

  String get displayDiscount {
    if (discountType == 'percentage') {
      return '$discountValue%';
    } else {
      return '${(discountValue / 100).toStringAsFixed(2)}€';
    }
  }
}
