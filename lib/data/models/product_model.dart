class ProductModel {
  final String id;
  final String name;
  final String category;
  final double price;
  final List<String> tags;
  final List<String> images;
  final String details;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.tags,
    required this.images,
    required this.details,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) => ProductModel(
        id: map['id'] as String,
        name: map['name'] as String? ?? '',
        category: map['category'] as String? ?? '',
        price: (map['price'] as num? ?? 0).toDouble(),
        tags: (map['tags'] as List<dynamic>? ?? []).cast<String>(),
        images: (map['images'] as List<dynamic>? ?? []).cast<String>(),
        details: map['details'] as String? ?? '',
      );
}
