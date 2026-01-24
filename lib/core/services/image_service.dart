import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Servicio para gestión y compresión de imágenes
/// Optimiza imágenes antes de subirlas a Supabase Storage
class ImageService {
  static final ImageService _instance = ImageService._internal();
  factory ImageService() => _instance;
  ImageService._internal();

  final ImagePicker _picker = ImagePicker();

  /// Configuración de compresión por defecto
  static const int defaultQuality = 80;
  static const int defaultMaxWidth = 1200;
  static const int defaultMaxHeight = 1200;
  static const int thumbnailSize = 300;

  /// Selecciona una imagen de la galería y la comprime
  Future<File?> pickAndCompressFromGallery({
    int quality = defaultQuality,
    int maxWidth = defaultMaxWidth,
    int maxHeight = defaultMaxHeight,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth.toDouble(),
        maxHeight: maxHeight.toDouble(),
        imageQuality: quality,
      );

      if (pickedFile == null) return null;

      return File(pickedFile.path);
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
      return null;
    }
  }

  /// Toma una foto con la cámara y la comprime
  Future<File?> pickAndCompressFromCamera({
    int quality = defaultQuality,
    int maxWidth = defaultMaxWidth,
    int maxHeight = defaultMaxHeight,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth.toDouble(),
        maxHeight: maxHeight.toDouble(),
        imageQuality: quality,
      );

      if (pickedFile == null) return null;

      return File(pickedFile.path);
    } catch (e) {
      debugPrint('Error taking photo: $e');
      return null;
    }
  }

  /// Comprime una imagen existente (para flutter_image_compress cuando esté disponible)
  /// Por ahora usa el resizing nativo de image_picker
  Future<Uint8List?> compressImage(
    File file, {
    int quality = defaultQuality,
    int maxWidth = defaultMaxWidth,
    int maxHeight = defaultMaxHeight,
  }) async {
    try {
      // Lee los bytes de la imagen
      final bytes = await file.readAsBytes();

      // En una implementación completa, aquí usaríamos flutter_image_compress:
      // final compressedBytes = await FlutterImageCompress.compressWithList(
      //   bytes,
      //   quality: quality,
      //   minWidth: maxWidth,
      //   minHeight: maxHeight,
      // );

      // Por ahora retornamos los bytes originales
      // La compresión ya se hace en pickImage
      return bytes;
    } catch (e) {
      debugPrint('Error compressing image: $e');
      return null;
    }
  }

  /// Genera una ruta de archivo temporal para guardar imágenes
  Future<String> getTemporaryImagePath(String filename) async {
    final directory = await getTemporaryDirectory();
    return '${directory.path}/$filename';
  }

  /// Calcula el tamaño de un archivo en formato legible
  String getReadableFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Verifica si el archivo es demasiado grande (> 5MB)
  bool isFileTooLarge(File file, {int maxSizeBytes = 5 * 1024 * 1024}) {
    return file.lengthSync() > maxSizeBytes;
  }

  /// Obtiene el tipo MIME de una imagen basado en su extensión
  String getMimeType(String path) {
    final extension = path.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  /// Genera un nombre único para la imagen
  String generateUniqueFileName(
      {String prefix = 'product', String extension = 'jpg'}) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecond;
    return '${prefix}_${timestamp}_$random.$extension';
  }

  /// Muestra un diálogo para elegir entre cámara o galería
  /// Retorna 'camera', 'gallery', o null si canceló
  // Este método debe ser llamado desde un BuildContext
  // Por eso se implementa en el widget, no aquí
}

/// Extensión para facilitar el trabajo con XFile
extension XFileExtension on XFile {
  /// Convierte XFile a File
  File toFile() => File(path);

  /// Obtiene el tamaño del archivo en bytes
  Future<int> getSize() async {
    return await length();
  }
}
