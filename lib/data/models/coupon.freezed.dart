// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coupon.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Coupon {
  int get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get discountType =>
      throw _privateConstructorUsedError; // 'percentage' o 'fixed'
  int get discountValue =>
      throw _privateConstructorUsedError; // Porcentaje o cantidad en centavos
  int? get maxUses => throw _privateConstructorUsedError;
  int get usedCount => throw _privateConstructorUsedError;
  int? get maxUsesPerUser => throw _privateConstructorUsedError;
  int? get minPurchase =>
      throw _privateConstructorUsedError; // Monto mínimo en centavos
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of Coupon
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CouponCopyWith<Coupon> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CouponCopyWith<$Res> {
  factory $CouponCopyWith(Coupon value, $Res Function(Coupon) then) =
      _$CouponCopyWithImpl<$Res, Coupon>;
  @useResult
  $Res call(
      {int id,
      String code,
      String discountType,
      int discountValue,
      int? maxUses,
      int usedCount,
      int? maxUsesPerUser,
      int? minPurchase,
      DateTime startDate,
      DateTime? endDate,
      bool isActive,
      DateTime createdAt});
}

/// @nodoc
class _$CouponCopyWithImpl<$Res, $Val extends Coupon>
    implements $CouponCopyWith<$Res> {
  _$CouponCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Coupon
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? discountType = null,
    Object? discountValue = null,
    Object? maxUses = freezed,
    Object? usedCount = null,
    Object? maxUsesPerUser = freezed,
    Object? minPurchase = freezed,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      discountType: null == discountType
          ? _value.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as String,
      discountValue: null == discountValue
          ? _value.discountValue
          : discountValue // ignore: cast_nullable_to_non_nullable
              as int,
      maxUses: freezed == maxUses
          ? _value.maxUses
          : maxUses // ignore: cast_nullable_to_non_nullable
              as int?,
      usedCount: null == usedCount
          ? _value.usedCount
          : usedCount // ignore: cast_nullable_to_non_nullable
              as int,
      maxUsesPerUser: freezed == maxUsesPerUser
          ? _value.maxUsesPerUser
          : maxUsesPerUser // ignore: cast_nullable_to_non_nullable
              as int?,
      minPurchase: freezed == minPurchase
          ? _value.minPurchase
          : minPurchase // ignore: cast_nullable_to_non_nullable
              as int?,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CouponImplCopyWith<$Res> implements $CouponCopyWith<$Res> {
  factory _$$CouponImplCopyWith(
          _$CouponImpl value, $Res Function(_$CouponImpl) then) =
      __$$CouponImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String code,
      String discountType,
      int discountValue,
      int? maxUses,
      int usedCount,
      int? maxUsesPerUser,
      int? minPurchase,
      DateTime startDate,
      DateTime? endDate,
      bool isActive,
      DateTime createdAt});
}

/// @nodoc
class __$$CouponImplCopyWithImpl<$Res>
    extends _$CouponCopyWithImpl<$Res, _$CouponImpl>
    implements _$$CouponImplCopyWith<$Res> {
  __$$CouponImplCopyWithImpl(
      _$CouponImpl _value, $Res Function(_$CouponImpl) _then)
      : super(_value, _then);

  /// Create a copy of Coupon
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? discountType = null,
    Object? discountValue = null,
    Object? maxUses = freezed,
    Object? usedCount = null,
    Object? maxUsesPerUser = freezed,
    Object? minPurchase = freezed,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(_$CouponImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      discountType: null == discountType
          ? _value.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as String,
      discountValue: null == discountValue
          ? _value.discountValue
          : discountValue // ignore: cast_nullable_to_non_nullable
              as int,
      maxUses: freezed == maxUses
          ? _value.maxUses
          : maxUses // ignore: cast_nullable_to_non_nullable
              as int?,
      usedCount: null == usedCount
          ? _value.usedCount
          : usedCount // ignore: cast_nullable_to_non_nullable
              as int,
      maxUsesPerUser: freezed == maxUsesPerUser
          ? _value.maxUsesPerUser
          : maxUsesPerUser // ignore: cast_nullable_to_non_nullable
              as int?,
      minPurchase: freezed == minPurchase
          ? _value.minPurchase
          : minPurchase // ignore: cast_nullable_to_non_nullable
              as int?,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$CouponImpl extends _Coupon {
  const _$CouponImpl(
      {required this.id,
      required this.code,
      required this.discountType,
      required this.discountValue,
      this.maxUses,
      this.usedCount = 0,
      this.maxUsesPerUser,
      this.minPurchase,
      required this.startDate,
      this.endDate,
      this.isActive = true,
      required this.createdAt})
      : super._();

  @override
  final int id;
  @override
  final String code;
  @override
  final String discountType;
// 'percentage' o 'fixed'
  @override
  final int discountValue;
// Porcentaje o cantidad en centavos
  @override
  final int? maxUses;
  @override
  @JsonKey()
  final int usedCount;
  @override
  final int? maxUsesPerUser;
  @override
  final int? minPurchase;
// Monto mínimo en centavos
  @override
  final DateTime startDate;
  @override
  final DateTime? endDate;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Coupon(id: $id, code: $code, discountType: $discountType, discountValue: $discountValue, maxUses: $maxUses, usedCount: $usedCount, maxUsesPerUser: $maxUsesPerUser, minPurchase: $minPurchase, startDate: $startDate, endDate: $endDate, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CouponImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.discountValue, discountValue) ||
                other.discountValue == discountValue) &&
            (identical(other.maxUses, maxUses) || other.maxUses == maxUses) &&
            (identical(other.usedCount, usedCount) ||
                other.usedCount == usedCount) &&
            (identical(other.maxUsesPerUser, maxUsesPerUser) ||
                other.maxUsesPerUser == maxUsesPerUser) &&
            (identical(other.minPurchase, minPurchase) ||
                other.minPurchase == minPurchase) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      code,
      discountType,
      discountValue,
      maxUses,
      usedCount,
      maxUsesPerUser,
      minPurchase,
      startDate,
      endDate,
      isActive,
      createdAt);

  /// Create a copy of Coupon
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CouponImplCopyWith<_$CouponImpl> get copyWith =>
      __$$CouponImplCopyWithImpl<_$CouponImpl>(this, _$identity);
}

abstract class _Coupon extends Coupon {
  const factory _Coupon(
      {required final int id,
      required final String code,
      required final String discountType,
      required final int discountValue,
      final int? maxUses,
      final int usedCount,
      final int? maxUsesPerUser,
      final int? minPurchase,
      required final DateTime startDate,
      final DateTime? endDate,
      final bool isActive,
      required final DateTime createdAt}) = _$CouponImpl;
  const _Coupon._() : super._();

  @override
  int get id;
  @override
  String get code;
  @override
  String get discountType; // 'percentage' o 'fixed'
  @override
  int get discountValue; // Porcentaje o cantidad en centavos
  @override
  int? get maxUses;
  @override
  int get usedCount;
  @override
  int? get maxUsesPerUser;
  @override
  int? get minPurchase; // Monto mínimo en centavos
  @override
  DateTime get startDate;
  @override
  DateTime? get endDate;
  @override
  bool get isActive;
  @override
  DateTime get createdAt;

  /// Create a copy of Coupon
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CouponImplCopyWith<_$CouponImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
