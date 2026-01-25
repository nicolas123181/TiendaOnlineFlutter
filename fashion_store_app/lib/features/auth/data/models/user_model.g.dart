// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      isAdmin: json['is_admin'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'phone': instance.phone,
      'avatar_url': instance.avatarUrl,
      'is_admin': instance.isAdmin,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$CustomerInfoImpl _$$CustomerInfoImplFromJson(Map<String, dynamic> json) =>
    _$CustomerInfoImpl(
      defaultAddress: json['default_address'] as String?,
      defaultCity: json['default_city'] as String?,
      defaultPostalCode: json['default_postal_code'] as String?,
      totalSpent: (json['total_spent'] as num?)?.toInt() ?? 0,
      totalOrders: (json['total_orders'] as num?)?.toInt() ?? 0,
      isSubscribedNewsletter: json['is_subscribed_newsletter'] as bool? ?? true,
      lastOrderAt: json['last_order_at'] == null
          ? null
          : DateTime.parse(json['last_order_at'] as String),
    );

Map<String, dynamic> _$$CustomerInfoImplToJson(_$CustomerInfoImpl instance) =>
    <String, dynamic>{
      'default_address': instance.defaultAddress,
      'default_city': instance.defaultCity,
      'default_postal_code': instance.defaultPostalCode,
      'total_spent': instance.totalSpent,
      'total_orders': instance.totalOrders,
      'is_subscribed_newsletter': instance.isSubscribedNewsletter,
      'last_order_at': instance.lastOrderAt?.toIso8601String(),
    };
