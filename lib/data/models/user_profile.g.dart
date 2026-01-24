// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'phone': instance.phone,
      'avatar_url': instance.avatarUrl,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$AdminUserImpl _$$AdminUserImplFromJson(Map<String, dynamic> json) =>
    _$AdminUserImpl(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      role: json['role'] as String? ?? 'admin',
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$AdminUserImplToJson(_$AdminUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'role': instance.role,
      'created_at': instance.createdAt.toIso8601String(),
    };

_$NewsletterSubscriberImpl _$$NewsletterSubscriberImplFromJson(
        Map<String, dynamic> json) =>
    _$NewsletterSubscriberImpl(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      name: json['name'] as String?,
      subscribedAt: DateTime.parse(json['subscribed_at'] as String),
      unsubscribedAt: json['unsubscribed_at'] == null
          ? null
          : DateTime.parse(json['unsubscribed_at'] as String),
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$NewsletterSubscriberImplToJson(
        _$NewsletterSubscriberImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'subscribed_at': instance.subscribedAt.toIso8601String(),
      'unsubscribed_at': instance.unsubscribedAt?.toIso8601String(),
      'is_active': instance.isActive,
    };
