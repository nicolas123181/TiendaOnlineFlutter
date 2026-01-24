/// Constantes de la aplicación VANTAGE Fashion
class AppConstants {
  AppConstants._();

  // ============================================
  // INFORMACIÓN DE LA EMPRESA
  // ============================================

  static const String appName = 'VANTAGE';
  static const String appFullName = 'Vantage Fashion';
  static const String appTagline = 'Moda Masculina Premium';
  static const String companyName = 'Vantage Fashion S.L.';
  static const String companyNif = 'B-12345678';
  static const String companyAddress = 'Calle de la Moda 123, 28001 Madrid';
  static const String companyEmail = 'contacto@vantage.com';
  static const String companyPhone = '+34 900 123 456';
  static const String websiteUrl = 'https://vantage.com';

  // ============================================
  // CONFIGURACIÓN DE PRECIOS
  // ============================================

  /// Porcentaje de IVA (21% en España)
  static const double vatRate = 21.0;

  /// Monto mínimo para envío gratis (en centavos)
  static const int freeShippingThreshold = 5000; // 50€

  /// Coste estándar de envío (en centavos)
  static const int standardShippingCost = 499; // 4.99€

  /// Tasa de impuesto (IVA 21%)
  static const double taxRate = 0.21;

  /// Moneda por defecto
  static const String defaultCurrency = 'EUR';

  /// Símbolo de moneda
  static const String currencySymbol = '€';

  // ============================================
  // TALLAS DISPONIBLES
  // ============================================

  static const List<String> availableSizes = [
    'XS',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
    'XXXL',
  ];

  /// Tallas numéricas para pantalones
  static const List<String> pantsSizes = [
    '28',
    '30',
    '32',
    '34',
    '36',
    '38',
    '40',
    '42',
    '44',
  ];

  /// Tallas de calzado
  static const List<String> shoeSizes = [
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
  ];

  // ============================================
  // ESTADOS DE PEDIDO
  // ============================================

  static const Map<String, String> orderStatuses = {
    'pending': 'Pendiente',
    'paid': 'Pagado',
    'ready_for_pickup': 'Listo para recoger',
    'shipped': 'Enviado',
    'delivered': 'Entregado',
    'cancelled': 'Cancelado',
  };

  // ============================================
  // ESTADOS DE DEVOLUCIÓN
  // ============================================

  static const Map<String, String> returnStatuses = {
    'pending': 'Pendiente',
    'in_transit': 'En tránsito',
    'received': 'Recibido',
    'refunded': 'Reembolsado',
    'rejected': 'Rechazado',
  };

  // ============================================
  // MOTIVOS DE DEVOLUCIÓN
  // ============================================

  static const Map<String, String> returnReasons = {
    'wrong_size': 'Talla incorrecta',
    'not_as_expected': 'No es como esperaba',
    'defective': 'Producto defectuoso',
    'wrong_item': 'Producto incorrecto',
    'changed_mind': 'He cambiado de opinión',
    'arrived_late': 'Llegó tarde',
    'other': 'Otro motivo',
  };

  // ============================================
  // CONFIGURACIÓN DE PAGINACIÓN
  // ============================================

  static const int productsPerPage = 20;
  static const int ordersPerPage = 10;
  static const int invoicesPerPage = 10;

  // ============================================
  // CONFIGURACIÓN DE CACHÉ
  // ============================================

  /// Tiempo de caché para productos (en minutos)
  static const int productsCacheMinutes = 5;

  /// Máximo de productos en caché
  static const int maxCachedProducts = 100;

  /// Máximo de productos vistos recientemente
  static const int maxRecentlyViewed = 10;

  // ============================================
  // CONFIGURACIÓN DE IMÁGENES
  // ============================================

  static const String placeholderImage = 'assets/images/placeholder.svg';
  static const String logoImage = 'assets/images/logo.svg';

  /// Aspect ratio de imágenes de producto
  static const double productImageAspectRatio = 3 / 4;

  /// Calidad de compresión de imágenes
  static const int imageCompressionQuality = 85;

  // ============================================
  // CONFIGURACIÓN DE ANIMACIONES
  // ============================================

  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 350);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // ============================================
  // LÍMITES Y VALIDACIONES
  // ============================================

  /// Mínimo de caracteres para contraseña
  static const int minPasswordLength = 8;

  /// Máximo de items en carrito
  static const int maxCartItems = 99;

  /// Máximo de direcciones guardadas
  static const int maxSavedAddresses = 5;

  /// Máximo de productos en wishlist
  static const int maxWishlistItems = 50;

  // ============================================
  // CONFIGURACIÓN DE STOCK
  // ============================================

  /// Umbral de stock bajo
  static const int lowStockThreshold = 5;

  /// Umbral de stock crítico
  static const int criticalStockThreshold = 2;

  // ============================================
  // PREFIJOS Y FORMATOS
  // ============================================

  /// Prefijo para número de factura
  static const String invoicePrefix = 'INV';

  /// Prefijo para número de devolución
  static const String returnPrefix = 'RET';

  /// Formato de fecha para mostrar
  static const String displayDateFormat = 'dd/MM/yyyy';

  /// Formato de fecha y hora para mostrar
  static const String displayDateTimeFormat = 'dd/MM/yyyy HH:mm';

  // ============================================
  // KEYS PARA STORAGE
  // ============================================

  static const String cartStorageKey = 'vantage_cart';
  static const String themeStorageKey = 'vantage_theme_mode';
  static const String recentSearchesKey = 'vantage_recent_searches';
  static const String recentlyViewedKey = 'vantage_recently_viewed';
  static const String onboardingCompleteKey = 'vantage_onboarding_complete';
}
