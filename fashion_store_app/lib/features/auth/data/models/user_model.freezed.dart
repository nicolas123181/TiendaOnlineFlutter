// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_admin')
  bool get isAdmin => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({
    String id,
    String email,
    String? name,
    String? phone,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'is_admin') bool isAdmin,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = freezed,
    Object? phone = freezed,
    Object? avatarUrl = freezed,
    Object? isAdmin = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            name: freezed == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            isAdmin: null == isAdmin
                ? _value.isAdmin
                : isAdmin // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String email,
    String? name,
    String? phone,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'is_admin') bool isAdmin,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = freezed,
    Object? phone = freezed,
    Object? avatarUrl = freezed,
    Object? isAdmin = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$UserModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        name: freezed == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        isAdmin: null == isAdmin
            ? _value.isAdmin
            : isAdmin // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl extends _UserModel {
  const _$UserModelImpl({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    @JsonKey(name: 'avatar_url') this.avatarUrl,
    @JsonKey(name: 'is_admin') this.isAdmin = false,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : super._();

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String? name;
  @override
  final String? phone;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  @JsonKey(name: 'is_admin')
  final bool isAdmin;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, phone: $phone, avatarUrl: $avatarUrl, isAdmin: $isAdmin, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    email,
    name,
    phone,
    avatarUrl,
    isAdmin,
    createdAt,
    updatedAt,
  );

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel extends UserModel {
  const factory _UserModel({
    required final String id,
    required final String email,
    final String? name,
    final String? phone,
    @JsonKey(name: 'avatar_url') final String? avatarUrl,
    @JsonKey(name: 'is_admin') final bool isAdmin,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$UserModelImpl;
  const _UserModel._() : super._();

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String? get name;
  @override
  String? get phone;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  @JsonKey(name: 'is_admin')
  bool get isAdmin;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CustomerInfo _$CustomerInfoFromJson(Map<String, dynamic> json) {
  return _CustomerInfo.fromJson(json);
}

/// @nodoc
mixin _$CustomerInfo {
  @JsonKey(name: 'default_address')
  String? get defaultAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'default_city')
  String? get defaultCity => throw _privateConstructorUsedError;
  @JsonKey(name: 'default_postal_code')
  String? get defaultPostalCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_spent')
  int get totalSpent => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_orders')
  int get totalOrders => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_subscribed_newsletter')
  bool get isSubscribedNewsletter => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_order_at')
  DateTime? get lastOrderAt => throw _privateConstructorUsedError;

  /// Serializes this CustomerInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerInfoCopyWith<CustomerInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerInfoCopyWith<$Res> {
  factory $CustomerInfoCopyWith(
    CustomerInfo value,
    $Res Function(CustomerInfo) then,
  ) = _$CustomerInfoCopyWithImpl<$Res, CustomerInfo>;
  @useResult
  $Res call({
    @JsonKey(name: 'default_address') String? defaultAddress,
    @JsonKey(name: 'default_city') String? defaultCity,
    @JsonKey(name: 'default_postal_code') String? defaultPostalCode,
    @JsonKey(name: 'total_spent') int totalSpent,
    @JsonKey(name: 'total_orders') int totalOrders,
    @JsonKey(name: 'is_subscribed_newsletter') bool isSubscribedNewsletter,
    @JsonKey(name: 'last_order_at') DateTime? lastOrderAt,
  });
}

/// @nodoc
class _$CustomerInfoCopyWithImpl<$Res, $Val extends CustomerInfo>
    implements $CustomerInfoCopyWith<$Res> {
  _$CustomerInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? defaultAddress = freezed,
    Object? defaultCity = freezed,
    Object? defaultPostalCode = freezed,
    Object? totalSpent = null,
    Object? totalOrders = null,
    Object? isSubscribedNewsletter = null,
    Object? lastOrderAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            defaultAddress: freezed == defaultAddress
                ? _value.defaultAddress
                : defaultAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            defaultCity: freezed == defaultCity
                ? _value.defaultCity
                : defaultCity // ignore: cast_nullable_to_non_nullable
                      as String?,
            defaultPostalCode: freezed == defaultPostalCode
                ? _value.defaultPostalCode
                : defaultPostalCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            totalSpent: null == totalSpent
                ? _value.totalSpent
                : totalSpent // ignore: cast_nullable_to_non_nullable
                      as int,
            totalOrders: null == totalOrders
                ? _value.totalOrders
                : totalOrders // ignore: cast_nullable_to_non_nullable
                      as int,
            isSubscribedNewsletter: null == isSubscribedNewsletter
                ? _value.isSubscribedNewsletter
                : isSubscribedNewsletter // ignore: cast_nullable_to_non_nullable
                      as bool,
            lastOrderAt: freezed == lastOrderAt
                ? _value.lastOrderAt
                : lastOrderAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomerInfoImplCopyWith<$Res>
    implements $CustomerInfoCopyWith<$Res> {
  factory _$$CustomerInfoImplCopyWith(
    _$CustomerInfoImpl value,
    $Res Function(_$CustomerInfoImpl) then,
  ) = __$$CustomerInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'default_address') String? defaultAddress,
    @JsonKey(name: 'default_city') String? defaultCity,
    @JsonKey(name: 'default_postal_code') String? defaultPostalCode,
    @JsonKey(name: 'total_spent') int totalSpent,
    @JsonKey(name: 'total_orders') int totalOrders,
    @JsonKey(name: 'is_subscribed_newsletter') bool isSubscribedNewsletter,
    @JsonKey(name: 'last_order_at') DateTime? lastOrderAt,
  });
}

/// @nodoc
class __$$CustomerInfoImplCopyWithImpl<$Res>
    extends _$CustomerInfoCopyWithImpl<$Res, _$CustomerInfoImpl>
    implements _$$CustomerInfoImplCopyWith<$Res> {
  __$$CustomerInfoImplCopyWithImpl(
    _$CustomerInfoImpl _value,
    $Res Function(_$CustomerInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? defaultAddress = freezed,
    Object? defaultCity = freezed,
    Object? defaultPostalCode = freezed,
    Object? totalSpent = null,
    Object? totalOrders = null,
    Object? isSubscribedNewsletter = null,
    Object? lastOrderAt = freezed,
  }) {
    return _then(
      _$CustomerInfoImpl(
        defaultAddress: freezed == defaultAddress
            ? _value.defaultAddress
            : defaultAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        defaultCity: freezed == defaultCity
            ? _value.defaultCity
            : defaultCity // ignore: cast_nullable_to_non_nullable
                  as String?,
        defaultPostalCode: freezed == defaultPostalCode
            ? _value.defaultPostalCode
            : defaultPostalCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalSpent: null == totalSpent
            ? _value.totalSpent
            : totalSpent // ignore: cast_nullable_to_non_nullable
                  as int,
        totalOrders: null == totalOrders
            ? _value.totalOrders
            : totalOrders // ignore: cast_nullable_to_non_nullable
                  as int,
        isSubscribedNewsletter: null == isSubscribedNewsletter
            ? _value.isSubscribedNewsletter
            : isSubscribedNewsletter // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastOrderAt: freezed == lastOrderAt
            ? _value.lastOrderAt
            : lastOrderAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerInfoImpl implements _CustomerInfo {
  const _$CustomerInfoImpl({
    @JsonKey(name: 'default_address') this.defaultAddress,
    @JsonKey(name: 'default_city') this.defaultCity,
    @JsonKey(name: 'default_postal_code') this.defaultPostalCode,
    @JsonKey(name: 'total_spent') this.totalSpent = 0,
    @JsonKey(name: 'total_orders') this.totalOrders = 0,
    @JsonKey(name: 'is_subscribed_newsletter')
    this.isSubscribedNewsletter = true,
    @JsonKey(name: 'last_order_at') this.lastOrderAt,
  });

  factory _$CustomerInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerInfoImplFromJson(json);

  @override
  @JsonKey(name: 'default_address')
  final String? defaultAddress;
  @override
  @JsonKey(name: 'default_city')
  final String? defaultCity;
  @override
  @JsonKey(name: 'default_postal_code')
  final String? defaultPostalCode;
  @override
  @JsonKey(name: 'total_spent')
  final int totalSpent;
  @override
  @JsonKey(name: 'total_orders')
  final int totalOrders;
  @override
  @JsonKey(name: 'is_subscribed_newsletter')
  final bool isSubscribedNewsletter;
  @override
  @JsonKey(name: 'last_order_at')
  final DateTime? lastOrderAt;

  @override
  String toString() {
    return 'CustomerInfo(defaultAddress: $defaultAddress, defaultCity: $defaultCity, defaultPostalCode: $defaultPostalCode, totalSpent: $totalSpent, totalOrders: $totalOrders, isSubscribedNewsletter: $isSubscribedNewsletter, lastOrderAt: $lastOrderAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerInfoImpl &&
            (identical(other.defaultAddress, defaultAddress) ||
                other.defaultAddress == defaultAddress) &&
            (identical(other.defaultCity, defaultCity) ||
                other.defaultCity == defaultCity) &&
            (identical(other.defaultPostalCode, defaultPostalCode) ||
                other.defaultPostalCode == defaultPostalCode) &&
            (identical(other.totalSpent, totalSpent) ||
                other.totalSpent == totalSpent) &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders) &&
            (identical(other.isSubscribedNewsletter, isSubscribedNewsletter) ||
                other.isSubscribedNewsletter == isSubscribedNewsletter) &&
            (identical(other.lastOrderAt, lastOrderAt) ||
                other.lastOrderAt == lastOrderAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    defaultAddress,
    defaultCity,
    defaultPostalCode,
    totalSpent,
    totalOrders,
    isSubscribedNewsletter,
    lastOrderAt,
  );

  /// Create a copy of CustomerInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerInfoImplCopyWith<_$CustomerInfoImpl> get copyWith =>
      __$$CustomerInfoImplCopyWithImpl<_$CustomerInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerInfoImplToJson(this);
  }
}

abstract class _CustomerInfo implements CustomerInfo {
  const factory _CustomerInfo({
    @JsonKey(name: 'default_address') final String? defaultAddress,
    @JsonKey(name: 'default_city') final String? defaultCity,
    @JsonKey(name: 'default_postal_code') final String? defaultPostalCode,
    @JsonKey(name: 'total_spent') final int totalSpent,
    @JsonKey(name: 'total_orders') final int totalOrders,
    @JsonKey(name: 'is_subscribed_newsletter')
    final bool isSubscribedNewsletter,
    @JsonKey(name: 'last_order_at') final DateTime? lastOrderAt,
  }) = _$CustomerInfoImpl;

  factory _CustomerInfo.fromJson(Map<String, dynamic> json) =
      _$CustomerInfoImpl.fromJson;

  @override
  @JsonKey(name: 'default_address')
  String? get defaultAddress;
  @override
  @JsonKey(name: 'default_city')
  String? get defaultCity;
  @override
  @JsonKey(name: 'default_postal_code')
  String? get defaultPostalCode;
  @override
  @JsonKey(name: 'total_spent')
  int get totalSpent;
  @override
  @JsonKey(name: 'total_orders')
  int get totalOrders;
  @override
  @JsonKey(name: 'is_subscribed_newsletter')
  bool get isSubscribedNewsletter;
  @override
  @JsonKey(name: 'last_order_at')
  DateTime? get lastOrderAt;

  /// Create a copy of CustomerInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerInfoImplCopyWith<_$CustomerInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AuthState {
  UserModel? get user => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isAuthenticated => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthStateCopyWith<AuthState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
  @useResult
  $Res call({
    UserModel? user,
    bool isLoading,
    bool isAuthenticated,
    String? error,
  });

  $UserModelCopyWith<$Res>? get user;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? isLoading = null,
    Object? isAuthenticated = null,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            user: freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as UserModel?,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isAuthenticated: null == isAuthenticated
                ? _value.isAuthenticated
                : isAuthenticated // ignore: cast_nullable_to_non_nullable
                      as bool,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserModelCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthStateImplCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory _$$AuthStateImplCopyWith(
    _$AuthStateImpl value,
    $Res Function(_$AuthStateImpl) then,
  ) = __$$AuthStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    UserModel? user,
    bool isLoading,
    bool isAuthenticated,
    String? error,
  });

  @override
  $UserModelCopyWith<$Res>? get user;
}

/// @nodoc
class __$$AuthStateImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthStateImpl>
    implements _$$AuthStateImplCopyWith<$Res> {
  __$$AuthStateImplCopyWithImpl(
    _$AuthStateImpl _value,
    $Res Function(_$AuthStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? isLoading = null,
    Object? isAuthenticated = null,
    Object? error = freezed,
  }) {
    return _then(
      _$AuthStateImpl(
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserModel?,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isAuthenticated: null == isAuthenticated
            ? _value.isAuthenticated
            : isAuthenticated // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$AuthStateImpl implements _AuthState {
  const _$AuthStateImpl({
    this.user,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
  });

  @override
  final UserModel? user;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isAuthenticated;
  @override
  final String? error;

  @override
  String toString() {
    return 'AuthState(user: $user, isLoading: $isLoading, isAuthenticated: $isAuthenticated, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthStateImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isAuthenticated, isAuthenticated) ||
                other.isAuthenticated == isAuthenticated) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, user, isLoading, isAuthenticated, error);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
      __$$AuthStateImplCopyWithImpl<_$AuthStateImpl>(this, _$identity);
}

abstract class _AuthState implements AuthState {
  const factory _AuthState({
    final UserModel? user,
    final bool isLoading,
    final bool isAuthenticated,
    final String? error,
  }) = _$AuthStateImpl;

  @override
  UserModel? get user;
  @override
  bool get isLoading;
  @override
  bool get isAuthenticated;
  @override
  String? get error;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AuthActionState {
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String? get successMessage => throw _privateConstructorUsedError;

  /// Create a copy of AuthActionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthActionStateCopyWith<AuthActionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthActionStateCopyWith<$Res> {
  factory $AuthActionStateCopyWith(
    AuthActionState value,
    $Res Function(AuthActionState) then,
  ) = _$AuthActionStateCopyWithImpl<$Res, AuthActionState>;
  @useResult
  $Res call({bool isLoading, String? error, String? successMessage});
}

/// @nodoc
class _$AuthActionStateCopyWithImpl<$Res, $Val extends AuthActionState>
    implements $AuthActionStateCopyWith<$Res> {
  _$AuthActionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthActionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? error = freezed,
    Object? successMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
            successMessage: freezed == successMessage
                ? _value.successMessage
                : successMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthActionStateImplCopyWith<$Res>
    implements $AuthActionStateCopyWith<$Res> {
  factory _$$AuthActionStateImplCopyWith(
    _$AuthActionStateImpl value,
    $Res Function(_$AuthActionStateImpl) then,
  ) = __$$AuthActionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, String? error, String? successMessage});
}

/// @nodoc
class __$$AuthActionStateImplCopyWithImpl<$Res>
    extends _$AuthActionStateCopyWithImpl<$Res, _$AuthActionStateImpl>
    implements _$$AuthActionStateImplCopyWith<$Res> {
  __$$AuthActionStateImplCopyWithImpl(
    _$AuthActionStateImpl _value,
    $Res Function(_$AuthActionStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthActionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? error = freezed,
    Object? successMessage = freezed,
  }) {
    return _then(
      _$AuthActionStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
        successMessage: freezed == successMessage
            ? _value.successMessage
            : successMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$AuthActionStateImpl implements _AuthActionState {
  const _$AuthActionStateImpl({
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;
  @override
  final String? successMessage;

  @override
  String toString() {
    return 'AuthActionState(isLoading: $isLoading, error: $error, successMessage: $successMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthActionStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.successMessage, successMessage) ||
                other.successMessage == successMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLoading, error, successMessage);

  /// Create a copy of AuthActionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthActionStateImplCopyWith<_$AuthActionStateImpl> get copyWith =>
      __$$AuthActionStateImplCopyWithImpl<_$AuthActionStateImpl>(
        this,
        _$identity,
      );
}

abstract class _AuthActionState implements AuthActionState {
  const factory _AuthActionState({
    final bool isLoading,
    final String? error,
    final String? successMessage,
  }) = _$AuthActionStateImpl;

  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  String? get successMessage;

  /// Create a copy of AuthActionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthActionStateImplCopyWith<_$AuthActionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
