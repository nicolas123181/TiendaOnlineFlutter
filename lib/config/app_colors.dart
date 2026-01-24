import 'package:flutter/material.dart';

/// Paleta de colores oficial de VANTAGE Fashion
/// Colores premium para moda masculina elegante
class AppColors {
  AppColors._();

  // ============================================
  // COLORES PRINCIPALES DE MARCA
  // ============================================

  /// Azul marino principal - Color corporativo
  static const Color brandNavy = Color(0xFF1A2744);

  /// Azul marino claro - Variante secundaria
  static const Color brandNavyLight = Color(0xFF2D3F5F);

  /// Gris carbón - Textos y acentos
  static const Color brandCharcoal = Color(0xFF36454F);

  /// Dorado - Acentos premium y precios de oferta
  static const Color brandGold = Color(0xFFB8860B);

  /// Ámbar - Variante del dorado para gradientes
  static const Color brandAmber = Color(0xFFD97706);

  /// Crema - Fondos sutiles
  static const Color brandCream = Color(0xFFFAF8F5);

  /// Marrón cuero - Acentos cálidos
  static const Color brandLeather = Color(0xFF8B4513);

  // ============================================
  // COLORES DE SUPERFICIE
  // ============================================

  /// Superficie principal - Blanco puro
  static const Color surfacePrimary = Color(0xFFFFFFFF);

  /// Superficie secundaria - Gris muy claro
  static const Color surfaceSecondary = Color(0xFFF9FAFB);

  /// Superficie terciaria - Gris claro
  static const Color surfaceTertiary = Color(0xFFF3F4F6);

  // ============================================
  // COLORES DE TEXTO
  // ============================================

  /// Texto principal - Negro casi puro
  static const Color textPrimary = Color(0xFF111827);

  /// Texto secundario - Gris oscuro
  static const Color textSecondary = Color(0xFF4B5563);

  /// Texto atenuado - Gris medio
  static const Color textMuted = Color(0xFF9CA3AF);

  /// Texto inverso - Blanco para fondos oscuros
  static const Color textInverse = Color(0xFFFFFFFF);

  // ============================================
  // COLORES DE ESTADO
  // ============================================

  /// Éxito - Verde esmeralda
  static const Color success = Color(0xFF059669);
  static const Color successLight = Color(0xFFD1FAE5);

  /// Error - Rojo
  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEE2E2);

  /// Advertencia - Ámbar
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);

  /// Información - Azul
  static const Color info = Color(0xFF0284C7);
  static const Color infoLight = Color(0xFFE0F2FE);

  // ============================================
  // COLORES DE BORDE
  // ============================================

  /// Borde claro
  static const Color borderLight = Color(0xFFE5E7EB);

  /// Borde medio
  static const Color borderMedium = Color(0xFFD1D5DB);

  /// Borde oscuro
  static const Color borderDark = Color(0xFF9CA3AF);

  // ============================================
  // COLORES PARA DARK MODE - MEJORADO
  // ============================================

  /// Fondo oscuro principal - Azul muy oscuro
  static const Color darkBackground = Color(0xFF0D1421);

  /// Superficie oscura - Cards y elementos elevados
  static const Color darkSurface = Color(0xFF1A2332);

  /// Superficie oscura elevada - Modales y dropdowns
  static const Color darkSurfaceElevated = Color(0xFF253043);

  /// Texto en modo oscuro - Blanco con alta luminosidad
  static const Color darkTextPrimary = Color(0xFFF8FAFC);

  /// Texto secundario en modo oscuro - Gris claro legible
  static const Color darkTextSecondary = Color(0xFFB8C5D6);

  /// Texto terciario en modo oscuro
  static const Color darkTextTertiary = Color(0xFF8899AA);

  /// Borde en modo oscuro - Visible pero sutil
  static const Color darkBorder = Color(0xFF3D4F66);

  /// Borde claro en modo oscuro
  static const Color darkBorderLight = Color(0xFF2D3D52);

  /// Color de acento en modo oscuro (gold más brillante)
  static const Color darkAccent = Color(0xFFD4A942);

  // ============================================
  // GRADIENTES
  // ============================================

  /// Gradiente principal de marca
  static const LinearGradient brandGradient = LinearGradient(
    colors: [brandNavy, brandNavyLight, brandCharcoal],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gradiente dorado para elementos premium
  static const LinearGradient goldGradient = LinearGradient(
    colors: [brandGold, brandAmber],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gradiente para el fondo del splash
  static const LinearGradient splashGradient = LinearGradient(
    colors: [brandNavy, Color(0xFF0F1729)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Alias de gradiente primario para botones
  static const List<Color> primaryGradient = [brandNavy, brandNavyLight];

  // ============================================
  // COLORES PARA ESTADOS DE PEDIDOS
  // ============================================

  /// Pendiente - Amarillo
  static const Color orderPending = Color(0xFFF59E0B);

  /// Pagado - Verde
  static const Color orderPaid = Color(0xFF10B981);

  /// Listo para recoger - Azul
  static const Color orderReadyForPickup = Color(0xFF3B82F6);

  /// Enviado - Púrpura
  static const Color orderShipped = Color(0xFF8B5CF6);

  /// Entregado - Verde esmeralda
  static const Color orderDelivered = Color(0xFF059669);

  /// Cancelado - Rojo
  static const Color orderCancelled = Color(0xFFEF4444);

  // ============================================
  // MÉTODOS AUXILIARES
  // ============================================

  /// Obtiene el color según el estado del pedido
  static Color getOrderStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return orderPending;
      case 'paid':
        return orderPaid;
      case 'ready_for_pickup':
        return orderReadyForPickup;
      case 'shipped':
        return orderShipped;
      case 'delivered':
        return orderDelivered;
      case 'cancelled':
        return orderCancelled;
      default:
        return textMuted;
    }
  }

  /// Obtiene el color según el estado de la devolución
  static Color getReturnStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return orderPending;
      case 'in_transit':
        return info;
      case 'received':
        return orderReadyForPickup;
      case 'refunded':
        return success;
      case 'rejected':
        return error;
      default:
        return textMuted;
    }
  }

  // ============================================
  // ALIAS PARA COMPATIBILIDAD
  // ============================================

  /// Alias para superficie (surfacePrimary)
  static const Color surface = surfacePrimary;

  /// Alias para fondo (surfaceSecondary)
  static const Color background = surfaceSecondary;

  /// Alias para borde (borderLight)
  static const Color border = borderLight;

  /// Alias para texto terciario (textMuted)
  static const Color textTertiary = textMuted;

  /// Superficie clara - Para fondos de cards
  static const Color surfaceLight = surfaceSecondary;

  /// Superficie media - Para fondos alternativos
  static const Color surfaceMedium = surfaceTertiary;

  /// Superficie oscura - Para elementos elevados
  static const Color surfaceDark = brandNavy;
}
