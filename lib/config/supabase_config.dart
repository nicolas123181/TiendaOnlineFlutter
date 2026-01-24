import 'package:supabase_flutter/supabase_flutter.dart';
import 'environment.dart';

/// Configuración de Supabase para VANTAGE Fashion
class SupabaseConfig {
  SupabaseConfig._();

  /// URL de Supabase
  static String get supabaseUrl => Environment.supabaseUrl;

  /// Clave anónima de Supabase
  static String get supabaseAnonKey => Environment.supabaseAnonKey;

  /// Inicializa Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  /// Cliente de Supabase
  static SupabaseClient get client => Supabase.instance.client;

  /// Cliente de autenticación
  static GoTrueClient get auth => client.auth;

  /// Usuario actual
  static User? get currentUser => auth.currentUser;

  /// Sesión actual
  static Session? get currentSession => auth.currentSession;

  /// Verifica si hay un usuario autenticado
  static bool get isAuthenticated => currentUser != null;

  /// Stream de cambios de autenticación
  static Stream<AuthState> get authStateChanges => auth.onAuthStateChange;
}
