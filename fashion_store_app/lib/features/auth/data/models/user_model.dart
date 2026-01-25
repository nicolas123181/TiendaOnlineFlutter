import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Modelo de Usuario
@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String email,
    String? name,
    String? phone,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'is_admin') @Default(false) bool isAdmin,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Nombre para mostrar
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
}

/// Información adicional del cliente
@freezed
class CustomerInfo with _$CustomerInfo {
  const factory CustomerInfo({
    @JsonKey(name: 'default_address') String? defaultAddress,
    @JsonKey(name: 'default_city') String? defaultCity,
    @JsonKey(name: 'default_postal_code') String? defaultPostalCode,
    @JsonKey(name: 'total_spent') @Default(0) int totalSpent,
    @JsonKey(name: 'total_orders') @Default(0) int totalOrders,
    @JsonKey(name: 'is_subscribed_newsletter')
    @Default(true)
    bool isSubscribedNewsletter,
    @JsonKey(name: 'last_order_at') DateTime? lastOrderAt,
  }) = _CustomerInfo;

  factory CustomerInfo.fromJson(Map<String, dynamic> json) =>
      _$CustomerInfoFromJson(json);
}

/// Estado de autenticación para UI
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    UserModel? user,
    @Default(false) bool isLoading,
    @Default(false) bool isAuthenticated,
    String? error,
  }) = _AuthState;
}

/// Estado para acciones de autenticación
@freezed
class AuthActionState with _$AuthActionState {
  const factory AuthActionState({
    @Default(false) bool isLoading,
    String? error,
    String? successMessage,
  }) = _AuthActionState;
}
