import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'config/theme/app_theme.dart';
import 'config/router/app_router.dart';
import 'shared/services/supabase_service.dart';
import 'shared/services/local_storage_service.dart';

/// Punto de entrada de la aplicación VANTAGE
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar orientación
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Inicializar locales para fechas
  await initializeDateFormatting('es_ES', null);

  // Inicializar Supabase
  final supabaseService = SupabaseService();
  await supabaseService.initialize();

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
class VantageApp extends ConsumerWidget {
  const VantageApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'VANTAGE',
      debugShowCheckedModeBanner: false,

      // Tema
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

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
