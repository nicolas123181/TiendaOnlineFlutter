import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../shared/services/supabase_service.dart';

/// Provider para el interruptor de ofertas en tiempo real
/// Este provider escucha cambios en la tabla app_settings para la clave 'flash_offers_enabled'
final flashOffersEnabledProvider = StreamProvider<bool>((ref) async* {
  final client = ref.watch(supabaseClientProvider);

  // Primero, obtener el valor actual
  try {
    final response = await client
        .from('app_settings')
        .select('value')
        .eq('key', 'flash_offers_enabled')
        .single();

    yield response['value'] == 'true';
  } catch (e) {
    yield true; // Por defecto habilitado
  }

  // Luego, suscribirse a cambios en tiempo real
  final stream = client
      .from('app_settings')
      .stream(primaryKey: ['id'])
      .eq('key', 'flash_offers_enabled')
      .map((data) {
        if (data.isNotEmpty) {
          return data.first['value'] == 'true';
        }
        return true;
      });

  await for (final value in stream) {
    yield value;
  }
});

/// Provider para configuración general de la app
final appSettingsProvider = FutureProvider<Map<String, String>>((ref) async {
  final client = ref.watch(supabaseClientProvider);

  try {
    final response = await client.from('app_settings').select('key, value');

    final settings = <String, String>{};
    for (final row in response as List) {
      settings[row['key'] as String] = row['value'] as String;
    }
    return settings;
  } catch (e) {
    return {};
  }
});

/// Notifier para gestionar configuración (Admin)
final settingsNotifierProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(() {
      return SettingsNotifier();
    });

class SettingsState {
  final bool isLoading;
  final String? error;
  final Map<String, String> settings;

  const SettingsState({
    this.isLoading = false,
    this.error,
    this.settings = const {},
  });

  SettingsState copyWith({
    bool? isLoading,
    String? error,
    Map<String, String>? settings,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      settings: settings ?? this.settings,
    );
  }

  bool get flashOffersEnabled => settings['flash_offers_enabled'] == 'true';
  bool get newsletterEnabled => settings['newsletter_enabled'] == 'true';
  bool get storeOpen => settings['store_open'] == 'true';
}

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    _loadSettings();
    return const SettingsState();
  }

  SupabaseClient get _client => ref.read(supabaseClientProvider);

  Future<void> _loadSettings() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _client.from('app_settings').select('key, value');

      final settings = <String, String>{};
      for (final row in response as List) {
        settings[row['key'] as String] = row['value'] as String;
      }

      state = state.copyWith(isLoading: false, settings: settings);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar configuración',
      );
    }
  }

  /// Actualizar el interruptor de ofertas flash
  Future<bool> toggleFlashOffers(bool enabled) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _client
          .from('app_settings')
          .update({'value': enabled.toString()})
          .eq('key', 'flash_offers_enabled');

      final newSettings = Map<String, String>.from(state.settings);
      newSettings['flash_offers_enabled'] = enabled.toString();

      state = state.copyWith(isLoading: false, settings: newSettings);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al actualizar configuración',
      );
      return false;
    }
  }

  /// Actualizar cualquier configuración
  Future<bool> updateSetting(String key, String value) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _client.from('app_settings').upsert({
        'key': key,
        'value': value,
      }, onConflict: 'key');

      final newSettings = Map<String, String>.from(state.settings);
      newSettings[key] = value;

      state = state.copyWith(isLoading: false, settings: newSettings);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al actualizar configuración',
      );
      return false;
    }
  }

  /// Recargar configuración
  Future<void> refresh() => _loadSettings();
}
