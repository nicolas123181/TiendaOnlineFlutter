/// Modelo de Método de Envío (sin freezed para simplicidad)
class ShippingMethod {
  final int id;
  final String name;
  final String? description;
  final int cost;
  final int minDays;
  final int maxDays;
  final bool isActive;

  const ShippingMethod({
    required this.id,
    required this.name,
    this.description,
    required this.cost,
    this.minDays = 2,
    this.maxDays = 5,
    this.isActive = true,
  });

  factory ShippingMethod.fromJson(Map<String, dynamic> json) {
    return ShippingMethod(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      cost: json['cost'] as int,
      minDays: json['minDays'] as int? ?? 2,
      maxDays: json['maxDays'] as int? ?? 5,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'cost': cost,
    'minDays': minDays,
    'maxDays': maxDays,
    'isActive': isActive,
  };

  /// Precio formateado
  String get formattedCost =>
      cost == 0 ? 'GRATIS' : '${(cost / 100).toStringAsFixed(2)} €';

  /// Tiempo de entrega formateado
  String get deliveryTime => '$minDays-$maxDays días laborables';
}
