import 'dart:convert';

class CartItemModel {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final List<String> tags;

  const CartItemModel({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    this.tags = const [],
  });

  CartItemModel copyWith({int? quantity}) => CartItemModel(
        productId: productId,
        name: name,
        price: price,
        quantity: quantity ?? this.quantity,
        tags: tags,
      );

  double get subtotal => price * quantity;

  Map<String, dynamic> toMap() => {
        'product_id': productId,
        'name': name,
        'price': price,
        'quantity': quantity,
        'tags': tags,
      };

  String toJsonString() => jsonEncode(toMap());

  factory CartItemModel.fromMap(Map<String, dynamic> map) => CartItemModel(
        productId: map['product_id'] as String,
        name: map['name'] as String? ?? '',
        price: (map['price'] as num?)?.toDouble() ?? 0,
        quantity: map['quantity'] as int? ?? 1,
        tags: (map['tags'] as List<dynamic>? ?? const []).cast<String>(),
      );
}
