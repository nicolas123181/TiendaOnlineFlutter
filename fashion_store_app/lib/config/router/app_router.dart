import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

// Features imports
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/products/presentation/screens/products_screen.dart';
import '../../features/products/presentation/screens/product_detail_screen.dart';
import '../../features/products/presentation/screens/size_guide_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/checkout/presentation/screens/checkout_success_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/favorites/presentation/screens/favorites_screen.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/orders/presentation/screens/order_detail_screen.dart';
import '../../features/orders/presentation/screens/invoice_screen.dart';
import '../../features/profile/presentation/screens/addresses_screen.dart';
import '../../features/admin/presentation/screens/admin_screens.dart';
import '../../features/admin/presentation/screens/admin_additional_screens.dart';
import '../../features/admin/presentation/screens/admin_specialized_screens.dart';
import '../../features/admin/presentation/screens/admin_product_form_screen.dart';
import '../../features/admin/presentation/screens/admin_improved_screens.dart';
import '../../features/admin/presentation/screens/admin_complete_screens.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/settings/presentation/screens/legal_screens.dart';
import '../../features/settings/presentation/screens/change_password_screen.dart';
import '../../features/products/presentation/screens/size_recommender_screen.dart';
import '../../features/returns/presentation/screens/return_screens.dart';

/// Provider del router
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final isAdmin = ref.watch(isAdminProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: kDebugMode,

    // Manejo global de errores
    errorBuilder: (context, state) =>
        _ErrorScreen(error: state.error?.toString() ?? 'Página no encontrada'),

    // Redirecciones globales
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isGoingToAuth = state.matchedLocation.startsWith('/auth');
      final isGoingToAdmin = state.matchedLocation.startsWith('/admin');

      // Si va a admin y no está logueado o no es admin
      if (isGoingToAdmin) {
        if (!isLoggedIn) {
          return '/auth/login?redirect=${state.matchedLocation}';
        }
        if (!isAdmin) {
          return '/'; // No tiene permisos de admin
        }
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const HomeScreen(),
                  transitionsBuilder: _fadeTransition,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/products',
                name: 'products',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const ProductsScreen(),
                  transitionsBuilder: _fadeTransition,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/favorites',
                name: 'favorites',
                pageBuilder: (context, state) => CustomTransitionPage(
                  key: state.pageKey,
                  child: const FavoritesScreen(),
                  transitionsBuilder: _fadeTransition,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
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
        ],
      ),

      // ============================================
      // RUTAS FUERA DEL SHELL
      // ============================================

      // Configuración
      GoRoute(
        path: '/settings',
        name: 'settings',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SettingsScreen(),
          transitionsBuilder: _slideTransition,
        ),
      ),

      // Cambiar contraseña
      GoRoute(
        path: '/change-password',
        name: 'changePassword',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ChangePasswordScreen(),
          transitionsBuilder: _slideTransition,
        ),
      ),

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

      // Guía de tallas
      GoRoute(
        path: '/size-guide',
        name: 'sizeGuide',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SizeGuideScreen(),
          transitionsBuilder: _slideTransition,
        ),
      ),

      // Categoría específica

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
          child: const CompleteCheckoutScreen(),
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
            routes: [
              GoRoute(
                path: 'new',
                name: 'adminProductNew',
                builder: (context, state) => const AdminProductFormScreen(),
              ),
              GoRoute(
                path: ':id/edit',
                name: 'adminProductEdit',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return AdminProductFormScreen(productId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: 'orders',
            name: 'adminOrders',
            builder: (context, state) => const AdminOrdersScreenImproved(),
          ),
          GoRoute(
            path: 'users',
            name: 'adminUsers',
            builder: (context, state) => const AdminUsersScreen(),
          ),
          GoRoute(
            path: 'coupons',
            name: 'adminCoupons',
            builder: (context, state) => const AdminCouponsScreen(),
          ),
          GoRoute(
            path: 'categories',
            name: 'adminCategories',
            builder: (context, state) => const AdminCategoriesScreenImproved(),
          ),
          GoRoute(
            path: 'sizes',
            name: 'adminSizes',
            builder: (context, state) => const AdminSizesScreen(),
          ),
          GoRoute(
            path: 'returns',
            name: 'adminReturns',
            builder: (context, state) => const AdminReturnsScreenComplete(),
          ),
          GoRoute(
            path: 'invoices',
            name: 'adminInvoices',
            builder: (context, state) => const AdminInvoicesScreenComplete(),
          ),
          GoRoute(
            path: 'newsletter',
            name: 'adminNewsletter',
            builder: (context, state) => const AdminNewsletterScreenComplete(),
          ),
          GoRoute(
            path: 'settings',
            name: 'adminSettings',
            builder: (context, state) => const AdminSettingsScreenComplete(),
          ),
          GoRoute(
            path: 'low-stock',
            name: 'adminLowStock',
            builder: (context, state) => const AdminLowStockAlertsScreen(),
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

      // Factura de pedido
      GoRoute(
        path: '/invoice/:orderId',
        name: 'invoice',
        builder: (context, state) {
          final orderId = int.parse(state.pathParameters['orderId']!);
          return InvoiceScreen(orderId: orderId);
        },
      ),

      // Solicitar devolución
      GoRoute(
        path: '/return/:orderId',
        name: 'createReturn',
        builder: (context, state) {
          final orderId = int.parse(state.pathParameters['orderId']!);
          return CreateReturnScreen(orderId: orderId);
        },
      ),

      // Direcciones del usuario
      GoRoute(
        path: '/addresses',
        name: 'addresses',
        builder: (context, state) => const AddressesScreen(),
      ),

      // ============================================
      // PÁGINAS LEGALES E INFORMATIVAS
      // ============================================
      GoRoute(
        path: '/about',
        name: 'aboutUs',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AboutUsScreen(),
          transitionsBuilder: _slideTransition,
        ),
      ),
      GoRoute(
        path: '/shipping-returns',
        name: 'shippingReturns',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ShippingReturnsScreen(),
          transitionsBuilder: _slideTransition,
        ),
      ),
      GoRoute(
        path: '/privacy',
        name: 'privacyPolicy',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const PrivacyPolicyScreen(),
          transitionsBuilder: _slideTransition,
        ),
      ),
      GoRoute(
        path: '/terms',
        name: 'termsConditions',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const TermsConditionsScreen(),
          transitionsBuilder: _slideTransition,
        ),
      ),

      // Recomendador de tallas interactivo
      GoRoute(
        path: '/size-recommender',
        name: 'sizeRecommender',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SizeRecommenderScreen(),
          transitionsBuilder: _slideTransition,
        ),
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

class _MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _MainShell({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentIndex = navigationShell.currentIndex;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: colorScheme.onSurface.withValues(alpha: 0.08),
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
                  isSelected: currentIndex == 0,
                  onTap: () => _onItemTapped(context, 0),
                ),
                _NavItem(
                  icon: Icons.grid_view_outlined,
                  activeIcon: Icons.grid_view,
                  label: 'Tienda',
                  isSelected: currentIndex == 1,
                  onTap: () => _onItemTapped(context, 1),
                ),
                _NavItem(
                  icon: Icons.favorite_outline,
                  activeIcon: Icons.favorite,
                  label: 'Favoritos',
                  isSelected: currentIndex == 2,
                  onTap: () => _onItemTapped(context, 2),
                ),
                _NavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Perfil',
                  isSelected: currentIndex == 3,
                  onTap: () => _onItemTapped(context, 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    HapticFeedback.selectionClick();
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final labelStyle = (textTheme.labelSmall ?? const TextStyle(fontSize: 10))
        .copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected
              ? colorScheme.primary
              : colorScheme.onSurface.withValues(alpha: 0.6),
        );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.08 : 1.0,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.92,
                      end: 1.0,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: Icon(
                  isSelected ? activeIcon : icon,
                  key: ValueKey<bool>(isSelected),
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 24,
                ),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              style: labelStyle,
              child: Text(label),
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
