import 'dart:convert';

/// Utilidades de texto para corregir problemas de codificación (Mojibake).
///
/// Cuando la base de datos almacena texto UTF-8 pero se lee como Latin-1,
/// caracteres como "ó" aparecen como "Ã³", "ñ" como "Ã±", etc.
class TextUtils {
  TextUtils._();

  /// Marcadores comunes de Mojibake (UTF-8 leído como Latin-1).
  static final _mojibakePattern = RegExp(
    r'Ã[¡-¼]|Ã\u0081|Ã\u0089|Ã\u008D|Ã\u0093|Ã\u009A|Ã\u0091|Â|â€',
  );

  /// Corrige texto con problemas de codificación Mojibake.
  /// Si el texto no tiene marcadores, lo devuelve sin cambios.
  static String fixEncoding(String? value) {
    if (value == null || value.isEmpty) return value ?? '';
    if (!_mojibakePattern.hasMatch(value)) return value;

    try {
      // Intentar decodificar: Latin-1 encode → UTF-8 decode
      return utf8.decode(latin1.encode(value));
    } catch (_) {
      // Si falla, intentar reemplazos manuales comunes
      return _manualFix(value);
    }
  }

  /// Reemplazos manuales para los casos más frecuentes en español.
  static String _manualFix(String value) {
    const replacements = {
      'Ã¡': 'á',
      'Ã©': 'é',
      'Ã­': 'í',
      'Ã³': 'ó',
      'Ãº': 'ú',
      'Ã±': 'ñ',
      'Ã¼': 'ü',
      'Ã\u0081': 'Á',
      'Ã\u0089': 'É',
      'Ã\u008D': 'Í',
      'Ã\u0093': 'Ó',
      'Ã\u009A': 'Ú',
      'Ã\u0091': 'Ñ',
      'Â¡': '¡',
      'Â¿': '¿',
      'â\u0082¬': '€',
    };

    var result = value;
    replacements.forEach((bad, good) {
      result = result.replaceAll(bad, good);
    });
    return result;
  }
}
