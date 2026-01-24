// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wishlist_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WishlistItem {
  int get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  int get productId => throw _privateConstructorUsedError;
  String get size => throw _privateConstructorUsedError;
  bool get notifiedLowStock => throw _privateConstructorUsedError;
  bool get notifiedSale => throw _privateConstructorUsedError;
  DateTime get createdAt =>
      throw _privateConstructorUsedError; // Datos del producto (cuando se incluyen en la consulta)
  String? get productName => throw _privateConstructorUsedError;
  String? get productSlug => throw _privateConstructorUsedError;
  String? get productImage => throw _privateConstructorUsedError;
  int? get productPrice => throw _privateConstructorUsedError;
  int? get productSalePrice => throw _privateConstructorUsedError;
  bool? get productIsOnSale => throw _privateConstructorUsedError;
  int? get productStock => throw _privateConstructorUsedError;

  /// Create a copy of WishlistItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WishlistItemCopyWith<WishlistItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WishlistItemCopyWith<$Res> {
  factory $WishlistItemCopyWith(
          WishlistItem value, $Res Function(WishlistItem) then) =
      _$WishlistItemCopyWithImpl<$Res, WishlistItem>;
  @useResult
  $Res call(
      {int id,
      String userId,
      int productId,
      String size,
      bool notifiedLowStock,
      bool notifiedSale,
      DateTime createdAt,
      String? productName,
      String? productSlug,
      String? productImage,
      int? productPrice,
      int? productSalePrice,
      bool? productIsOnSale,
      int? productStock});
}

/// @nodoc
class _$WishlistItemCopyWithImpl<$Res, $Val extends WishlistItem>
    implements $WishlistItemCopyWith<$Res> {
  _$WishlistItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WishlistItem
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
    Object? createdAt = null,
    Object? productName = freezed,
    Object? productSlug = freezed,
    Object? productImage = freezed,
    Object? productPrice = freezed,
    Object? productSalePrice = freezed,
    Object? productIsOnSale = freezed,
    Object? productStock = freezed,
  }) {
    return _then(_value.copyWith(
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
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      productName: freezed == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      productSlug: freezed == productSlug
          ? _value.productSlug
          : productSlug // ignore: cast_nullable_to_non_nullable
              as String?,
      productImage: freezed == productImage
          ? _value.productImage
          : productImage // ignore: cast_nullable_to_non_nullable
              as String?,
      productPrice: freezed == productPrice
          ? _value.productPrice
          : productPrice // ignore: cast_nullable_to_non_nullable
              as int?,
      productSalePrice: freezed == productSalePrice
          ? _value.productSalePrice
          : productSalePrice // ignore: cast_nullable_to_non_nullable
              as int?,
      productIsOnSale: freezed == productIsOnSale
          ? _value.productIsOnSale
          : productIsOnSale // ignore: cast_nullable_to_non_nullable
              as bool?,
      productStock: freezed == productStock
          ? _value.productStock
          : productStock // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WishlistItemImplCopyWith<$Res>
    implements $WishlistItemCopyWith<$Res> {
  factory _$$WishlistItemImplCopyWith(
          _$WishlistItemImpl value, $Res Function(_$WishlistItemImpl) then) =
      __$$WishlistItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String userId,
      int productId,
      String size,
      bool notifiedLowStock,
      bool notifiedSale,
      DateTime createdAt,
      String? productName,
      String? productSlug,
      String? productImage,
      int? productPrice,
      int? productSalePrice,
      bool? productIsOnSale,
      int? productStock});
}

/// @nodoc
class __$$WishlistItemImplCopyWithImpl<$Res>
    extends _$WishlistItemCopyWithImpl<$Res, _$WishlistItemImpl>
    implements _$$WishlistItemImplCopyWith<$Res> {
  __$$WishlistItemImplCopyWithImpl(
      _$WishlistItemImpl _value, $Res Function(_$WishlistItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of WishlistItem
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
    Object? createdAt = null,
    Object? productName = freezed,
    Object? productSlug = freezed,
    Object? productImage = freezed,
    Object? productPrice = freezed,
    Object? productSalePrice = freezed,
    Object? productIsOnSale = freezed,
    Object? productStock = freezed,
  }) {
    return _then(_$WishlistItemImpl(
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
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      productName: freezed == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      productSlug: freezed == productSlug
          ? _value.productSlug
          : productSlug // ignore: cast_nullable_to_non_nullable
              as String?,
      productImage: freezed == productImage
          ? _value.productImage
          : productImage // ignore: cast_nullable_to_non_nullable
              as String?,
      productPrice: freezed == productPrice
          ? _value.productPrice
          : productPrice // ignore: cast_nullable_to_non_nullable
              as int?,
      productSalePrice: freezed == productSalePrice
          ? _value.productSalePrice
          : productSalePrice // ignore: cast_nullable_to_non_nullable
              as int?,
      productIsOnSale: freezed == productIsOnSale
          ? _value.productIsOnSale
          : productIsOnSale // ignore: cast_nullable_to_non_nullable
              as bool?,
      productStock: freezed == productStock
          ? _value.productStock
          : productStock // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$WishlistItemImpl extends _WishlistItem {
  const _$WishlistItemImpl(
      {required this.id,
      required this.userId,
      required this.productId,
      required this.size,
      this.notifiedLowStock = false,
      this.notifiedSale = false,
      required this.createdAt,
      this.productName,
      this.productSlug,
      this.productImage,
      this.productPrice,
      this.productSalePrice,
      this.productIsOnSale,
      this.productStock})
      : super._();

  @override
  final int id;
  @override
  final String userId;
  @override
  final int productId;
  @override
  final String size;
  @override
  @JsonKey()
  final bool notifiedLowStock;
  @override
  @JsonKey()
  final bool notifiedSale;
  @override
  final DateTime createdAt;
// Datos del producto (cuando se incluyen en la consulta)
  @override
  final String? productName;
  @override
  final String? productSlug;
  @override
  final String? productImage;
  @override
  final int? productPrice;
  @override
  final int? productSalePrice;
  @override
  final bool? productIsOnSale;
  @override
  final int? productStock;

  @override
  String toString() {
    return 'WishlistItem(id: $id, userId: $userId, productId: $productId, size: $size, notifiedLowStock: $notifiedLowStock, notifiedSale: $notifiedSale, createdAt: $createdAt, productName: $productName, productSlug: $productSlug, productImage: $productImage, productPrice: $productPrice, productSalePrice: $productSalePrice, productIsOnSale: $productIsOnSale, productStock: $productStock)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WishlistItemImpl &&
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
            (identical(other.productImage, productImage) ||
                other.productImage == productImage) &&
            (identical(other.productPrice, productPrice) ||
                other.productPrice == productPrice) &&
            (identical(other.productSalePrice, productSalePrice) ||
                other.productSalePrice == productSalePrice) &&
            (identical(other.productIsOnSale, productIsOnSale) ||
                other.productIsOnSale == productIsOnSale) &&
            (identical(other.productStock, productStock) ||
                other.productStock == productStock));
  }

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
      productImage,
      productPrice,
      productSalePrice,
      productIsOnSale,
      productStock);

  /// Create a copy of WishlistItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WishlistItemImplCopyWith<_$WishlistItemImpl> get copyWith =>
      __$$WishlistItemImplCopyWithImpl<_$WishlistItemImpl>(this, _$identity);
}

abstract class _WishlistItem extends WishlistItem {
  const factory _WishlistItem(
      {required final int id,
      required final String userId,
      required final int productId,
      required final String size,
      final bool notifiedLowStock,
      final bool notifiedSale,
      required final DateTime createdAt,
      final String? productName,
      final String? productSlug,
      final String? productImage,
      final int? productPrice,
      final int? productSalePrice,
      final bool? productIsOnSale,
      final int? productStock}) = _$WishlistItemImpl;
  const _WishlistItem._() : super._();

  @override
  int get id;
  @override
  String get userId;
  @override
  int get productId;
  @override
  String get size;
  @override
  bool get notifiedLowStock;
  @override
  bool get notifiedSale;
  @override
  DateTime
      get createdAt; // Datos del producto (cuando se incluyen en la consulta)
  @override
  String? get productName;
  @override
  String? get productSlug;
  @override
  String? get productImage;
  @override
  int? get productPrice;
  @override
  int? get productSalePrice;
  @override
  bool? get productIsOnSale;
  @override
  int? get productStock;

  /// Create a copy of WishlistItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WishlistItemImplCopyWith<_$WishlistItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
