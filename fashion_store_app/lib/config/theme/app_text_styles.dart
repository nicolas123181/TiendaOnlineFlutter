import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Estilos de texto de VANTAGE
/// Fuentes: Playfair Display (títulos) + Lato (cuerpo)
class AppTextStyles {
  AppTextStyles._();

  // ============================================
  // HEADINGS - Playfair Display
  // ============================================

  /// H1 - 32px, Bold
  static TextStyle get h1 => GoogleFonts.playfairDisplay(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    height: 1.2,
    letterSpacing: -0.5,
  );

  /// H2 - 28px, SemiBold
  static TextStyle get h2 => GoogleFonts.playfairDisplay(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    height: 1.25,
    letterSpacing: -0.3,
  );

  /// H3 - 24px, SemiBold
  static TextStyle get h3 => GoogleFonts.playfairDisplay(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    height: 1.3,
  );

  /// H4 - 20px, Medium
  static TextStyle get h4 => GoogleFonts.playfairDisplay(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    height: 1.35,
  );

  /// H5 - 18px, Medium
  static TextStyle get h5 => GoogleFonts.playfairDisplay(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    height: 1.4,
  );

  // ============================================
  // BODY - Lato
  // ============================================

  /// Body Large - 16px, Regular
  static TextStyle get bodyLarge => GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
    height: 1.5,
  );

  /// Body Medium - 14px, Regular (Default)
  static TextStyle get bodyMedium => GoogleFonts.lato(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
    height: 1.5,
  );

  /// Body Small - 12px, Regular
  static TextStyle get bodySmall => GoogleFonts.lato(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // ============================================
  // LABELS & BUTTONS
  // ============================================

  /// Button Text - 14px, SemiBold, Uppercase
  static TextStyle get button => GoogleFonts.lato(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.surface,
    letterSpacing: 1.2,
    height: 1.2,
  );

  /// Label Large - 14px, Medium
  static TextStyle get labelLarge => GoogleFonts.lato(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    height: 1.3,
  );

  /// Label Medium - 12px, Medium
  static TextStyle get labelMedium => GoogleFonts.lato(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  /// Label Small - 10px, Medium (Captions, badges)
  static TextStyle get labelSmall => GoogleFonts.lato(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.2,
    letterSpacing: 0.5,
  );

  // ============================================
  // PRECIOS
  // ============================================

  /// Precio principal - 20px, Bold
  static TextStyle get price => GoogleFonts.lato(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    height: 1.2,
  );

  /// Precio pequeño - 16px, SemiBold
  static TextStyle get priceSmall => GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    height: 1.2,
  );

  /// Precio en oferta - 20px, Bold, Rojo
  static TextStyle get salePrice => GoogleFonts.lato(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.salePrice,
    height: 1.2,
  );

  /// Precio original tachado - 14px, Regular, Gris
  static TextStyle get originalPrice => GoogleFonts.lato(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.originalPrice,
    height: 1.2,
    decoration: TextDecoration.lineThrough,
  );

  // ============================================
  // ESPECIALES
  // ============================================

  /// Link - 14px, Medium, con subrayado
  static TextStyle get link => GoogleFonts.lato(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    height: 1.4,
    decoration: TextDecoration.underline,
  );

  /// Error text - 12px, Regular, Rojo
  static TextStyle get error => GoogleFonts.lato(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.error,
    height: 1.4,
  );

  /// Badge text - 10px, Bold, Uppercase
  static TextStyle get badge => GoogleFonts.lato(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1,
    height: 1.0,
  );
}
