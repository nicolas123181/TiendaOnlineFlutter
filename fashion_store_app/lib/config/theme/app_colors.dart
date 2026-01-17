import 'package:flutter/material.dart';

/// Paleta de colores de VANTAGE - Minimalismo Sofisticado
class AppColors {
  AppColors._();

  // ============================================
  // COLORES PRIMARIOS
  // ============================================
  
  /// Negro principal - Para textos y elementos principales
  static const Color primary = Color(0xFF1A1A1A);
  
  /// Dorado/Champán - Acento de lujo
  static const Color accent = Color(0xFFD4AF37);
  
  /// Blanco hueso - Fondo principal
  static const Color background = Color(0xFFFAFAFA);
  
  /// Blanco puro - Para tarjetas y superficies
  static const Color surface = Color(0xFFFFFFFF);

  // ============================================
  // COLORES SECUNDARIOS
  // ============================================
  
  /// Gris oscuro - Textos secundarios
  static const Color textSecondary = Color(0xFF6B6B6B);
  
  /// Gris claro - Bordes y divisores
  static const Color border = Color(0xFFE8E8E8);
  
  /// Gris muy claro - Fondos secundarios
  static const Color backgroundSecondary = Color(0xFFF5F5F5);

  // ============================================
  // COLORES DE ESTADO
  // ============================================
  
  /// Verde éxito
  static const Color success = Color(0xFF2ECC71);
  
  /// Rojo error
  static const Color error = Color(0xFFE74C3C);
  
  /// Amarillo advertencia
  static const Color warning = Color(0xFFF39C12);
  
  /// Azul información
  static const Color info = Color(0xFF3498DB);

  // ============================================
  // COLORES ESPECIALES
  // ============================================
  
  /// Overlay oscuro para modales
  static const Color overlay = Color(0x80000000);
  
  /// Shimmer base
  static const Color shimmerBase = Color(0xFFE0E0E0);
  
  /// Shimmer highlight
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  
  /// Precio en oferta
  static const Color salePrice = Color(0xFFE74C3C);
  
  /// Precio original tachado
  static const Color originalPrice = Color(0xFF9B9B9B);

  // ============================================
  // GRADIENTES
  // ============================================
  
  /// Gradiente premium dorado
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFFF4E5B8), Color(0xFFD4AF37)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// Gradiente oscuro para overlays
  static const LinearGradient darkOverlay = LinearGradient(
    colors: [Colors.transparent, Color(0xCC000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ============================================
  // COLORES PARA MODO OSCURO
  // ============================================
  
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkBorder = Color(0xFF2C2C2C);
}
