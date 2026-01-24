// lib/config/environment.dart
// Configuración de entorno para VANTAGE Fashion App
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Clase de configuración de entorno
/// Contiene todas las credenciales y URLs de servicios externos
class Environment {
  Environment._();

  // ==================== SUPABASE ====================
  /// URL del proyecto Supabase
  static const String supabaseUrl = 'https://djzetbvdkdundjyvlgac.supabase.co';

  /// Clave anónima de Supabase (para operaciones del lado del cliente)
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRqemV0YnZka2R1bmRqeXZsZ2FjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc4NjUwNzUsImV4cCI6MjA4MzQ0MTA3NX0.mRfUmw7YZeUpTggclG7iZdECeejWOrh5D-AGFpcxSlg';

  // ==================== STRIPE ====================
  /// Clave pública de Stripe (modo test)
  static const String stripePublishableKey =
      'pk_test_51QizHdIPzTByQPGmEVRzSU3rUIxBqI4SB2FqfKKrPE1eFzqSjyJH2EqbbL4R4d5oRjOT2hL1qvZKXL1Wxt0lsNMU00q0WxTHlM';

  /// Clave secreta de Stripe (modo test) - NO usar en cliente de forma directa si es posible.
  /// Se carga desde variables de entorno.
  static String get stripeSecretKey => dotenv.env['STRIPE_SECRET_KEY'] ?? '';

  // ==================== CONFIGURACIÓN DE APP ====================
  /// Nombre de la aplicación
  static const String appName = 'VANTAGE Fashion';

  /// Versión de la aplicación
  static const String appVersion = '1.0.0';

  /// Modo de desarrollo
  static const bool isDevelopment = true;

  /// URL base de la API (si se necesita backend adicional)
  static const String apiBaseUrl = 'https://api.vantagefashion.com';

  // ==================== STORAGE ====================
  /// Nombre del bucket de imágenes de productos
  static const String productImagesBucket = 'product-images';

  /// Nombre del bucket de avatares de usuarios
  static const String userAvatarsBucket = 'user-avatars';

  /// Nombre del bucket de facturas
  static const String invoicesBucket = 'invoices';

  // ==================== CONFIGURACIÓN DE PAGOS ====================
  /// Moneda por defecto
  static const String defaultCurrency = 'EUR';

  /// Símbolo de moneda
  static const String currencySymbol = '€';

  /// Locale para formateo
  static const String locale = 'es_ES';

  // ==================== TIEMPOS DE ESPERA ====================
  /// Timeout para peticiones HTTP (segundos)
  static const int httpTimeout = 30;

  /// Duración del splash screen (milisegundos)
  static const int splashDuration = 2000;

  // ==================== LÍMITES ====================
  /// Máximo de productos por página
  static const int productsPerPage = 20;

  /// Máximo de órdenes por página
  static const int ordersPerPage = 10;

  /// Máximo de imágenes por producto
  static const int maxProductImages = 10;

  /// Tamaño máximo de imagen (bytes) - 5MB
  static const int maxImageSize = 5 * 1024 * 1024;

  // ==================== NOTIFICACIONES ====================
  /// ID del canal de notificaciones Android
  static const String notificationChannelId = 'vantage_notifications';

  /// Nombre del canal de notificaciones
  static const String notificationChannelName = 'VANTAGE Notifications';

  // ==================== MÉTODOS HELPER ====================
  /// Obtiene la URL completa de una imagen de producto
  static String getProductImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) return imagePath;
    return '$supabaseUrl/storage/v1/object/public/$productImagesBucket/$imagePath';
  }

  /// Obtiene la URL completa de un avatar de usuario
  static String getUserAvatarUrl(String avatarPath) {
    if (avatarPath.startsWith('http')) return avatarPath;
    return '$supabaseUrl/storage/v1/object/public/$userAvatarsBucket/$avatarPath';
  }

  /// Verifica si estamos en modo producción
  static bool get isProduction => !isDevelopment;
}
