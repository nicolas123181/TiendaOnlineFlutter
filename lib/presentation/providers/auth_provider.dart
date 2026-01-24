import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/models/user_profile.dart';
import '../../data/repositories/auth_repository.dart';

/// Provider del repositorio de autenticación
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Provider del estado de autenticación
final authStateProvider = StreamProvider<AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
});

/// Provider del usuario actual
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.whenOrNull(
    data: (state) => state.session?.user,
  );
});

/// Provider de verificación de autenticación
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});

/// Provider del perfil del usuario
final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;

  final repository = ref.watch(authRepositoryProvider);
  return await repository.getCurrentUserProfile();
});

/// Provider de verificación de admin
final isAdminProvider = FutureProvider<bool>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return false;

  final repository = ref.watch(authRepositoryProvider);
  return await repository.isAdmin();
});

/// Provider del admin user
final adminUserProvider = FutureProvider<AdminUser?>((ref) async {
  final isAdmin = await ref.watch(isAdminProvider.future);
  if (!isAdmin) return null;

  final repository = ref.watch(authRepositoryProvider);
  return await repository.getAdminUser();
});

/// Notifier para las acciones de autenticación
class AuthNotifier extends StateNotifier<AuthNotifierState> {
  final AuthRepository _repository;
  final Ref _ref;

  AuthNotifier(this._repository, this._ref)
      : super(AuthNotifierState.initial());

  /// Registro de usuario
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.signUp(
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Cuenta creada. Por favor, verifica tu email.',
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }

  /// Inicio de sesión
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.signIn(
      email: email,
      password: password,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Sesión iniciada correctamente',
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }

  /// Cierre de sesión
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);

    await _repository.signOut();

    state = state.copyWith(
      isLoading: false,
      successMessage: 'Sesión cerrada',
    );
  }

  /// Recuperación de contraseña
  Future<void> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.resetPassword(email);

    if (result.isSuccess) {
      state = state.copyWith(
        isLoading: false,
        successMessage: result.message,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }

  /// Actualiza la contraseña
  Future<void> updatePassword(String newPassword) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.updatePassword(newPassword);

    if (result.isSuccess) {
      state = state.copyWith(
        isLoading: false,
        successMessage: result.message,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }

  /// Actualiza el perfil
  Future<void> updateProfile({
    required String fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.updateProfile(
      fullName: fullName,
      phone: phone,
      avatarUrl: avatarUrl,
    );

    if (result.isSuccess) {
      // Invalidar el provider del perfil para que se recargue
      _ref.invalidate(userProfileProvider);

      state = state.copyWith(
        isLoading: false,
        successMessage: result.message,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }

  /// Limpia los mensajes
  void clearMessages() {
    state = state.copyWith(
      error: null,
      successMessage: null,
    );
  }
}

/// Estado del notifier de autenticación
class AuthNotifierState {
  final bool isLoading;
  final String? error;
  final String? successMessage;

  AuthNotifierState({
    required this.isLoading,
    this.error,
    this.successMessage,
  });

  factory AuthNotifierState.initial() {
    return AuthNotifierState(isLoading: false);
  }

  AuthNotifierState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
  }) {
    return AuthNotifierState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
    );
  }
}

/// Provider del notifier de autenticación
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthNotifierState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository, ref);
});

/// Alias para compatibilidad - uso directo como authProvider
final authProvider = authNotifierProvider;
