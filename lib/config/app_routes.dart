// lib/config/app_routes.dart
// Constantes de rutas para VANTAGE Fashion App
// El router principal está configurado en main.dart

/// Rutas de la aplicación VANTAGE Fashion
///
/// Esta clase contiene todas las constantes de rutas utilizadas en la navegación.
/// El router principal (GoRouter) está configurado en lib/main.dart
class AppRoutes {
  AppRoutes._();

  // ============================================
  // RUTAS PRINCIPALES
  // ============================================

  /// Pantalla de splash/inicio
  static const String splash = '/';

  /// Pantalla principal/home
  static const String home = '/home';

  // ============================================
  // AUTENTICACIÓN
  // ============================================

  /// Iniciar sesión
  static const String login = '/login';

  /// Registro de usuario
  static const String register = '/register';

  /// Recuperar contraseña
  static const String forgotPassword = '/forgot-password';

  // ============================================
  // PRODUCTOS
  // ============================================

  /// Lista de productos
  static const String products = '/products';

  /// Detalle de producto (requiere :id)
  static const String productDetail = '/product/:id';

  /// Búsqueda de productos
  static const String search = '/search';

  // ============================================
  // CARRITO Y CHECKOUT
  // ============================================

  /// Carrito de compras
  static const String cart = '/cart';

  /// Proceso de checkout
  static const String checkout = '/checkout';

  /// Confirmación de pedido (requiere :orderId)
  static const String orderConfirmation = '/order-confirmation/:orderId';

  // ============================================
  // PEDIDOS
  // ============================================

  /// Lista de pedidos del usuario
  static const String orders = '/orders';

  /// Detalle de pedido (requiere :id)
  static const String orderDetail = '/order/:id';

  // ============================================
  // PERFIL
  // ============================================

  /// Perfil del usuario
  static const String profile = '/profile';

  /// Editar perfil
  static const String editProfile = '/profile/edit';

  /// Direcciones guardadas
  static const String addresses = '/profile/addresses';

  /// Agregar/editar dirección
  static const String addressForm = '/profile/addresses/form';

  /// Cambiar contraseña
  static const String changePassword = '/profile/change-password';

  // ============================================
  // WISHLIST
  // ============================================

  /// Lista de deseos
  static const String wishlist = '/wishlist';

  // ============================================
  // DEVOLUCIONES
  // ============================================

  /// Lista de devoluciones
  static const String returns = '/returns';

  /// Detalle de devolución (requiere :id)
  static const String returnDetail = '/return/:id';

  /// Crear nueva devolución (requiere :orderId)
  static const String newReturn = '/new-return/:orderId';

  // ============================================
  // ADMINISTRACIÓN
  // ============================================

  /// Dashboard de administración
  static const String adminDashboard = '/admin';

  /// Gestión de productos (admin)
  static const String adminProducts = '/admin/products';

  /// Formulario de producto (admin) - nuevo o editar
  static const String adminProductForm = '/admin/product-form';

  /// Gestión de pedidos (admin)
  static const String adminOrders = '/admin/orders';

  /// Detalle de pedido (admin)
  static const String adminOrderDetail = '/admin/order/:id';

  /// Gestión de devoluciones (admin)
  static const String adminReturns = '/admin/returns';

  /// Gestión de cupones (admin)
  static const String adminCoupons = '/admin/coupons';

  /// Gestión de categorías (admin)
  static const String adminCategories = '/admin/categories';

  /// Gestión de newsletter (admin)
  static const String adminNewsletter = '/admin/newsletter';

  /// Gestión de envíos (admin)
  static const String adminShipping = '/admin/shipping';

  /// Configuración de la tienda (admin)
  static const String adminSettings = '/admin/settings';

  // ============================================
  // MÉTODOS HELPER PARA RUTAS CON PARÁMETROS
  // ============================================

  /// Genera la ruta de detalle de producto
  static String productDetailPath(String id) => '/product/$id';

  /// Genera la ruta de detalle de pedido
  static String orderDetailPath(String id) => '/order/$id';

  /// Genera la ruta de confirmación de pedido
  static String orderConfirmationPath(String orderId) =>
      '/order-confirmation/$orderId';

  /// Genera la ruta de detalle de devolución
  static String returnDetailPath(String id) => '/return/$id';

  /// Genera la ruta para crear nueva devolución
  static String newReturnPath(String orderId) => '/new-return/$orderId';

  /// Genera la ruta de detalle de pedido (admin)
  static String adminOrderDetailPath(String id) => '/admin/order/$id';
}
