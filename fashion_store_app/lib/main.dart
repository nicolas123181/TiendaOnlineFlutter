import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

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
  bool _showBrandSplash = true;
  double _brandSplashOpacity = 1;
  bool _brandSplashContentVisible = false;
  Timer? _brandSplashFadeOutTimer;
  Timer? _brandSplashHideTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playBrandSplash();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _brandSplashFadeOutTimer?.cancel();
    _brandSplashHideTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _handlePendingCheckoutReload();
    }
  }

  void _playBrandSplash() {
    _brandSplashFadeOutTimer?.cancel();
    _brandSplashHideTimer?.cancel();

    if (!mounted) return;

    setState(() {
      _showBrandSplash = true;
      _brandSplashOpacity = 1;
      _brandSplashContentVisible = false;
    });

    // Entrada visible del contenido
    Timer(const Duration(milliseconds: 50), () {
      if (!mounted) return;
      setState(() => _brandSplashContentVisible = true);
    });

    // Salida con fade del overlay
    _brandSplashFadeOutTimer = Timer(const Duration(milliseconds: 2600), () {
      if (!mounted) return;
      setState(() => _brandSplashOpacity = 0);
    });

    _brandSplashHideTimer = Timer(const Duration(milliseconds: 3650), () {
      if (!mounted) return;
      setState(() => _showBrandSplash = false);
    });
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
          child: Stack(
            children: [
              child!,
              if (_showBrandSplash)
                AnimatedOpacity(
                  opacity: _brandSplashOpacity,
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutCubic,
                  child: _BrandLaunchOverlay(
                    contentVisible: _brandSplashContentVisible,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _BrandLaunchOverlay extends StatelessWidget {
  final bool contentVisible;

  const _BrandLaunchOverlay({required this.contentVisible});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutCubic,
          opacity: contentVisible ? 1 : 0,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            offset: contentVisible ? Offset.zero : const Offset(0, 0.08),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              scale: contentVisible ? 1 : 0.93,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/branding/vantage-logo.jpg',
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 42),
                  Text(
                    'VANTAGE',
                    style: GoogleFonts.playfairDisplay(
                      textStyle: textTheme.headlineMedium,
                      fontSize: 44,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 5.2,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'since 2024',
                    style: GoogleFonts.cormorantGaramond(
                      textStyle: textTheme.bodyMedium,
                      fontSize: 24,
                      letterSpacing: 2.4,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Elegancia Atemporal',
                    style: GoogleFonts.cormorantGaramond(
                      textStyle: textTheme.titleMedium,
                      fontSize: 28,
                      letterSpacing: 1.7,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: colorScheme.onSurface.withValues(alpha: 0.92),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
