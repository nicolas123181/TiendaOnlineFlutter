// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shipping_method.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ShippingMethod {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int get cost => throw _privateConstructorUsedError; // En centavos
  int get minDays => throw _privateConstructorUsedError;
  int get maxDays => throw _privateConstructorUsedError;
  int? get minOrderAmount => throw _privateConstructorUsedError;
  int? get maxWeightGrams => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  int get displayOrder => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of ShippingMethod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShippingMethodCopyWith<ShippingMethod> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShippingMethodCopyWith<$Res> {
  factory $ShippingMethodCopyWith(
          ShippingMethod value, $Res Function(ShippingMethod) then) =
      _$ShippingMethodCopyWithImpl<$Res, ShippingMethod>;
  @useResult
  $Res call(
      {int id,
      String name,
      String? description,
      int cost,
      int minDays,
      int maxDays,
      int? minOrderAmount,
      int? maxWeightGrams,
      bool isActive,
      int displayOrder,
      DateTime createdAt});
}

/// @nodoc
class _$ShippingMethodCopyWithImpl<$Res, $Val extends ShippingMethod>
    implements $ShippingMethodCopyWith<$Res> {
  _$ShippingMethodCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShippingMethod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? cost = null,
    Object? minDays = null,
    Object? maxDays = null,
    Object? minOrderAmount = freezed,
    Object? maxWeightGrams = freezed,
    Object? isActive = null,
    Object? displayOrder = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      cost: null == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as int,
      minDays: null == minDays
          ? _value.minDays
          : minDays // ignore: cast_nullable_to_non_nullable
              as int,
      maxDays: null == maxDays
          ? _value.maxDays
          : maxDays // ignore: cast_nullable_to_non_nullable
              as int,
      minOrderAmount: freezed == minOrderAmount
          ? _value.minOrderAmount
          : minOrderAmount // ignore: cast_nullable_to_non_nullable
              as int?,
      maxWeightGrams: freezed == maxWeightGrams
          ? _value.maxWeightGrams
          : maxWeightGrams // ignore: cast_nullable_to_non_nullable
              as int?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShippingMethodImplCopyWith<$Res>
    implements $ShippingMethodCopyWith<$Res> {
  factory _$$ShippingMethodImplCopyWith(_$ShippingMethodImpl value,
          $Res Function(_$ShippingMethodImpl) then) =
      __$$ShippingMethodImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String? description,
      int cost,
      int minDays,
      int maxDays,
      int? minOrderAmount,
      int? maxWeightGrams,
      bool isActive,
      int displayOrder,
      DateTime createdAt});
}

/// @nodoc
class __$$ShippingMethodImplCopyWithImpl<$Res>
    extends _$ShippingMethodCopyWithImpl<$Res, _$ShippingMethodImpl>
    implements _$$ShippingMethodImplCopyWith<$Res> {
  __$$ShippingMethodImplCopyWithImpl(
      _$ShippingMethodImpl _value, $Res Function(_$ShippingMethodImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShippingMethod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? cost = null,
    Object? minDays = null,
    Object? maxDays = null,
    Object? minOrderAmount = freezed,
    Object? maxWeightGrams = freezed,
    Object? isActive = null,
    Object? displayOrder = null,
    Object? createdAt = null,
  }) {
    return _then(_$ShippingMethodImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      cost: null == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as int,
      minDays: null == minDays
          ? _value.minDays
          : minDays // ignore: cast_nullable_to_non_nullable
              as int,
      maxDays: null == maxDays
          ? _value.maxDays
          : maxDays // ignore: cast_nullable_to_non_nullable
              as int,
      minOrderAmount: freezed == minOrderAmount
          ? _value.minOrderAmount
          : minOrderAmount // ignore: cast_nullable_to_non_nullable
              as int?,
      maxWeightGrams: freezed == maxWeightGrams
          ? _value.maxWeightGrams
          : maxWeightGrams // ignore: cast_nullable_to_non_nullable
              as int?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$ShippingMethodImpl extends _ShippingMethod {
  const _$ShippingMethodImpl(
      {required this.id,
      required this.name,
      this.description,
      required this.cost,
      required this.minDays,
      required this.maxDays,
      this.minOrderAmount,
      this.maxWeightGrams,
      this.isActive = true,
      this.displayOrder = 0,
      required this.createdAt})
      : super._();

  @override
  final int id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final int cost;
// En centavos
  @override
  final int minDays;
  @override
  final int maxDays;
  @override
  final int? minOrderAmount;
  @override
  final int? maxWeightGrams;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final int displayOrder;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ShippingMethod(id: $id, name: $name, description: $description, cost: $cost, minDays: $minDays, maxDays: $maxDays, minOrderAmount: $minOrderAmount, maxWeightGrams: $maxWeightGrams, isActive: $isActive, displayOrder: $displayOrder, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShippingMethodImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.minDays, minDays) || other.minDays == minDays) &&
            (identical(other.maxDays, maxDays) || other.maxDays == maxDays) &&
            (identical(other.minOrderAmount, minOrderAmount) ||
                other.minOrderAmount == minOrderAmount) &&
            (identical(other.maxWeightGrams, maxWeightGrams) ||
                other.maxWeightGrams == maxWeightGrams) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      cost,
      minDays,
      maxDays,
      minOrderAmount,
      maxWeightGrams,
      isActive,
      displayOrder,
      createdAt);

  /// Create a copy of ShippingMethod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShippingMethodImplCopyWith<_$ShippingMethodImpl> get copyWith =>
      __$$ShippingMethodImplCopyWithImpl<_$ShippingMethodImpl>(
          this, _$identity);
}

abstract class _ShippingMethod extends ShippingMethod {
  const factory _ShippingMethod(
      {required final int id,
      required final String name,
      final String? description,
      required final int cost,
      required final int minDays,
      required final int maxDays,
      final int? minOrderAmount,
      final int? maxWeightGrams,
      final bool isActive,
      final int displayOrder,
      required final DateTime createdAt}) = _$ShippingMethodImpl;
  const _ShippingMethod._() : super._();

  @override
  int get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  int get cost; // En centavos
  @override
  int get minDays;
  @override
  int get maxDays;
  @override
  int? get minOrderAmount;
  @override
  int? get maxWeightGrams;
  @override
  bool get isActive;
  @override
  int get displayOrder;
  @override
  DateTime get createdAt;

  /// Create a copy of ShippingMethod
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShippingMethodImplCopyWith<_$ShippingMethodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ShippingCarrier {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String? get trackingUrlTemplate => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  int get displayOrder => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of ShippingCarrier
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShippingCarrierCopyWith<ShippingCarrier> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShippingCarrierCopyWith<$Res> {
  factory $ShippingCarrierCopyWith(
          ShippingCarrier value, $Res Function(ShippingCarrier) then) =
      _$ShippingCarrierCopyWithImpl<$Res, ShippingCarrier>;
  @useResult
  $Res call(
      {int id,
      String name,
      String code,
      String? trackingUrlTemplate,
      String? logoUrl,
      bool isActive,
      int displayOrder,
      DateTime createdAt});
}

/// @nodoc
class _$ShippingCarrierCopyWithImpl<$Res, $Val extends ShippingCarrier>
    implements $ShippingCarrierCopyWith<$Res> {
  _$ShippingCarrierCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShippingCarrier
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = null,
    Object? trackingUrlTemplate = freezed,
    Object? logoUrl = freezed,
    Object? isActive = null,
    Object? displayOrder = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      trackingUrlTemplate: freezed == trackingUrlTemplate
          ? _value.trackingUrlTemplate
          : trackingUrlTemplate // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShippingCarrierImplCopyWith<$Res>
    implements $ShippingCarrierCopyWith<$Res> {
  factory _$$ShippingCarrierImplCopyWith(_$ShippingCarrierImpl value,
          $Res Function(_$ShippingCarrierImpl) then) =
      __$$ShippingCarrierImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String code,
      String? trackingUrlTemplate,
      String? logoUrl,
      bool isActive,
      int displayOrder,
      DateTime createdAt});
}

/// @nodoc
class __$$ShippingCarrierImplCopyWithImpl<$Res>
    extends _$ShippingCarrierCopyWithImpl<$Res, _$ShippingCarrierImpl>
    implements _$$ShippingCarrierImplCopyWith<$Res> {
  __$$ShippingCarrierImplCopyWithImpl(
      _$ShippingCarrierImpl _value, $Res Function(_$ShippingCarrierImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShippingCarrier
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = null,
    Object? trackingUrlTemplate = freezed,
    Object? logoUrl = freezed,
    Object? isActive = null,
    Object? displayOrder = null,
    Object? createdAt = null,
  }) {
    return _then(_$ShippingCarrierImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      trackingUrlTemplate: freezed == trackingUrlTemplate
          ? _value.trackingUrlTemplate
          : trackingUrlTemplate // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$ShippingCarrierImpl extends _ShippingCarrier {
  const _$ShippingCarrierImpl(
      {required this.id,
      required this.name,
      required this.code,
      this.trackingUrlTemplate,
      this.logoUrl,
      this.isActive = true,
      this.displayOrder = 0,
      required this.createdAt})
      : super._();

  @override
  final int id;
  @override
  final String name;
  @override
  final String code;
  @override
  final String? trackingUrlTemplate;
  @override
  final String? logoUrl;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final int displayOrder;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ShippingCarrier(id: $id, name: $name, code: $code, trackingUrlTemplate: $trackingUrlTemplate, logoUrl: $logoUrl, isActive: $isActive, displayOrder: $displayOrder, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShippingCarrierImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.trackingUrlTemplate, trackingUrlTemplate) ||
                other.trackingUrlTemplate == trackingUrlTemplate) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, code,
      trackingUrlTemplate, logoUrl, isActive, displayOrder, createdAt);

  /// Create a copy of ShippingCarrier
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShippingCarrierImplCopyWith<_$ShippingCarrierImpl> get copyWith =>
      __$$ShippingCarrierImplCopyWithImpl<_$ShippingCarrierImpl>(
          this, _$identity);
}

abstract class _ShippingCarrier extends ShippingCarrier {
  const factory _ShippingCarrier(
      {required final int id,
      required final String name,
      required final String code,
      final String? trackingUrlTemplate,
      final String? logoUrl,
      final bool isActive,
      final int displayOrder,
      required final DateTime createdAt}) = _$ShippingCarrierImpl;
  const _ShippingCarrier._() : super._();

  @override
  int get id;
  @override
  String get name;
  @override
  String get code;
  @override
  String? get trackingUrlTemplate;
  @override
  String? get logoUrl;
  @override
  bool get isActive;
  @override
  int get displayOrder;
  @override
  DateTime get createdAt;

  /// Create a copy of ShippingCarrier
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShippingCarrierImplCopyWith<_$ShippingCarrierImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
