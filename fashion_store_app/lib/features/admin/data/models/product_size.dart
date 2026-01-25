// Modelo para Tallas de Producto con Stock

class ProductSize {
  final int id;
  final int productId;
  final String size;
  final int stock;
  final DateTime createdAt;

  ProductSize({
    required this.id,
    required this.productId,
    required this.size,
    required this.stock,
    required this.createdAt,
  });

  factory ProductSize.fromJson(Map<String, dynamic> json) {
    return ProductSize(
      id: json['id'],
      productId: json['product_id'],
      size: json['size'],
      stock: json['stock'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'size': size,
      'stock': stock,
      'created_at': createdAt.toIso8601String(),
    };
  }

  bool get isLowStock => stock > 0 && stock < 5;
  bool get isOutOfStock => stock == 0;
}

class SizeSystem {
  final String name;
  final String slug;
  final List<String> sizes;
  final String description;

  SizeSystem({
    required this.name,
    required this.slug,
    required this.sizes,
    required this.description,
  });
}

// Sistemas de tallas predefinidos
class SizeSystems {
  static final Map<String, SizeSystem> systems = {
    'camisas': SizeSystem(
      name: 'Camisas',
      slug: 'camisas',
      sizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      description: 'Sistema estándar de letras',
    ),
    'camisetas': SizeSystem(
      name: 'Camisetas',
      slug: 'camisetas',
      sizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      description: 'Sistema estándar de letras',
    ),
    'pantalones': SizeSystem(
      name: 'Pantalones',
      slug: 'pantalones',
      sizes: ['28', '30', '32', '34', '36', '38', '40', '42'],
      description: 'Sistema numérico (cintura en pulgadas)',
    ),
    'trajes': SizeSystem(
      name: 'Trajes',
      slug: 'trajes',
      sizes: ['44', '46', '48', '50', '52', '54', '56'],
      description: 'Sistema europeo de tallas',
    ),
    'chalecos': SizeSystem(
      name: 'Chalecos',
      slug: 'chalecos',
      sizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      description: 'Sistema estándar de letras',
    ),
    'abrigos': SizeSystem(
      name: 'Abrigos',
      slug: 'abrigos',
      sizes: ['XS', 'S', 'M', 'L', 'XL', 'XXL'],
      description: 'Sistema estándar de letras',
    ),
  };

  static List<String> getSizesForCategory(String categorySlug) {
    return systems[categorySlug]?.sizes ?? ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  }

  static SizeSystem? getSystemForCategory(String categorySlug) {
    return systems[categorySlug];
  }
}
