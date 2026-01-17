import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

/// Modelo de Item del Carrito
@freezed
abstract class CartItemModel with _$CartItemModel {
  const CartItemModel._();

  const factory CartItemModel({
    required int productId,
    required String name,
    required String slug,
    required int price,
    required int quantity,
    required String size,
    required String imageUrl,
    @Default(99) int maxStock,
    int? salePrice,
    @Default(false) bool isOnSale,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  // ============================================
  // PROPIEDADES COMPUTADAS
  // ============================================

  /// Clave única del item
  String get key => '$productId-$size';

  /// Precio actual
  int get currentPrice => isOnSale && salePrice != null ? salePrice! : price;

  /// Subtotal del item
  int get subtotal => currentPrice * quantity;

  /// ¿Puede incrementar?
  bool get canIncrease => quantity < maxStock;

  /// ¿Puede decrementar?
  bool get canDecrease => quantity > 1;

  /// Precio formateado
  String get formattedPrice => '${(currentPrice / 100).toStringAsFixed(2)} €';

  /// Subtotal formateado
  String get formattedSubtotal => '${(subtotal / 100).toStringAsFixed(2)} €';
}

/// Estado del carrito
@freezed
abstract class CartState with _$CartState {
  const CartState._();

  const factory CartState({
    @Default(<String, CartItemModel>{}) Map<String, CartItemModel> items,
  }) = _CartState;

  // ============================================
  // PROPIEDADES COMPUTADAS
  // ============================================

  /// Lista de items
  List<CartItemModel> get itemsList => items.values.toList();

  /// Total de items (suma de cantidades)
  int get totalItems =>
      items.values.fold(0, (sum, item) => sum + item.quantity);

  /// Número de líneas (productos únicos)
  int get lineCount => items.length;

  /// Subtotal en céntimos
  int get subtotal => items.values.fold(0, (sum, item) => sum + item.subtotal);

  /// ¿Está vacío?
  bool get isEmpty => items.isEmpty;

  /// ¿Tiene items?
  bool get isNotEmpty => items.isNotEmpty;

  /// Subtotal formateado
  String get formattedSubtotal => '${(subtotal / 100).toStringAsFixed(2)} €';
}
