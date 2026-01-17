import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../config/constants/app_constants.dart';
import '../exceptions/failures.dart';
import 'supabase_service.dart';

/// Servicio para manejo de imágenes y almacenamiento
class StorageService {
  final SupabaseClient _client;
  final ImagePicker _imagePicker = ImagePicker();

  StorageService(this._client);

  // ============================================
  // SELECCIÓN DE IMÁGENES
  // ============================================

  /// Tomar foto con la cámara
  Future<Either<Failure, XFile>> takePhoto() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: AppConstants.compressedImageMaxWidth.toDouble(),
        maxHeight: AppConstants.compressedImageMaxHeight.toDouble(),
        imageQuality: AppConstants.compressedImageQuality,
      );

      if (photo == null) {
        return left(
          const StorageFailure(
            message: 'No se tomó ninguna foto.',
            code: 'NO_PHOTO',
          ),
        );
      }

      return right(photo);
    } catch (e) {
      return left(
        StorageFailure(
          message: 'Error al acceder a la cámara.',
          originalError: e,
        ),
      );
    }
  }

  /// Seleccionar imagen de la galería
  Future<Either<Failure, XFile>> pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: AppConstants.compressedImageMaxWidth.toDouble(),
        maxHeight: AppConstants.compressedImageMaxHeight.toDouble(),
        imageQuality: AppConstants.compressedImageQuality,
      );

      if (image == null) {
        return left(
          const StorageFailure(
            message: 'No se seleccionó ninguna imagen.',
            code: 'NO_IMAGE',
          ),
        );
      }

      return right(image);
    } catch (e) {
      return left(
        StorageFailure(
          message: 'Error al acceder a la galería.',
          originalError: e,
        ),
      );
    }
  }

  /// Seleccionar múltiples imágenes de la galería
  Future<Either<Failure, List<XFile>>> pickMultipleImages({
    int maxImages = 5,
  }) async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        maxWidth: AppConstants.compressedImageMaxWidth.toDouble(),
        maxHeight: AppConstants.compressedImageMaxHeight.toDouble(),
        imageQuality: AppConstants.compressedImageQuality,
      );

      if (images.isEmpty) {
        return left(
          const StorageFailure(
            message: 'No se seleccionaron imágenes.',
            code: 'NO_IMAGES',
          ),
        );
      }

      // Limitar cantidad de imágenes
      final limitedImages = images.take(maxImages).toList();

      return right(limitedImages);
    } catch (e) {
      return left(
        StorageFailure(
          message: 'Error al seleccionar imágenes.',
          originalError: e,
        ),
      );
    }
  }

  // ============================================
  // COMPRESIÓN DE IMÁGENES
  // ============================================

  /// Comprimir imagen antes de subir
  Future<Either<Failure, Uint8List>> compressImage(File file) async {
    try {
      final result = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: AppConstants.compressedImageMaxWidth,
        minHeight: AppConstants.compressedImageMaxHeight,
        quality: AppConstants.compressedImageQuality,
        format: CompressFormat.webp, // WebP para mejor compresión
      );

      if (result == null) {
        return left(
          const StorageFailure(
            message: 'Error al comprimir la imagen.',
            code: 'COMPRESSION_ERROR',
          ),
        );
      }

      return right(result);
    } catch (e) {
      return left(
        StorageFailure(
          message: 'Error al comprimir la imagen.',
          originalError: e,
        ),
      );
    }
  }

  /// Comprimir XFile
  Future<Either<Failure, Uint8List>> compressXFile(XFile xFile) async {
    try {
      final bytes = await xFile.readAsBytes();

      final result = await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: AppConstants.compressedImageMaxWidth,
        minHeight: AppConstants.compressedImageMaxHeight,
        quality: AppConstants.compressedImageQuality,
        format: CompressFormat.webp,
      );

      return right(result);
    } catch (e) {
      return left(
        StorageFailure(
          message: 'Error al comprimir la imagen.',
          originalError: e,
        ),
      );
    }
  }

  // ============================================
  // SUBIDA A SUPABASE STORAGE
  // ============================================

  /// Subir imagen comprimida a Supabase Storage
  Future<Either<Failure, String>> uploadImage({
    required Uint8List imageBytes,
    required String bucket,
    required String path,
  }) async {
    try {
      // Verificar tamaño máximo
      if (imageBytes.length > AppConstants.maxImageSizeBytes) {
        return left(StorageFailure.fileTooLarge(5));
      }

      // Generar nombre único
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${path.replaceAll('/', '_')}.webp';

      // Subir a Supabase
      await _client.storage
          .from(bucket)
          .uploadBinary(
            fileName,
            imageBytes,
            fileOptions: const FileOptions(
              contentType: 'image/webp',
              upsert: true,
            ),
          );

      // Obtener URL pública
      final publicUrl = _client.storage.from(bucket).getPublicUrl(fileName);

      return right(publicUrl);
    } on StorageException catch (e) {
      return left(StorageFailure(message: e.message, originalError: e));
    } catch (e) {
      return left(
        StorageFailure(message: 'Error al subir la imagen.', originalError: e),
      );
    }
  }

  /// Subir imagen desde XFile (flujo completo: comprimir + subir)
  Future<Either<Failure, String>> uploadXFile({
    required XFile xFile,
    required String bucket,
    String? customPath,
  }) async {
    // 1. Comprimir
    final compressResult = await compressXFile(xFile);

    return compressResult.fold((failure) => left(failure), (
      compressedBytes,
    ) async {
      // 2. Subir
      final path = customPath ?? xFile.name;
      return uploadImage(
        imageBytes: compressedBytes,
        bucket: bucket,
        path: path,
      );
    });
  }

  /// Subir múltiples imágenes
  Future<Either<Failure, List<String>>> uploadMultipleImages({
    required List<XFile> images,
    required String bucket,
    String pathPrefix = '',
  }) async {
    final urls = <String>[];

    for (int i = 0; i < images.length; i++) {
      final result = await uploadXFile(
        xFile: images[i],
        bucket: bucket,
        customPath: '$pathPrefix${i}_${images[i].name}',
      );

      final either = result.fold(
        (failure) => left<Failure, String>(failure),
        (url) => right<Failure, String>(url),
      );

      if (either.isLeft()) {
        return left((either as Left<Failure, String>).value);
      }

      urls.add((either as Right<Failure, String>).value);
    }

    return right(urls);
  }

  // ============================================
  // ELIMINACIÓN DE IMÁGENES
  // ============================================

  /// Eliminar imagen de Supabase Storage
  Future<Either<Failure, void>> deleteImage({
    required String bucket,
    required String path,
  }) async {
    try {
      await _client.storage.from(bucket).remove([path]);
      return right(null);
    } on StorageException catch (e) {
      return left(StorageFailure(message: e.message, originalError: e));
    } catch (e) {
      return left(
        StorageFailure(
          message: 'Error al eliminar la imagen.',
          originalError: e,
        ),
      );
    }
  }

  /// Extraer path del archivo desde URL pública
  String extractPathFromUrl(String url, String bucket) {
    final bucketPath = '/storage/v1/object/public/$bucket/';
    final index = url.indexOf(bucketPath);
    if (index != -1) {
      return url.substring(index + bucketPath.length);
    }
    return url;
  }
}

/// Provider del servicio de storage
final storageServiceProvider = Provider<StorageService>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return StorageService(client);
});
