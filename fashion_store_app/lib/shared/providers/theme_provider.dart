import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/local_storage_service.dart';

/// Provider para el modo de tema
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(() {
  return ThemeModeNotifier();
});

/// Notifier para manejar el cambio de tema
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.light;
  }
  
  LocalStorageService get _localStorage => ref.read(localStorageServiceProvider);
  
  void _loadTheme() {
    final savedTheme = _localStorage.getString(StorageKeys.themeMode);
    if (savedTheme != null) {
      state = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    }
  }
  
  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _localStorage.setString(
      StorageKeys.themeMode, 
      state == ThemeMode.dark ? 'dark' : 'light',
    );
  }
  
  void setTheme(ThemeMode mode) {
    state = mode;
    _localStorage.setString(
      StorageKeys.themeMode, 
      mode == ThemeMode.dark ? 'dark' : 'light',
    );
  }
  
  bool get isDarkMode => state == ThemeMode.dark;
}
