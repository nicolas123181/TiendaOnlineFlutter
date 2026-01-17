import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

// Features imports
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/products/presentation/screens/products_screen.dart';
import '../../features/products/presentation/screens/product_detail_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/checkout/presentation/screens/checkout_screen.dart';
import '../../features/checkout/presentation/screens/checkout_success_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/categories/presentation/screens/categories_screen.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/orders/presentation/screens/order_detail_screen.dart';
import '../../features/admin/presentation/screens/admin_screens.dart';

/// Provider del router
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final isAdmin = ref.watch(isAdminProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,

    // Manejo global de errores
    errorBuilder: (context, state) =>
        _ErrorScreen(error: state.error?.toString() ?? 'Página no encontrada'),

    // Redirecciones globales
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isGoingToAuth = state.matchedLocation.startsWith('/auth');
      final isGoingToAdmin = state.matchedLocation.startsWith('/admin');
      final isGoingToCheckout = state.matchedLocation.startsWith('/checkout');

      // Si va a admin y no está logueado o no es admin
      if (isGoingToAdmin) {
        if (!isLoggedIn) {
          return '/auth/login?redirect=${state.matchedLocation}';
        }
        if (!isAdmin) {
          return '/'; // No tiene permisos de admin
        }
      }

      // Si va a checkout y no está logueado
      if (isGoingToCheckout && !isLoggedIn) {
        return '/auth/login?redirect=/checkout';
      }

      // Si va a auth pero ya está logueado
      if (isGoingToAuth && isLoggedIn) {
        final redirect = state.uri.queryParameters['redirect'];
        return redirect ?? '/';
      }

      return null;
    },

    routes: [
      // ============================================
      // SHELL ROUTE - NAVEGACIÓN PRINCIPAL
      // ============================================
      ShellRoute(
        builder: (context, state, child) {
          return _MainShell(child: child);
        },
        routes: [
          // Home
          GoRoute(
            path: '/',
            name: 'home',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const HomeScreen(),
              transitionsBuilder: _fadeTransition,
            ),
          ),

          // Productos
          GoRoute(
            path: '/products',
            name: 'products',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const ProductsScreen(),
              transitionsBuilder: _fadeTransition,
            ),
          ),

          // Categorías
          GoRoute(
            path: '/categories',
            name: 'categories',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const CategoriesScreen(),
              transitionsBuilder: _fadeTransition,
            ),
          ),

          // Favoritos
          GoRoute(
            path: '/favorites',
            name: 'favorites',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const FavoritesScreen(),
              transitionsBuilder: _fadeTransition,
            ),
          ),

          // Perfil
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const ProfileScreen(),
              transitionsBuilder: _fadeTransition,
            ),
          ),
        ],
      ),

      // ============================================
      // RUTAS FUERA DEL SHELL
      // ============================================

      // Detalle de producto
      GoRoute(
        path: '/product/:slug',
        name: 'productDetail',
        pageBuilder: (context, state) {
          final slug = state.pathParameters['slug']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: ProductDetailScreen(slug: slug),
            transitionsBuilder: _slideTransition,
          );
        },
      ),

      // Categoría específica
      GoRoute(
        path: '/category/:slug',
        name: 'category',
        pageBuilder: (context, state) {
          final slug = state.pathParameters['slug']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: ProductsScreen(categorySlug: slug),
            transitionsBuilder: _slideTransition,
          );
        },
      ),

      // Carrito
      GoRoute(
        path: '/cart',
        name: 'cart',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const CartScreen(),
          transitionsBuilder: _slideFromBottomTransition,
        ),
      ),

      // Checkout
      GoRoute(
        path: '/checkout',
        name: 'checkout',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const CheckoutScreen(),
          transitionsBuilder: _slideTransition,
        ),
        routes: [
          GoRoute(
            path: 'success/:orderId',
            name: 'checkoutSuccess',
            builder: (context, state) {
              final orderId = int.parse(state.pathParameters['orderId']!);
              return CheckoutSuccessScreen(orderId: orderId);
            },
          ),
        ],
      ),

      // ============================================
      // AUTENTICACIÓN
      // ============================================
      GoRoute(
        path: '/auth',
        redirect: (context, state) => '/auth/login',
        routes: [
          GoRoute(
            path: 'login',
            name: 'login',
            pageBuilder: (context, state) {
              final redirect = state.uri.queryParameters['redirect'];
              return CustomTransitionPage(
                key: state.pageKey,
                child: LoginScreen(redirectTo: redirect),
                transitionsBuilder: _fadeTransition,
              );
            },
          ),
          GoRoute(
            path: 'register',
            name: 'register',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const RegisterScreen(),
              transitionsBuilder: _slideTransition,
            ),
          ),
          GoRoute(
            path: 'forgot-password',
            name: 'forgotPassword',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const ForgotPasswordScreen(),
              transitionsBuilder: _slideTransition,
            ),
          ),
        ],
      ),

      // ============================================
      // ADMIN PANEL
      // ============================================
      GoRoute(
        path: '/admin',
        name: 'adminDashboard',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AdminDashboardScreen(),
          transitionsBuilder: _fadeTransition,
        ),
        routes: [
          GoRoute(
            path: 'products',
            name: 'adminProducts',
            builder: (context, state) => const AdminProductsScreen(),
          ),
          GoRoute(
            path: 'orders',
            name: 'adminOrders',
            builder: (context, state) => const AdminOrdersScreen(),
          ),
          GoRoute(
            path: 'settings',
            name: 'adminSettings',
            builder: (context, state) => const AdminSettingsScreen(),
          ),
        ],
      ),

      // Pedidos del usuario
      GoRoute(
        path: '/orders',
        name: 'orders',
        builder: (context, state) => const OrdersScreen(),
        routes: [
          GoRoute(
            path: ':orderId',
            name: 'orderDetail',
            builder: (context, state) {
              final orderId = int.parse(state.pathParameters['orderId']!);
              return OrderDetailScreen(orderId: orderId);
            },
          ),
        ],
      ),
    ],
  );
});

// ============================================
// TRANSICIONES PERSONALIZADAS
// ============================================

Widget _fadeTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(opacity: animation, child: child);
}

Widget _slideTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
    child: child,
  );
}

Widget _slideFromBottomTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
    child: child,
  );
}

// ============================================
// SHELL PRINCIPAL
// ============================================

class _MainShell extends StatefulWidget {
  final Widget child;

  const _MainShell({required this.child});

  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell> {
  int _currentIndex = 0;

  static const _routes = [
    '/',
    '/products',
    '/categories',
    '/favorites',
    '/profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Inicio',
                  isSelected: _currentIndex == 0,
                  onTap: () => _onItemTapped(0),
                ),
                _NavItem(
                  icon: Icons.grid_view_outlined,
                  activeIcon: Icons.grid_view,
                  label: 'Tienda',
                  isSelected: _currentIndex == 1,
                  onTap: () => _onItemTapped(1),
                ),
                _NavItem(
                  icon: Icons.category_outlined,
                  activeIcon: Icons.category,
                  label: 'Categorías',
                  isSelected: _currentIndex == 2,
                  onTap: () => _onItemTapped(2),
                ),
                _NavItem(
                  icon: Icons.favorite_outline,
                  activeIcon: Icons.favorite,
                  label: 'Favoritos',
                  isSelected: _currentIndex == 3,
                  onTap: () => _onItemTapped(3),
                ),
                _NavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Perfil',
                  isSelected: _currentIndex == 4,
                  onTap: () => _onItemTapped(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
      context.go(_routes[index]);
    }
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================
// PANTALLA DE ERROR
// ============================================

class _ErrorScreen extends StatelessWidget {
  final String error;

  const _ErrorScreen({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                'Página no encontrada',
                style: AppTextStyles.h3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                error,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('VOLVER AL INICIO'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Clase helper para rutas tipadas
class AppRoutes {
  AppRoutes._();

  static String home() => '/';
  static String products({String? category, String? search}) {
    final params = <String>[];
    if (category != null) params.add('category=$category');
    if (search != null) params.add('search=$search');
    return params.isEmpty ? '/products' : '/products?${params.join('&')}';
  }

  static String productDetail(String slug) => '/product/$slug';
  static String category(String slug) => '/category/$slug';
  static String cart() => '/cart';
  static String checkout() => '/checkout';
  static String checkoutSuccess(int orderId) => '/checkout/success/$orderId';
  static String login({String? redirect}) =>
      redirect != null ? '/auth/login?redirect=$redirect' : '/auth/login';
  static String register() => '/auth/register';
  static String forgotPassword() => '/auth/forgot-password';
  static String profile() => '/profile';
  static String favorites() => '/favorites';
  static String orders() => '/orders';
  static String orderDetail(int orderId) => '/orders/$orderId';
  static String adminDashboard() => '/admin';
  static String adminProducts() => '/admin/products';
  static String adminOrders() => '/admin/orders';
  static String adminSettings() => '/admin/settings';
}
