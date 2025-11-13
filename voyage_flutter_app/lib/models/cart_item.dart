import 'product.dart';

class CartItem {
  final String id;
  final Product product;
  final ProductVariant variant;
  int quantity;
  final Map<String, dynamic>? properties;

  CartItem({
    required this.id,
    required this.product,
    required this.variant,
    this.quantity = 1,
    this.properties,
  });

  double get totalPrice => variant.price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? '',
      product: Product.fromJson(json['product'] ?? {}),
      variant: ProductVariant.fromJson(json['variant'] ?? {}),
      quantity: json['quantity'] ?? 1,
      properties: json['properties'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'variant': variant.toJson(),
      'quantity': quantity,
      'properties': properties,
    };
  }

  CartItem copyWith({
    String? id,
    Product? product,
    ProductVariant? variant,
    int? quantity,
    Map<String, dynamic>? properties,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      variant: variant ?? this.variant,
      quantity: quantity ?? this.quantity,
      properties: properties ?? this.properties,
    );
  }

  bool get hasProperties => properties != null && properties!.isNotEmpty;

  bool get isPrescriptionLens {
    if (properties == null) return false;
    return properties!.containsKey('Right SPH') || 
           properties!.containsKey('Lens Type');
  }
}

