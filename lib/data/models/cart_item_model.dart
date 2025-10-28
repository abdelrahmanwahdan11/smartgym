import 'dart:convert';

class CartItemModel {
  final String id;
  final String productId;
  final String name;
  final double price;
  final int qty;
  final List<String> tags;

  const CartItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.qty,
    this.tags = const [],
  });

  CartItemModel copyWith({int? qty}) => CartItemModel(
        id: id,
        productId: productId,
        name: name,
        price: price,
        qty: qty ?? this.qty,
        tags: tags,
      );

  double get subtotal => price * qty;

  Map<String, dynamic> toMap() => {
        'id': id,
        'product_id': productId,
        'name': name,
        'price': price,
        'qty': qty,
        'tags': tags,
      };

  String toJsonString() => jsonEncode(toMap());

  factory CartItemModel.fromMap(Map<String, dynamic> map) => CartItemModel(
        id: map['id'] as String? ?? map['product_id'] as String,
        productId: map['product_id'] as String,
        name: map['name'] as String? ?? '',
        price: (map['price'] as num?)?.toDouble() ?? 0,
        qty: map['quantity'] as int? ?? map['qty'] as int? ?? 1,
        tags: (map['tags'] as List<dynamic>? ?? const []).cast<String>(),
      );
}
