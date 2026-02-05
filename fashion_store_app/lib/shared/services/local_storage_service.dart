import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio de almacenamiento local
class LocalStorageService {
  late SharedPreferences _prefs;

  /// Inicializar SharedPreferences
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ============================================
  // STRINGS
  // ============================================

  Future<bool> setString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  // ============================================
  // INTEGERS
  // ============================================

  Future<bool> setInt(String key, int value) async {
    return _prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // ============================================
  // BOOLEANS
  // ============================================

  Future<bool> setBool(String key, bool value) async {
    return _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  // ============================================
  // DOUBLES
  // ============================================

  Future<bool> setDouble(String key, double value) async {
    return _prefs.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  // ============================================
  // STRING LISTS
  // ============================================

  Future<bool> setStringList(String key, List<String> value) async {
    return _prefs.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  // ============================================
  // JSON OBJECTS
  // ============================================

  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    return _prefs.setString(key, jsonEncode(value));
  }

  Map<String, dynamic>? getJson(String key) {
    final string = _prefs.getString(key);
    if (string == null) return null;
    try {
      return jsonDecode(string) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  // ============================================
  // JSON LISTS
  // ============================================

  Future<bool> setJsonList(String key, List<Map<String, dynamic>> value) async {
    return _prefs.setString(key, jsonEncode(value));
  }

  List<Map<String, dynamic>>? getJsonList(String key) {
    final string = _prefs.getString(key);
    if (string == null) return null;
    try {
      final list = jsonDecode(string) as List;
      return list.map((e) => e as Map<String, dynamic>).toList();
    } catch (_) {
      return null;
    }
  }

  // ============================================
  // UTILIDADES
  // ============================================

  /// Eliminar una clave
  Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  /// Limpiar todo el storage
  Future<bool> clear() async {
    return _prefs.clear();
  }

  /// Verificar si existe una clave
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  /// Obtener todas las claves
  Set<String> getKeys() {
    return _prefs.getKeys();
  }
}

/// Claves de almacenamiento local
class StorageKeys {
  StorageKeys._();

  static const String cart = 'vantage_cart';
  static const String favorites = 'vantage_favorites';
  static const String recentSearches = 'vantage_recent_searches';
  static const String userPreferences = 'vantage_preferences';
  static const String onboardingCompleted = 'vantage_onboarding';
  static const String lastSyncTime = 'vantage_last_sync';
  static const String themeMode = 'vantage_theme_mode';
  static const String pendingCheckoutReload = 'vantage_pending_checkout_reload';
}

/// Provider del servicio de almacenamiento local
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});
