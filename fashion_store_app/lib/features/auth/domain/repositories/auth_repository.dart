import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../shared/exceptions/failures.dart';
import '../../data/models/user_model.dart' hide AuthState;

/// Contrato del repositorio de autenticación
abstract class AuthRepository {
  /// Stream del estado de autenticación
  Stream<AuthState> get authStateChanges;

  /// Usuario actual
  User? get currentUser;

  /// Sesión actual
  Session? get currentSession;

  /// ¿Está autenticado?
  bool get isAuthenticated;

  /// Iniciar sesión con email y contraseña
  FutureEither<UserModel> signInWithEmail({
    required String email,
    required String password,
  });

  /// Registrar nuevo usuario
  FutureEither<UserModel> signUp({
    required String email,
    required String password,
    String? name,
  });

  /// Cerrar sesión
  FutureEither<void> signOut();

  /// Enviar email de recuperación de contraseña
  FutureEither<void> sendPasswordResetEmail(String email);

  /// Actualizar contraseña
  FutureEither<void> updatePassword(String newPassword);

  /// Obtener perfil del usuario
  FutureEither<UserModel> getUserProfile();

  /// Actualizar perfil del usuario
  FutureEither<UserModel> updateUserProfile({
    String? name,
    String? phone,
    String? avatarUrl,
  });

  /// Verificar si el usuario es admin
  FutureEither<bool> checkIfAdmin(String email);
}
