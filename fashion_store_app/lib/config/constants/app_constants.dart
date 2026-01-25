import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Constantes de la aplicación VANTAGE
class AppConstants {
  AppConstants._();

  // ============================================
  // APP INFO
  // ============================================
  static const String appName = 'VANTAGE';
  static const String appTagline = 'Moda Masculina Premium';
  static const String appVersion = '1.0.0';

  // ============================================
  // SUPABASE
  // ============================================
  static String get supabaseUrl =>
      dotenv.env['PUBLIC_SUPABASE_URL'] ?? 'https://your-project.supabase.co';

  static String get supabaseAnonKey =>
      dotenv.env['PUBLIC_SUPABASE_ANON_KEY'] ?? 'your-anon-key';

  // ============================================
  // STORAGE BUCKETS
  // ============================================
  static const String productImagesBucket = 'products-images';
  static const String categoryImagesBucket = 'category-images';

  // ============================================
  // PAGINACIÓN
  // ============================================
  static const int productsPerPage = 20;
  static const int ordersPerPage = 15;

  // ============================================
  // CACHE
  // ============================================
  static const Duration cacheDuration = Duration(minutes: 5);
  static const Duration sessionDuration = Duration(days: 7);

  // ============================================
  // VALIDACIONES
  // ============================================
  static const int minPasswordLength = 6;
  static const int maxProductImages = 5;
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5MB
  static const int compressedImageQuality = 80;
  static const int compressedImageMaxWidth = 1200;
  static const int compressedImageMaxHeight = 1200;

  // ============================================
  // ANIMACIONES
  // ============================================
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // ============================================
  // ENVÍO
  // ============================================
  static const int freeShippingThreshold = 10000; // 100€ en céntimos
  static const int standardShippingCost = 500; // 5€ en céntimos

  // ============================================
  // TALLAS DISPONIBLES
  // ============================================
  static const List<String> availableSizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  // ============================================
  // ESTADOS DE PEDIDO
  // ============================================
  static const Map<String, String> orderStatuses = {
    'pending': 'Pendiente',
    'paid': 'Pagado',
    'ready_for_pickup': 'Listo para envío',
    'shipped': 'Enviado',
    'delivered': 'Entregado',
    'cancelled': 'Cancelado',
  };

  // ============================================
  // ROLES DE USUARIO
  // ============================================
  static const String roleAdmin = 'admin';
  static const String roleCustomer = 'customer';
}
