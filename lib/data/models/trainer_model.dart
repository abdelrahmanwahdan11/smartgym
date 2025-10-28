class TrainerModel {
  final String id;
  final String name;
  final List<String> specialties;
  final List<String> certifications;
  final double rating;
  final String bio;
  final Map<String, dynamic> rates;

  TrainerModel({
    required this.id,
    required this.name,
    required this.specialties,
    required this.certifications,
    required this.rating,
    required this.bio,
    required this.rates,
  });

  factory TrainerModel.fromMap(Map<String, dynamic> map) => TrainerModel(
        id: map['id'] as String,
        name: map['name'] as String? ?? '',
        specialties: (map['specialties'] as List<dynamic>? ?? []).cast<String>(),
        certifications: (map['certs'] as List<dynamic>? ?? []).cast<String>(),
        rating: (map['rating'] as num? ?? 0).toDouble(),
        bio: map['bio'] as String? ?? '',
        rates: Map<String, dynamic>.from(map['rates'] as Map? ?? {}),
      );
}
