import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_profile.dart';
import '../../core/services/supabase_service.dart';
import '../../core/services/storage_service.dart';

/// Repositorio de autenticación
class AuthRepository {
  final SupabaseService _supabaseService = SupabaseService.instance;
  final StorageService _storageService = StorageService.instance;

  /// Stream del estado de autenticación
  Stream<AuthState> get authStateChanges => _supabaseService.authStateChanges;

  /// Usuario actual de Supabase
  User? get currentUser => _supabaseService.currentUser;

  /// Verifica si hay un usuario autenticado
  bool get isAuthenticated => currentUser != null;

  /// Registro con email y contraseña
  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    try {
      final response = await _supabaseService.signUp(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
      );

      if (response.user != null) {
        return AuthResult.success(user: response.user);
      } else {
        return AuthResult.error(message: 'Error al crear la cuenta');
      }
    } on AuthException catch (e) {
      return AuthResult.error(message: _parseAuthError(e));
    } catch (e) {
      return AuthResult.error(message: 'Error inesperado: $e');
    }
  }

  /// Inicio de sesión con email y contraseña
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseService.signIn(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Guardar en almacenamiento seguro si el usuario lo solicita
        return AuthResult.success(user: response.user);
      } else {
        return AuthResult.error(message: 'Credenciales inválidas');
      }
    } on AuthException catch (e) {
      return AuthResult.error(message: _parseAuthError(e));
    } catch (e) {
      return AuthResult.error(message: 'Error inesperado: $e');
    }
  }

  /// Cierre de sesión
  Future<void> signOut() async {
    await _supabaseService.signOut();
    await _storageService.clearCart();
    await _storageService.clearRecentlyViewed();
  }

  /// Recuperación de contraseña
  Future<AuthResult> resetPassword(String email) async {
    try {
      await _supabaseService.resetPassword(email);
      return AuthResult.success(
        message: 'Se ha enviado un correo para restablecer la contraseña',
      );
    } on AuthException catch (e) {
      return AuthResult.error(message: _parseAuthError(e));
    } catch (e) {
      return AuthResult.error(message: 'Error inesperado: $e');
    }
  }

  /// Actualiza la contraseña
  Future<AuthResult> updatePassword(String newPassword) async {
    try {
      await _supabaseService.updatePassword(newPassword);
      return AuthResult.success(
          message: 'Contraseña actualizada correctamente');
    } on AuthException catch (e) {
      return AuthResult.error(message: _parseAuthError(e));
    } catch (e) {
      return AuthResult.error(message: 'Error inesperado: $e');
    }
  }

  /// Obtiene el perfil del usuario actual
  Future<UserProfile?> getCurrentUserProfile() async {
    final user = currentUser;
    if (user == null) return null;

    try {
      return await _supabaseService.getUserProfile(user.id);
    } catch (e) {
      return null;
    }
  }

  /// Actualiza el perfil del usuario
  Future<AuthResult> updateProfile({
    required String fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    final user = currentUser;
    if (user == null) {
      return AuthResult.error(message: 'Usuario no autenticado');
    }

    try {
      await _supabaseService.updateUserProfile(
        userId: user.id,
        fullName: fullName,
        phone: phone,
        avatarUrl: avatarUrl,
      );
      return AuthResult.success(message: 'Perfil actualizado correctamente');
    } catch (e) {
      return AuthResult.error(message: 'Error al actualizar el perfil: $e');
    }
  }

  /// Verifica si el usuario es administrador
  Future<bool> isAdmin() async {
    final user = currentUser;
    if (user == null) return false;

    try {
      return await _supabaseService.isAdmin(user.email ?? '');
    } catch (e) {
      return false;
    }
  }

  /// Obtiene los datos del administrador
  Future<AdminUser?> getAdminUser() async {
    final user = currentUser;
    if (user == null) return null;

    try {
      return await _supabaseService.getAdminUser(user.email ?? '');
    } catch (e) {
      return null;
    }
  }

  /// Parsea los errores de autenticación a mensajes legibles
  String _parseAuthError(AuthException e) {
    final message = e.message.toLowerCase();

    if (message.contains('invalid login credentials') ||
        message.contains('invalid email or password')) {
      return 'Email o contraseña incorrectos';
    }
    if (message.contains('email not confirmed')) {
      return 'Por favor, confirma tu email antes de iniciar sesión';
    }
    if (message.contains('user already registered')) {
      return 'Este email ya está registrado';
    }
    if (message.contains('password should be at least')) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    if (message.contains('invalid email')) {
      return 'El formato del email no es válido';
    }
    if (message.contains('rate limit') ||
        message.contains('too many requests')) {
      return 'Demasiados intentos. Por favor, espera un momento';
    }
    if (message.contains('network') || message.contains('connection')) {
      return 'Error de conexión. Comprueba tu internet';
    }

    return e.message;
  }
}

/// Resultado de operaciones de autenticación
class AuthResult {
  final bool isSuccess;
  final User? user;
  final String? message;
  final String? errorCode;

  AuthResult._({
    required this.isSuccess,
    this.user,
    this.message,
    this.errorCode,
  });

  factory AuthResult.success({User? user, String? message}) {
    return AuthResult._(
      isSuccess: true,
      user: user,
      message: message,
    );
  }

  factory AuthResult.error({required String message, String? errorCode}) {
    return AuthResult._(
      isSuccess: false,
      message: message,
      errorCode: errorCode,
    );
  }
}
