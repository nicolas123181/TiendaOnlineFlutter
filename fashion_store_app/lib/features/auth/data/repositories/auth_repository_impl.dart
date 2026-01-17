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
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return left(AuthFailure.invalidCredentials());
      }

      // Verificar si es admin
      final isAdmin = await _checkAdminStatus(email);

      return right(
        UserModel(
          id: response.user!.id,
          email: response.user!.email!,
          name: response.user!.userMetadata?['name'],
          isAdmin: isAdmin,
          createdAt: DateTime.tryParse(response.user!.createdAt),
        ),
      );
    } on AuthException catch (e) {
      if (e.message.contains('Invalid login credentials')) {
        return left(AuthFailure.invalidCredentials());
      }
      return left(AuthFailure(message: e.message, originalError: e));
    } catch (e) {
      return left(
        UnknownFailure(message: 'Error al iniciar sesión', originalError: e),
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
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: name != null ? {'name': name} : null,
      );

      if (response.user == null) {
        return left(const AuthFailure(message: 'Error al crear la cuenta'));
      }

      // Crear registro en customers
      await _createCustomerRecord(
        email: email,
        name: name ?? email.split('@')[0],
      );

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

      // Obtener datos del cliente
      final customerData = await _client
          .from('customers')
          .select()
          .eq('email', user.email!)
          .maybeSingle();

      final isAdmin = await _checkAdminStatus(user.email!);

      return right(
        UserModel(
          id: user.id,
          email: user.email!,
          name: user.userMetadata?['name'] ?? customerData?['name'],
          phone: customerData?['phone'],
          isAdmin: isAdmin,
          createdAt: DateTime.tryParse(user.createdAt),
          customerInfo: customerData != null
              ? CustomerInfo.fromJson(customerData)
              : null,
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

      // Actualizar metadata en auth
      if (name != null) {
        await _client.auth.updateUser(UserAttributes(data: {'name': name}));
      }

      // Actualizar en customers
      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (phone != null) updateData['phone'] = phone;

      if (updateData.isNotEmpty) {
        await _client
            .from('customers')
            .update(updateData)
            .eq('email', user.email!);
      }

      return getUserProfile();
    } catch (e) {
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

  Future<void> _createCustomerRecord({
    required String email,
    required String name,
  }) async {
    try {
      await _client.from('customers').upsert({
        'email': email,
        'name': name,
      }, onConflict: 'email');
    } catch (_) {
      // Ignorar errores al crear el registro de cliente
    }
  }
}

/// Provider del repositorio de autenticación
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRepositoryImpl(client);
});
