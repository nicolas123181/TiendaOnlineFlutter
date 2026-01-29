import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../config/constants/app_constants.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

/// Modelo de Categoría
@freezed
class CategoryModel with _$CategoryModel {
  const CategoryModel._();

  const factory CategoryModel({
    required int id,
    required String name,
    required String slug,
    String? description,
    @JsonKey(name: 'image_url') String? imageUrl,
    @Default(0) int productCount,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  /// URL de la imagen o placeholder
  String get displayImage {
    final rawUrl = imageUrl;
    if (rawUrl == null || rawUrl.isEmpty) {
      return 'https://via.placeholder.com/400x300?text=${name.replaceAll(' ', '+')}';
    }

    if (rawUrl.startsWith('http://') || rawUrl.startsWith('https://')) {
      return rawUrl;
    }

    final trimmed = rawUrl.startsWith('/') ? rawUrl.substring(1) : rawUrl;
    final base = AppConstants.supabaseUrl;
    if (trimmed.startsWith(AppConstants.categoryImagesBucket)) {
      return '$base/storage/v1/object/public/$trimmed';
    }

    return '$base/storage/v1/object/public/${AppConstants.categoryImagesBucket}/$trimmed';
  }
}
