// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProductSize _$ProductSizeFromJson(Map<String, dynamic> json) {
  return _ProductSize.fromJson(json);
}

/// @nodoc
mixin _$ProductSize {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  int get productId => throw _privateConstructorUsedError;
  String get size => throw _privateConstructorUsedError;
  int get stock => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ProductSize to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductSize
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductSizeCopyWith<ProductSize> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductSizeCopyWith<$Res> {
  factory $ProductSizeCopyWith(
          ProductSize value, $Res Function(ProductSize) then) =
      _$ProductSizeCopyWithImpl<$Res, ProductSize>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'product_id') int productId,
      String size,
      int stock,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$ProductSizeCopyWithImpl<$Res, $Val extends ProductSize>
    implements $ProductSizeCopyWith<$Res> {
  _$ProductSizeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductSize
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? size = null,
    Object? stock = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String,
      stock: null == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductSizeImplCopyWith<$Res>
    implements $ProductSizeCopyWith<$Res> {
  factory _$$ProductSizeImplCopyWith(
          _$ProductSizeImpl value, $Res Function(_$ProductSizeImpl) then) =
      __$$ProductSizeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'product_id') int productId,
      String size,
      int stock,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$ProductSizeImplCopyWithImpl<$Res>
    extends _$ProductSizeCopyWithImpl<$Res, _$ProductSizeImpl>
    implements _$$ProductSizeImplCopyWith<$Res> {
  __$$ProductSizeImplCopyWithImpl(
      _$ProductSizeImpl _value, $Res Function(_$ProductSizeImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProductSize
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? size = null,
    Object? stock = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ProductSizeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String,
      stock: null == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductSizeImpl extends _ProductSize {
  const _$ProductSizeImpl(
      {required this.id,
      @JsonKey(name: 'product_id') required this.productId,
      required this.size,
      required this.stock,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt})
      : super._();

  factory _$ProductSizeImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductSizeImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'product_id')
  final int productId;
  @override
  final String size;
  @override
  final int stock;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ProductSize(id: $id, productId: $productId, size: $size, stock: $stock, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductSizeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, productId, size, stock, createdAt, updatedAt);

  /// Create a copy of ProductSize
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductSizeImplCopyWith<_$ProductSizeImpl> get copyWith =>
      __$$ProductSizeImplCopyWithImpl<_$ProductSizeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductSizeImplToJson(
      this,
    );
  }
}

abstract class _ProductSize extends ProductSize {
  const factory _ProductSize(
          {required final int id,
          @JsonKey(name: 'product_id') required final int productId,
          required final String size,
          required final int stock,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$ProductSizeImpl;
  const _ProductSize._() : super._();

  factory _ProductSize.fromJson(Map<String, dynamic> json) =
      _$ProductSizeImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'product_id')
  int get productId;
  @override
  String get size;
  @override
  int get stock;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of ProductSize
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductSizeImplCopyWith<_$ProductSizeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Product {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int get price => throw _privateConstructorUsedError; // En centavos
  @JsonKey(name: 'sale_price')
  int? get salePrice =>
      throw _privateConstructorUsedError; // Precio de oferta en centavos
  @JsonKey(name: 'is_on_sale')
  bool get isOnSale => throw _privateConstructorUsedError;
  @JsonKey(name: 'sale_ends_at')
  DateTime? get saleEndsAt => throw _privateConstructorUsedError;
  int get stock => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  int? get categoryId => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get categoryName => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  bool get featured => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_sizes', includeToJson: false)
  List<ProductSize> get sizes => throw _privateConstructorUsedError;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call(
      {int id,
      String name,
      String slug,
      String? description,
      int price,
      @JsonKey(name: 'sale_price') int? salePrice,
      @JsonKey(name: 'is_on_sale') bool isOnSale,
      @JsonKey(name: 'sale_ends_at') DateTime? saleEndsAt,
      int stock,
      @JsonKey(name: 'category_id') int? categoryId,
      @JsonKey(includeFromJson: false, includeToJson: false)
      String? categoryName,
      List<String> images,
      bool featured,
      String status,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'product_sizes', includeToJson: false)
      List<ProductSize> sizes});
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? price = null,
    Object? salePrice = freezed,
    Object? isOnSale = null,
    Object? saleEndsAt = freezed,
    Object? stock = null,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
    Object? images = null,
    Object? featured = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? sizes = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      salePrice: freezed == salePrice
          ? _value.salePrice
          : salePrice // ignore: cast_nullable_to_non_nullable
              as int?,
      isOnSale: null == isOnSale
          ? _value.isOnSale
          : isOnSale // ignore: cast_nullable_to_non_nullable
              as bool,
      saleEndsAt: freezed == saleEndsAt
          ? _value.saleEndsAt
          : saleEndsAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      stock: null == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      featured: null == featured
          ? _value.featured
          : featured // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sizes: null == sizes
          ? _value.sizes
          : sizes // ignore: cast_nullable_to_non_nullable
              as List<ProductSize>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$ProductImplCopyWith(
          _$ProductImpl value, $Res Function(_$ProductImpl) then) =
      __$$ProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String slug,
      String? description,
      int price,
      @JsonKey(name: 'sale_price') int? salePrice,
      @JsonKey(name: 'is_on_sale') bool isOnSale,
      @JsonKey(name: 'sale_ends_at') DateTime? saleEndsAt,
      int stock,
      @JsonKey(name: 'category_id') int? categoryId,
      @JsonKey(includeFromJson: false, includeToJson: false)
      String? categoryName,
      List<String> images,
      bool featured,
      String status,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'product_sizes', includeToJson: false)
      List<ProductSize> sizes});
}

/// @nodoc
class __$$ProductImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$ProductImpl>
    implements _$$ProductImplCopyWith<$Res> {
  __$$ProductImplCopyWithImpl(
      _$ProductImpl _value, $Res Function(_$ProductImpl) _then)
      : super(_value, _then);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? price = null,
    Object? salePrice = freezed,
    Object? isOnSale = null,
    Object? saleEndsAt = freezed,
    Object? stock = null,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
    Object? images = null,
    Object? featured = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? sizes = null,
  }) {
    return _then(_$ProductImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      salePrice: freezed == salePrice
          ? _value.salePrice
          : salePrice // ignore: cast_nullable_to_non_nullable
              as int?,
      isOnSale: null == isOnSale
          ? _value.isOnSale
          : isOnSale // ignore: cast_nullable_to_non_nullable
              as bool,
      saleEndsAt: freezed == saleEndsAt
          ? _value.saleEndsAt
          : saleEndsAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      stock: null == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as int,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      featured: null == featured
          ? _value.featured
          : featured // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sizes: null == sizes
          ? _value._sizes
          : sizes // ignore: cast_nullable_to_non_nullable
              as List<ProductSize>,
    ));
  }
}

/// @nodoc

class _$ProductImpl extends _Product {
  const _$ProductImpl(
      {required this.id,
      required this.name,
      required this.slug,
      this.description,
      required this.price,
      @JsonKey(name: 'sale_price') this.salePrice,
      @JsonKey(name: 'is_on_sale') this.isOnSale = false,
      @JsonKey(name: 'sale_ends_at') this.saleEndsAt,
      this.stock = 0,
      @JsonKey(name: 'category_id') this.categoryId,
      @JsonKey(includeFromJson: false, includeToJson: false) this.categoryName,
      final List<String> images = const [],
      this.featured = false,
      this.status = 'active',
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'product_sizes', includeToJson: false)
      final List<ProductSize> sizes = const []})
      : _images = images,
        _sizes = sizes,
        super._();

  @override
  final int id;
  @override
  final String name;
  @override
  final String slug;
  @override
  final String? description;
  @override
  final int price;
// En centavos
  @override
  @JsonKey(name: 'sale_price')
  final int? salePrice;
// Precio de oferta en centavos
  @override
  @JsonKey(name: 'is_on_sale')
  final bool isOnSale;
  @override
  @JsonKey(name: 'sale_ends_at')
  final DateTime? saleEndsAt;
  @override
  @JsonKey()
  final int stock;
  @override
  @JsonKey(name: 'category_id')
  final int? categoryId;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? categoryName;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  @JsonKey()
  final bool featured;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final List<ProductSize> _sizes;
  @override
  @JsonKey(name: 'product_sizes', includeToJson: false)
  List<ProductSize> get sizes {
    if (_sizes is EqualUnmodifiableListView) return _sizes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sizes);
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, slug: $slug, description: $description, price: $price, salePrice: $salePrice, isOnSale: $isOnSale, saleEndsAt: $saleEndsAt, stock: $stock, categoryId: $categoryId, categoryName: $categoryName, images: $images, featured: $featured, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, sizes: $sizes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.salePrice, salePrice) ||
                other.salePrice == salePrice) &&
            (identical(other.isOnSale, isOnSale) ||
                other.isOnSale == isOnSale) &&
            (identical(other.saleEndsAt, saleEndsAt) ||
                other.saleEndsAt == saleEndsAt) &&
            (identical(other.stock, stock) || other.stock == stock) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.featured, featured) ||
                other.featured == featured) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._sizes, _sizes));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      slug,
      description,
      price,
      salePrice,
      isOnSale,
      saleEndsAt,
      stock,
      categoryId,
      categoryName,
      const DeepCollectionEquality().hash(_images),
      featured,
      status,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_sizes));

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      __$$ProductImplCopyWithImpl<_$ProductImpl>(this, _$identity);
}

abstract class _Product extends Product {
  const factory _Product(
      {required final int id,
      required final String name,
      required final String slug,
      final String? description,
      required final int price,
      @JsonKey(name: 'sale_price') final int? salePrice,
      @JsonKey(name: 'is_on_sale') final bool isOnSale,
      @JsonKey(name: 'sale_ends_at') final DateTime? saleEndsAt,
      final int stock,
      @JsonKey(name: 'category_id') final int? categoryId,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final String? categoryName,
      final List<String> images,
      final bool featured,
      final String status,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      @JsonKey(name: 'product_sizes', includeToJson: false)
      final List<ProductSize> sizes}) = _$ProductImpl;
  const _Product._() : super._();

  @override
  int get id;
  @override
  String get name;
  @override
  String get slug;
  @override
  String? get description;
  @override
  int get price; // En centavos
  @override
  @JsonKey(name: 'sale_price')
  int? get salePrice; // Precio de oferta en centavos
  @override
  @JsonKey(name: 'is_on_sale')
  bool get isOnSale;
  @override
  @JsonKey(name: 'sale_ends_at')
  DateTime? get saleEndsAt;
  @override
  int get stock;
  @override
  @JsonKey(name: 'category_id')
  int? get categoryId;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get categoryName;
  @override
  List<String> get images;
  @override
  bool get featured;
  @override
  String get status;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(name: 'product_sizes', includeToJson: false)
  List<ProductSize> get sizes;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
