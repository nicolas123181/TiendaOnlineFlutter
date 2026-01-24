// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CartItem _$CartItemFromJson(Map<String, dynamic> json) {
  return _CartItem.fromJson(json);
}

/// @nodoc
mixin _$CartItem {
  @JsonKey(name: 'product_id')
  int get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_name')
  String get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_slug')
  String get productSlug => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_image')
  String? get productImage => throw _privateConstructorUsedError;
  int get price =>
      throw _privateConstructorUsedError; // Precio unitario en centavos
  String get size => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'sale_price')
  int? get salePrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_on_sale')
  bool get isOnSale => throw _privateConstructorUsedError;
  @JsonKey(name: 'available_stock')
  int get availableStock => throw _privateConstructorUsedError;

  /// Serializes this CartItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartItemCopyWith<CartItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartItemCopyWith<$Res> {
  factory $CartItemCopyWith(CartItem value, $Res Function(CartItem) then) =
      _$CartItemCopyWithImpl<$Res, CartItem>;
  @useResult
  $Res call(
      {@JsonKey(name: 'product_id') int productId,
      @JsonKey(name: 'product_name') String productName,
      @JsonKey(name: 'product_slug') String productSlug,
      @JsonKey(name: 'product_image') String? productImage,
      int price,
      String size,
      int quantity,
      @JsonKey(name: 'sale_price') int? salePrice,
      @JsonKey(name: 'is_on_sale') bool isOnSale,
      @JsonKey(name: 'available_stock') int availableStock});
}

/// @nodoc
class _$CartItemCopyWithImpl<$Res, $Val extends CartItem>
    implements $CartItemCopyWith<$Res> {
  _$CartItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? productSlug = null,
    Object? productImage = freezed,
    Object? price = null,
    Object? size = null,
    Object? quantity = null,
    Object? salePrice = freezed,
    Object? isOnSale = null,
    Object? availableStock = null,
  }) {
    return _then(_value.copyWith(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      productSlug: null == productSlug
          ? _value.productSlug
          : productSlug // ignore: cast_nullable_to_non_nullable
              as String,
      productImage: freezed == productImage
          ? _value.productImage
          : productImage // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      salePrice: freezed == salePrice
          ? _value.salePrice
          : salePrice // ignore: cast_nullable_to_non_nullable
              as int?,
      isOnSale: null == isOnSale
          ? _value.isOnSale
          : isOnSale // ignore: cast_nullable_to_non_nullable
              as bool,
      availableStock: null == availableStock
          ? _value.availableStock
          : availableStock // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CartItemImplCopyWith<$Res>
    implements $CartItemCopyWith<$Res> {
  factory _$$CartItemImplCopyWith(
          _$CartItemImpl value, $Res Function(_$CartItemImpl) then) =
      __$$CartItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'product_id') int productId,
      @JsonKey(name: 'product_name') String productName,
      @JsonKey(name: 'product_slug') String productSlug,
      @JsonKey(name: 'product_image') String? productImage,
      int price,
      String size,
      int quantity,
      @JsonKey(name: 'sale_price') int? salePrice,
      @JsonKey(name: 'is_on_sale') bool isOnSale,
      @JsonKey(name: 'available_stock') int availableStock});
}

/// @nodoc
class __$$CartItemImplCopyWithImpl<$Res>
    extends _$CartItemCopyWithImpl<$Res, _$CartItemImpl>
    implements _$$CartItemImplCopyWith<$Res> {
  __$$CartItemImplCopyWithImpl(
      _$CartItemImpl _value, $Res Function(_$CartItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? productSlug = null,
    Object? productImage = freezed,
    Object? price = null,
    Object? size = null,
    Object? quantity = null,
    Object? salePrice = freezed,
    Object? isOnSale = null,
    Object? availableStock = null,
  }) {
    return _then(_$CartItemImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      productSlug: null == productSlug
          ? _value.productSlug
          : productSlug // ignore: cast_nullable_to_non_nullable
              as String,
      productImage: freezed == productImage
          ? _value.productImage
          : productImage // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      salePrice: freezed == salePrice
          ? _value.salePrice
          : salePrice // ignore: cast_nullable_to_non_nullable
              as int?,
      isOnSale: null == isOnSale
          ? _value.isOnSale
          : isOnSale // ignore: cast_nullable_to_non_nullable
              as bool,
      availableStock: null == availableStock
          ? _value.availableStock
          : availableStock // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CartItemImpl extends _CartItem {
  const _$CartItemImpl(
      {@JsonKey(name: 'product_id') required this.productId,
      @JsonKey(name: 'product_name') required this.productName,
      @JsonKey(name: 'product_slug') required this.productSlug,
      @JsonKey(name: 'product_image') this.productImage,
      required this.price,
      required this.size,
      required this.quantity,
      @JsonKey(name: 'sale_price') this.salePrice,
      @JsonKey(name: 'is_on_sale') this.isOnSale = false,
      @JsonKey(name: 'available_stock') this.availableStock = 0})
      : super._();

  factory _$CartItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartItemImplFromJson(json);

  @override
  @JsonKey(name: 'product_id')
  final int productId;
  @override
  @JsonKey(name: 'product_name')
  final String productName;
  @override
  @JsonKey(name: 'product_slug')
  final String productSlug;
  @override
  @JsonKey(name: 'product_image')
  final String? productImage;
  @override
  final int price;
// Precio unitario en centavos
  @override
  final String size;
  @override
  final int quantity;
  @override
  @JsonKey(name: 'sale_price')
  final int? salePrice;
  @override
  @JsonKey(name: 'is_on_sale')
  final bool isOnSale;
  @override
  @JsonKey(name: 'available_stock')
  final int availableStock;

  @override
  String toString() {
    return 'CartItem(productId: $productId, productName: $productName, productSlug: $productSlug, productImage: $productImage, price: $price, size: $size, quantity: $quantity, salePrice: $salePrice, isOnSale: $isOnSale, availableStock: $availableStock)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartItemImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productSlug, productSlug) ||
                other.productSlug == productSlug) &&
            (identical(other.productImage, productImage) ||
                other.productImage == productImage) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.salePrice, salePrice) ||
                other.salePrice == salePrice) &&
            (identical(other.isOnSale, isOnSale) ||
                other.isOnSale == isOnSale) &&
            (identical(other.availableStock, availableStock) ||
                other.availableStock == availableStock));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      productId,
      productName,
      productSlug,
      productImage,
      price,
      size,
      quantity,
      salePrice,
      isOnSale,
      availableStock);

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartItemImplCopyWith<_$CartItemImpl> get copyWith =>
      __$$CartItemImplCopyWithImpl<_$CartItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartItemImplToJson(
      this,
    );
  }
}

abstract class _CartItem extends CartItem {
  const factory _CartItem(
          {@JsonKey(name: 'product_id') required final int productId,
          @JsonKey(name: 'product_name') required final String productName,
          @JsonKey(name: 'product_slug') required final String productSlug,
          @JsonKey(name: 'product_image') final String? productImage,
          required final int price,
          required final String size,
          required final int quantity,
          @JsonKey(name: 'sale_price') final int? salePrice,
          @JsonKey(name: 'is_on_sale') final bool isOnSale,
          @JsonKey(name: 'available_stock') final int availableStock}) =
      _$CartItemImpl;
  const _CartItem._() : super._();

  factory _CartItem.fromJson(Map<String, dynamic> json) =
      _$CartItemImpl.fromJson;

  @override
  @JsonKey(name: 'product_id')
  int get productId;
  @override
  @JsonKey(name: 'product_name')
  String get productName;
  @override
  @JsonKey(name: 'product_slug')
  String get productSlug;
  @override
  @JsonKey(name: 'product_image')
  String? get productImage;
  @override
  int get price; // Precio unitario en centavos
  @override
  String get size;
  @override
  int get quantity;
  @override
  @JsonKey(name: 'sale_price')
  int? get salePrice;
  @override
  @JsonKey(name: 'is_on_sale')
  bool get isOnSale;
  @override
  @JsonKey(name: 'available_stock')
  int get availableStock;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartItemImplCopyWith<_$CartItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Cart _$CartFromJson(Map<String, dynamic> json) {
  return _Cart.fromJson(json);
}

/// @nodoc
mixin _$Cart {
  List<CartItem> get items => throw _privateConstructorUsedError;
  @JsonKey(name: 'coupon_code')
  String? get couponCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_amount')
  int get discountAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_type')
  String? get discountType => throw _privateConstructorUsedError;
  @JsonKey(name: 'discount_value')
  int? get discountValue => throw _privateConstructorUsedError;

  /// Serializes this Cart to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartCopyWith<Cart> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartCopyWith<$Res> {
  factory $CartCopyWith(Cart value, $Res Function(Cart) then) =
      _$CartCopyWithImpl<$Res, Cart>;
  @useResult
  $Res call(
      {List<CartItem> items,
      @JsonKey(name: 'coupon_code') String? couponCode,
      @JsonKey(name: 'discount_amount') int discountAmount,
      @JsonKey(name: 'discount_type') String? discountType,
      @JsonKey(name: 'discount_value') int? discountValue});
}

/// @nodoc
class _$CartCopyWithImpl<$Res, $Val extends Cart>
    implements $CartCopyWith<$Res> {
  _$CartCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? couponCode = freezed,
    Object? discountAmount = null,
    Object? discountType = freezed,
    Object? discountValue = freezed,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CartItem>,
      couponCode: freezed == couponCode
          ? _value.couponCode
          : couponCode // ignore: cast_nullable_to_non_nullable
              as String?,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as int,
      discountType: freezed == discountType
          ? _value.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as String?,
      discountValue: freezed == discountValue
          ? _value.discountValue
          : discountValue // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CartImplCopyWith<$Res> implements $CartCopyWith<$Res> {
  factory _$$CartImplCopyWith(
          _$CartImpl value, $Res Function(_$CartImpl) then) =
      __$$CartImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<CartItem> items,
      @JsonKey(name: 'coupon_code') String? couponCode,
      @JsonKey(name: 'discount_amount') int discountAmount,
      @JsonKey(name: 'discount_type') String? discountType,
      @JsonKey(name: 'discount_value') int? discountValue});
}

/// @nodoc
class __$$CartImplCopyWithImpl<$Res>
    extends _$CartCopyWithImpl<$Res, _$CartImpl>
    implements _$$CartImplCopyWith<$Res> {
  __$$CartImplCopyWithImpl(_$CartImpl _value, $Res Function(_$CartImpl) _then)
      : super(_value, _then);

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? couponCode = freezed,
    Object? discountAmount = null,
    Object? discountType = freezed,
    Object? discountValue = freezed,
  }) {
    return _then(_$CartImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CartItem>,
      couponCode: freezed == couponCode
          ? _value.couponCode
          : couponCode // ignore: cast_nullable_to_non_nullable
              as String?,
      discountAmount: null == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as int,
      discountType: freezed == discountType
          ? _value.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as String?,
      discountValue: freezed == discountValue
          ? _value.discountValue
          : discountValue // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CartImpl extends _Cart {
  const _$CartImpl(
      {final List<CartItem> items = const [],
      @JsonKey(name: 'coupon_code') this.couponCode,
      @JsonKey(name: 'discount_amount') this.discountAmount = 0,
      @JsonKey(name: 'discount_type') this.discountType,
      @JsonKey(name: 'discount_value') this.discountValue})
      : _items = items,
        super._();

  factory _$CartImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartImplFromJson(json);

  final List<CartItem> _items;
  @override
  @JsonKey()
  List<CartItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey(name: 'coupon_code')
  final String? couponCode;
  @override
  @JsonKey(name: 'discount_amount')
  final int discountAmount;
  @override
  @JsonKey(name: 'discount_type')
  final String? discountType;
  @override
  @JsonKey(name: 'discount_value')
  final int? discountValue;

  @override
  String toString() {
    return 'Cart(items: $items, couponCode: $couponCode, discountAmount: $discountAmount, discountType: $discountType, discountValue: $discountValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.couponCode, couponCode) ||
                other.couponCode == couponCode) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.discountValue, discountValue) ||
                other.discountValue == discountValue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      couponCode,
      discountAmount,
      discountType,
      discountValue);

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartImplCopyWith<_$CartImpl> get copyWith =>
      __$$CartImplCopyWithImpl<_$CartImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartImplToJson(
      this,
    );
  }
}

abstract class _Cart extends Cart {
  const factory _Cart(
      {final List<CartItem> items,
      @JsonKey(name: 'coupon_code') final String? couponCode,
      @JsonKey(name: 'discount_amount') final int discountAmount,
      @JsonKey(name: 'discount_type') final String? discountType,
      @JsonKey(name: 'discount_value') final int? discountValue}) = _$CartImpl;
  const _Cart._() : super._();

  factory _Cart.fromJson(Map<String, dynamic> json) = _$CartImpl.fromJson;

  @override
  List<CartItem> get items;
  @override
  @JsonKey(name: 'coupon_code')
  String? get couponCode;
  @override
  @JsonKey(name: 'discount_amount')
  int get discountAmount;
  @override
  @JsonKey(name: 'discount_type')
  String? get discountType;
  @override
  @JsonKey(name: 'discount_value')
  int? get discountValue;

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartImplCopyWith<_$CartImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
