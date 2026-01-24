import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Tema de la aplicación VANTAGE Fashion
/// Diseño premium y elegante para moda masculina
class AppTheme {
  AppTheme._();

  // ============================================
  // TEMA CLARO - PREMIUM CON AZUL Y BLANCO
  // ============================================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Colores principales - Azul Premium + Blanco
      colorScheme: const ColorScheme.light(
        primary: AppColors.brandNavy,
        onPrimary: Colors.white,
        primaryContainer: Color(0xFFE8EEF8), // Azul muy claro
        onPrimaryContainer: AppColors.brandNavy,
        secondary: AppColors.brandNavy,
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFFDFEBFF), // Azul claro para alternativas
        onSecondaryContainer: AppColors.brandNavy,
        tertiary: Color(0xFF546E7A), // Gris azulado
        onTertiary: Colors.white,
        error: AppColors.error,
        onError: Colors.white,
        surface: Colors.white,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: Color(0xFFF8F9FA), // Gris muy claro
        outline: Color(0xFFBCC7D4), // Azul grisáceo
        outlineVariant: Color(0xFFE1E8F0), // Azul muy claro
      ),

      // Scaffold - Blanco puro para premium
      scaffoldBackgroundColor: Colors.white,

      // AppBar - Blanco con azul oscuro
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0.5,
        shadowColor: Color(0xFF1A2744).withAlpha(30),
        scrolledUnderElevation: 1,
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 2,
          color: AppColors.brandNavy,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.brandNavy,
          size: 24,
        ),
      ),

      // Bottom Navigation - Blanco con azul
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.brandNavy,
        unselectedItemColor: Color(0xFF9CA3AF),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // Cards - Blanco con sombra azul sutil
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 1,
        shadowColor: AppColors.brandNavy.withAlpha(20),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: Color(0xFFE1E8F0), width: 0.5),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Elevated Buttons - Azul marino
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandNavy,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ),

      // Outlined Buttons - Azul
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brandNavy,
          side: const BorderSide(color: AppColors.brandNavy, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ),

      // Text Buttons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.brandNavy,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Input Decoration - Azul claro
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFFF8F9FA),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Color(0xFFE1E8F0)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Color(0xFFE1E8F0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.brandNavy, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.inter(
          color: Color(0xFFADB8C5),
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.inter(
          color: Color(0xFF4B5563),
          fontSize: 14,
        ),
      ),

      // Chips - Azul claro
      chipTheme: ChipThemeData(
        backgroundColor: Color(0xFFE8EEF8),
        selectedColor: AppColors.brandNavy,
        disabledColor: Color(0xFFF8F9FA),
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.brandNavy,
        ),
        secondaryLabelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),

      // Divider - Azul muy claro
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE1E8F0),
        thickness: 1,
        space: 1,
      ),

      // Dialog - Blanco
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: AppColors.brandNavy.withAlpha(20),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),

      // SnackBar - Azul
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.brandNavy,
        contentTextStyle: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 14,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Bottom Sheet - Blanco
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        elevation: 8,
        shadowColor: Color(0xFF000000),
      ),

      // TabBar - Azul
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.brandNavy,
        unselectedLabelColor: Color(0xFF9CA3AF),
        indicatorColor: AppColors.brandNavy,
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Typography
      textTheme: _textTheme,

      // Icon Theme - Azul
      iconTheme: const IconThemeData(
        color: AppColors.brandNavy,
        size: 24,
      ),

      // List Tile - Textos con contraste
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        subtitleTextStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF4B5563), // Gris con contraste
        ),
      ),

      // Floating Action Button - Azul
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.brandNavy,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // Progress Indicator - Azul
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.brandNavy,
        linearTrackColor: Color(0xFFE1E8F0),
      ),
    );
  }

  // ============================================
  // TEMA OSCURO - MEJORADO PARA MEJOR LEGIBILIDAD
  // ============================================

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Colores principales - Mayor contraste
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFD4A942), // Gold más brillante
        onPrimary: Color(0xFF0D1421),
        primaryContainer: Color(0xFF2D3D52),
        onPrimaryContainer: Color(0xFFF8FAFC),
        secondary: Color(0xFFE5B94D),
        onSecondary: Color(0xFF0D1421),
        secondaryContainer: Color(0xFF253043),
        onSecondaryContainer: Color(0xFFF8FAFC),
        tertiary: Color(0xFF93C5FD), // Azul claro para acentos
        onTertiary: Color(0xFF0D1421),
        error: Color(0xFFF87171), // Rojo más visible
        onError: Color(0xFF0D1421),
        surface: Color(0xFF1A2332),
        onSurface: Color(0xFFF8FAFC),
        surfaceContainerHighest: Color(0xFF253043),
        outline: Color(0xFF5D7090),
        outlineVariant: Color(0xFF3D4F66),
      ),

      // Scaffold - Fondo oscuro profundo
      scaffoldBackgroundColor: AppColors.darkBackground,

      // AppBar - Elegante y legible
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 2,
        shadowColor: Colors.black54,
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 3,
          color: Color(0xFFD4A942), // Gold más brillante
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFF8FAFC),
          size: 24,
        ),
      ),

      // Bottom Navigation - Más contraste
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1A2332),
        selectedItemColor: Color(0xFFD4A942),
        unselectedItemColor: Color(0xFF8899AA),
        type: BottomNavigationBarType.fixed,
        elevation: 12,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      // Cards - Mejor separación visual
      cardTheme: CardThemeData(
        color: Color(0xFF1A2332),
        elevation: 2,
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: Color(0xFF3D4F66)),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Elevated Buttons - Gold brillante
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFD4A942),
          foregroundColor: Color(0xFF0D1421),
          elevation: 2,
          shadowColor: Color(0xFFD4A942).withOpacity(0.3),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
      ),

      // Outlined Buttons - Borde visible
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Color(0xFFD4A942),
          side: const BorderSide(color: Color(0xFFD4A942), width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
      ),

      // Text Buttons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Color(0xFFD4A942),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Input Decoration - Mayor contraste
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF1A2332),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Color(0xFF5D7090)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Color(0xFF3D4F66)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Color(0xFFD4A942), width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Color(0xFFF87171)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Color(0xFFF87171), width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: GoogleFonts.inter(
          color: Color(0xFF8899AA),
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.inter(
          color: Color(0xFFB8C5D6),
          fontSize: 14,
        ),
        prefixIconColor: Color(0xFFB8C5D6),
        suffixIconColor: Color(0xFFB8C5D6),
      ),

      // Chips - Más visibles
      chipTheme: ChipThemeData(
        backgroundColor: Color(0xFF253043),
        selectedColor: Color(0xFFD4A942),
        disabledColor: Color(0xFF1A2332),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFFF8FAFC),
        ),
        secondaryLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF0D1421),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),

      // Divider - Visible pero sutil
      dividerTheme: const DividerThemeData(
        color: Color(0xFF3D4F66),
        thickness: 1,
        space: 1,
      ),

      // Dialog - Fondo elevado
      dialogTheme: DialogThemeData(
        backgroundColor: Color(0xFF1A2332),
        elevation: 16,
        shadowColor: Colors.black54,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF8FAFC),
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: Color(0xFFB8C5D6),
        ),
      ),

      // SnackBar - Alto contraste
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Color(0xFF253043),
        contentTextStyle: GoogleFonts.inter(
          color: Color(0xFFF8FAFC),
          fontSize: 14,
        ),
        actionTextColor: Color(0xFFD4A942),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Bottom Sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xFF1A2332),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        elevation: 16,
        shadowColor: Colors.black54,
      ),

      // TabBar - Claro y visible
      tabBarTheme: TabBarThemeData(
        labelColor: Color(0xFFD4A942),
        unselectedLabelColor: Color(0xFF8899AA),
        indicatorColor: Color(0xFFD4A942),
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Typography
      textTheme: _darkTextTheme,

      // Icon Theme - Más brillante
      iconTheme: const IconThemeData(
        color: Color(0xFFF8FAFC),
        size: 24,
      ),

      // Primary Icon Theme
      primaryIconTheme: const IconThemeData(
        color: Color(0xFFD4A942),
        size: 24,
      ),

      // List Tile - Mejor legibilidad
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        tileColor: Colors.transparent,
        selectedTileColor: Color(0xFF253043),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFFF8FAFC),
        ),
        subtitleTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: Color(0xFFB8C5D6),
        ),
        iconColor: Color(0xFFB8C5D6),
        selectedColor: Color(0xFFD4A942),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Color(0xFFD4A942);
          }
          return Color(0xFF8899AA);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Color(0xFFD4A942).withOpacity(0.4);
          }
          return Color(0xFF3D4F66);
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Color(0xFFD4A942);
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Color(0xFF0D1421)),
        side: BorderSide(color: Color(0xFF5D7090), width: 1.5),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Color(0xFFD4A942);
          }
          return Color(0xFF5D7090);
        }),
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFD4A942),
        foregroundColor: Color(0xFF0D1421),
        elevation: 6,
        shape: CircleBorder(),
      ),

      // Progress Indicator - Gold
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xFFD4A942),
        linearTrackColor: Color(0xFF3D4F66),
        circularTrackColor: Color(0xFF3D4F66),
      ),

      // Tooltip
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: Color(0xFF253043),
          borderRadius: BorderRadius.circular(4),
        ),
        textStyle: GoogleFonts.inter(
          color: Color(0xFFF8FAFC),
          fontSize: 12,
        ),
      ),

      // Popup Menu
      popupMenuTheme: PopupMenuThemeData(
        color: Color(0xFF1A2332),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: Color(0xFF3D4F66)),
        ),
        textStyle: GoogleFonts.inter(
          color: Color(0xFFF8FAFC),
          fontSize: 14,
        ),
      ),

      // Dropdown Menu
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF1A2332),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Color(0xFF3D4F66)),
          ),
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(Color(0xFF1A2332)),
        ),
      ),

      // Expansion Tile
      expansionTileTheme: ExpansionTileThemeData(
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        iconColor: Color(0xFFB8C5D6),
        collapsedIconColor: Color(0xFF8899AA),
        textColor: Color(0xFFF8FAFC),
        collapsedTextColor: Color(0xFFB8C5D6),
      ),

      // Data Table
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(Color(0xFF253043)),
        dataRowColor: WidgetStateProperty.all(Colors.transparent),
        headingTextStyle: GoogleFonts.inter(
          color: Color(0xFFF8FAFC),
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        dataTextStyle: GoogleFonts.inter(
          color: Color(0xFFB8C5D6),
          fontSize: 13,
        ),
        dividerThickness: 1,
      ),
    );
  }

  // ============================================
  // TIPOGRAFÍA LIGHT - PREMIUM
  // ============================================

  static TextTheme get _textTheme => TextTheme(
        // Display - Para logo y títulos hero
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 48,
          fontWeight: FontWeight.w600,
          letterSpacing: 4,
          color: AppColors.brandNavy,
          height: 1.2,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          letterSpacing: 2,
          color: AppColors.brandNavy,
          height: 1.2,
        ),
        displaySmall: GoogleFonts.playfairDisplay(
          fontSize: 28,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
          color: AppColors.brandNavy,
          height: 1.3,
        ),

        // Headlines - Títulos de sección
        headlineLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          height: 1.2,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.3,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.4,
        ),

        // Titles - Subtítulos
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          height: 1.4,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.5,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.5,
        ),

        // Body - Cuerpo de texto
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF4B5563), // Gris oscuro para mejor contraste
          height: 1.5,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Color(0xFF7B8899), // Gris más visible que textMuted
          height: 1.5,
        ),

        // Labels - Botones y etiquetas
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.25,
          color: Colors.white,
          height: 1.4,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: AppColors.brandNavy,
          height: 1.5,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: Color(0xFF7B8899),
          height: 1.45,
        ),
      );

  // ============================================
  // TIPOGRAFÍA DARK
  // ============================================

  static TextTheme get _darkTextTheme => TextTheme(
        // Display
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 48,
          fontWeight: FontWeight.w300,
          letterSpacing: 8,
          color: AppColors.brandGold,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 36,
          fontWeight: FontWeight.w300,
          letterSpacing: 6,
          color: AppColors.brandGold,
        ),
        displaySmall: GoogleFonts.playfairDisplay(
          fontSize: 28,
          fontWeight: FontWeight.w400,
          letterSpacing: 4,
          color: AppColors.brandGold,
        ),

        // Headlines
        headlineLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: AppColors.darkTextPrimary,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: AppColors.darkTextPrimary,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: AppColors.darkTextPrimary,
        ),

        // Titles
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.darkTextPrimary,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.darkTextPrimary,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.darkTextPrimary,
        ),

        // Body
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.darkTextPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.darkTextSecondary,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.darkTextSecondary,
        ),

        // Labels
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
          color: AppColors.darkBackground,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 1,
          color: AppColors.darkTextSecondary,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: AppColors.darkTextSecondary,
        ),
      );
}
