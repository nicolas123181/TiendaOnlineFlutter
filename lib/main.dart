import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/app_colors.dart';
import 'config/app_theme.dart';
import 'config/environment.dart';
import 'core/services/storage_service.dart';

// Screens imports
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/auth/auth.dart';
import 'presentation/screens/home/home.dart';
import 'presentation/screens/products/products.dart';
import 'presentation/screens/cart/cart.dart';
import 'presentation/screens/orders/orders.dart';
import 'presentation/screens/profile/profile.dart';
import 'presentation/screens/wishlist/wishlist.dart';
import 'presentation/screens/returns/returns.dart';
import 'presentation/screens/invoices/invoices.dart';
import 'presentation/screens/admin/admin.dart';

// Providers
import 'presentation/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar orientación de pantalla
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Inicializar Supabase
  await Supabase.initialize(
    url: Environment.supabaseUrl,
    anonKey: Environment.supabaseAnonKey,
  );

  // Inicializar almacenamiento local
  await StorageService.instance.initialize();

  // Inicializar Stripe (no soportado en web)
  if (!kIsWeb) {
    Stripe.publishableKey = Environment.stripePublishableKey;
    await Stripe.instance.applySettings();
  }

  runApp(
    const ProviderScope(
      child: VantageApp(),
    ),
  );
}

/// Aplicación principal VANTAGE Fashion
class VantageApp extends ConsumerWidget {
  const VantageApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'VANTAGE Fashion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: _router,
    );
  }
}

// Configuración del router
final _router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    // Splash
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),

    // Auth routes
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      name: 'forgotPassword',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    // Main shell con navegación inferior
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        // Home
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),

        // Products
        GoRoute(
          path: '/products',
          name: 'products',
          builder: (context, state) {
            final category = state.uri.queryParameters['category'];
            final search = state.uri.queryParameters['search'];
            return ProductsScreen(category: category, searchQuery: search);
          },
        ),
        GoRoute(
          path: '/product/:id',
          name: 'productDetail',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return ProductDetailScreen(productId: id);
          },
        ),
        GoRoute(
          path: '/search',
          name: 'search',
          builder: (context, state) => const SearchScreen(),
        ),

        // Cart
        GoRoute(
          path: '/cart',
          name: 'cart',
          builder: (context, state) => const CartScreen(),
        ),

        // Wishlist
        GoRoute(
          path: '/wishlist',
          name: 'wishlist',
          builder: (context, state) => const WishlistScreen(),
        ),

        // Profile
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),

    // Checkout (fuera del shell)
    GoRoute(
      path: '/checkout',
      name: 'checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: '/order-confirmation/:orderId',
      name: 'orderConfirmation',
      builder: (context, state) {
        final orderId = state.pathParameters['orderId']!;
        return OrderConfirmationScreen(orderId: orderId);
      },
    ),

    // Orders
    GoRoute(
      path: '/orders',
      name: 'orders',
      builder: (context, state) => const OrdersScreen(),
    ),
    // Invoices
    GoRoute(
      path: '/invoices',
      name: 'invoices',
      builder: (context, state) => const InvoicesScreen(),
    ),
    GoRoute(
      path: '/invoice/:id',
      name: 'invoiceDetail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return InvoiceDetailScreen(invoiceId: id);
      },
    ),
    GoRoute(
      path: '/order/:id',
      name: 'orderDetail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return OrderDetailScreen(orderId: id);
      },
    ),

    // Profile screens
    GoRoute(
      path: '/edit-profile',
      name: 'editProfile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/addresses',
      name: 'addresses',
      builder: (context, state) => const AddressesScreen(),
    ),
    GoRoute(
      path: '/address/new',
      name: 'newAddress',
      builder: (context, state) => const AddressFormScreen(),
    ),
    GoRoute(
      path: '/address/:id',
      name: 'editAddress',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return AddressFormScreen(addressId: id);
      },
    ),
    GoRoute(
      path: '/change-password',
      name: 'changePassword',
      builder: (context, state) => const ChangePasswordScreen(),
    ),

    // Returns
    GoRoute(
      path: '/returns',
      name: 'returns',
      builder: (context, state) => const ReturnsScreen(),
    ),
    GoRoute(
      path: '/return/:id',
      name: 'returnDetail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ReturnDetailScreen(returnId: id);
      },
    ),
    GoRoute(
      path: '/new-return/:orderId',
      name: 'newReturn',
      builder: (context, state) {
        final orderId = state.pathParameters['orderId']!;
        return NewReturnScreen(orderId: orderId);
      },
    ),

    // Admin routes
    GoRoute(
      path: '/admin',
      name: 'adminDashboard',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: '/admin/products',
      name: 'adminProducts',
      builder: (context, state) => const AdminProductsScreen(),
    ),
    GoRoute(
      path: '/admin/product/new',
      name: 'adminNewProduct',
      builder: (context, state) => const AdminProductFormScreen(),
    ),
    GoRoute(
      path: '/admin/product/:id',
      name: 'adminEditProduct',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return AdminProductFormScreen(productId: id);
      },
    ),
    GoRoute(
      path: '/admin/orders',
      name: 'adminOrders',
      builder: (context, state) => const AdminOrdersScreen(),
    ),
    GoRoute(
      path: '/admin/order/:id',
      name: 'adminOrderDetail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return AdminOrderDetailScreen(orderId: id);
      },
    ),
    GoRoute(
      path: '/admin/returns',
      name: 'adminReturns',
      builder: (context, state) => const AdminReturnsScreen(),
    ),
    GoRoute(
      path: '/admin/coupons',
      name: 'adminCoupons',
      builder: (context, state) => const AdminCouponsScreen(),
    ),
    GoRoute(
      path: '/admin/categories',
      name: 'adminCategories',
      builder: (context, state) => const AdminCategoriesScreen(),
    ),
    GoRoute(
      path: '/admin/newsletter',
      name: 'adminNewsletter',
      builder: (context, state) => const AdminNewsletterScreen(),
    ),
    GoRoute(
      path: '/admin/shipping',
      name: 'adminShipping',
      builder: (context, state) => const AdminShippingScreen(),
    ),
    GoRoute(
      path: '/admin/settings',
      name: 'adminSettings',
      builder: (context, state) => const AdminSettingsScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Página no encontrada',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            state.uri.toString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandNavy,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text('Ir al inicio'),
          ),
        ],
      ),
    ),
  ),
  redirect: (context, state) async {
    final supabase = Supabase.instance.client;
    final isLoggedIn = supabase.auth.currentUser != null;
    final isAuthRoute = state.matchedLocation == '/login' ||
        state.matchedLocation == '/register' ||
        state.matchedLocation == '/forgot-password';
    final isSplash = state.matchedLocation == '/';
    final isAdminRoute = state.matchedLocation.startsWith('/admin');

    // Si está en splash, permitir
    if (isSplash) return null;

    // Si no está logueado y no está en ruta de auth, redirigir a login
    if (!isLoggedIn && !isAuthRoute) {
      return '/login';
    }

    // Si está logueado y está en ruta de auth, redirigir a home
    if (isLoggedIn && isAuthRoute) {
      return '/home';
    }

    // Validar acceso a rutas admin
    if (isAdminRoute && isLoggedIn) {
      try {
        await supabase
            .from('admin_users')
            .select('email')
            .eq('email', supabase.auth.currentUser!.email!)
            .single();

        // Si llegó aquí, está en la tabla admin_users, permitir acceso
        return null;
      } catch (e) {
        // Si hay error, no es admin - redirigir a home
        return '/home';
      }
    }

    return null;
  },
);
