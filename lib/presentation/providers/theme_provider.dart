import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/storage_service.dart';

/// Provider del servicio de almacenamiento
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService.instance;
});

/// Estado del tema
class ThemeState {
  final ThemeMode themeMode;
  final bool isLoading;

  ThemeState({
    this.themeMode = ThemeMode.system,
    this.isLoading = true,
  });

  bool get isDark {
    if (themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
    return themeMode == ThemeMode.dark;
  }

  ThemeState copyWith({
    ThemeMode? themeMode,
    bool? isLoading,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Notifier del tema
class ThemeNotifier extends StateNotifier<ThemeState> {
  final StorageService _storageService;

  ThemeNotifier(this._storageService) : super(ThemeState()) {
    _loadTheme();
  }

  /// Carga el tema guardado
  Future<void> _loadTheme() async {
    final mode = _storageService.getThemeMode();

    final themeMode = mode == null
        ? ThemeMode.system
        : (mode == 'dark' ? ThemeMode.dark : ThemeMode.light);

    state = state.copyWith(
      themeMode: themeMode,
      isLoading: false,
    );
  }

  /// Cambia el modo del tema
  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);

    // Guardar preferencia
    if (mode == ThemeMode.system) {
      // Eliminar la preferencia para usar el sistema
      await _storageService.saveTheme(
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark,
      );
    } else {
      await _storageService.saveTheme(mode == ThemeMode.dark);
    }
  }

  /// Alterna entre modo claro y oscuro
  Future<void> toggleTheme() async {
    final newMode = state.isDark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  /// Establece el tema claro
  Future<void> setLightTheme() async {
    await setThemeMode(ThemeMode.light);
  }

  /// Establece el tema oscuro
  Future<void> setDarkTheme() async {
    await setThemeMode(ThemeMode.dark);
  }

  /// Establece el tema del sistema
  Future<void> setSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }
}

/// Provider del notifier del tema
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return ThemeNotifier(storageService);
});

/// Provider del modo del tema
final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(themeProvider).themeMode;
});

/// Provider para verificar si el tema oscuro está activo
final isDarkModeProvider = Provider<bool>((ref) {
  return ref.watch(themeProvider).isDark;
});
