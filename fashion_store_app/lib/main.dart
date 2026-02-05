import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

import 'config/theme/app_theme.dart';
import 'config/router/app_router.dart';
import 'shared/services/supabase_service.dart';
import 'shared/services/local_storage_service.dart';
import 'shared/providers/theme_provider.dart';
import 'shared/utils/app_reload.dart';
import 'features/products/presentation/providers/products_provider.dart';
import 'features/categories/presentation/providers/categories_provider.dart';

/// Punto de entrada de la aplicación VANTAGE
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Cargar variables de entorno
    await dotenv.load(fileName: ".env");

    // Verificar que se cargaron las credenciales
    print('🔑 SUPABASE_URL: ${dotenv.env['PUBLIC_SUPABASE_URL']}');
    print(
      '🔑 SUPABASE_ANON_KEY: ${dotenv.env['PUBLIC_SUPABASE_ANON_KEY']?.substring(0, 20)}...',
    );

    if (dotenv.env['PUBLIC_SUPABASE_URL'] == null ||
        dotenv.env['PUBLIC_SUPABASE_ANON_KEY'] == null) {
      throw Exception('Faltan credenciales de Supabase en el archivo .env');
    }
  } catch (e) {
    print('❌ Error cargando .env: $e');
    rethrow;
  }

  // Configurar orientación
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Inicializar locales para fechas
  await initializeDateFormatting('es_ES', null);

  // Inicializar Supabase
  final supabaseService = SupabaseService();
  try {
    await supabaseService.initialize();
    print('✅ Supabase inicializado correctamente');
  } catch (e) {
    print('❌ Error inicializando Supabase: $e');
    rethrow;
  }

  // Inicializar almacenamiento local
  final localStorage = LocalStorageService();
  await localStorage.initialize();

  runApp(
    ProviderScope(
      overrides: [
        localStorageServiceProvider.overrideWithValue(localStorage),
        supabaseServiceProvider.overrideWithValue(supabaseService),
      ],
      child: const VantageApp(),
    ),
  );
}

/// Widget principal de la aplicación
class VantageApp extends ConsumerStatefulWidget {
  const VantageApp({super.key});

  @override
  ConsumerState<VantageApp> createState() => _VantageAppState();
}

class _VantageAppState extends ConsumerState<VantageApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _handlePendingCheckoutReload();
    }
  }

  Future<void> _handlePendingCheckoutReload() async {
    final storage = ref.read(localStorageServiceProvider);
    final shouldReload =
        storage.getBool(StorageKeys.pendingCheckoutReload) ?? false;
    if (!shouldReload) return;

    await storage.setBool(StorageKeys.pendingCheckoutReload, false);

    if (kIsWeb) {
      reloadApp();
      return;
    }

    ref.invalidate(productsProvider);
    ref.invalidate(featuredProductsProvider);
    ref.invalidate(saleProductsProvider);
    ref.invalidate(productBySlugProvider);
    ref.invalidate(productByIdProvider);
    ref.invalidate(categoriesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'VANTAGE',
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'vantage_app',

      // Tema
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // Router
      routerConfig: router,

      // Builder para aplicar estilos globales
      builder: (context, child) {
        // Limitar escala de texto para accesibilidad controlada
        final mediaQueryData = MediaQuery.of(context);
        final scale = mediaQueryData.textScaler.scale(1.0).clamp(0.8, 1.2);

        return MediaQuery(
          data: mediaQueryData.copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        );
      },
    );
  }
}
