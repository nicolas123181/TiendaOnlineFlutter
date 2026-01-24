// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InvoiceItem {
  int get id => throw _privateConstructorUsedError;
  int get invoiceId => throw _privateConstructorUsedError;
  int? get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String? get productSku => throw _privateConstructorUsedError;
  String? get productSize => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  int get unitPrice => throw _privateConstructorUsedError; // En centavos
  double get discountPercent => throw _privateConstructorUsedError;
  int get lineTotal => throw _privateConstructorUsedError; // En centavos
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of InvoiceItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InvoiceItemCopyWith<InvoiceItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceItemCopyWith<$Res> {
  factory $InvoiceItemCopyWith(
          InvoiceItem value, $Res Function(InvoiceItem) then) =
      _$InvoiceItemCopyWithImpl<$Res, InvoiceItem>;
  @useResult
  $Res call(
      {int id,
      int invoiceId,
      int? productId,
      String productName,
      String? productSku,
      String? productSize,
      int quantity,
      int unitPrice,
      double discountPercent,
      int lineTotal,
      DateTime createdAt});
}

/// @nodoc
class _$InvoiceItemCopyWithImpl<$Res, $Val extends InvoiceItem>
    implements $InvoiceItemCopyWith<$Res> {
  _$InvoiceItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InvoiceItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? invoiceId = null,
    Object? productId = freezed,
    Object? productName = null,
    Object? productSku = freezed,
    Object? productSize = freezed,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? discountPercent = null,
    Object? lineTotal = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      invoiceId: null == invoiceId
          ? _value.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as int,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int?,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      productSku: freezed == productSku
          ? _value.productSku
          : productSku // ignore: cast_nullable_to_non_nullable
              as String?,
      productSize: freezed == productSize
          ? _value.productSize
          : productSize // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as int,
      discountPercent: null == discountPercent
          ? _value.discountPercent
          : discountPercent // ignore: cast_nullable_to_non_nullable
              as double,
      lineTotal: null == lineTotal
          ? _value.lineTotal
          : lineTotal // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvoiceItemImplCopyWith<$Res>
    implements $InvoiceItemCopyWith<$Res> {
  factory _$$InvoiceItemImplCopyWith(
          _$InvoiceItemImpl value, $Res Function(_$InvoiceItemImpl) then) =
      __$$InvoiceItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int invoiceId,
      int? productId,
      String productName,
      String? productSku,
      String? productSize,
      int quantity,
      int unitPrice,
      double discountPercent,
      int lineTotal,
      DateTime createdAt});
}

/// @nodoc
class __$$InvoiceItemImplCopyWithImpl<$Res>
    extends _$InvoiceItemCopyWithImpl<$Res, _$InvoiceItemImpl>
    implements _$$InvoiceItemImplCopyWith<$Res> {
  __$$InvoiceItemImplCopyWithImpl(
      _$InvoiceItemImpl _value, $Res Function(_$InvoiceItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of InvoiceItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? invoiceId = null,
    Object? productId = freezed,
    Object? productName = null,
    Object? productSku = freezed,
    Object? productSize = freezed,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? discountPercent = null,
    Object? lineTotal = null,
    Object? createdAt = null,
  }) {
    return _then(_$InvoiceItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      invoiceId: null == invoiceId
          ? _value.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as int,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int?,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      productSku: freezed == productSku
          ? _value.productSku
          : productSku // ignore: cast_nullable_to_non_nullable
              as String?,
      productSize: freezed == productSize
          ? _value.productSize
          : productSize // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as int,
      discountPercent: null == discountPercent
          ? _value.discountPercent
          : discountPercent // ignore: cast_nullable_to_non_nullable
              as double,
      lineTotal: null == lineTotal
          ? _value.lineTotal
          : lineTotal // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$InvoiceItemImpl extends _InvoiceItem {
  const _$InvoiceItemImpl(
      {required this.id,
      required this.invoiceId,
      this.productId,
      required this.productName,
      this.productSku,
      this.productSize,
      required this.quantity,
      required this.unitPrice,
      this.discountPercent = 0.0,
      required this.lineTotal,
      required this.createdAt})
      : super._();

  @override
  final int id;
  @override
  final int invoiceId;
  @override
  final int? productId;
  @override
  final String productName;
  @override
  final String? productSku;
  @override
  final String? productSize;
  @override
  final int quantity;
  @override
  final int unitPrice;
// En centavos
  @override
  @JsonKey()
  final double discountPercent;
  @override
  final int lineTotal;
// En centavos
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'InvoiceItem(id: $id, invoiceId: $invoiceId, productId: $productId, productName: $productName, productSku: $productSku, productSize: $productSize, quantity: $quantity, unitPrice: $unitPrice, discountPercent: $discountPercent, lineTotal: $lineTotal, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.invoiceId, invoiceId) ||
                other.invoiceId == invoiceId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productSku, productSku) ||
                other.productSku == productSku) &&
            (identical(other.productSize, productSize) ||
                other.productSize == productSize) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.discountPercent, discountPercent) ||
                other.discountPercent == discountPercent) &&
            (identical(other.lineTotal, lineTotal) ||
                other.lineTotal == lineTotal) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      invoiceId,
      productId,
      productName,
      productSku,
      productSize,
      quantity,
      unitPrice,
      discountPercent,
      lineTotal,
      createdAt);

  /// Create a copy of InvoiceItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceItemImplCopyWith<_$InvoiceItemImpl> get copyWith =>
      __$$InvoiceItemImplCopyWithImpl<_$InvoiceItemImpl>(this, _$identity);
}

abstract class _InvoiceItem extends InvoiceItem {
  const factory _InvoiceItem(
      {required final int id,
      required final int invoiceId,
      final int? productId,
      required final String productName,
      final String? productSku,
      final String? productSize,
      required final int quantity,
      required final int unitPrice,
      final double discountPercent,
      required final int lineTotal,
      required final DateTime createdAt}) = _$InvoiceItemImpl;
  const _InvoiceItem._() : super._();

  @override
  int get id;
  @override
  int get invoiceId;
  @override
  int? get productId;
  @override
  String get productName;
  @override
  String? get productSku;
  @override
  String? get productSize;
  @override
  int get quantity;
  @override
  int get unitPrice; // En centavos
  @override
  double get discountPercent;
  @override
  int get lineTotal; // En centavos
  @override
  DateTime get createdAt;

  /// Create a copy of InvoiceItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvoiceItemImplCopyWith<_$InvoiceItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Invoice {
  int get id => throw _privateConstructorUsedError;
  String get invoiceNumber => throw _privateConstructorUsedError;
  int get orderId => throw _privateConstructorUsedError; // Datos del cliente
  String get customerName => throw _privateConstructorUsedError;
  String get customerEmail => throw _privateConstructorUsedError;
  String? get customerAddress => throw _privateConstructorUsedError;
  String? get customerCity => throw _privateConstructorUsedError;
  String? get customerPostalCode => throw _privateConstructorUsedError;
  String? get customerPhone =>
      throw _privateConstructorUsedError; // Datos de la empresa
  String get companyName => throw _privateConstructorUsedError;
  String? get companyAddress => throw _privateConstructorUsedError;
  String? get companyNif => throw _privateConstructorUsedError;
  String? get companyEmail => throw _privateConstructorUsedError;
  String? get companyPhone => throw _privateConstructorUsedError; // Importes
  int get subtotal => throw _privateConstructorUsedError; // En centavos
  int get shippingCost => throw _privateConstructorUsedError; // En centavos
  int get discount => throw _privateConstructorUsedError; // En centavos
  double get taxRate => throw _privateConstructorUsedError;
  int get taxAmount => throw _privateConstructorUsedError; // En centavos
  int get total => throw _privateConstructorUsedError; // En centavos
// Pago
  String get paymentMethod => throw _privateConstructorUsedError;
  String get paymentStatus => throw _privateConstructorUsedError; // Fechas
  DateTime get issueDate => throw _privateConstructorUsedError;
  DateTime? get dueDate => throw _privateConstructorUsedError; // Estado y PDF
  String get status => throw _privateConstructorUsedError;
  String? get pdfUrl => throw _privateConstructorUsedError;
  DateTime? get pdfGeneratedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<InvoiceItem> get items => throw _privateConstructorUsedError;

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InvoiceCopyWith<Invoice> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvoiceCopyWith<$Res> {
  factory $InvoiceCopyWith(Invoice value, $Res Function(Invoice) then) =
      _$InvoiceCopyWithImpl<$Res, Invoice>;
  @useResult
  $Res call(
      {int id,
      String invoiceNumber,
      int orderId,
      String customerName,
      String customerEmail,
      String? customerAddress,
      String? customerCity,
      String? customerPostalCode,
      String? customerPhone,
      String companyName,
      String? companyAddress,
      String? companyNif,
      String? companyEmail,
      String? companyPhone,
      int subtotal,
      int shippingCost,
      int discount,
      double taxRate,
      int taxAmount,
      int total,
      String paymentMethod,
      String paymentStatus,
      DateTime issueDate,
      DateTime? dueDate,
      String status,
      String? pdfUrl,
      DateTime? pdfGeneratedAt,
      String? notes,
      DateTime createdAt,
      DateTime updatedAt,
      List<InvoiceItem> items});
}

/// @nodoc
class _$InvoiceCopyWithImpl<$Res, $Val extends Invoice>
    implements $InvoiceCopyWith<$Res> {
  _$InvoiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? invoiceNumber = null,
    Object? orderId = null,
    Object? customerName = null,
    Object? customerEmail = null,
    Object? customerAddress = freezed,
    Object? customerCity = freezed,
    Object? customerPostalCode = freezed,
    Object? customerPhone = freezed,
    Object? companyName = null,
    Object? companyAddress = freezed,
    Object? companyNif = freezed,
    Object? companyEmail = freezed,
    Object? companyPhone = freezed,
    Object? subtotal = null,
    Object? shippingCost = null,
    Object? discount = null,
    Object? taxRate = null,
    Object? taxAmount = null,
    Object? total = null,
    Object? paymentMethod = null,
    Object? paymentStatus = null,
    Object? issueDate = null,
    Object? dueDate = freezed,
    Object? status = null,
    Object? pdfUrl = freezed,
    Object? pdfGeneratedAt = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      invoiceNumber: null == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerEmail: null == customerEmail
          ? _value.customerEmail
          : customerEmail // ignore: cast_nullable_to_non_nullable
              as String,
      customerAddress: freezed == customerAddress
          ? _value.customerAddress
          : customerAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      customerCity: freezed == customerCity
          ? _value.customerCity
          : customerCity // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPostalCode: freezed == customerPostalCode
          ? _value.customerPostalCode
          : customerPostalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      companyAddress: freezed == companyAddress
          ? _value.companyAddress
          : companyAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      companyNif: freezed == companyNif
          ? _value.companyNif
          : companyNif // ignore: cast_nullable_to_non_nullable
              as String?,
      companyEmail: freezed == companyEmail
          ? _value.companyEmail
          : companyEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      companyPhone: freezed == companyPhone
          ? _value.companyPhone
          : companyPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as int,
      shippingCost: null == shippingCost
          ? _value.shippingCost
          : shippingCost // ignore: cast_nullable_to_non_nullable
              as int,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as int,
      taxRate: null == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as double,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      issueDate: null == issueDate
          ? _value.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      pdfUrl: freezed == pdfUrl
          ? _value.pdfUrl
          : pdfUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      pdfGeneratedAt: freezed == pdfGeneratedAt
          ? _value.pdfGeneratedAt
          : pdfGeneratedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
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
              as List<InvoiceItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvoiceImplCopyWith<$Res> implements $InvoiceCopyWith<$Res> {
  factory _$$InvoiceImplCopyWith(
          _$InvoiceImpl value, $Res Function(_$InvoiceImpl) then) =
      __$$InvoiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String invoiceNumber,
      int orderId,
      String customerName,
      String customerEmail,
      String? customerAddress,
      String? customerCity,
      String? customerPostalCode,
      String? customerPhone,
      String companyName,
      String? companyAddress,
      String? companyNif,
      String? companyEmail,
      String? companyPhone,
      int subtotal,
      int shippingCost,
      int discount,
      double taxRate,
      int taxAmount,
      int total,
      String paymentMethod,
      String paymentStatus,
      DateTime issueDate,
      DateTime? dueDate,
      String status,
      String? pdfUrl,
      DateTime? pdfGeneratedAt,
      String? notes,
      DateTime createdAt,
      DateTime updatedAt,
      List<InvoiceItem> items});
}

/// @nodoc
class __$$InvoiceImplCopyWithImpl<$Res>
    extends _$InvoiceCopyWithImpl<$Res, _$InvoiceImpl>
    implements _$$InvoiceImplCopyWith<$Res> {
  __$$InvoiceImplCopyWithImpl(
      _$InvoiceImpl _value, $Res Function(_$InvoiceImpl) _then)
      : super(_value, _then);

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? invoiceNumber = null,
    Object? orderId = null,
    Object? customerName = null,
    Object? customerEmail = null,
    Object? customerAddress = freezed,
    Object? customerCity = freezed,
    Object? customerPostalCode = freezed,
    Object? customerPhone = freezed,
    Object? companyName = null,
    Object? companyAddress = freezed,
    Object? companyNif = freezed,
    Object? companyEmail = freezed,
    Object? companyPhone = freezed,
    Object? subtotal = null,
    Object? shippingCost = null,
    Object? discount = null,
    Object? taxRate = null,
    Object? taxAmount = null,
    Object? total = null,
    Object? paymentMethod = null,
    Object? paymentStatus = null,
    Object? issueDate = null,
    Object? dueDate = freezed,
    Object? status = null,
    Object? pdfUrl = freezed,
    Object? pdfGeneratedAt = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? items = null,
  }) {
    return _then(_$InvoiceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      invoiceNumber: null == invoiceNumber
          ? _value.invoiceNumber
          : invoiceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerEmail: null == customerEmail
          ? _value.customerEmail
          : customerEmail // ignore: cast_nullable_to_non_nullable
              as String,
      customerAddress: freezed == customerAddress
          ? _value.customerAddress
          : customerAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      customerCity: freezed == customerCity
          ? _value.customerCity
          : customerCity // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPostalCode: freezed == customerPostalCode
          ? _value.customerPostalCode
          : customerPostalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: freezed == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      companyAddress: freezed == companyAddress
          ? _value.companyAddress
          : companyAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      companyNif: freezed == companyNif
          ? _value.companyNif
          : companyNif // ignore: cast_nullable_to_non_nullable
              as String?,
      companyEmail: freezed == companyEmail
          ? _value.companyEmail
          : companyEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      companyPhone: freezed == companyPhone
          ? _value.companyPhone
          : companyPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as int,
      shippingCost: null == shippingCost
          ? _value.shippingCost
          : shippingCost // ignore: cast_nullable_to_non_nullable
              as int,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as int,
      taxRate: null == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as double,
      taxAmount: null == taxAmount
          ? _value.taxAmount
          : taxAmount // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      issueDate: null == issueDate
          ? _value.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      pdfUrl: freezed == pdfUrl
          ? _value.pdfUrl
          : pdfUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      pdfGeneratedAt: freezed == pdfGeneratedAt
          ? _value.pdfGeneratedAt
          : pdfGeneratedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
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
              as List<InvoiceItem>,
    ));
  }
}

/// @nodoc

class _$InvoiceImpl extends _Invoice {
  const _$InvoiceImpl(
      {required this.id,
      required this.invoiceNumber,
      required this.orderId,
      required this.customerName,
      required this.customerEmail,
      this.customerAddress,
      this.customerCity,
      this.customerPostalCode,
      this.customerPhone,
      this.companyName = 'Vantage Fashion S.L.',
      this.companyAddress,
      this.companyNif,
      this.companyEmail,
      this.companyPhone,
      required this.subtotal,
      this.shippingCost = 0,
      this.discount = 0,
      this.taxRate = 21.0,
      required this.taxAmount,
      required this.total,
      this.paymentMethod = 'Tarjeta de crédito',
      this.paymentStatus = 'paid',
      required this.issueDate,
      this.dueDate,
      this.status = 'issued',
      this.pdfUrl,
      this.pdfGeneratedAt,
      this.notes,
      required this.createdAt,
      required this.updatedAt,
      final List<InvoiceItem> items = const []})
      : _items = items,
        super._();

  @override
  final int id;
  @override
  final String invoiceNumber;
  @override
  final int orderId;
// Datos del cliente
  @override
  final String customerName;
  @override
  final String customerEmail;
  @override
  final String? customerAddress;
  @override
  final String? customerCity;
  @override
  final String? customerPostalCode;
  @override
  final String? customerPhone;
// Datos de la empresa
  @override
  @JsonKey()
  final String companyName;
  @override
  final String? companyAddress;
  @override
  final String? companyNif;
  @override
  final String? companyEmail;
  @override
  final String? companyPhone;
// Importes
  @override
  final int subtotal;
// En centavos
  @override
  @JsonKey()
  final int shippingCost;
// En centavos
  @override
  @JsonKey()
  final int discount;
// En centavos
  @override
  @JsonKey()
  final double taxRate;
  @override
  final int taxAmount;
// En centavos
  @override
  final int total;
// En centavos
// Pago
  @override
  @JsonKey()
  final String paymentMethod;
  @override
  @JsonKey()
  final String paymentStatus;
// Fechas
  @override
  final DateTime issueDate;
  @override
  final DateTime? dueDate;
// Estado y PDF
  @override
  @JsonKey()
  final String status;
  @override
  final String? pdfUrl;
  @override
  final DateTime? pdfGeneratedAt;
  @override
  final String? notes;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final List<InvoiceItem> _items;
  @override
  @JsonKey()
  List<InvoiceItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'Invoice(id: $id, invoiceNumber: $invoiceNumber, orderId: $orderId, customerName: $customerName, customerEmail: $customerEmail, customerAddress: $customerAddress, customerCity: $customerCity, customerPostalCode: $customerPostalCode, customerPhone: $customerPhone, companyName: $companyName, companyAddress: $companyAddress, companyNif: $companyNif, companyEmail: $companyEmail, companyPhone: $companyPhone, subtotal: $subtotal, shippingCost: $shippingCost, discount: $discount, taxRate: $taxRate, taxAmount: $taxAmount, total: $total, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, issueDate: $issueDate, dueDate: $dueDate, status: $status, pdfUrl: $pdfUrl, pdfGeneratedAt: $pdfGeneratedAt, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvoiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.invoiceNumber, invoiceNumber) ||
                other.invoiceNumber == invoiceNumber) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerEmail, customerEmail) ||
                other.customerEmail == customerEmail) &&
            (identical(other.customerAddress, customerAddress) ||
                other.customerAddress == customerAddress) &&
            (identical(other.customerCity, customerCity) ||
                other.customerCity == customerCity) &&
            (identical(other.customerPostalCode, customerPostalCode) ||
                other.customerPostalCode == customerPostalCode) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.companyAddress, companyAddress) ||
                other.companyAddress == companyAddress) &&
            (identical(other.companyNif, companyNif) ||
                other.companyNif == companyNif) &&
            (identical(other.companyEmail, companyEmail) ||
                other.companyEmail == companyEmail) &&
            (identical(other.companyPhone, companyPhone) ||
                other.companyPhone == companyPhone) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.shippingCost, shippingCost) ||
                other.shippingCost == shippingCost) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.issueDate, issueDate) ||
                other.issueDate == issueDate) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.pdfUrl, pdfUrl) || other.pdfUrl == pdfUrl) &&
            (identical(other.pdfGeneratedAt, pdfGeneratedAt) ||
                other.pdfGeneratedAt == pdfGeneratedAt) &&
            (identical(other.notes, notes) || other.notes == notes) &&
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
        invoiceNumber,
        orderId,
        customerName,
        customerEmail,
        customerAddress,
        customerCity,
        customerPostalCode,
        customerPhone,
        companyName,
        companyAddress,
        companyNif,
        companyEmail,
        companyPhone,
        subtotal,
        shippingCost,
        discount,
        taxRate,
        taxAmount,
        total,
        paymentMethod,
        paymentStatus,
        issueDate,
        dueDate,
        status,
        pdfUrl,
        pdfGeneratedAt,
        notes,
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(_items)
      ]);

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InvoiceImplCopyWith<_$InvoiceImpl> get copyWith =>
      __$$InvoiceImplCopyWithImpl<_$InvoiceImpl>(this, _$identity);
}

abstract class _Invoice extends Invoice {
  const factory _Invoice(
      {required final int id,
      required final String invoiceNumber,
      required final int orderId,
      required final String customerName,
      required final String customerEmail,
      final String? customerAddress,
      final String? customerCity,
      final String? customerPostalCode,
      final String? customerPhone,
      final String companyName,
      final String? companyAddress,
      final String? companyNif,
      final String? companyEmail,
      final String? companyPhone,
      required final int subtotal,
      final int shippingCost,
      final int discount,
      final double taxRate,
      required final int taxAmount,
      required final int total,
      final String paymentMethod,
      final String paymentStatus,
      required final DateTime issueDate,
      final DateTime? dueDate,
      final String status,
      final String? pdfUrl,
      final DateTime? pdfGeneratedAt,
      final String? notes,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final List<InvoiceItem> items}) = _$InvoiceImpl;
  const _Invoice._() : super._();

  @override
  int get id;
  @override
  String get invoiceNumber;
  @override
  int get orderId; // Datos del cliente
  @override
  String get customerName;
  @override
  String get customerEmail;
  @override
  String? get customerAddress;
  @override
  String? get customerCity;
  @override
  String? get customerPostalCode;
  @override
  String? get customerPhone; // Datos de la empresa
  @override
  String get companyName;
  @override
  String? get companyAddress;
  @override
  String? get companyNif;
  @override
  String? get companyEmail;
  @override
  String? get companyPhone; // Importes
  @override
  int get subtotal; // En centavos
  @override
  int get shippingCost; // En centavos
  @override
  int get discount; // En centavos
  @override
  double get taxRate;
  @override
  int get taxAmount; // En centavos
  @override
  int get total; // En centavos
// Pago
  @override
  String get paymentMethod;
  @override
  String get paymentStatus; // Fechas
  @override
  DateTime get issueDate;
  @override
  DateTime? get dueDate; // Estado y PDF
  @override
  String get status;
  @override
  String? get pdfUrl;
  @override
  DateTime? get pdfGeneratedAt;
  @override
  String? get notes;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  List<InvoiceItem> get items;

  /// Create a copy of Invoice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InvoiceImplCopyWith<_$InvoiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
