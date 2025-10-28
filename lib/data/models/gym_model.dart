class GymModel {
  final String id;
  final String name;
  final String locationText;
  final List<String> amenities;
  final List<String> equipment;
  final double rating;
  final List<String> photos;
  final int discount;

  GymModel({
    required this.id,
    required this.name,
    required this.locationText,
    required this.amenities,
    required this.equipment,
    required this.rating,
    required this.photos,
    required this.discount,
  });

  factory GymModel.fromMap(Map<String, dynamic> map) => GymModel(
        id: map['id'] as String,
        name: map['name'] as String? ?? '',
        locationText: map['location_text'] as String? ?? '',
        amenities: (map['amenities'] as List<dynamic>? ?? []).cast<String>(),
        equipment: (map['equipment'] as List<dynamic>? ?? []).cast<String>(),
        rating: (map['rating'] as num? ?? 0).toDouble(),
        photos: (map['photos'] as List<dynamic>? ?? []).cast<String>(),
        discount: map['discount'] as int? ?? 0,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'location_text': locationText,
        'amenities': amenities,
        'equipment': equipment,
        'rating': rating,
        'photos': photos,
        'discount': discount,
      };
}
