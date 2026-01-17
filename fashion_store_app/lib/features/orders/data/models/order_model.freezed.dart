// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderModel {

 int get id;@JsonKey(name: 'user_id') String? get userId;@JsonKey(name: 'customer_email') String get customerEmail;@JsonKey(name: 'customer_name') String? get customerName;@JsonKey(name: 'customer_phone') String? get customerPhone; String get status;@JsonKey(name: 'payment_status') String get paymentStatus;@JsonKey(name: 'payment_method') String? get paymentMethod; int get subtotal; int get discount;@JsonKey(name: 'shipping_cost') int get shippingCost; int get total;@JsonKey(name: 'shipping_address') String? get shippingAddress;@JsonKey(name: 'shipping_city') String? get shippingCity;@JsonKey(name: 'shipping_postal_code') String? get shippingPostalCode;@JsonKey(name: 'billing_address') String? get billingAddress; String? get notes;@JsonKey(name: 'tracking_number') String? get trackingNumber; List<OrderItemModel> get items;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;@JsonKey(name: 'shipped_at') DateTime? get shippedAt;@JsonKey(name: 'delivered_at') DateTime? get deliveredAt;
/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderModelCopyWith<OrderModel> get copyWith => _$OrderModelCopyWithImpl<OrderModel>(this as OrderModel, _$identity);

  /// Serializes this OrderModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.customerEmail, customerEmail) || other.customerEmail == customerEmail)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.shippingCost, shippingCost) || other.shippingCost == shippingCost)&&(identical(other.total, total) || other.total == total)&&(identical(other.shippingAddress, shippingAddress) || other.shippingAddress == shippingAddress)&&(identical(other.shippingCity, shippingCity) || other.shippingCity == shippingCity)&&(identical(other.shippingPostalCode, shippingPostalCode) || other.shippingPostalCode == shippingPostalCode)&&(identical(other.billingAddress, billingAddress) || other.billingAddress == billingAddress)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.trackingNumber, trackingNumber) || other.trackingNumber == trackingNumber)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.shippedAt, shippedAt) || other.shippedAt == shippedAt)&&(identical(other.deliveredAt, deliveredAt) || other.deliveredAt == deliveredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,customerEmail,customerName,customerPhone,status,paymentStatus,paymentMethod,subtotal,discount,shippingCost,total,shippingAddress,shippingCity,shippingPostalCode,billingAddress,notes,trackingNumber,const DeepCollectionEquality().hash(items),createdAt,updatedAt,shippedAt,deliveredAt]);

@override
String toString() {
  return 'OrderModel(id: $id, userId: $userId, customerEmail: $customerEmail, customerName: $customerName, customerPhone: $customerPhone, status: $status, paymentStatus: $paymentStatus, paymentMethod: $paymentMethod, subtotal: $subtotal, discount: $discount, shippingCost: $shippingCost, total: $total, shippingAddress: $shippingAddress, shippingCity: $shippingCity, shippingPostalCode: $shippingPostalCode, billingAddress: $billingAddress, notes: $notes, trackingNumber: $trackingNumber, items: $items, createdAt: $createdAt, updatedAt: $updatedAt, shippedAt: $shippedAt, deliveredAt: $deliveredAt)';
}


}

/// @nodoc
abstract mixin class $OrderModelCopyWith<$Res>  {
  factory $OrderModelCopyWith(OrderModel value, $Res Function(OrderModel) _then) = _$OrderModelCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'customer_email') String customerEmail,@JsonKey(name: 'customer_name') String? customerName,@JsonKey(name: 'customer_phone') String? customerPhone, String status,@JsonKey(name: 'payment_status') String paymentStatus,@JsonKey(name: 'payment_method') String? paymentMethod, int subtotal, int discount,@JsonKey(name: 'shipping_cost') int shippingCost, int total,@JsonKey(name: 'shipping_address') String? shippingAddress,@JsonKey(name: 'shipping_city') String? shippingCity,@JsonKey(name: 'shipping_postal_code') String? shippingPostalCode,@JsonKey(name: 'billing_address') String? billingAddress, String? notes,@JsonKey(name: 'tracking_number') String? trackingNumber, List<OrderItemModel> items,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'shipped_at') DateTime? shippedAt,@JsonKey(name: 'delivered_at') DateTime? deliveredAt
});




}
/// @nodoc
class _$OrderModelCopyWithImpl<$Res>
    implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._self, this._then);

  final OrderModel _self;
  final $Res Function(OrderModel) _then;

/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = freezed,Object? customerEmail = null,Object? customerName = freezed,Object? customerPhone = freezed,Object? status = null,Object? paymentStatus = null,Object? paymentMethod = freezed,Object? subtotal = null,Object? discount = null,Object? shippingCost = null,Object? total = null,Object? shippingAddress = freezed,Object? shippingCity = freezed,Object? shippingPostalCode = freezed,Object? billingAddress = freezed,Object? notes = freezed,Object? trackingNumber = freezed,Object? items = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? shippedAt = freezed,Object? deliveredAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,customerEmail: null == customerEmail ? _self.customerEmail : customerEmail // ignore: cast_nullable_to_non_nullable
as String,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,customerPhone: freezed == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as int,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as int,shippingCost: null == shippingCost ? _self.shippingCost : shippingCost // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,shippingAddress: freezed == shippingAddress ? _self.shippingAddress : shippingAddress // ignore: cast_nullable_to_non_nullable
as String?,shippingCity: freezed == shippingCity ? _self.shippingCity : shippingCity // ignore: cast_nullable_to_non_nullable
as String?,shippingPostalCode: freezed == shippingPostalCode ? _self.shippingPostalCode : shippingPostalCode // ignore: cast_nullable_to_non_nullable
as String?,billingAddress: freezed == billingAddress ? _self.billingAddress : billingAddress // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,trackingNumber: freezed == trackingNumber ? _self.trackingNumber : trackingNumber // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItemModel>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,shippedAt: freezed == shippedAt ? _self.shippedAt : shippedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveredAt: freezed == deliveredAt ? _self.deliveredAt : deliveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderModel].
extension OrderModelPatterns on OrderModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'customer_email')  String customerEmail, @JsonKey(name: 'customer_name')  String? customerName, @JsonKey(name: 'customer_phone')  String? customerPhone,  String status, @JsonKey(name: 'payment_status')  String paymentStatus, @JsonKey(name: 'payment_method')  String? paymentMethod,  int subtotal,  int discount, @JsonKey(name: 'shipping_cost')  int shippingCost,  int total, @JsonKey(name: 'shipping_address')  String? shippingAddress, @JsonKey(name: 'shipping_city')  String? shippingCity, @JsonKey(name: 'shipping_postal_code')  String? shippingPostalCode, @JsonKey(name: 'billing_address')  String? billingAddress,  String? notes, @JsonKey(name: 'tracking_number')  String? trackingNumber,  List<OrderItemModel> items, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'shipped_at')  DateTime? shippedAt, @JsonKey(name: 'delivered_at')  DateTime? deliveredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderModel() when $default != null:
return $default(_that.id,_that.userId,_that.customerEmail,_that.customerName,_that.customerPhone,_that.status,_that.paymentStatus,_that.paymentMethod,_that.subtotal,_that.discount,_that.shippingCost,_that.total,_that.shippingAddress,_that.shippingCity,_that.shippingPostalCode,_that.billingAddress,_that.notes,_that.trackingNumber,_that.items,_that.createdAt,_that.updatedAt,_that.shippedAt,_that.deliveredAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'customer_email')  String customerEmail, @JsonKey(name: 'customer_name')  String? customerName, @JsonKey(name: 'customer_phone')  String? customerPhone,  String status, @JsonKey(name: 'payment_status')  String paymentStatus, @JsonKey(name: 'payment_method')  String? paymentMethod,  int subtotal,  int discount, @JsonKey(name: 'shipping_cost')  int shippingCost,  int total, @JsonKey(name: 'shipping_address')  String? shippingAddress, @JsonKey(name: 'shipping_city')  String? shippingCity, @JsonKey(name: 'shipping_postal_code')  String? shippingPostalCode, @JsonKey(name: 'billing_address')  String? billingAddress,  String? notes, @JsonKey(name: 'tracking_number')  String? trackingNumber,  List<OrderItemModel> items, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'shipped_at')  DateTime? shippedAt, @JsonKey(name: 'delivered_at')  DateTime? deliveredAt)  $default,) {final _that = this;
switch (_that) {
case _OrderModel():
return $default(_that.id,_that.userId,_that.customerEmail,_that.customerName,_that.customerPhone,_that.status,_that.paymentStatus,_that.paymentMethod,_that.subtotal,_that.discount,_that.shippingCost,_that.total,_that.shippingAddress,_that.shippingCity,_that.shippingPostalCode,_that.billingAddress,_that.notes,_that.trackingNumber,_that.items,_that.createdAt,_that.updatedAt,_that.shippedAt,_that.deliveredAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'customer_email')  String customerEmail, @JsonKey(name: 'customer_name')  String? customerName, @JsonKey(name: 'customer_phone')  String? customerPhone,  String status, @JsonKey(name: 'payment_status')  String paymentStatus, @JsonKey(name: 'payment_method')  String? paymentMethod,  int subtotal,  int discount, @JsonKey(name: 'shipping_cost')  int shippingCost,  int total, @JsonKey(name: 'shipping_address')  String? shippingAddress, @JsonKey(name: 'shipping_city')  String? shippingCity, @JsonKey(name: 'shipping_postal_code')  String? shippingPostalCode, @JsonKey(name: 'billing_address')  String? billingAddress,  String? notes, @JsonKey(name: 'tracking_number')  String? trackingNumber,  List<OrderItemModel> items, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'shipped_at')  DateTime? shippedAt, @JsonKey(name: 'delivered_at')  DateTime? deliveredAt)?  $default,) {final _that = this;
switch (_that) {
case _OrderModel() when $default != null:
return $default(_that.id,_that.userId,_that.customerEmail,_that.customerName,_that.customerPhone,_that.status,_that.paymentStatus,_that.paymentMethod,_that.subtotal,_that.discount,_that.shippingCost,_that.total,_that.shippingAddress,_that.shippingCity,_that.shippingPostalCode,_that.billingAddress,_that.notes,_that.trackingNumber,_that.items,_that.createdAt,_that.updatedAt,_that.shippedAt,_that.deliveredAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderModel extends OrderModel {
  const _OrderModel({required this.id, @JsonKey(name: 'user_id') this.userId, @JsonKey(name: 'customer_email') required this.customerEmail, @JsonKey(name: 'customer_name') this.customerName, @JsonKey(name: 'customer_phone') this.customerPhone, this.status = 'pending', @JsonKey(name: 'payment_status') this.paymentStatus = 'pending', @JsonKey(name: 'payment_method') this.paymentMethod, required this.subtotal, this.discount = 0, @JsonKey(name: 'shipping_cost') this.shippingCost = 0, required this.total, @JsonKey(name: 'shipping_address') this.shippingAddress, @JsonKey(name: 'shipping_city') this.shippingCity, @JsonKey(name: 'shipping_postal_code') this.shippingPostalCode, @JsonKey(name: 'billing_address') this.billingAddress, this.notes, @JsonKey(name: 'tracking_number') this.trackingNumber, final  List<OrderItemModel> items = const <OrderItemModel>[], @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt, @JsonKey(name: 'shipped_at') this.shippedAt, @JsonKey(name: 'delivered_at') this.deliveredAt}): _items = items,super._();
  factory _OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);

@override final  int id;
@override@JsonKey(name: 'user_id') final  String? userId;
@override@JsonKey(name: 'customer_email') final  String customerEmail;
@override@JsonKey(name: 'customer_name') final  String? customerName;
@override@JsonKey(name: 'customer_phone') final  String? customerPhone;
@override@JsonKey() final  String status;
@override@JsonKey(name: 'payment_status') final  String paymentStatus;
@override@JsonKey(name: 'payment_method') final  String? paymentMethod;
@override final  int subtotal;
@override@JsonKey() final  int discount;
@override@JsonKey(name: 'shipping_cost') final  int shippingCost;
@override final  int total;
@override@JsonKey(name: 'shipping_address') final  String? shippingAddress;
@override@JsonKey(name: 'shipping_city') final  String? shippingCity;
@override@JsonKey(name: 'shipping_postal_code') final  String? shippingPostalCode;
@override@JsonKey(name: 'billing_address') final  String? billingAddress;
@override final  String? notes;
@override@JsonKey(name: 'tracking_number') final  String? trackingNumber;
 final  List<OrderItemModel> _items;
@override@JsonKey() List<OrderItemModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;
@override@JsonKey(name: 'shipped_at') final  DateTime? shippedAt;
@override@JsonKey(name: 'delivered_at') final  DateTime? deliveredAt;

/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderModelCopyWith<_OrderModel> get copyWith => __$OrderModelCopyWithImpl<_OrderModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.customerEmail, customerEmail) || other.customerEmail == customerEmail)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.discount, discount) || other.discount == discount)&&(identical(other.shippingCost, shippingCost) || other.shippingCost == shippingCost)&&(identical(other.total, total) || other.total == total)&&(identical(other.shippingAddress, shippingAddress) || other.shippingAddress == shippingAddress)&&(identical(other.shippingCity, shippingCity) || other.shippingCity == shippingCity)&&(identical(other.shippingPostalCode, shippingPostalCode) || other.shippingPostalCode == shippingPostalCode)&&(identical(other.billingAddress, billingAddress) || other.billingAddress == billingAddress)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.trackingNumber, trackingNumber) || other.trackingNumber == trackingNumber)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.shippedAt, shippedAt) || other.shippedAt == shippedAt)&&(identical(other.deliveredAt, deliveredAt) || other.deliveredAt == deliveredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,customerEmail,customerName,customerPhone,status,paymentStatus,paymentMethod,subtotal,discount,shippingCost,total,shippingAddress,shippingCity,shippingPostalCode,billingAddress,notes,trackingNumber,const DeepCollectionEquality().hash(_items),createdAt,updatedAt,shippedAt,deliveredAt]);

@override
String toString() {
  return 'OrderModel(id: $id, userId: $userId, customerEmail: $customerEmail, customerName: $customerName, customerPhone: $customerPhone, status: $status, paymentStatus: $paymentStatus, paymentMethod: $paymentMethod, subtotal: $subtotal, discount: $discount, shippingCost: $shippingCost, total: $total, shippingAddress: $shippingAddress, shippingCity: $shippingCity, shippingPostalCode: $shippingPostalCode, billingAddress: $billingAddress, notes: $notes, trackingNumber: $trackingNumber, items: $items, createdAt: $createdAt, updatedAt: $updatedAt, shippedAt: $shippedAt, deliveredAt: $deliveredAt)';
}


}

/// @nodoc
abstract mixin class _$OrderModelCopyWith<$Res> implements $OrderModelCopyWith<$Res> {
  factory _$OrderModelCopyWith(_OrderModel value, $Res Function(_OrderModel) _then) = __$OrderModelCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'customer_email') String customerEmail,@JsonKey(name: 'customer_name') String? customerName,@JsonKey(name: 'customer_phone') String? customerPhone, String status,@JsonKey(name: 'payment_status') String paymentStatus,@JsonKey(name: 'payment_method') String? paymentMethod, int subtotal, int discount,@JsonKey(name: 'shipping_cost') int shippingCost, int total,@JsonKey(name: 'shipping_address') String? shippingAddress,@JsonKey(name: 'shipping_city') String? shippingCity,@JsonKey(name: 'shipping_postal_code') String? shippingPostalCode,@JsonKey(name: 'billing_address') String? billingAddress, String? notes,@JsonKey(name: 'tracking_number') String? trackingNumber, List<OrderItemModel> items,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'shipped_at') DateTime? shippedAt,@JsonKey(name: 'delivered_at') DateTime? deliveredAt
});




}
/// @nodoc
class __$OrderModelCopyWithImpl<$Res>
    implements _$OrderModelCopyWith<$Res> {
  __$OrderModelCopyWithImpl(this._self, this._then);

  final _OrderModel _self;
  final $Res Function(_OrderModel) _then;

/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = freezed,Object? customerEmail = null,Object? customerName = freezed,Object? customerPhone = freezed,Object? status = null,Object? paymentStatus = null,Object? paymentMethod = freezed,Object? subtotal = null,Object? discount = null,Object? shippingCost = null,Object? total = null,Object? shippingAddress = freezed,Object? shippingCity = freezed,Object? shippingPostalCode = freezed,Object? billingAddress = freezed,Object? notes = freezed,Object? trackingNumber = freezed,Object? items = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? shippedAt = freezed,Object? deliveredAt = freezed,}) {
  return _then(_OrderModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,customerEmail: null == customerEmail ? _self.customerEmail : customerEmail // ignore: cast_nullable_to_non_nullable
as String,customerName: freezed == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String?,customerPhone: freezed == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as int,discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as int,shippingCost: null == shippingCost ? _self.shippingCost : shippingCost // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,shippingAddress: freezed == shippingAddress ? _self.shippingAddress : shippingAddress // ignore: cast_nullable_to_non_nullable
as String?,shippingCity: freezed == shippingCity ? _self.shippingCity : shippingCity // ignore: cast_nullable_to_non_nullable
as String?,shippingPostalCode: freezed == shippingPostalCode ? _self.shippingPostalCode : shippingPostalCode // ignore: cast_nullable_to_non_nullable
as String?,billingAddress: freezed == billingAddress ? _self.billingAddress : billingAddress // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,trackingNumber: freezed == trackingNumber ? _self.trackingNumber : trackingNumber // ignore: cast_nullable_to_non_nullable
as String?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItemModel>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,shippedAt: freezed == shippedAt ? _self.shippedAt : shippedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveredAt: freezed == deliveredAt ? _self.deliveredAt : deliveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$OrderItemModel {

 int get id;@JsonKey(name: 'order_id') int get orderId;@JsonKey(name: 'product_id') int get productId;@JsonKey(name: 'product_name') String get productName;@JsonKey(name: 'product_image') String? get productImage; String? get size; int get quantity;@JsonKey(name: 'unit_price') int get unitPrice; int get subtotal;
/// Create a copy of OrderItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderItemModelCopyWith<OrderItemModel> get copyWith => _$OrderItemModelCopyWithImpl<OrderItemModel>(this as OrderItemModel, _$identity);

  /// Serializes this OrderItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productImage, productImage) || other.productImage == productImage)&&(identical(other.size, size) || other.size == size)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,productId,productName,productImage,size,quantity,unitPrice,subtotal);

@override
String toString() {
  return 'OrderItemModel(id: $id, orderId: $orderId, productId: $productId, productName: $productName, productImage: $productImage, size: $size, quantity: $quantity, unitPrice: $unitPrice, subtotal: $subtotal)';
}


}

/// @nodoc
abstract mixin class $OrderItemModelCopyWith<$Res>  {
  factory $OrderItemModelCopyWith(OrderItemModel value, $Res Function(OrderItemModel) _then) = _$OrderItemModelCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'order_id') int orderId,@JsonKey(name: 'product_id') int productId,@JsonKey(name: 'product_name') String productName,@JsonKey(name: 'product_image') String? productImage, String? size, int quantity,@JsonKey(name: 'unit_price') int unitPrice, int subtotal
});




}
/// @nodoc
class _$OrderItemModelCopyWithImpl<$Res>
    implements $OrderItemModelCopyWith<$Res> {
  _$OrderItemModelCopyWithImpl(this._self, this._then);

  final OrderItemModel _self;
  final $Res Function(OrderItemModel) _then;

/// Create a copy of OrderItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderId = null,Object? productId = null,Object? productName = null,Object? productImage = freezed,Object? size = freezed,Object? quantity = null,Object? unitPrice = null,Object? subtotal = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,productImage: freezed == productImage ? _self.productImage : productImage // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderItemModel].
extension OrderItemModelPatterns on OrderItemModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderItemModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderItemModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderItemModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderItemModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'order_id')  int orderId, @JsonKey(name: 'product_id')  int productId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'product_image')  String? productImage,  String? size,  int quantity, @JsonKey(name: 'unit_price')  int unitPrice,  int subtotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderItemModel() when $default != null:
return $default(_that.id,_that.orderId,_that.productId,_that.productName,_that.productImage,_that.size,_that.quantity,_that.unitPrice,_that.subtotal);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'order_id')  int orderId, @JsonKey(name: 'product_id')  int productId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'product_image')  String? productImage,  String? size,  int quantity, @JsonKey(name: 'unit_price')  int unitPrice,  int subtotal)  $default,) {final _that = this;
switch (_that) {
case _OrderItemModel():
return $default(_that.id,_that.orderId,_that.productId,_that.productName,_that.productImage,_that.size,_that.quantity,_that.unitPrice,_that.subtotal);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'order_id')  int orderId, @JsonKey(name: 'product_id')  int productId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'product_image')  String? productImage,  String? size,  int quantity, @JsonKey(name: 'unit_price')  int unitPrice,  int subtotal)?  $default,) {final _that = this;
switch (_that) {
case _OrderItemModel() when $default != null:
return $default(_that.id,_that.orderId,_that.productId,_that.productName,_that.productImage,_that.size,_that.quantity,_that.unitPrice,_that.subtotal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderItemModel extends OrderItemModel {
  const _OrderItemModel({required this.id, @JsonKey(name: 'order_id') required this.orderId, @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'product_name') required this.productName, @JsonKey(name: 'product_image') this.productImage, this.size, required this.quantity, @JsonKey(name: 'unit_price') required this.unitPrice, required this.subtotal}): super._();
  factory _OrderItemModel.fromJson(Map<String, dynamic> json) => _$OrderItemModelFromJson(json);

@override final  int id;
@override@JsonKey(name: 'order_id') final  int orderId;
@override@JsonKey(name: 'product_id') final  int productId;
@override@JsonKey(name: 'product_name') final  String productName;
@override@JsonKey(name: 'product_image') final  String? productImage;
@override final  String? size;
@override final  int quantity;
@override@JsonKey(name: 'unit_price') final  int unitPrice;
@override final  int subtotal;

/// Create a copy of OrderItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderItemModelCopyWith<_OrderItemModel> get copyWith => __$OrderItemModelCopyWithImpl<_OrderItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productImage, productImage) || other.productImage == productImage)&&(identical(other.size, size) || other.size == size)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,orderId,productId,productName,productImage,size,quantity,unitPrice,subtotal);

@override
String toString() {
  return 'OrderItemModel(id: $id, orderId: $orderId, productId: $productId, productName: $productName, productImage: $productImage, size: $size, quantity: $quantity, unitPrice: $unitPrice, subtotal: $subtotal)';
}


}

/// @nodoc
abstract mixin class _$OrderItemModelCopyWith<$Res> implements $OrderItemModelCopyWith<$Res> {
  factory _$OrderItemModelCopyWith(_OrderItemModel value, $Res Function(_OrderItemModel) _then) = __$OrderItemModelCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'order_id') int orderId,@JsonKey(name: 'product_id') int productId,@JsonKey(name: 'product_name') String productName,@JsonKey(name: 'product_image') String? productImage, String? size, int quantity,@JsonKey(name: 'unit_price') int unitPrice, int subtotal
});




}
/// @nodoc
class __$OrderItemModelCopyWithImpl<$Res>
    implements _$OrderItemModelCopyWith<$Res> {
  __$OrderItemModelCopyWithImpl(this._self, this._then);

  final _OrderItemModel _self;
  final $Res Function(_OrderItemModel) _then;

/// Create a copy of OrderItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderId = null,Object? productId = null,Object? productName = null,Object? productImage = freezed,Object? size = freezed,Object? quantity = null,Object? unitPrice = null,Object? subtotal = null,}) {
  return _then(_OrderItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,productImage: freezed == productImage ? _self.productImage : productImage // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
