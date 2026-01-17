import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../config/constants/app_constants.dart';

/// Servicio de Supabase
class SupabaseService {
  late final SupabaseClient _client;

  SupabaseClient get client => _client;

  /// Inicializar Supabase
  Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
      realtimeClientOptions: const RealtimeClientOptions(eventsPerSecond: 2),
    );
    _client = Supabase.instance.client;
  }

  /// Obtener el cliente de Supabase
  static SupabaseClient getClient() {
    return Supabase.instance.client;
  }

  /// Obtener el usuario actual
  User? get currentUser => _client.auth.currentUser;

  /// Obtener la sesión actual
  Session? get currentSession => _client.auth.currentSession;

  /// Stream de cambios de autenticación
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Verificar si hay una sesión activa
  bool get isAuthenticated => currentSession != null;
}

/// Provider del servicio de Supabase
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

/// Provider del cliente de Supabase
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return SupabaseService.getClient();
});

/// Provider del usuario actual (reactivo)
final currentUserProvider = StreamProvider<User?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.auth.onAuthStateChange.map((event) => event.session?.user);
});
