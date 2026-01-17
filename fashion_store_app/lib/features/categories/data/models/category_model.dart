import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

/// Modelo de Categoría
@freezed
abstract class CategoryModel with _$CategoryModel {
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
  String get displayImage =>
      imageUrl ??
      'https://via.placeholder.com/400x300?text=${name.replaceAll(' ', '+')}';
}
