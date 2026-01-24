import '../models/coupon.dart';
import '../../core/services/supabase_service.dart';

/// Repositorio de cupones de descuento
class CouponRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;

  /// Valida y obtiene un cupón por código
  Future<CouponResult> validateCoupon({
    required String code,
    required int orderTotal,
  }) async {
    try {
      final coupon = await _supabaseService.getCouponByCode(code);

      if (coupon == null) {
        return CouponResult.error(message: 'Cupón no encontrado');
      }

      // Validar el cupón
      final validation = coupon.validate(orderTotal);

      if (!validation.isValid) {
        return CouponResult.error(message: validation.message!);
      }

      // Calcular el descuento
      final discount = coupon.calculateDiscount(orderTotal);

      return CouponResult.success(
        coupon: coupon,
        discount: discount,
        message: 'Cupón aplicado: -€${(discount / 100).toStringAsFixed(2)}',
      );
    } catch (e) {
      return CouponResult.error(message: 'Error al validar el cupón: $e');
    }
  }

  /// Marca un cupón como usado
  Future<void> markCouponAsUsed(String couponId) async {
    try {
      await _supabaseService.incrementCouponUsage(couponId);
    } catch (e) {
      // Log error pero no bloqueamos el flujo
    }
  }

  // ==================== Admin Methods ====================

  /// Obtiene todos los cupones (Admin)
  Future<List<Coupon>> getAllCoupons() async {
    try {
      return await _supabaseService.getAllCoupons();
    } catch (e) {
      return [];
    }
  }

  /// Obtiene cupones activos (Admin)
  Future<List<Coupon>> getActiveCoupons() async {
    try {
      return await _supabaseService.getActiveCoupons();
    } catch (e) {
      return [];
    }
  }

  /// Obtiene un cupón por ID (Admin)
  Future<Coupon?> getCouponById(String id) async {
    try {
      return await _supabaseService.getCouponById(id);
    } catch (e) {
      return null;
    }
  }

  /// Crea un nuevo cupón (Admin)
  Future<CouponResult> createCoupon(Coupon coupon) async {
    try {
      // Verificar que el código no exista
      final existing = await _supabaseService.getCouponByCode(coupon.code);
      if (existing != null) {
        return CouponResult.error(
            message: 'Ya existe un cupón con este código');
      }

      final created = await _supabaseService.createCoupon(coupon);

      if (created != null) {
        return CouponResult.success(
          coupon: created,
          message: 'Cupón creado correctamente',
        );
      } else {
        return CouponResult.error(message: 'Error al crear el cupón');
      }
    } catch (e) {
      return CouponResult.error(message: 'Error al crear el cupón: $e');
    }
  }

  /// Actualiza un cupón (Admin)
  Future<CouponResult> updateCoupon(Coupon coupon) async {
    try {
      // Verificar que el código no esté en uso por otro cupón
      final existing = await _supabaseService.getCouponByCode(coupon.code);
      if (existing != null && existing.id != coupon.id) {
        return CouponResult.error(
          message: 'Ya existe otro cupón con este código',
        );
      }

      final updated = await _supabaseService.updateCoupon(coupon);

      if (updated != null) {
        return CouponResult.success(
          coupon: updated,
          message: 'Cupón actualizado correctamente',
        );
      } else {
        return CouponResult.error(message: 'Error al actualizar el cupón');
      }
    } catch (e) {
      return CouponResult.error(message: 'Error al actualizar el cupón: $e');
    }
  }

  /// Elimina un cupón (Admin)
  Future<CouponResult> deleteCoupon(String id) async {
    try {
      await _supabaseService.deleteCoupon(id);
      return CouponResult.success(message: 'Cupón eliminado correctamente');
    } catch (e) {
      return CouponResult.error(message: 'Error al eliminar el cupón: $e');
    }
  }

  /// Activa/desactiva un cupón (Admin)
  Future<CouponResult> toggleCouponActive(String id, bool isActive) async {
    try {
      final coupon = await _supabaseService.getCouponById(id);
      if (coupon == null) {
        return CouponResult.error(message: 'Cupón no encontrado');
      }

      final updated = await _supabaseService.updateCoupon(
        coupon.copyWith(isActive: isActive),
      );

      if (updated != null) {
        return CouponResult.success(
          coupon: updated,
          message: isActive ? 'Cupón activado' : 'Cupón desactivado',
        );
      } else {
        return CouponResult.error(message: 'Error al actualizar el cupón');
      }
    } catch (e) {
      return CouponResult.error(message: 'Error al actualizar el cupón: $e');
    }
  }

  /// Obtiene estadísticas de uso de cupones (Admin)
  Future<CouponStats> getCouponStats() async {
    try {
      final coupons = await _supabaseService.getAllCoupons();

      int totalCoupons = coupons.length;
      int activeCoupons =
          coupons.where((c) => c.isActive && !c.isExpired).length;
      int expiredCoupons = coupons.where((c) => c.isExpired).length;
      int totalUsage = coupons.fold<int>(0, (sum, c) => sum + c.usageCount);

      return CouponStats(
        totalCoupons: totalCoupons,
        activeCoupons: activeCoupons,
        expiredCoupons: expiredCoupons,
        totalUsage: totalUsage,
      );
    } catch (e) {
      return CouponStats.empty();
    }
  }

  /// Genera un código de cupón único
  String generateCouponCode({int length = 8}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    final buffer = StringBuffer();

    for (int i = 0; i < length; i++) {
      buffer.write(chars[(random + i * 7) % chars.length]);
    }

    return buffer.toString();
  }
}

/// Resultado de operaciones con cupones
class CouponResult {
  final bool isSuccess;
  final Coupon? coupon;
  final int discount;
  final String? message;

  CouponResult._({
    required this.isSuccess,
    this.coupon,
    this.discount = 0,
    this.message,
  });

  factory CouponResult.success({
    Coupon? coupon,
    int discount = 0,
    String? message,
  }) {
    return CouponResult._(
      isSuccess: true,
      coupon: coupon,
      discount: discount,
      message: message,
    );
  }

  factory CouponResult.error({required String message}) {
    return CouponResult._(
      isSuccess: false,
      message: message,
    );
  }
}

/// Estadísticas de cupones
class CouponStats {
  final int totalCoupons;
  final int activeCoupons;
  final int expiredCoupons;
  final int totalUsage;

  CouponStats({
    required this.totalCoupons,
    required this.activeCoupons,
    required this.expiredCoupons,
    required this.totalUsage,
  });

  factory CouponStats.empty() {
    return CouponStats(
      totalCoupons: 0,
      activeCoupons: 0,
      expiredCoupons: 0,
      totalUsage: 0,
    );
  }
}
