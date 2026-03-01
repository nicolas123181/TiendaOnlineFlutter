// Servicio de Cloudinary para Flutter
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import '../../config/constants/app_constants.dart';

class CloudinaryService {
  static String get cloudName => AppConstants.cloudinaryCloudName;
  static String get apiKey => AppConstants.cloudinaryApiKey;
  static String get apiSecret => AppConstants.cloudinaryApiSecret;

  /// Genera la firma SHA-1 para signed upload
  static String _generateSignature(Map<String, String> params) {
    // Ordenar params alfabéticamente y unir como key=value&...
    final sortedKeys = params.keys.toList()..sort();
    final paramString = sortedKeys.map((k) => '$k=${params[k]}').join('&');
    final toSign = '$paramString$apiSecret';
    final bytes = utf8.encode(toSign);
    return sha1.convert(bytes).toString();
  }

  /// Upload de imagen a Cloudinary usando signed upload (API key + secret)
  static Future<CloudinaryUploadResult> uploadImage({
    required Uint8List imageBytes,
    required String fileName,
    String folder = 'productos',
    Function(double)? onProgress,
  }) async {
    try {
      final timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000)
          .toString();

      // Parámetros que se firman (deben coincidir exactamente con los enviados)
      final signParams = {'folder': folder, 'timestamp': timestamp};

      final signature = _generateSignature(signParams);

      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );

      final request = http.MultipartRequest('POST', uri);

      request.files.add(
        http.MultipartFile.fromBytes('file', imageBytes, filename: fileName),
      );

      request.fields['api_key'] = apiKey;
      request.fields['timestamp'] = timestamp;
      request.fields['signature'] = signature;
      request.fields['folder'] = folder;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (streamedResponse.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return CloudinaryUploadResult(
          url: data['secure_url'],
          publicId: data['public_id'],
          width: data['width'],
          height: data['height'],
        );
      } else {
        final body = json.decode(response.body);
        throw Exception(
          'Error Cloudinary ${streamedResponse.statusCode}: ${body['error']?['message'] ?? response.body}',
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
