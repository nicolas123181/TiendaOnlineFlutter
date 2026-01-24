import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// Modelo de Perfil de Usuario
@freezed
class UserProfile with _$UserProfile {
  const UserProfile._(); // Constructor privado para permitir métodos

  const factory UserProfile({
    required String id,
    required String email,
    String? name,
    String? phone,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  /// Crea desde datos de Supabase Auth
  factory UserProfile.fromAuthUser(Map<String, dynamic> json) {
    final userMetadata = json['user_metadata'] as Map<String, dynamic>?;

    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      name: userMetadata?['name'] as String? ??
          userMetadata?['full_name'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: userMetadata?['avatar_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Nombre para mostrar (o email si no hay nombre)
  String get displayName => name ?? email.split('@').first;

  /// Iniciales para avatar
  String get initials {
    if (name != null && name!.isNotEmpty) {
      final parts = name!.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return name![0].toUpperCase();
    }
    return email[0].toUpperCase();
  }

  /// Verifica si tiene avatar
  bool get hasAvatar => avatarUrl != null && avatarUrl!.isNotEmpty;
}

/// Modelo de Usuario Admin
@freezed
class AdminUser with _$AdminUser {
  const AdminUser._(); // Constructor privado para permitir métodos

  const factory AdminUser({
    required int id,
    required String email,
    @Default('admin') String role,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _AdminUser;

  factory AdminUser.fromJson(Map<String, dynamic> json) =>
      _$AdminUserFromJson(json);

  /// Verifica si es super admin
  bool get isSuperAdmin => role == 'super_admin';
}

/// Modelo de Suscriptor de Newsletter
@freezed
class NewsletterSubscriber with _$NewsletterSubscriber {
  const factory NewsletterSubscriber({
    required int id,
    required String email,
    String? name,
    @JsonKey(name: 'subscribed_at') required DateTime subscribedAt,
    @JsonKey(name: 'unsubscribed_at') DateTime? unsubscribedAt,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _NewsletterSubscriber;

  factory NewsletterSubscriber.fromJson(Map<String, dynamic> json) =>
      _$NewsletterSubscriberFromJson(json);
}
