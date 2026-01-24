import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

/// Modelo de Categoría
@freezed
class Category with _$Category {
  const factory Category({
    required int id,
    required String name,
    required String slug,
    String? description,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'product_count') @Default(0) int productCount,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
