// Provider para configuración del admin

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/services/supabase_service.dart';

/// Provider para obtener una configuración específica
final settingProvider = FutureProvider.family<String?, String>((
  ref,
  key,
) async {
  final supabase = ref.read(supabaseClientProvider);

  final response = await supabase
      .from('app_settings')
      .select('value')
      .eq('key', key)
      .maybeSingle();

  return response?['value'] as String?;
});

/// Provider para ofertas flash habilitadas
final flashOffersEnabledProvider = FutureProvider<bool>((ref) async {
  final value = await ref.watch(settingProvider('flash_offers_enabled').future);
  return value == 'true';
});

/// Provider para umbral de stock bajo
final lowStockThresholdProvider = FutureProvider<int>((ref) async {
  final value = await ref.watch(settingProvider('low_stock_threshold').future);
  return int.tryParse(value ?? '5') ?? 5;
});

/// Provider para todas las configuraciones
final allSettingsProvider = FutureProvider<Map<String, String>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);

  final response = await supabase.from('app_settings').select('key, value');

  final Map<String, String> settings = {};
  for (final row in (response as List)) {
    settings[row['key'] as String] = row['value'] as String;
  }
  return settings;
});

/// Provider para acciones de configuración
final settingsActionsProvider = Provider((ref) => SettingsActions(ref));

class SettingsActions {
  final Ref ref;

  SettingsActions(this.ref);

  /// Actualizar o crear una configuración
  Future<void> updateSetting(String key, String value) async {
    final supabase = ref.read(supabaseClientProvider);

    await supabase.from('app_settings').upsert({
      'key': key,
      'value': value,
      'updated_at': DateTime.now().toIso8601String(),
    }, onConflict: 'key');

    _invalidateCache();
  }

  /// Activar/desactivar ofertas flash
  Future<void> toggleFlashOffers(bool enabled) async {
    await updateSetting('flash_offers_enabled', enabled.toString());
  }

  /// Actualizar umbral de stock bajo
  Future<void> updateLowStockThreshold(int threshold) async {
    await updateSetting('low_stock_threshold', threshold.toString());
  }

  void _invalidateCache() {
    ref.invalidate(allSettingsProvider);
    ref.invalidate(flashOffersEnabledProvider);
    ref.invalidate(lowStockThresholdProvider);
  }
}
