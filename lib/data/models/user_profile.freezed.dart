// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {String id,
      String email,
      String? name,
      String? phone,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = freezed,
    Object? phone = freezed,
    Object? avatarUrl = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
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
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String? name,
      String? phone,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = freezed,
    Object? phone = freezed,
    Object? avatarUrl = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$UserProfileImpl(
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
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl extends _UserProfile {
  const _$UserProfileImpl(
      {required this.id,
      required this.email,
      this.name,
      this.phone,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : super._();

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

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
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UserProfile(id: $id, email: $email, name: $name, phone: $phone, avatarUrl: $avatarUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, email, name, phone, avatarUrl, createdAt, updatedAt);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(
      this,
    );
  }
}

abstract class _UserProfile extends UserProfile {
  const factory _UserProfile(
          {required final String id,
          required final String email,
          final String? name,
          final String? phone,
          @JsonKey(name: 'avatar_url') final String? avatarUrl,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$UserProfileImpl;
  const _UserProfile._() : super._();

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

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
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AdminUser _$AdminUserFromJson(Map<String, dynamic> json) {
  return _AdminUser.fromJson(json);
}

/// @nodoc
mixin _$AdminUser {
  int get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AdminUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AdminUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdminUserCopyWith<AdminUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminUserCopyWith<$Res> {
  factory $AdminUserCopyWith(AdminUser value, $Res Function(AdminUser) then) =
      _$AdminUserCopyWithImpl<$Res, AdminUser>;
  @useResult
  $Res call(
      {int id,
      String email,
      String role,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class _$AdminUserCopyWithImpl<$Res, $Val extends AdminUser>
    implements $AdminUserCopyWith<$Res> {
  _$AdminUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdminUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? role = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdminUserImplCopyWith<$Res>
    implements $AdminUserCopyWith<$Res> {
  factory _$$AdminUserImplCopyWith(
          _$AdminUserImpl value, $Res Function(_$AdminUserImpl) then) =
      __$$AdminUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String email,
      String role,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class __$$AdminUserImplCopyWithImpl<$Res>
    extends _$AdminUserCopyWithImpl<$Res, _$AdminUserImpl>
    implements _$$AdminUserImplCopyWith<$Res> {
  __$$AdminUserImplCopyWithImpl(
      _$AdminUserImpl _value, $Res Function(_$AdminUserImpl) _then)
      : super(_value, _then);

  /// Create a copy of AdminUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? role = null,
    Object? createdAt = null,
  }) {
    return _then(_$AdminUserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdminUserImpl extends _AdminUser {
  const _$AdminUserImpl(
      {required this.id,
      required this.email,
      this.role = 'admin',
      @JsonKey(name: 'created_at') required this.createdAt})
      : super._();

  factory _$AdminUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdminUserImplFromJson(json);

  @override
  final int id;
  @override
  final String email;
  @override
  @JsonKey()
  final String role;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'AdminUser(id: $id, email: $email, role: $role, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, email, role, createdAt);

  /// Create a copy of AdminUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminUserImplCopyWith<_$AdminUserImpl> get copyWith =>
      __$$AdminUserImplCopyWithImpl<_$AdminUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdminUserImplToJson(
      this,
    );
  }
}

abstract class _AdminUser extends AdminUser {
  const factory _AdminUser(
          {required final int id,
          required final String email,
          final String role,
          @JsonKey(name: 'created_at') required final DateTime createdAt}) =
      _$AdminUserImpl;
  const _AdminUser._() : super._();

  factory _AdminUser.fromJson(Map<String, dynamic> json) =
      _$AdminUserImpl.fromJson;

  @override
  int get id;
  @override
  String get email;
  @override
  String get role;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of AdminUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdminUserImplCopyWith<_$AdminUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NewsletterSubscriber _$NewsletterSubscriberFromJson(Map<String, dynamic> json) {
  return _NewsletterSubscriber.fromJson(json);
}

/// @nodoc
mixin _$NewsletterSubscriber {
  int get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscribed_at')
  DateTime get subscribedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'unsubscribed_at')
  DateTime? get unsubscribedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this NewsletterSubscriber to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NewsletterSubscriber
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NewsletterSubscriberCopyWith<NewsletterSubscriber> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewsletterSubscriberCopyWith<$Res> {
  factory $NewsletterSubscriberCopyWith(NewsletterSubscriber value,
          $Res Function(NewsletterSubscriber) then) =
      _$NewsletterSubscriberCopyWithImpl<$Res, NewsletterSubscriber>;
  @useResult
  $Res call(
      {int id,
      String email,
      String? name,
      @JsonKey(name: 'subscribed_at') DateTime subscribedAt,
      @JsonKey(name: 'unsubscribed_at') DateTime? unsubscribedAt,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class _$NewsletterSubscriberCopyWithImpl<$Res,
        $Val extends NewsletterSubscriber>
    implements $NewsletterSubscriberCopyWith<$Res> {
  _$NewsletterSubscriberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NewsletterSubscriber
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = freezed,
    Object? subscribedAt = null,
    Object? unsubscribedAt = freezed,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      subscribedAt: null == subscribedAt
          ? _value.subscribedAt
          : subscribedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      unsubscribedAt: freezed == unsubscribedAt
          ? _value.unsubscribedAt
          : unsubscribedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NewsletterSubscriberImplCopyWith<$Res>
    implements $NewsletterSubscriberCopyWith<$Res> {
  factory _$$NewsletterSubscriberImplCopyWith(_$NewsletterSubscriberImpl value,
          $Res Function(_$NewsletterSubscriberImpl) then) =
      __$$NewsletterSubscriberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String email,
      String? name,
      @JsonKey(name: 'subscribed_at') DateTime subscribedAt,
      @JsonKey(name: 'unsubscribed_at') DateTime? unsubscribedAt,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class __$$NewsletterSubscriberImplCopyWithImpl<$Res>
    extends _$NewsletterSubscriberCopyWithImpl<$Res, _$NewsletterSubscriberImpl>
    implements _$$NewsletterSubscriberImplCopyWith<$Res> {
  __$$NewsletterSubscriberImplCopyWithImpl(_$NewsletterSubscriberImpl _value,
      $Res Function(_$NewsletterSubscriberImpl) _then)
      : super(_value, _then);

  /// Create a copy of NewsletterSubscriber
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = freezed,
    Object? subscribedAt = null,
    Object? unsubscribedAt = freezed,
    Object? isActive = null,
  }) {
    return _then(_$NewsletterSubscriberImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      subscribedAt: null == subscribedAt
          ? _value.subscribedAt
          : subscribedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      unsubscribedAt: freezed == unsubscribedAt
          ? _value.unsubscribedAt
          : unsubscribedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NewsletterSubscriberImpl implements _NewsletterSubscriber {
  const _$NewsletterSubscriberImpl(
      {required this.id,
      required this.email,
      this.name,
      @JsonKey(name: 'subscribed_at') required this.subscribedAt,
      @JsonKey(name: 'unsubscribed_at') this.unsubscribedAt,
      @JsonKey(name: 'is_active') this.isActive = true});

  factory _$NewsletterSubscriberImpl.fromJson(Map<String, dynamic> json) =>
      _$$NewsletterSubscriberImplFromJson(json);

  @override
  final int id;
  @override
  final String email;
  @override
  final String? name;
  @override
  @JsonKey(name: 'subscribed_at')
  final DateTime subscribedAt;
  @override
  @JsonKey(name: 'unsubscribed_at')
  final DateTime? unsubscribedAt;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'NewsletterSubscriber(id: $id, email: $email, name: $name, subscribedAt: $subscribedAt, unsubscribedAt: $unsubscribedAt, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NewsletterSubscriberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.subscribedAt, subscribedAt) ||
                other.subscribedAt == subscribedAt) &&
            (identical(other.unsubscribedAt, unsubscribedAt) ||
                other.unsubscribedAt == unsubscribedAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, email, name, subscribedAt, unsubscribedAt, isActive);

  /// Create a copy of NewsletterSubscriber
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NewsletterSubscriberImplCopyWith<_$NewsletterSubscriberImpl>
      get copyWith =>
          __$$NewsletterSubscriberImplCopyWithImpl<_$NewsletterSubscriberImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NewsletterSubscriberImplToJson(
      this,
    );
  }
}

abstract class _NewsletterSubscriber implements NewsletterSubscriber {
  const factory _NewsletterSubscriber(
          {required final int id,
          required final String email,
          final String? name,
          @JsonKey(name: 'subscribed_at') required final DateTime subscribedAt,
          @JsonKey(name: 'unsubscribed_at') final DateTime? unsubscribedAt,
          @JsonKey(name: 'is_active') final bool isActive}) =
      _$NewsletterSubscriberImpl;

  factory _NewsletterSubscriber.fromJson(Map<String, dynamic> json) =
      _$NewsletterSubscriberImpl.fromJson;

  @override
  int get id;
  @override
  String get email;
  @override
  String? get name;
  @override
  @JsonKey(name: 'subscribed_at')
  DateTime get subscribedAt;
  @override
  @JsonKey(name: 'unsubscribed_at')
  DateTime? get unsubscribedAt;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Create a copy of NewsletterSubscriber
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NewsletterSubscriberImplCopyWith<_$NewsletterSubscriberImpl>
      get copyWith => throw _privateConstructorUsedError;
}
