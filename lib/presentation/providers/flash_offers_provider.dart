import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider para escuchar cambios en tiempo real de las ofertas flash
/// Esto permite que cuando el admin active/desactive las ofertas,
/// todos los clientes reciban la actualización instantáneamente
final flashOffersEnabledProvider = StreamProvider<bool>((ref) {
  return FlashOffersService().flashOffersStream;
});

/// Provider para obtener el estado actual de las ofertas flash (sin stream)
final flashOffersCurrentStateProvider = FutureProvider<bool>((ref) async {
  return await FlashOffersService().isFlashOffersEnabled();
});

/// Servicio para gestionar las ofertas flash
class FlashOffersService {
  static final FlashOffersService _instance = FlashOffersService._internal();
  factory FlashOffersService() => _instance;
  FlashOffersService._internal();

  final _supabase = Supabase.instance.client;

  /// StreamController para emitir cambios en el estado de ofertas flash
  final _flashOffersController = StreamController<bool>.broadcast();

  /// Stream que emite cambios en tiempo real
  Stream<bool> get flashOffersStream async* {
    // Emitir estado inicial
    final initial = await isFlashOffersEnabled();
    yield initial;

    // Escuchar cambios en tiempo real desde Supabase
    _supabase
        .channel('flash_offers_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'app_settings',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'key',
            value: 'flash_offers_enabled',
          ),
          callback: (payload) {
            final newValue = payload.newRecord['value'] as String?;
            final isEnabled = newValue == 'true';
            _flashOffersController.add(isEnabled);
          },
        )
        .subscribe();

    // Yield valores del controller
    yield* _flashOffersController.stream;
  }

  /// Obtiene el estado actual de las ofertas flash desde la BD
  Future<bool> isFlashOffersEnabled() async {
    try {
      final response = await _supabase
          .from('app_settings')
          .select('value')
          .eq('key', 'flash_offers_enabled')
          .maybeSingle();

      if (response == null) return false;
      return response['value'] == 'true';
    } catch (e) {
      print('Error checking flash offers status: $e');
      return false;
    }
  }

  /// Activa o desactiva las ofertas flash (solo admin)
  Future<bool> toggleFlashOffers(bool enabled) async {
    try {
      await _supabase.from('app_settings').upsert({
        'key': 'flash_offers_enabled',
        'value': enabled.toString(),
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'key');

      return true;
    } catch (e) {
      print('Error toggling flash offers: $e');
      return false;
    }
  }

  /// Limpia recursos
  void dispose() {
    _flashOffersController.close();
  }
}
