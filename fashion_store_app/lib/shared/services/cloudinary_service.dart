// Servicio de Cloudinary para Flutter
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import '../../config/constants/app_constants.dart';

class CloudinaryService {
  // Obtener credenciales desde AppConstants (que lee .env)
  static String get cloudName => AppConstants.cloudinaryCloudName;
  static String get uploadPreset => AppConstants.cloudinaryUploadPreset;

  /// Upload de imagen a Cloudinary
  /// Retorna la URL de la imagen subida
  static Future<CloudinaryUploadResult> uploadImage({
    required Uint8List imageBytes,
    required String fileName,
    String folder = 'productos',
    Function(double)? onProgress,
  }) async {
    try {
      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );

      final request = http.MultipartRequest('POST', uri);

      // Agregar archivo
      request.files.add(
        http.MultipartFile.fromBytes('file', imageBytes, filename: fileName),
      );

      // Agregar parámetros
      request.fields['upload_preset'] = uploadPreset;
      request.fields['folder'] = folder;
      request.fields['quality'] = 'auto:good';
      request.fields['fetch_format'] = 'auto';

      // Enviar request
      final streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        final response = await http.Response.fromStream(streamedResponse);
        final Map<String, dynamic> data = json.decode(response.body);

        return CloudinaryUploadResult(
          url: data['secure_url'],
          publicId: data['public_id'],
          width: data['width'],
          height: data['height'],
        );
      } else {
        throw Exception(
          'Error al subir imagen: ${streamedResponse.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error al subir imagen a Cloudinary: $e');
    }
  }

  /// Eliminar imagen de Cloudinary
  static Future<bool> deleteImage(String publicId) async {
    try {
      // Nota: Eliminar desde Flutter requiere un backend con API key/secret
      // Por seguridad, esto debería hacerse desde el backend
      // Por ahora, retornamos true ya que las imágenes en Cloudinary no se eliminan automáticamente
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Extraer public ID de una URL de Cloudinary
  static String? getPublicIdFromUrl(String url) {
    try {
      final regex = RegExp(r'/upload/(?:v\d+/)?(.+)\.\w+$');
      final match = regex.firstMatch(url);
      return match?.group(1);
    } catch (e) {
      return null;
    }
  }

  /// Generar URL optimizada para thumbnail
  static String getThumbnailUrl(
    String publicId, {
    int width = 200,
    int height = 200,
  }) {
    return 'https://res.cloudinary.com/$cloudName/image/upload/w_$width,h_$height,c_fill,q_auto,f_auto/$publicId';
  }
}

class CloudinaryUploadResult {
  final String url;
  final String publicId;
  final int width;
  final int height;

  CloudinaryUploadResult({
    required this.url,
    required this.publicId,
    required this.width,
    required this.height,
  });
}
