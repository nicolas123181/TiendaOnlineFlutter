import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

/// Provider del estado de autenticación (Stream)
final authStateProvider = StreamProvider<User?>((ref) {
  final client = Supabase.instance.client;
  return client.auth.onAuthStateChange.map((event) => event.session?.user);
});

/// Provider del usuario actual
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) async {
      if (user == null) return null;

      final repository = ref.read(authRepositoryProvider);
      final result = await repository.getUserProfile();

      return result.fold((failure) => null, (userModel) => userModel);
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Provider para verificar si es admin
final isAdminProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user.value?.isAdmin ?? false;
});

/// Provider para verificar si está autenticado
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.value != null;
});

/// Notifier para acciones de autenticación
final authActionsProvider =
    NotifierProvider<AuthActionsNotifier, AuthActionState>(() {
      return AuthActionsNotifier();
    });

/// Estado de las acciones de autenticación
class AuthActionState {
  final bool isLoading;
  final String? error;
  final String? successMessage;

  const AuthActionState({
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  AuthActionState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
  }) {
    return AuthActionState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
    );
  }
}

/// Notifier para acciones de autenticación
class AuthActionsNotifier extends Notifier<AuthActionState> {
  @override
  AuthActionState build() => const AuthActionState();

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  /// Iniciar sesión
  Future<bool> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.signInWithEmail(
      email: email,
      password: password,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (user) {
        state = state.copyWith(
          isLoading: false,
          successMessage: '¡Bienvenido, ${user.name ?? user.email}!',
        );
        return true;
      },
    );
  }

  /// Registrar usuario
  Future<bool> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.signUp(
      email: email,
      password: password,
      name: name,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (user) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Cuenta creada correctamente. ¡Bienvenido!',
        );
        return true;
      },
    );
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.signOut();

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Sesión cerrada',
        );
      },
    );
  }

  /// Recuperar contraseña
  Future<bool> sendPasswordResetEmail(String email) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.sendPasswordResetEmail(email);

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage:
              'Te hemos enviado un email para restablecer tu contraseña.',
        );
        return true;
      },
    );
  }

  /// Cambiar contraseña (usuario autenticado)
  Future<bool> changePassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    // Validaciones del lado del cliente (mismas que la web)
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'Todos los campos son requeridos',
      );
      return false;
    }

    if (newPassword != confirmPassword) {
      state = state.copyWith(
        isLoading: false,
        error: 'Las contraseñas no coinciden',
      );
      return false;
    }

    if (newPassword.length < 6) {
      state = state.copyWith(
        isLoading: false,
        error: 'La contraseña debe tener al menos 6 caracteres',
      );
      return false;
    }

    final result = await _repository.updatePassword(newPassword);

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Contraseña actualizada correctamente',
        );
        return true;
      },
    );
  }

  /// Limpiar errores
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Limpiar mensajes de éxito
  void clearSuccess() {
    state = state.copyWith(successMessage: null);
  }
}
