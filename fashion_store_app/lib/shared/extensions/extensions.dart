import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Extensiones para BuildContext
extension ContextExtensions on BuildContext {
  /// Acceso rápido al tema
  ThemeData get theme => Theme.of(this);

  /// Acceso rápido a los estilos de texto
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Acceso rápido al color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Acceso rápido a MediaQuery
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Ancho de pantalla
  double get screenWidth => mediaQuery.size.width;

  /// Alto de pantalla
  double get screenHeight => mediaQuery.size.height;

  /// Padding de sistema (notch, etc.)
  EdgeInsets get padding => mediaQuery.padding;

  /// ¿Es una pantalla pequeña? (móvil)
  bool get isMobile => screenWidth < 600;

  /// ¿Es una pantalla mediana? (tablet)
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;

  /// ¿Es una pantalla grande? (desktop)
  bool get isDesktop => screenWidth >= 1200;

  /// Mostrar SnackBar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () => ScaffoldMessenger.of(this).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  /// Mostrar SnackBar de éxito
  void showSuccessSnackBar(String message) {
    showSnackBar(message, isError: false);
  }

  /// Mostrar SnackBar de error
  void showErrorSnackBar(String message) {
    showSnackBar(message, isError: true);
  }

  /// Mostrar diálogo de confirmación
  Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
  }) async {
    final result = await showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

/// Extensiones para String
extension StringExtensions on String {
  /// Capitalizar primera letra
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalizar cada palabra
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Verificar si es un email válido
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// Verificar si es un teléfono válido
  bool get isValidPhone {
    return RegExp(r'^\+?[\d\s-]{9,}$').hasMatch(this);
  }

  /// Truncar texto con elipsis
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  /// Convertir a slug
  String get toSlug {
    return toLowerCase()
        .replaceAll(RegExp(r'[àáâãäå]'), 'a')
        .replaceAll(RegExp(r'[èéêë]'), 'e')
        .replaceAll(RegExp(r'[ìíîï]'), 'i')
        .replaceAll(RegExp(r'[òóôõö]'), 'o')
        .replaceAll(RegExp(r'[ùúûü]'), 'u')
        .replaceAll(RegExp(r'[ñ]'), 'n')
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }
}

/// Extensiones para int (precios en céntimos)
extension IntExtensions on int {
  /// Formatear precio desde céntimos a euros
  String get toEuroPrice {
    final euros = this / 100;
    return NumberFormat.currency(
      locale: 'es_ES',
      symbol: '€',
      decimalDigits: 2,
    ).format(euros);
  }

  /// Formatear precio sin símbolo
  String get toPriceValue {
    final euros = this / 100;
    return NumberFormat('#,##0.00', 'es_ES').format(euros);
  }

  /// Convertir a duración legible
  String get toDurationString {
    final duration = Duration(milliseconds: this);
    if (duration.inDays > 0) {
      return '${duration.inDays}d';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}

/// Extensiones para DateTime
extension DateTimeExtensions on DateTime {
  /// Formatear fecha completa
  String get formatFull {
    return DateFormat('d MMMM yyyy, HH:mm', 'es_ES').format(this);
  }

  /// Formatear solo fecha
  String get formatDate {
    return DateFormat('d MMM yyyy', 'es_ES').format(this);
  }

  /// Formatear solo hora
  String get formatTime {
    return DateFormat('HH:mm', 'es_ES').format(this);
  }

  /// Formatear fecha relativa (hace X tiempo)
  String get formatRelative {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} años';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} meses';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} días';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} min';
    } else {
      return 'Ahora';
    }
  }

  /// ¿Es hoy?
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}

/// Extensiones para List
extension ListExtensions<T> on List<T> {
  /// Obtener elemento o null si el índice no existe
  T? getOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// Dividir lista en chunks
  List<List<T>> chunk(int size) {
    return [
      for (var i = 0; i < length; i += size)
        sublist(i, (i + size > length) ? length : i + size),
    ];
  }
}
