// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {

 String get id; String get email; String? get name; String? get phone;@JsonKey(name: 'avatar_url') String? get avatarUrl;@JsonKey(name: 'is_admin') bool get isAdmin;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt; CustomerInfo? get customerInfo;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.customerInfo, customerInfo) || other.customerInfo == customerInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,name,phone,avatarUrl,isAdmin,createdAt,updatedAt,customerInfo);

@override
String toString() {
  return 'UserModel(id: $id, email: $email, name: $name, phone: $phone, avatarUrl: $avatarUrl, isAdmin: $isAdmin, createdAt: $createdAt, updatedAt: $updatedAt, customerInfo: $customerInfo)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 String id, String email, String? name, String? phone,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'is_admin') bool isAdmin,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt, CustomerInfo? customerInfo
});


$CustomerInfoCopyWith<$Res>? get customerInfo;

}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? name = freezed,Object? phone = freezed,Object? avatarUrl = freezed,Object? isAdmin = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? customerInfo = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,customerInfo: freezed == customerInfo ? _self.customerInfo : customerInfo // ignore: cast_nullable_to_non_nullable
as CustomerInfo?,
  ));
}
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerInfoCopyWith<$Res>? get customerInfo {
    if (_self.customerInfo == null) {
    return null;
  }

  return $CustomerInfoCopyWith<$Res>(_self.customerInfo!, (value) {
    return _then(_self.copyWith(customerInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserModel].
extension UserModelPatterns on UserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserModel value)  $default,){
final _that = this;
switch (_that) {
case _UserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String? name,  String? phone, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'is_admin')  bool isAdmin, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt,  CustomerInfo? customerInfo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.email,_that.name,_that.phone,_that.avatarUrl,_that.isAdmin,_that.createdAt,_that.updatedAt,_that.customerInfo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String? name,  String? phone, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'is_admin')  bool isAdmin, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt,  CustomerInfo? customerInfo)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.id,_that.email,_that.name,_that.phone,_that.avatarUrl,_that.isAdmin,_that.createdAt,_that.updatedAt,_that.customerInfo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String? name,  String? phone, @JsonKey(name: 'avatar_url')  String? avatarUrl, @JsonKey(name: 'is_admin')  bool isAdmin, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt,  CustomerInfo? customerInfo)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.email,_that.name,_that.phone,_that.avatarUrl,_that.isAdmin,_that.createdAt,_that.updatedAt,_that.customerInfo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel extends UserModel {
  const _UserModel({required this.id, required this.email, this.name, this.phone, @JsonKey(name: 'avatar_url') this.avatarUrl, @JsonKey(name: 'is_admin') this.isAdmin = false, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt, this.customerInfo}): super._();
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override final  String id;
@override final  String email;
@override final  String? name;
@override final  String? phone;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override@JsonKey(name: 'is_admin') final  bool isAdmin;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;
@override final  CustomerInfo? customerInfo;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.customerInfo, customerInfo) || other.customerInfo == customerInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,name,phone,avatarUrl,isAdmin,createdAt,updatedAt,customerInfo);

@override
String toString() {
  return 'UserModel(id: $id, email: $email, name: $name, phone: $phone, avatarUrl: $avatarUrl, isAdmin: $isAdmin, createdAt: $createdAt, updatedAt: $updatedAt, customerInfo: $customerInfo)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String? name, String? phone,@JsonKey(name: 'avatar_url') String? avatarUrl,@JsonKey(name: 'is_admin') bool isAdmin,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt, CustomerInfo? customerInfo
});


@override $CustomerInfoCopyWith<$Res>? get customerInfo;

}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? name = freezed,Object? phone = freezed,Object? avatarUrl = freezed,Object? isAdmin = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? customerInfo = freezed,}) {
  return _then(_UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,customerInfo: freezed == customerInfo ? _self.customerInfo : customerInfo // ignore: cast_nullable_to_non_nullable
as CustomerInfo?,
  ));
}

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerInfoCopyWith<$Res>? get customerInfo {
    if (_self.customerInfo == null) {
    return null;
  }

  return $CustomerInfoCopyWith<$Res>(_self.customerInfo!, (value) {
    return _then(_self.copyWith(customerInfo: value));
  });
}
}


/// @nodoc
mixin _$CustomerInfo {

@JsonKey(name: 'default_address') String? get defaultAddress;@JsonKey(name: 'default_city') String? get defaultCity;@JsonKey(name: 'default_postal_code') String? get defaultPostalCode;@JsonKey(name: 'total_spent') int get totalSpent;@JsonKey(name: 'total_orders') int get totalOrders;@JsonKey(name: 'is_subscribed_newsletter') bool get isSubscribedNewsletter;@JsonKey(name: 'last_order_at') DateTime? get lastOrderAt;
/// Create a copy of CustomerInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerInfoCopyWith<CustomerInfo> get copyWith => _$CustomerInfoCopyWithImpl<CustomerInfo>(this as CustomerInfo, _$identity);

  /// Serializes this CustomerInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerInfo&&(identical(other.defaultAddress, defaultAddress) || other.defaultAddress == defaultAddress)&&(identical(other.defaultCity, defaultCity) || other.defaultCity == defaultCity)&&(identical(other.defaultPostalCode, defaultPostalCode) || other.defaultPostalCode == defaultPostalCode)&&(identical(other.totalSpent, totalSpent) || other.totalSpent == totalSpent)&&(identical(other.totalOrders, totalOrders) || other.totalOrders == totalOrders)&&(identical(other.isSubscribedNewsletter, isSubscribedNewsletter) || other.isSubscribedNewsletter == isSubscribedNewsletter)&&(identical(other.lastOrderAt, lastOrderAt) || other.lastOrderAt == lastOrderAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,defaultAddress,defaultCity,defaultPostalCode,totalSpent,totalOrders,isSubscribedNewsletter,lastOrderAt);

@override
String toString() {
  return 'CustomerInfo(defaultAddress: $defaultAddress, defaultCity: $defaultCity, defaultPostalCode: $defaultPostalCode, totalSpent: $totalSpent, totalOrders: $totalOrders, isSubscribedNewsletter: $isSubscribedNewsletter, lastOrderAt: $lastOrderAt)';
}


}

/// @nodoc
abstract mixin class $CustomerInfoCopyWith<$Res>  {
  factory $CustomerInfoCopyWith(CustomerInfo value, $Res Function(CustomerInfo) _then) = _$CustomerInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'default_address') String? defaultAddress,@JsonKey(name: 'default_city') String? defaultCity,@JsonKey(name: 'default_postal_code') String? defaultPostalCode,@JsonKey(name: 'total_spent') int totalSpent,@JsonKey(name: 'total_orders') int totalOrders,@JsonKey(name: 'is_subscribed_newsletter') bool isSubscribedNewsletter,@JsonKey(name: 'last_order_at') DateTime? lastOrderAt
});




}
/// @nodoc
class _$CustomerInfoCopyWithImpl<$Res>
    implements $CustomerInfoCopyWith<$Res> {
  _$CustomerInfoCopyWithImpl(this._self, this._then);

  final CustomerInfo _self;
  final $Res Function(CustomerInfo) _then;

/// Create a copy of CustomerInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? defaultAddress = freezed,Object? defaultCity = freezed,Object? defaultPostalCode = freezed,Object? totalSpent = null,Object? totalOrders = null,Object? isSubscribedNewsletter = null,Object? lastOrderAt = freezed,}) {
  return _then(_self.copyWith(
defaultAddress: freezed == defaultAddress ? _self.defaultAddress : defaultAddress // ignore: cast_nullable_to_non_nullable
as String?,defaultCity: freezed == defaultCity ? _self.defaultCity : defaultCity // ignore: cast_nullable_to_non_nullable
as String?,defaultPostalCode: freezed == defaultPostalCode ? _self.defaultPostalCode : defaultPostalCode // ignore: cast_nullable_to_non_nullable
as String?,totalSpent: null == totalSpent ? _self.totalSpent : totalSpent // ignore: cast_nullable_to_non_nullable
as int,totalOrders: null == totalOrders ? _self.totalOrders : totalOrders // ignore: cast_nullable_to_non_nullable
as int,isSubscribedNewsletter: null == isSubscribedNewsletter ? _self.isSubscribedNewsletter : isSubscribedNewsletter // ignore: cast_nullable_to_non_nullable
as bool,lastOrderAt: freezed == lastOrderAt ? _self.lastOrderAt : lastOrderAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerInfo].
extension CustomerInfoPatterns on CustomerInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerInfo value)  $default,){
final _that = this;
switch (_that) {
case _CustomerInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerInfo value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'default_address')  String? defaultAddress, @JsonKey(name: 'default_city')  String? defaultCity, @JsonKey(name: 'default_postal_code')  String? defaultPostalCode, @JsonKey(name: 'total_spent')  int totalSpent, @JsonKey(name: 'total_orders')  int totalOrders, @JsonKey(name: 'is_subscribed_newsletter')  bool isSubscribedNewsletter, @JsonKey(name: 'last_order_at')  DateTime? lastOrderAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerInfo() when $default != null:
return $default(_that.defaultAddress,_that.defaultCity,_that.defaultPostalCode,_that.totalSpent,_that.totalOrders,_that.isSubscribedNewsletter,_that.lastOrderAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'default_address')  String? defaultAddress, @JsonKey(name: 'default_city')  String? defaultCity, @JsonKey(name: 'default_postal_code')  String? defaultPostalCode, @JsonKey(name: 'total_spent')  int totalSpent, @JsonKey(name: 'total_orders')  int totalOrders, @JsonKey(name: 'is_subscribed_newsletter')  bool isSubscribedNewsletter, @JsonKey(name: 'last_order_at')  DateTime? lastOrderAt)  $default,) {final _that = this;
switch (_that) {
case _CustomerInfo():
return $default(_that.defaultAddress,_that.defaultCity,_that.defaultPostalCode,_that.totalSpent,_that.totalOrders,_that.isSubscribedNewsletter,_that.lastOrderAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'default_address')  String? defaultAddress, @JsonKey(name: 'default_city')  String? defaultCity, @JsonKey(name: 'default_postal_code')  String? defaultPostalCode, @JsonKey(name: 'total_spent')  int totalSpent, @JsonKey(name: 'total_orders')  int totalOrders, @JsonKey(name: 'is_subscribed_newsletter')  bool isSubscribedNewsletter, @JsonKey(name: 'last_order_at')  DateTime? lastOrderAt)?  $default,) {final _that = this;
switch (_that) {
case _CustomerInfo() when $default != null:
return $default(_that.defaultAddress,_that.defaultCity,_that.defaultPostalCode,_that.totalSpent,_that.totalOrders,_that.isSubscribedNewsletter,_that.lastOrderAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomerInfo implements CustomerInfo {
  const _CustomerInfo({@JsonKey(name: 'default_address') this.defaultAddress, @JsonKey(name: 'default_city') this.defaultCity, @JsonKey(name: 'default_postal_code') this.defaultPostalCode, @JsonKey(name: 'total_spent') this.totalSpent = 0, @JsonKey(name: 'total_orders') this.totalOrders = 0, @JsonKey(name: 'is_subscribed_newsletter') this.isSubscribedNewsletter = true, @JsonKey(name: 'last_order_at') this.lastOrderAt});
  factory _CustomerInfo.fromJson(Map<String, dynamic> json) => _$CustomerInfoFromJson(json);

@override@JsonKey(name: 'default_address') final  String? defaultAddress;
@override@JsonKey(name: 'default_city') final  String? defaultCity;
@override@JsonKey(name: 'default_postal_code') final  String? defaultPostalCode;
@override@JsonKey(name: 'total_spent') final  int totalSpent;
@override@JsonKey(name: 'total_orders') final  int totalOrders;
@override@JsonKey(name: 'is_subscribed_newsletter') final  bool isSubscribedNewsletter;
@override@JsonKey(name: 'last_order_at') final  DateTime? lastOrderAt;

/// Create a copy of CustomerInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerInfoCopyWith<_CustomerInfo> get copyWith => __$CustomerInfoCopyWithImpl<_CustomerInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerInfo&&(identical(other.defaultAddress, defaultAddress) || other.defaultAddress == defaultAddress)&&(identical(other.defaultCity, defaultCity) || other.defaultCity == defaultCity)&&(identical(other.defaultPostalCode, defaultPostalCode) || other.defaultPostalCode == defaultPostalCode)&&(identical(other.totalSpent, totalSpent) || other.totalSpent == totalSpent)&&(identical(other.totalOrders, totalOrders) || other.totalOrders == totalOrders)&&(identical(other.isSubscribedNewsletter, isSubscribedNewsletter) || other.isSubscribedNewsletter == isSubscribedNewsletter)&&(identical(other.lastOrderAt, lastOrderAt) || other.lastOrderAt == lastOrderAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,defaultAddress,defaultCity,defaultPostalCode,totalSpent,totalOrders,isSubscribedNewsletter,lastOrderAt);

@override
String toString() {
  return 'CustomerInfo(defaultAddress: $defaultAddress, defaultCity: $defaultCity, defaultPostalCode: $defaultPostalCode, totalSpent: $totalSpent, totalOrders: $totalOrders, isSubscribedNewsletter: $isSubscribedNewsletter, lastOrderAt: $lastOrderAt)';
}


}

/// @nodoc
abstract mixin class _$CustomerInfoCopyWith<$Res> implements $CustomerInfoCopyWith<$Res> {
  factory _$CustomerInfoCopyWith(_CustomerInfo value, $Res Function(_CustomerInfo) _then) = __$CustomerInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'default_address') String? defaultAddress,@JsonKey(name: 'default_city') String? defaultCity,@JsonKey(name: 'default_postal_code') String? defaultPostalCode,@JsonKey(name: 'total_spent') int totalSpent,@JsonKey(name: 'total_orders') int totalOrders,@JsonKey(name: 'is_subscribed_newsletter') bool isSubscribedNewsletter,@JsonKey(name: 'last_order_at') DateTime? lastOrderAt
});




}
/// @nodoc
class __$CustomerInfoCopyWithImpl<$Res>
    implements _$CustomerInfoCopyWith<$Res> {
  __$CustomerInfoCopyWithImpl(this._self, this._then);

  final _CustomerInfo _self;
  final $Res Function(_CustomerInfo) _then;

/// Create a copy of CustomerInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? defaultAddress = freezed,Object? defaultCity = freezed,Object? defaultPostalCode = freezed,Object? totalSpent = null,Object? totalOrders = null,Object? isSubscribedNewsletter = null,Object? lastOrderAt = freezed,}) {
  return _then(_CustomerInfo(
defaultAddress: freezed == defaultAddress ? _self.defaultAddress : defaultAddress // ignore: cast_nullable_to_non_nullable
as String?,defaultCity: freezed == defaultCity ? _self.defaultCity : defaultCity // ignore: cast_nullable_to_non_nullable
as String?,defaultPostalCode: freezed == defaultPostalCode ? _self.defaultPostalCode : defaultPostalCode // ignore: cast_nullable_to_non_nullable
as String?,totalSpent: null == totalSpent ? _self.totalSpent : totalSpent // ignore: cast_nullable_to_non_nullable
as int,totalOrders: null == totalOrders ? _self.totalOrders : totalOrders // ignore: cast_nullable_to_non_nullable
as int,isSubscribedNewsletter: null == isSubscribedNewsletter ? _self.isSubscribedNewsletter : isSubscribedNewsletter // ignore: cast_nullable_to_non_nullable
as bool,lastOrderAt: freezed == lastOrderAt ? _self.lastOrderAt : lastOrderAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$AuthState {

 UserModel? get user; bool get isLoading; bool get isAuthenticated; String? get error;
/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStateCopyWith<AuthState> get copyWith => _$AuthStateCopyWithImpl<AuthState>(this as AuthState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState&&(identical(other.user, user) || other.user == user)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isAuthenticated, isAuthenticated) || other.isAuthenticated == isAuthenticated)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,user,isLoading,isAuthenticated,error);

@override
String toString() {
  return 'AuthState(user: $user, isLoading: $isLoading, isAuthenticated: $isAuthenticated, error: $error)';
}


}

/// @nodoc
abstract mixin class $AuthStateCopyWith<$Res>  {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) _then) = _$AuthStateCopyWithImpl;
@useResult
$Res call({
 UserModel? user, bool isLoading, bool isAuthenticated, String? error
});


$UserModelCopyWith<$Res>? get user;

}
/// @nodoc
class _$AuthStateCopyWithImpl<$Res>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._self, this._then);

  final AuthState _self;
  final $Res Function(AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = freezed,Object? isLoading = null,Object? isAuthenticated = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isAuthenticated: null == isAuthenticated ? _self.isAuthenticated : isAuthenticated // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserModelCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthState value)  $default,){
final _that = this;
switch (_that) {
case _AuthState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserModel? user,  bool isLoading,  bool isAuthenticated,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that.user,_that.isLoading,_that.isAuthenticated,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserModel? user,  bool isLoading,  bool isAuthenticated,  String? error)  $default,) {final _that = this;
switch (_that) {
case _AuthState():
return $default(_that.user,_that.isLoading,_that.isAuthenticated,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserModel? user,  bool isLoading,  bool isAuthenticated,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that.user,_that.isLoading,_that.isAuthenticated,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _AuthState implements AuthState {
  const _AuthState({this.user, this.isLoading = false, this.isAuthenticated = false, this.error});
  

@override final  UserModel? user;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isAuthenticated;
@override final  String? error;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthStateCopyWith<_AuthState> get copyWith => __$AuthStateCopyWithImpl<_AuthState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthState&&(identical(other.user, user) || other.user == user)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isAuthenticated, isAuthenticated) || other.isAuthenticated == isAuthenticated)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,user,isLoading,isAuthenticated,error);

@override
String toString() {
  return 'AuthState(user: $user, isLoading: $isLoading, isAuthenticated: $isAuthenticated, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AuthStateCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthStateCopyWith(_AuthState value, $Res Function(_AuthState) _then) = __$AuthStateCopyWithImpl;
@override @useResult
$Res call({
 UserModel? user, bool isLoading, bool isAuthenticated, String? error
});


@override $UserModelCopyWith<$Res>? get user;

}
/// @nodoc
class __$AuthStateCopyWithImpl<$Res>
    implements _$AuthStateCopyWith<$Res> {
  __$AuthStateCopyWithImpl(this._self, this._then);

  final _AuthState _self;
  final $Res Function(_AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = freezed,Object? isLoading = null,Object? isAuthenticated = null,Object? error = freezed,}) {
  return _then(_AuthState(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isAuthenticated: null == isAuthenticated ? _self.isAuthenticated : isAuthenticated // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserModelCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc
mixin _$AuthActionState {

 bool get isLoading; String? get error; String? get successMessage;
/// Create a copy of AuthActionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthActionStateCopyWith<AuthActionState> get copyWith => _$AuthActionStateCopyWithImpl<AuthActionState>(this as AuthActionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthActionState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error)&&(identical(other.successMessage, successMessage) || other.successMessage == successMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,error,successMessage);

@override
String toString() {
  return 'AuthActionState(isLoading: $isLoading, error: $error, successMessage: $successMessage)';
}


}

/// @nodoc
abstract mixin class $AuthActionStateCopyWith<$Res>  {
  factory $AuthActionStateCopyWith(AuthActionState value, $Res Function(AuthActionState) _then) = _$AuthActionStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, String? error, String? successMessage
});




}
/// @nodoc
class _$AuthActionStateCopyWithImpl<$Res>
    implements $AuthActionStateCopyWith<$Res> {
  _$AuthActionStateCopyWithImpl(this._self, this._then);

  final AuthActionState _self;
  final $Res Function(AuthActionState) _then;

/// Create a copy of AuthActionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? error = freezed,Object? successMessage = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,successMessage: freezed == successMessage ? _self.successMessage : successMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthActionState].
extension AuthActionStatePatterns on AuthActionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthActionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthActionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthActionState value)  $default,){
final _that = this;
switch (_that) {
case _AuthActionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthActionState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthActionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  String? error,  String? successMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthActionState() when $default != null:
return $default(_that.isLoading,_that.error,_that.successMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  String? error,  String? successMessage)  $default,) {final _that = this;
switch (_that) {
case _AuthActionState():
return $default(_that.isLoading,_that.error,_that.successMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  String? error,  String? successMessage)?  $default,) {final _that = this;
switch (_that) {
case _AuthActionState() when $default != null:
return $default(_that.isLoading,_that.error,_that.successMessage);case _:
  return null;

}
}

}

/// @nodoc


class _AuthActionState implements AuthActionState {
  const _AuthActionState({this.isLoading = false, this.error, this.successMessage});
  

@override@JsonKey() final  bool isLoading;
@override final  String? error;
@override final  String? successMessage;

/// Create a copy of AuthActionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthActionStateCopyWith<_AuthActionState> get copyWith => __$AuthActionStateCopyWithImpl<_AuthActionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthActionState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error)&&(identical(other.successMessage, successMessage) || other.successMessage == successMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,error,successMessage);

@override
String toString() {
  return 'AuthActionState(isLoading: $isLoading, error: $error, successMessage: $successMessage)';
}


}

/// @nodoc
abstract mixin class _$AuthActionStateCopyWith<$Res> implements $AuthActionStateCopyWith<$Res> {
  factory _$AuthActionStateCopyWith(_AuthActionState value, $Res Function(_AuthActionState) _then) = __$AuthActionStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String? error, String? successMessage
});




}
/// @nodoc
class __$AuthActionStateCopyWithImpl<$Res>
    implements _$AuthActionStateCopyWith<$Res> {
  __$AuthActionStateCopyWithImpl(this._self, this._then);

  final _AuthActionState _self;
  final $Res Function(_AuthActionState) _then;

/// Create a copy of AuthActionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? error = freezed,Object? successMessage = freezed,}) {
  return _then(_AuthActionState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,successMessage: freezed == successMessage ? _self.successMessage : successMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
