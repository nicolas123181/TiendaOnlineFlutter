// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wishlist_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WishlistItemModel _$WishlistItemModelFromJson(Map<String, dynamic> json) {
  return _WishlistItemModel.fromJson(json);
}

/// @nodoc
mixin _$WishlistItemModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  int get productId => throw _privateConstructorUsedError;
  String get size => throw _privateConstructorUsedError;
  @JsonKey(name: 'notified_low_stock')
  bool get notifiedLowStock => throw _privateConstructorUsedError;
  @JsonKey(name: 'notified_sale')
  bool get notifiedSale => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError; // Datos del producto (de la vista wishlist_with_details)
  @JsonKey(name: 'product_name')
  String? get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_slug')
  String? get productSlug => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_price')
  int? get productPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_sale_price')
  int? get productSalePrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_is_on_sale')
  bool get productIsOnSale => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_images')
  List<String>? get productImages => throw _privateConstructorUsedError;
  @JsonKey(name: 'size_stock')
  int? get sizeStock => throw _privateConstructorUsedError;

  /// Serializes this WishlistItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WishlistItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WishlistItemModelCopyWith<WishlistItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WishlistItemModelCopyWith<$Res> {
  factory $WishlistItemModelCopyWith(
    WishlistItemModel value,
    $Res Function(WishlistItemModel) then,
  ) = _$WishlistItemModelCopyWithImpl<$Res, WishlistItemModel>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'product_id') int productId,
    String size,
    @JsonKey(name: 'notified_low_stock') bool notifiedLowStock,
    @JsonKey(name: 'notified_sale') bool notifiedSale,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'product_name') String? productName,
    @JsonKey(name: 'product_slug') String? productSlug,
    @JsonKey(name: 'product_price') int? productPrice,
    @JsonKey(name: 'product_sale_price') int? productSalePrice,
    @JsonKey(name: 'product_is_on_sale') bool productIsOnSale,
    @JsonKey(name: 'product_images') List<String>? productImages,
    @JsonKey(name: 'size_stock') int? sizeStock,
  });
}

/// @nodoc
class _$WishlistItemModelCopyWithImpl<$Res, $Val extends WishlistItemModel>
    implements $WishlistItemModelCopyWith<$Res> {
  _$WishlistItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WishlistItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? productId = null,
    Object? size = null,
    Object? notifiedLowStock = null,
    Object? notifiedSale = null,
    Object? createdAt = freezed,
    Object? productName = freezed,
    Object? productSlug = freezed,
    Object? productPrice = freezed,
    Object? productSalePrice = freezed,
    Object? productIsOnSale = null,
    Object? productImages = freezed,
    Object? sizeStock = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as int,
            size: null == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                      as String,
            notifiedLowStock: null == notifiedLowStock
                ? _value.notifiedLowStock
                : notifiedLowStock // ignore: cast_nullable_to_non_nullable
                      as bool,
            notifiedSale: null == notifiedSale
                ? _value.notifiedSale
                : notifiedSale // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            productName: freezed == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String?,
            productSlug: freezed == productSlug
                ? _value.productSlug
                : productSlug // ignore: cast_nullable_to_non_nullable
                      as String?,
            productPrice: freezed == productPrice
                ? _value.productPrice
                : productPrice // ignore: cast_nullable_to_non_nullable
                      as int?,
            productSalePrice: freezed == productSalePrice
                ? _value.productSalePrice
                : productSalePrice // ignore: cast_nullable_to_non_nullable
                      as int?,
            productIsOnSale: null == productIsOnSale
                ? _value.productIsOnSale
                : productIsOnSale // ignore: cast_nullable_to_non_nullable
                      as bool,
            productImages: freezed == productImages
                ? _value.productImages
                : productImages // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            sizeStock: freezed == sizeStock
                ? _value.sizeStock
                : sizeStock // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WishlistItemModelImplCopyWith<$Res>
    implements $WishlistItemModelCopyWith<$Res> {
  factory _$$WishlistItemModelImplCopyWith(
    _$WishlistItemModelImpl value,
    $Res Function(_$WishlistItemModelImpl) then,
  ) = __$$WishlistItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'product_id') int productId,
    String size,
    @JsonKey(name: 'notified_low_stock') bool notifiedLowStock,
    @JsonKey(name: 'notified_sale') bool notifiedSale,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'product_name') String? productName,
    @JsonKey(name: 'product_slug') String? productSlug,
    @JsonKey(name: 'product_price') int? productPrice,
    @JsonKey(name: 'product_sale_price') int? productSalePrice,
    @JsonKey(name: 'product_is_on_sale') bool productIsOnSale,
    @JsonKey(name: 'product_images') List<String>? productImages,
    @JsonKey(name: 'size_stock') int? sizeStock,
  });
}

/// @nodoc
class __$$WishlistItemModelImplCopyWithImpl<$Res>
    extends _$WishlistItemModelCopyWithImpl<$Res, _$WishlistItemModelImpl>
    implements _$$WishlistItemModelImplCopyWith<$Res> {
  __$$WishlistItemModelImplCopyWithImpl(
    _$WishlistItemModelImpl _value,
    $Res Function(_$WishlistItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WishlistItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? productId = null,
    Object? size = null,
    Object? notifiedLowStock = null,
    Object? notifiedSale = null,
    Object? createdAt = freezed,
    Object? productName = freezed,
    Object? productSlug = freezed,
    Object? productPrice = freezed,
    Object? productSalePrice = freezed,
    Object? productIsOnSale = null,
    Object? productImages = freezed,
    Object? sizeStock = freezed,
  }) {
    return _then(
      _$WishlistItemModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as int,
        size: null == size
            ? _value.size
            : size // ignore: cast_nullable_to_non_nullable
                  as String,
        notifiedLowStock: null == notifiedLowStock
            ? _value.notifiedLowStock
            : notifiedLowStock // ignore: cast_nullable_to_non_nullable
                  as bool,
        notifiedSale: null == notifiedSale
            ? _value.notifiedSale
            : notifiedSale // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        productName: freezed == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String?,
        productSlug: freezed == productSlug
            ? _value.productSlug
            : productSlug // ignore: cast_nullable_to_non_nullable
                  as String?,
        productPrice: freezed == productPrice
            ? _value.productPrice
            : productPrice // ignore: cast_nullable_to_non_nullable
                  as int?,
        productSalePrice: freezed == productSalePrice
            ? _value.productSalePrice
            : productSalePrice // ignore: cast_nullable_to_non_nullable
                  as int?,
        productIsOnSale: null == productIsOnSale
            ? _value.productIsOnSale
            : productIsOnSale // ignore: cast_nullable_to_non_nullable
                  as bool,
        productImages: freezed == productImages
            ? _value._productImages
            : productImages // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        sizeStock: freezed == sizeStock
            ? _value.sizeStock
            : sizeStock // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WishlistItemModelImpl extends _WishlistItemModel {
  const _$WishlistItemModelImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'product_id') required this.productId,
    required this.size,
    @JsonKey(name: 'notified_low_stock') this.notifiedLowStock = false,
    @JsonKey(name: 'notified_sale') this.notifiedSale = false,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'product_name') this.productName,
    @JsonKey(name: 'product_slug') this.productSlug,
    @JsonKey(name: 'product_price') this.productPrice,
    @JsonKey(name: 'product_sale_price') this.productSalePrice,
    @JsonKey(name: 'product_is_on_sale') this.productIsOnSale = false,
    @JsonKey(name: 'product_images') final List<String>? productImages,
    @JsonKey(name: 'size_stock') this.sizeStock,
  }) : _productImages = productImages,
       super._();

  factory _$WishlistItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WishlistItemModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'product_id')
  final int productId;
  @override
  final String size;
  @override
  @JsonKey(name: 'notified_low_stock')
  final bool notifiedLowStock;
  @override
  @JsonKey(name: 'notified_sale')
  final bool notifiedSale;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  // Datos del producto (de la vista wishlist_with_details)
  @override
  @JsonKey(name: 'product_name')
  final String? productName;
  @override
  @JsonKey(name: 'product_slug')
  final String? productSlug;
  @override
  @JsonKey(name: 'product_price')
  final int? productPrice;
  @override
  @JsonKey(name: 'product_sale_price')
  final int? productSalePrice;
  @override
  @JsonKey(name: 'product_is_on_sale')
  final bool productIsOnSale;
  final List<String>? _productImages;
  @override
  @JsonKey(name: 'product_images')
  List<String>? get productImages {
    final value = _productImages;
    if (value == null) return null;
    if (_productImages is EqualUnmodifiableListView) return _productImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'size_stock')
  final int? sizeStock;

  @override
  String toString() {
    return 'WishlistItemModel(id: $id, userId: $userId, productId: $productId, size: $size, notifiedLowStock: $notifiedLowStock, notifiedSale: $notifiedSale, createdAt: $createdAt, productName: $productName, productSlug: $productSlug, productPrice: $productPrice, productSalePrice: $productSalePrice, productIsOnSale: $productIsOnSale, productImages: $productImages, sizeStock: $sizeStock)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WishlistItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.notifiedLowStock, notifiedLowStock) ||
                other.notifiedLowStock == notifiedLowStock) &&
            (identical(other.notifiedSale, notifiedSale) ||
                other.notifiedSale == notifiedSale) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productSlug, productSlug) ||
                other.productSlug == productSlug) &&
            (identical(other.productPrice, productPrice) ||
                other.productPrice == productPrice) &&
            (identical(other.productSalePrice, productSalePrice) ||
                other.productSalePrice == productSalePrice) &&
            (identical(other.productIsOnSale, productIsOnSale) ||
                other.productIsOnSale == productIsOnSale) &&
            const DeepCollectionEquality().equals(
              other._productImages,
              _productImages,
            ) &&
            (identical(other.sizeStock, sizeStock) ||
                other.sizeStock == sizeStock));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    productId,
    size,
    notifiedLowStock,
    notifiedSale,
    createdAt,
    productName,
    productSlug,
    productPrice,
    productSalePrice,
    productIsOnSale,
    const DeepCollectionEquality().hash(_productImages),
    sizeStock,
  );

  /// Create a copy of WishlistItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WishlistItemModelImplCopyWith<_$WishlistItemModelImpl> get copyWith =>
      __$$WishlistItemModelImplCopyWithImpl<_$WishlistItemModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WishlistItemModelImplToJson(this);
  }
}

abstract class _WishlistItemModel extends WishlistItemModel {
  const factory _WishlistItemModel({
    required final int id,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'product_id') required final int productId,
    required final String size,
    @JsonKey(name: 'notified_low_stock') final bool notifiedLowStock,
    @JsonKey(name: 'notified_sale') final bool notifiedSale,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'product_name') final String? productName,
    @JsonKey(name: 'product_slug') final String? productSlug,
    @JsonKey(name: 'product_price') final int? productPrice,
    @JsonKey(name: 'product_sale_price') final int? productSalePrice,
    @JsonKey(name: 'product_is_on_sale') final bool productIsOnSale,
    @JsonKey(name: 'product_images') final List<String>? productImages,
    @JsonKey(name: 'size_stock') final int? sizeStock,
  }) = _$WishlistItemModelImpl;
  const _WishlistItemModel._() : super._();

  factory _WishlistItemModel.fromJson(Map<String, dynamic> json) =
      _$WishlistItemModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'product_id')
  int get productId;
  @override
  String get size;
  @override
  @JsonKey(name: 'notified_low_stock')
  bool get notifiedLowStock;
  @override
  @JsonKey(name: 'notified_sale')
  bool get notifiedSale;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt; // Datos del producto (de la vista wishlist_with_details)
  @override
  @JsonKey(name: 'product_name')
  String? get productName;
  @override
  @JsonKey(name: 'product_slug')
  String? get productSlug;
  @override
  @JsonKey(name: 'product_price')
  int? get productPrice;
  @override
  @JsonKey(name: 'product_sale_price')
  int? get productSalePrice;
  @override
  @JsonKey(name: 'product_is_on_sale')
  bool get productIsOnSale;
  @override
  @JsonKey(name: 'product_images')
  List<String>? get productImages;
  @override
  @JsonKey(name: 'size_stock')
  int? get sizeStock;

  /// Create a copy of WishlistItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WishlistItemModelImplCopyWith<_$WishlistItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
