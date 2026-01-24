// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'return_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ReturnItem {
  int get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String? get size => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  int get price => throw _privateConstructorUsedError;

  /// Create a copy of ReturnItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReturnItemCopyWith<ReturnItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReturnItemCopyWith<$Res> {
  factory $ReturnItemCopyWith(
          ReturnItem value, $Res Function(ReturnItem) then) =
      _$ReturnItemCopyWithImpl<$Res, ReturnItem>;
  @useResult
  $Res call(
      {int productId,
      String productName,
      String? size,
      int quantity,
      int price});
}

/// @nodoc
class _$ReturnItemCopyWithImpl<$Res, $Val extends ReturnItem>
    implements $ReturnItemCopyWith<$Res> {
  _$ReturnItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReturnItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? size = freezed,
    Object? quantity = null,
    Object? price = null,
  }) {
    return _then(_value.copyWith(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReturnItemImplCopyWith<$Res>
    implements $ReturnItemCopyWith<$Res> {
  factory _$$ReturnItemImplCopyWith(
          _$ReturnItemImpl value, $Res Function(_$ReturnItemImpl) then) =
      __$$ReturnItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int productId,
      String productName,
      String? size,
      int quantity,
      int price});
}

/// @nodoc
class __$$ReturnItemImplCopyWithImpl<$Res>
    extends _$ReturnItemCopyWithImpl<$Res, _$ReturnItemImpl>
    implements _$$ReturnItemImplCopyWith<$Res> {
  __$$ReturnItemImplCopyWithImpl(
      _$ReturnItemImpl _value, $Res Function(_$ReturnItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReturnItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? size = freezed,
    Object? quantity = null,
    Object? price = null,
  }) {
    return _then(_$ReturnItemImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ReturnItemImpl extends _ReturnItem {
  const _$ReturnItemImpl(
      {required this.productId,
      required this.productName,
      this.size,
      required this.quantity,
      required this.price})
      : super._();

  @override
  final int productId;
  @override
  final String productName;
  @override
  final String? size;
  @override
  final int quantity;
  @override
  final int price;

  @override
  String toString() {
    return 'ReturnItem(productId: $productId, productName: $productName, size: $size, quantity: $quantity, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReturnItemImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, productId, productName, size, quantity, price);

  /// Create a copy of ReturnItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReturnItemImplCopyWith<_$ReturnItemImpl> get copyWith =>
      __$$ReturnItemImplCopyWithImpl<_$ReturnItemImpl>(this, _$identity);
}

abstract class _ReturnItem extends ReturnItem {
  const factory _ReturnItem(
      {required final int productId,
      required final String productName,
      final String? size,
      required final int quantity,
      required final int price}) = _$ReturnItemImpl;
  const _ReturnItem._() : super._();

  @override
  int get productId;
  @override
  String get productName;
  @override
  String? get size;
  @override
  int get quantity;
  @override
  int get price;

  /// Create a copy of ReturnItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReturnItemImplCopyWith<_$ReturnItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Return {
  int get id => throw _privateConstructorUsedError;
  String get returnNumber => throw _privateConstructorUsedError;
  int get orderId => throw _privateConstructorUsedError;
  String get customerEmail => throw _privateConstructorUsedError;
  String get customerName => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  String? get reasonDetails => throw _privateConstructorUsedError;
  List<ReturnItem> get items => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int? get refundAmount => throw _privateConstructorUsedError; // En centavos
  String? get trackingNumber => throw _privateConstructorUsedError;
  String? get adminNotes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get receivedAt => throw _privateConstructorUsedError;
  DateTime? get refundedAt => throw _privateConstructorUsedError;
  String? get stripeRefundId => throw _privateConstructorUsedError;

  /// Create a copy of Return
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReturnCopyWith<Return> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReturnCopyWith<$Res> {
  factory $ReturnCopyWith(Return value, $Res Function(Return) then) =
      _$ReturnCopyWithImpl<$Res, Return>;
  @useResult
  $Res call(
      {int id,
      String returnNumber,
      int orderId,
      String customerEmail,
      String customerName,
      String reason,
      String? reasonDetails,
      List<ReturnItem> items,
      String status,
      int? refundAmount,
      String? trackingNumber,
      String? adminNotes,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? receivedAt,
      DateTime? refundedAt,
      String? stripeRefundId});
}

/// @nodoc
class _$ReturnCopyWithImpl<$Res, $Val extends Return>
    implements $ReturnCopyWith<$Res> {
  _$ReturnCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Return
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? returnNumber = null,
    Object? orderId = null,
    Object? customerEmail = null,
    Object? customerName = null,
    Object? reason = null,
    Object? reasonDetails = freezed,
    Object? items = null,
    Object? status = null,
    Object? refundAmount = freezed,
    Object? trackingNumber = freezed,
    Object? adminNotes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? receivedAt = freezed,
    Object? refundedAt = freezed,
    Object? stripeRefundId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      returnNumber: null == returnNumber
          ? _value.returnNumber
          : returnNumber // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      customerEmail: null == customerEmail
          ? _value.customerEmail
          : customerEmail // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      reasonDetails: freezed == reasonDetails
          ? _value.reasonDetails
          : reasonDetails // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ReturnItem>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      refundAmount: freezed == refundAmount
          ? _value.refundAmount
          : refundAmount // ignore: cast_nullable_to_non_nullable
              as int?,
      trackingNumber: freezed == trackingNumber
          ? _value.trackingNumber
          : trackingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      adminNotes: freezed == adminNotes
          ? _value.adminNotes
          : adminNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      refundedAt: freezed == refundedAt
          ? _value.refundedAt
          : refundedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      stripeRefundId: freezed == stripeRefundId
          ? _value.stripeRefundId
          : stripeRefundId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReturnImplCopyWith<$Res> implements $ReturnCopyWith<$Res> {
  factory _$$ReturnImplCopyWith(
          _$ReturnImpl value, $Res Function(_$ReturnImpl) then) =
      __$$ReturnImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String returnNumber,
      int orderId,
      String customerEmail,
      String customerName,
      String reason,
      String? reasonDetails,
      List<ReturnItem> items,
      String status,
      int? refundAmount,
      String? trackingNumber,
      String? adminNotes,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? receivedAt,
      DateTime? refundedAt,
      String? stripeRefundId});
}

/// @nodoc
class __$$ReturnImplCopyWithImpl<$Res>
    extends _$ReturnCopyWithImpl<$Res, _$ReturnImpl>
    implements _$$ReturnImplCopyWith<$Res> {
  __$$ReturnImplCopyWithImpl(
      _$ReturnImpl _value, $Res Function(_$ReturnImpl) _then)
      : super(_value, _then);

  /// Create a copy of Return
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? returnNumber = null,
    Object? orderId = null,
    Object? customerEmail = null,
    Object? customerName = null,
    Object? reason = null,
    Object? reasonDetails = freezed,
    Object? items = null,
    Object? status = null,
    Object? refundAmount = freezed,
    Object? trackingNumber = freezed,
    Object? adminNotes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? receivedAt = freezed,
    Object? refundedAt = freezed,
    Object? stripeRefundId = freezed,
  }) {
    return _then(_$ReturnImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      returnNumber: null == returnNumber
          ? _value.returnNumber
          : returnNumber // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      customerEmail: null == customerEmail
          ? _value.customerEmail
          : customerEmail // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      reasonDetails: freezed == reasonDetails
          ? _value.reasonDetails
          : reasonDetails // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ReturnItem>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      refundAmount: freezed == refundAmount
          ? _value.refundAmount
          : refundAmount // ignore: cast_nullable_to_non_nullable
              as int?,
      trackingNumber: freezed == trackingNumber
          ? _value.trackingNumber
          : trackingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      adminNotes: freezed == adminNotes
          ? _value.adminNotes
          : adminNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      receivedAt: freezed == receivedAt
          ? _value.receivedAt
          : receivedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      refundedAt: freezed == refundedAt
          ? _value.refundedAt
          : refundedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      stripeRefundId: freezed == stripeRefundId
          ? _value.stripeRefundId
          : stripeRefundId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ReturnImpl extends _Return {
  const _$ReturnImpl(
      {required this.id,
      required this.returnNumber,
      required this.orderId,
      required this.customerEmail,
      required this.customerName,
      required this.reason,
      this.reasonDetails,
      final List<ReturnItem> items = const [],
      this.status = 'pending',
      this.refundAmount,
      this.trackingNumber,
      this.adminNotes,
      required this.createdAt,
      required this.updatedAt,
      this.receivedAt,
      this.refundedAt,
      this.stripeRefundId})
      : _items = items,
        super._();

  @override
  final int id;
  @override
  final String returnNumber;
  @override
  final int orderId;
  @override
  final String customerEmail;
  @override
  final String customerName;
  @override
  final String reason;
  @override
  final String? reasonDetails;
  final List<ReturnItem> _items;
  @override
  @JsonKey()
  List<ReturnItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final String status;
  @override
  final int? refundAmount;
// En centavos
  @override
  final String? trackingNumber;
  @override
  final String? adminNotes;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? receivedAt;
  @override
  final DateTime? refundedAt;
  @override
  final String? stripeRefundId;

  @override
  String toString() {
    return 'Return(id: $id, returnNumber: $returnNumber, orderId: $orderId, customerEmail: $customerEmail, customerName: $customerName, reason: $reason, reasonDetails: $reasonDetails, items: $items, status: $status, refundAmount: $refundAmount, trackingNumber: $trackingNumber, adminNotes: $adminNotes, createdAt: $createdAt, updatedAt: $updatedAt, receivedAt: $receivedAt, refundedAt: $refundedAt, stripeRefundId: $stripeRefundId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReturnImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.returnNumber, returnNumber) ||
                other.returnNumber == returnNumber) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.customerEmail, customerEmail) ||
                other.customerEmail == customerEmail) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.reasonDetails, reasonDetails) ||
                other.reasonDetails == reasonDetails) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.refundAmount, refundAmount) ||
                other.refundAmount == refundAmount) &&
            (identical(other.trackingNumber, trackingNumber) ||
                other.trackingNumber == trackingNumber) &&
            (identical(other.adminNotes, adminNotes) ||
                other.adminNotes == adminNotes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.refundedAt, refundedAt) ||
                other.refundedAt == refundedAt) &&
            (identical(other.stripeRefundId, stripeRefundId) ||
                other.stripeRefundId == stripeRefundId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      returnNumber,
      orderId,
      customerEmail,
      customerName,
      reason,
      reasonDetails,
      const DeepCollectionEquality().hash(_items),
      status,
      refundAmount,
      trackingNumber,
      adminNotes,
      createdAt,
      updatedAt,
      receivedAt,
      refundedAt,
      stripeRefundId);

  /// Create a copy of Return
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReturnImplCopyWith<_$ReturnImpl> get copyWith =>
      __$$ReturnImplCopyWithImpl<_$ReturnImpl>(this, _$identity);
}

abstract class _Return extends Return {
  const factory _Return(
      {required final int id,
      required final String returnNumber,
      required final int orderId,
      required final String customerEmail,
      required final String customerName,
      required final String reason,
      final String? reasonDetails,
      final List<ReturnItem> items,
      final String status,
      final int? refundAmount,
      final String? trackingNumber,
      final String? adminNotes,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final DateTime? receivedAt,
      final DateTime? refundedAt,
      final String? stripeRefundId}) = _$ReturnImpl;
  const _Return._() : super._();

  @override
  int get id;
  @override
  String get returnNumber;
  @override
  int get orderId;
  @override
  String get customerEmail;
  @override
  String get customerName;
  @override
  String get reason;
  @override
  String? get reasonDetails;
  @override
  List<ReturnItem> get items;
  @override
  String get status;
  @override
  int? get refundAmount; // En centavos
  @override
  String? get trackingNumber;
  @override
  String? get adminNotes;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get receivedAt;
  @override
  DateTime? get refundedAt;
  @override
  String? get stripeRefundId;

  /// Create a copy of Return
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReturnImplCopyWith<_$ReturnImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
