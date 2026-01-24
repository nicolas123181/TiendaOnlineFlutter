import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/models/cart_item.dart';
import '../../config/app_constants.dart';

/// Servicio de almacenamiento local
/// Maneja persistencia de datos en SharedPreferences y FlutterSecureStorage
class StorageService {
  StorageService._();

  static final StorageService _instance = StorageService._();
  static StorageService get instance => _instance;

  late SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  /// Inicializa el servicio
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ============================================
  // CARRITO
  // ============================================

  /// Guarda el carrito
  Future<void> saveCart(Cart cart) async {
    final json = jsonEncode(cart.toJson());
    await _prefs.setString(AppConstants.cartStorageKey, json);
  }

  /// Obtiene el carrito guardado
  Cart getCart() {
    final json = _prefs.getString(AppConstants.cartStorageKey);
    if (json == null) return Cart.empty;

    try {
      final data = jsonDecode(json) as Map<String, dynamic>;
      return Cart.fromJson(data);
    } catch (e) {
      return Cart.empty;
    }
  }

  /// Limpia el carrito
  Future<void> clearCart() async {
    await _prefs.remove(AppConstants.cartStorageKey);
  }

  // ============================================
  // TEMA
  // ============================================

  /// Guarda la preferencia de tema
  Future<void> saveThemeMode(String mode) async {
    await _prefs.setString(AppConstants.themeStorageKey, mode);
  }

  /// Obtiene la preferencia de tema
  String? getThemeMode() {
    return _prefs.getString(AppConstants.themeStorageKey);
  }

  /// Verifica si el modo oscuro está activo
  bool isDarkMode() {
    final mode = getThemeMode();
    return mode == 'dark';
  }

  /// Guarda la preferencia de tema (true = dark, false = light)
  Future<void> saveTheme(bool isDark) async {
    await saveThemeMode(isDark ? 'dark' : 'light');
  }

  // ============================================
  // BÚSQUEDAS RECIENTES
  // ============================================

  /// Guarda una búsqueda reciente
  Future<void> addRecentSearch(String query) async {
    final searches = getRecentSearches();

    // Eliminar si ya existe
    searches.remove(query);

    // Agregar al principio
    searches.insert(0, query);

    // Mantener máximo 10 búsquedas
    if (searches.length > 10) {
      searches.removeLast();
    }

    await _prefs.setStringList(AppConstants.recentSearchesKey, searches);
  }

  /// Obtiene las búsquedas recientes
  List<String> getRecentSearches() {
    return _prefs.getStringList(AppConstants.recentSearchesKey) ?? [];
  }

  /// Elimina una búsqueda reciente
  Future<void> removeRecentSearch(String query) async {
    final searches = getRecentSearches();
    searches.remove(query);
    await _prefs.setStringList(AppConstants.recentSearchesKey, searches);
  }

  /// Limpia todas las búsquedas recientes
  Future<void> clearRecentSearches() async {
    await _prefs.remove(AppConstants.recentSearchesKey);
  }

  // ============================================
  // PRODUCTOS VISTOS RECIENTEMENTE
  // ============================================

  /// Guarda un producto visto
  Future<void> addRecentlyViewed(int productId) async {
    final viewed = getRecentlyViewed();

    // Eliminar si ya existe
    viewed.remove(productId);

    // Agregar al principio
    viewed.insert(0, productId);

    // Mantener máximo definido en constantes
    if (viewed.length > AppConstants.maxRecentlyViewed) {
      viewed.removeLast();
    }

    await _prefs.setStringList(
      AppConstants.recentlyViewedKey,
      viewed.map((e) => e.toString()).toList(),
    );
  }

  /// Obtiene los productos vistos recientemente
  List<int> getRecentlyViewed() {
    final list = _prefs.getStringList(AppConstants.recentlyViewedKey) ?? [];
    return list.map((e) => int.parse(e)).toList();
  }

  /// Limpia los productos vistos recientemente
  Future<void> clearRecentlyViewed() async {
    await _prefs.remove(AppConstants.recentlyViewedKey);
  }

  // ============================================
  // ONBOARDING
  // ============================================

  /// Marca el onboarding como completado
  Future<void> setOnboardingComplete() async {
    await _prefs.setBool(AppConstants.onboardingCompleteKey, true);
  }

  /// Verifica si el onboarding está completado
  bool isOnboardingComplete() {
    return _prefs.getBool(AppConstants.onboardingCompleteKey) ?? false;
  }

  // ============================================
  // ALMACENAMIENTO SEGURO
  // ============================================

  /// Guarda un valor de forma segura
  Future<void> setSecure(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  /// Obtiene un valor seguro
  Future<String?> getSecure(String key) async {
    return await _secureStorage.read(key: key);
  }

  /// Elimina un valor seguro
  Future<void> deleteSecure(String key) async {
    await _secureStorage.delete(key: key);
  }

  /// Elimina todos los valores seguros
  Future<void> deleteAllSecure() async {
    await _secureStorage.deleteAll();
  }

  // ============================================
  // GENÉRICOS
  // ============================================

  /// Guarda un valor string
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  /// Obtiene un valor string
  String? getString(String key) {
    return _prefs.getString(key);
  }

  /// Guarda un valor int
  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  /// Obtiene un valor int
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  /// Guarda un valor bool
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  /// Obtiene un valor bool
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  /// Elimina un valor
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  /// Limpia todo el almacenamiento
  Future<void> clear() async {
    await _prefs.clear();
    await _secureStorage.deleteAll();
  }
}
