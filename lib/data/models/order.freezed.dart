// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) {
  return _OrderItem.fromJson(json);
}

/// @nodoc
mixin _$OrderItem {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_id')
  int get orderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_id')
  int? get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_name')
  String get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_price')
  int get productPrice => throw _privateConstructorUsedError; // En centavos
  int get quantity => throw _privateConstructorUsedError;
  String? get size => throw _privateConstructorUsedError;

  /// Serializes this OrderItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemCopyWith<OrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemCopyWith<$Res> {
  factory $OrderItemCopyWith(OrderItem value, $Res Function(OrderItem) then) =
      _$OrderItemCopyWithImpl<$Res, OrderItem>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'order_id') int orderId,
      @JsonKey(name: 'product_id') int? productId,
      @JsonKey(name: 'product_name') String productName,
      @JsonKey(name: 'product_price') int productPrice,
      int quantity,
      String? size});
}

/// @nodoc
class _$OrderItemCopyWithImpl<$Res, $Val extends OrderItem>
    implements $OrderItemCopyWith<$Res> {
  _$OrderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? productId = freezed,
    Object? productName = null,
    Object? productPrice = null,
    Object? quantity = null,
    Object? size = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int?,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      productPrice: null == productPrice
          ? _value.productPrice
          : productPrice // ignore: cast_nullable_to_non_nullable
              as int,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderItemImplCopyWith<$Res>
    implements $OrderItemCopyWith<$Res> {
  factory _$$OrderItemImplCopyWith(
          _$OrderItemImpl value, $Res Function(_$OrderItemImpl) then) =
      __$$OrderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'order_id') int orderId,
      @JsonKey(name: 'product_id') int? productId,
      @JsonKey(name: 'product_name') String productName,
      @JsonKey(name: 'product_price') int productPrice,
      int quantity,
      String? size});
}

/// @nodoc
class __$$OrderItemImplCopyWithImpl<$Res>
    extends _$OrderItemCopyWithImpl<$Res, _$OrderItemImpl>
    implements _$$OrderItemImplCopyWith<$Res> {
  __$$OrderItemImplCopyWithImpl(
      _$OrderItemImpl _value, $Res Function(_$OrderItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? productId = freezed,
    Object? productName = null,
    Object? productPrice = null,
    Object? quantity = null,
    Object? size = freezed,
  }) {
    return _then(_$OrderItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int?,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      productPrice: null == productPrice
          ? _value.productPrice
          : productPrice // ignore: cast_nullable_to_non_nullable
              as int,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderItemImpl extends _OrderItem {
  const _$OrderItemImpl(
      {required this.id,
      @JsonKey(name: 'order_id') required this.orderId,
      @JsonKey(name: 'product_id') this.productId,
      @JsonKey(name: 'product_name') required this.productName,
      @JsonKey(name: 'product_price') required this.productPrice,
      required this.quantity,
      this.size})
      : super._();

  factory _$OrderItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'order_id')
  final int orderId;
  @override
  @JsonKey(name: 'product_id')
  final int? productId;
  @override
  @JsonKey(name: 'product_name')
  final String productName;
  @override
  @JsonKey(name: 'product_price')
  final int productPrice;
// En centavos
  @override
  final int quantity;
  @override
  final String? size;

  @override
  String toString() {
    return 'OrderItem(id: $id, orderId: $orderId, productId: $productId, productName: $productName, productPrice: $productPrice, quantity: $quantity, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productPrice, productPrice) ||
                other.productPrice == productPrice) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.size, size) || other.size == size));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, orderId, productId,
      productName, productPrice, quantity, size);

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      __$$OrderItemImplCopyWithImpl<_$OrderItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemImplToJson(
      this,
    );
  }
}

abstract class _OrderItem extends OrderItem {
  const factory _OrderItem(
      {required final int id,
      @JsonKey(name: 'order_id') required final int orderId,
      @JsonKey(name: 'product_id') final int? productId,
      @JsonKey(name: 'product_name') required final String productName,
      @JsonKey(name: 'product_price') required final int productPrice,
      required final int quantity,
      final String? size}) = _$OrderItemImpl;
  const _OrderItem._() : super._();

  factory _OrderItem.fromJson(Map<String, dynamic> json) =
      _$OrderItemImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'order_id')
  int get orderId;
  @override
  @JsonKey(name: 'product_id')
  int? get productId;
  @override
  @JsonKey(name: 'product_name')
  String get productName;
  @override
  @JsonKey(name: 'product_price')
  int get productPrice; // En centavos
  @override
  int get quantity;
  @override
  String? get size;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Order {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_email')
  String get customerEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_name')
  String get customerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_address')
  String get customerAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_city')
  String get customerCity => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_postal_code')
  String get customerPostalCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_phone')
  String? get customerPhone => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError; // En centavos
  int? get subtotal => throw _privateConstructorUsedError; // En centavos
  int get discount => throw _privateConstructorUsedError; // En centavos
  @JsonKey(name: 'shipping_cost')
  int get shippingCost => throw _privateConstructorUsedError; // En centavos
  @JsonKey(name: 'shipping_method_id')
  int? get shippingMethodId => throw _privateConstructorUsedError;
  @JsonKey(name: 'carrier_id')
  int? get carrierId => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get carrierName => throw _privateConstructorUsedError;
  @JsonKey(name: 'tracking_number')
  String? get trackingNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'stripe_payment_intent_id')
  String? get stripePaymentIntentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_items', includeToJson: false)
  List<OrderItem> get items => throw _privateConstructorUsedError;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderCopyWith<Order> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) then) =
      _$OrderCopyWithImpl<$Res, Order>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'customer_email') String customerEmail,
      @JsonKey(name: 'customer_name') String customerName,
      @JsonKey(name: 'customer_address') String customerAddress,
      @JsonKey(name: 'customer_city') String customerCity,
      @JsonKey(name: 'customer_postal_code') String customerPostalCode,
      @JsonKey(name: 'customer_phone') String? customerPhone,
      String status,
      int total,
      int? subtotal,
      int discount,
      @JsonKey(name: 'shipping_cost') int shippingCost,
      @JsonKey(name: 'shipping_method_id') int? shippingMethodId,
      @JsonKey(name: 'carrier_id') int? carrierId,
      @JsonKey(includeFromJson: false, includeToJson: false)
      String? carrierName,
      @JsonKey(name: 'tracking_number') String? trackingNumber,
      @JsonKey(name: 'stripe_payment_intent_id') String? stripePaymentIntentId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'order_items', includeToJson: false)
      List<OrderItem> items});
}

/// @nodoc
class _$OrderCopyWithImpl<$Res, $Val extends Order>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customerEmail = null,
    Object? customerName = null,
    Object? customerAddress = null,
    Object? customerCity = null,
    Object? customerPostalCode = null,
    Object? customerPhone = freezed,
    Object? status = null,
    Object? total = null,
    Object? subtotal = freezed,
    Object? discount = null,
    Object? shippingCost = null,
    Object? shippingMethodId = freezed,
    Object? carrierId = freezed,
    Object? carrierName = freezed,
    Object? trackingNumber = freezed,
    Object? stripePaymentIntentId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      customerEmail: null == customerEmail
          ? _value.customerEmail
          : customerEmail // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerAddress: null == customerAddress
          ? _value.customerAddress
          : customerAddress // ignore: cast_nullable_to_non_nullable
              as String,
      customerCity: null == customerCity
          ? _value.customerCity
          : customerCity // ignore: cast_nullable_to_non_nullable
              as String,
      customerPostalCode: null == customerPostalCode
          ? _value.customerPostalCode
          : customerPostalCode // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      subtotal: freezed == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as int?,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as int,
      shippingCost: null == shippingCost
          ? _value.shippingCost
          : shippingCost // ignore: cast_nullable_to_non_nullable
              as int,
      shippingMethodId: freezed == shippingMethodId
          ? _value.shippingMethodId
          : shippingMethodId // ignore: cast_nullable_to_non_nullable
              as int?,
      carrierId: freezed == carrierId
          ? _value.carrierId
          : carrierId // ignore: cast_nullable_to_non_nullable
              as int?,
      carrierName: freezed == carrierName
          ? _value.carrierName
          : carrierName // ignore: cast_nullable_to_non_nullable
              as String?,
      trackingNumber: freezed == trackingNumber
          ? _value.trackingNumber
          : trackingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      stripePaymentIntentId: freezed == stripePaymentIntentId
          ? _value.stripePaymentIntentId
          : stripePaymentIntentId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderImplCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$$OrderImplCopyWith(
          _$OrderImpl value, $Res Function(_$OrderImpl) then) =
      __$$OrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'customer_email') String customerEmail,
      @JsonKey(name: 'customer_name') String customerName,
      @JsonKey(name: 'customer_address') String customerAddress,
      @JsonKey(name: 'customer_city') String customerCity,
      @JsonKey(name: 'customer_postal_code') String customerPostalCode,
      @JsonKey(name: 'customer_phone') String? customerPhone,
      String status,
      int total,
      int? subtotal,
      int discount,
      @JsonKey(name: 'shipping_cost') int shippingCost,
      @JsonKey(name: 'shipping_method_id') int? shippingMethodId,
      @JsonKey(name: 'carrier_id') int? carrierId,
      @JsonKey(includeFromJson: false, includeToJson: false)
      String? carrierName,
      @JsonKey(name: 'tracking_number') String? trackingNumber,
      @JsonKey(name: 'stripe_payment_intent_id') String? stripePaymentIntentId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'order_items', includeToJson: false)
      List<OrderItem> items});
}

/// @nodoc
class __$$OrderImplCopyWithImpl<$Res>
    extends _$OrderCopyWithImpl<$Res, _$OrderImpl>
    implements _$$OrderImplCopyWith<$Res> {
  __$$OrderImplCopyWithImpl(
      _$OrderImpl _value, $Res Function(_$OrderImpl) _then)
      : super(_value, _then);

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customerEmail = null,
    Object? customerName = null,
    Object? customerAddress = null,
    Object? customerCity = null,
    Object? customerPostalCode = null,
    Object? customerPhone = freezed,
    Object? status = null,
    Object? total = null,
    Object? subtotal = freezed,
    Object? discount = null,
    Object? shippingCost = null,
    Object? shippingMethodId = freezed,
    Object? carrierId = freezed,
    Object? carrierName = freezed,
    Object? trackingNumber = freezed,
    Object? stripePaymentIntentId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? items = null,
  }) {
    return _then(_$OrderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      customerEmail: null == customerEmail
          ? _value.customerEmail
          : customerEmail // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerAddress: null == customerAddress
          ? _value.customerAddress
          : customerAddress // ignore: cast_nullable_to_non_nullable
              as String,
      customerCity: null == customerCity
          ? _value.customerCity
          : customerCity // ignore: cast_nullable_to_non_nullable
              as String,
      customerPostalCode: null == customerPostalCode
          ? _value.customerPostalCode
          : customerPostalCode // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      subtotal: freezed == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as int?,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as int,
      shippingCost: null == shippingCost
          ? _value.shippingCost
          : shippingCost // ignore: cast_nullable_to_non_nullable
              as int,
      shippingMethodId: freezed == shippingMethodId
          ? _value.shippingMethodId
          : shippingMethodId // ignore: cast_nullable_to_non_nullable
              as int?,
      carrierId: freezed == carrierId
          ? _value.carrierId
          : carrierId // ignore: cast_nullable_to_non_nullable
              as int?,
      carrierName: freezed == carrierName
          ? _value.carrierName
          : carrierName // ignore: cast_nullable_to_non_nullable
              as String?,
      trackingNumber: freezed == trackingNumber
          ? _value.trackingNumber
          : trackingNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      stripePaymentIntentId: freezed == stripePaymentIntentId
          ? _value.stripePaymentIntentId
          : stripePaymentIntentId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OrderItem>,
    ));
  }
}

/// @nodoc

class _$OrderImpl extends _Order {
  const _$OrderImpl(
      {required this.id,
      @JsonKey(name: 'customer_email') required this.customerEmail,
      @JsonKey(name: 'customer_name') required this.customerName,
      @JsonKey(name: 'customer_address') required this.customerAddress,
      @JsonKey(name: 'customer_city') required this.customerCity,
      @JsonKey(name: 'customer_postal_code') required this.customerPostalCode,
      @JsonKey(name: 'customer_phone') this.customerPhone,
      this.status = 'pending',
      required this.total,
      this.subtotal,
      this.discount = 0,
      @JsonKey(name: 'shipping_cost') this.shippingCost = 0,
      @JsonKey(name: 'shipping_method_id') this.shippingMethodId,
      @JsonKey(name: 'carrier_id') this.carrierId,
      @JsonKey(includeFromJson: false, includeToJson: false) this.carrierName,
      @JsonKey(name: 'tracking_number') this.trackingNumber,
      @JsonKey(name: 'stripe_payment_intent_id') this.stripePaymentIntentId,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'order_items', includeToJson: false)
      final List<OrderItem> items = const []})
      : _items = items,
        super._();

  @override
  final int id;
  @override
  @JsonKey(name: 'customer_email')
  final String customerEmail;
  @override
  @JsonKey(name: 'customer_name')
  final String customerName;
  @override
  @JsonKey(name: 'customer_address')
  final String customerAddress;
  @override
  @JsonKey(name: 'customer_city')
  final String customerCity;
  @override
  @JsonKey(name: 'customer_postal_code')
  final String customerPostalCode;
  @override
  @JsonKey(name: 'customer_phone')
  final String? customerPhone;
  @override
  @JsonKey()
  final String status;
  @override
  final int total;
// En centavos
  @override
  final int? subtotal;
// En centavos
  @override
  @JsonKey()
  final int discount;
// En centavos
  @override
  @JsonKey(name: 'shipping_cost')
  final int shippingCost;
// En centavos
  @override
  @JsonKey(name: 'shipping_method_id')
  final int? shippingMethodId;
  @override
  @JsonKey(name: 'carrier_id')
  final int? carrierId;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? carrierName;
  @override
  @JsonKey(name: 'tracking_number')
  final String? trackingNumber;
  @override
  @JsonKey(name: 'stripe_payment_intent_id')
  final String? stripePaymentIntentId;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final List<OrderItem> _items;
  @override
  @JsonKey(name: 'order_items', includeToJson: false)
  List<OrderItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'Order(id: $id, customerEmail: $customerEmail, customerName: $customerName, customerAddress: $customerAddress, customerCity: $customerCity, customerPostalCode: $customerPostalCode, customerPhone: $customerPhone, status: $status, total: $total, subtotal: $subtotal, discount: $discount, shippingCost: $shippingCost, shippingMethodId: $shippingMethodId, carrierId: $carrierId, carrierName: $carrierName, trackingNumber: $trackingNumber, stripePaymentIntentId: $stripePaymentIntentId, createdAt: $createdAt, updatedAt: $updatedAt, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.customerEmail, customerEmail) ||
                other.customerEmail == customerEmail) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerAddress, customerAddress) ||
                other.customerAddress == customerAddress) &&
            (identical(other.customerCity, customerCity) ||
                other.customerCity == customerCity) &&
            (identical(other.customerPostalCode, customerPostalCode) ||
                other.customerPostalCode == customerPostalCode) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.shippingCost, shippingCost) ||
                other.shippingCost == shippingCost) &&
            (identical(other.shippingMethodId, shippingMethodId) ||
                other.shippingMethodId == shippingMethodId) &&
            (identical(other.carrierId, carrierId) ||
                other.carrierId == carrierId) &&
            (identical(other.carrierName, carrierName) ||
                other.carrierName == carrierName) &&
            (identical(other.trackingNumber, trackingNumber) ||
                other.trackingNumber == trackingNumber) &&
            (identical(other.stripePaymentIntentId, stripePaymentIntentId) ||
                other.stripePaymentIntentId == stripePaymentIntentId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        customerEmail,
        customerName,
        customerAddress,
        customerCity,
        customerPostalCode,
        customerPhone,
        status,
        total,
        subtotal,
        discount,
        shippingCost,
        shippingMethodId,
        carrierId,
        carrierName,
        trackingNumber,
        stripePaymentIntentId,
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(_items)
      ]);

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      __$$OrderImplCopyWithImpl<_$OrderImpl>(this, _$identity);
}

abstract class _Order extends Order {
  const factory _Order(
      {required final int id,
      @JsonKey(name: 'customer_email') required final String customerEmail,
      @JsonKey(name: 'customer_name') required final String customerName,
      @JsonKey(name: 'customer_address') required final String customerAddress,
      @JsonKey(name: 'customer_city') required final String customerCity,
      @JsonKey(name: 'customer_postal_code')
      required final String customerPostalCode,
      @JsonKey(name: 'customer_phone') final String? customerPhone,
      final String status,
      required final int total,
      final int? subtotal,
      final int discount,
      @JsonKey(name: 'shipping_cost') final int shippingCost,
      @JsonKey(name: 'shipping_method_id') final int? shippingMethodId,
      @JsonKey(name: 'carrier_id') final int? carrierId,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final String? carrierName,
      @JsonKey(name: 'tracking_number') final String? trackingNumber,
      @JsonKey(name: 'stripe_payment_intent_id')
      final String? stripePaymentIntentId,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      @JsonKey(name: 'order_items', includeToJson: false)
      final List<OrderItem> items}) = _$OrderImpl;
  const _Order._() : super._();

  @override
  int get id;
  @override
  @JsonKey(name: 'customer_email')
  String get customerEmail;
  @override
  @JsonKey(name: 'customer_name')
  String get customerName;
  @override
  @JsonKey(name: 'customer_address')
  String get customerAddress;
  @override
  @JsonKey(name: 'customer_city')
  String get customerCity;
  @override
  @JsonKey(name: 'customer_postal_code')
  String get customerPostalCode;
  @override
  @JsonKey(name: 'customer_phone')
  String? get customerPhone;
  @override
  String get status;
  @override
  int get total; // En centavos
  @override
  int? get subtotal; // En centavos
  @override
  int get discount; // En centavos
  @override
  @JsonKey(name: 'shipping_cost')
  int get shippingCost; // En centavos
  @override
  @JsonKey(name: 'shipping_method_id')
  int? get shippingMethodId;
  @override
  @JsonKey(name: 'carrier_id')
  int? get carrierId;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get carrierName;
  @override
  @JsonKey(name: 'tracking_number')
  String? get trackingNumber;
  @override
  @JsonKey(name: 'stripe_payment_intent_id')
  String? get stripePaymentIntentId;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(name: 'order_items', includeToJson: false)
  List<OrderItem> get items;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
