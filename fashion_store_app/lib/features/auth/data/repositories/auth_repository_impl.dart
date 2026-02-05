import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../shared/exceptions/failures.dart';
import '../../../../shared/services/supabase_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart' hide AuthState, AuthActionState;

/// Implementación del repositorio de autenticación
class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _client;

  AuthRepositoryImpl(this._client);

  @override
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  @override
  User? get currentUser => _client.auth.currentUser;

  @override
  Session? get currentSession => _client.auth.currentSession;

  @override
  bool get isAuthenticated => currentSession != null;

  @override
  FutureEither<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 Intentando login con email: $email');

      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      print('📱 Respuesta de Supabase recibida');
      print('📱 Usuario: ${response.user?.id}');
      print('📱 Sesión: ${response.session != null ? "Activa" : "Null"}');

      if (response.user == null) {
        print('❌ Usuario null en respuesta');
        return left(AuthFailure.invalidCredentials());
      }

      // Verificar si es admin
      final isAdmin = await _checkAdminStatus(email);
      print('Es admin: $isAdmin');

      // Obtener datos del metadata de auth.users
      final metadata = response.user!.userMetadata ?? {};

      final userModel = UserModel(
        id: response.user!.id,
        email: response.user!.email!,
        name: metadata['name'] as String?,
        phone: metadata['phone'] as String?,
        isAdmin: isAdmin,
        createdAt: DateTime.tryParse(response.user!.createdAt),
      );

      print('✅ Login exitoso para: ${userModel.email}');
      return right(userModel);
    } on AuthException catch (e) {
      print('❌ AuthException: ${e.message}');
      print('❌ StatusCode: ${e.statusCode}');

      if (e.message.contains('Invalid login credentials')) {
        return left(AuthFailure.invalidCredentials());
      }
      if (e.message.contains('Email not confirmed')) {
        return left(
          AuthFailure(
            message:
                'Por favor confirma tu correo electrónico antes de iniciar sesión',
            originalError: e,
          ),
        );
      }
      return left(AuthFailure(message: e.message, originalError: e));
    } catch (e) {
      print('❌ Error desconocido: $e');
      return left(
        UnknownFailure(
          message: 'Error al iniciar sesión: $e',
          originalError: e,
        ),
      );
    }
  }

  @override
  FutureEither<UserModel> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      // Preparar metadata del usuario
      final metadata = <String, dynamic>{};
      if (name != null) metadata['name'] = name;

      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: metadata.isNotEmpty ? metadata : null,
      );

      if (response.user == null) {
        return left(const AuthFailure(message: 'Error al crear la cuenta'));
      }

      print('✅ Usuario registrado: ${response.user!.email}');

      return right(
        UserModel(
          id: response.user!.id,
          email: response.user!.email!,
          name: name,
          isAdmin: false,
          createdAt: DateTime.tryParse(response.user!.createdAt),
        ),
      );
    } on AuthException catch (e) {
      if (e.message.contains('already registered')) {
        return left(AuthFailure.emailAlreadyInUse());
      }
      if (e.message.contains('weak password')) {
        return left(AuthFailure.weakPassword());
      }
      return left(AuthFailure(message: e.message, originalError: e));
    } catch (e) {
      return left(
        UnknownFailure(message: 'Error al registrar', originalError: e),
      );
    }
  }

  @override
  FutureEither<void> signOut() async {
    try {
      await _client.auth.signOut();
      return right(null);
    } on AuthException catch (e) {
      return left(AuthFailure(message: e.message, originalError: e));
    } catch (e) {
      return left(
        UnknownFailure(message: 'Error al cerrar sesión', originalError: e),
      );
    }
  }

  @override
  FutureEither<void> sendPasswordResetEmail(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      return right(null);
    } on AuthException catch (e) {
      return left(AuthFailure(message: e.message, originalError: e));
    } catch (e) {
      return left(
        UnknownFailure(
          message: 'Error al enviar email de recuperación',
          originalError: e,
        ),
      );
    }
  }

  @override
  FutureEither<void> updatePassword(String newPassword) async {
    try {
      await _client.auth.updateUser(UserAttributes(password: newPassword));
      return right(null);
    } on AuthException catch (e) {
      return left(AuthFailure(message: e.message, originalError: e));
    } catch (e) {
      return left(
        UnknownFailure(
          message: 'Error al actualizar contraseña',
          originalError: e,
        ),
      );
    }
  }

  @override
  FutureEither<UserModel> getUserProfile() async {
    try {
      final user = currentUser;
      if (user == null) {
        return left(AuthFailure.sessionExpired());
      }

      final isAdmin = await _checkAdminStatus(user.email!);
      final metadata = user.userMetadata ?? {};

      return right(
        UserModel(
          id: user.id,
          email: user.email!,
          name: metadata['name'] as String?,
          phone: metadata['phone'] as String?,
          avatarUrl: metadata['avatar_url'] as String?,
          isAdmin: isAdmin,
          createdAt: DateTime.tryParse(user.createdAt),
        ),
      );
    } catch (e) {
      return left(
        UnknownFailure(message: 'Error al obtener perfil', originalError: e),
      );
    }
  }

  @override
  FutureEither<UserModel> updateUserProfile({
    String? name,
    String? phone,
    String? avatarUrl,
  }) async {
    try {
      final user = currentUser;
      if (user == null) {
        return left(AuthFailure.sessionExpired());
      }

      // Preparar datos a actualizar en metadata
      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (phone != null) updateData['phone'] = phone;
      if (avatarUrl != null) updateData['avatar_url'] = avatarUrl;

      // Actualizar metadata en auth.users
      if (updateData.isNotEmpty) {
        await _client.auth.updateUser(UserAttributes(data: updateData));
        print('✅ Perfil actualizado: $updateData');
      }

      return getUserProfile();
    } catch (e) {
      print('❌ Error actualizando perfil: $e');
      return left(
        UnknownFailure(message: 'Error al actualizar perfil', originalError: e),
      );
    }
  }

  @override
  FutureEither<bool> checkIfAdmin(String email) async {
    try {
      final isAdmin = await _checkAdminStatus(email);
      return right(isAdmin);
    } catch (e) {
      return left(
        UnknownFailure(
          message: 'Error al verificar permisos',
          originalError: e,
        ),
      );
    }
  }

  // ============================================
  // MÉTODOS PRIVADOS
  // ============================================

  Future<bool> _checkAdminStatus(String email) async {
    try {
      final response = await _client
          .from('admin_users')
          .select('id')
          .eq('email', email)
          .maybeSingle();

      return response != null;
    } catch (_) {
      return false;
    }
  }
}

/// Provider del repositorio de autenticación
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRepositoryImpl(client);
});
