// Provider simplificado para gestión de cupones

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/services/supabase_service.dart';
import '../../data/models/coupon.dart';

/// Provider para listar cupones
final couponsProvider = FutureProvider<List<Coupon>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);

  final response = await supabase
      .from('coupons')
      .select('*')
      .order('created_at', ascending: false);

  return (response as List).map((json) => Coupon.fromJson(json)).toList();
});

/// Provider para acciones de cupones (sin state management)
final couponActionsProvider = Provider((ref) => CouponActions(ref));

class CouponActions {
  final Ref ref;

  CouponActions(this.ref);

  Future<void> createCoupon({
    required String code,
    required String discountType,
    required int discountValue,
    required int minPurchase,
    int? maxUses,
    int? maxUsesPerUser,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final supabase = ref.read(supabaseClientProvider);

    // Verificar si el código ya existe
    final existing = await supabase
        .from('coupons')
        .select('id')
        .eq('code', code.toUpperCase())
        .maybeSingle();

    if (existing != null) {
      throw Exception('Ya existe un cupón con ese código');
    }

    await supabase.from('coupons').insert({
      'code': code.toUpperCase(),
      'discount_type': discountType,
      'discount_value': discountType == 'percentage'
          ? discountValue
          : discountValue * 100,
      'min_purchase': minPurchase * 100,
      'max_uses': maxUses,
      'max_uses_per_user': maxUsesPerUser,
      'start_date':
          startDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_active': true,
      'current_uses': 0,
    });

    ref.invalidate(couponsProvider);
  }

  Future<void> toggleCoupon(int id, bool isActive) async {
    final supabase = ref.read(supabaseClientProvider);

    await supabase
        .from('coupons')
        .update({'is_active': !isActive})
        .eq('id', id);

    ref.invalidate(couponsProvider);
  }

  Future<void> deleteCoupon(int id) async {
    final supabase = ref.read(supabaseClientProvider);

    await supabase.from('coupons').delete().eq('id', id);

    ref.invalidate(couponsProvider);
  }
}
