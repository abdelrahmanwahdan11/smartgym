class InBodyRecordModel {
  final String id;
  final DateTime date;
  final double weight;
  final double bodyFat;
  final double muscle;
  final double water;
  final double waist;
  final double hip;
  final String notes;

  InBodyRecordModel({
    required this.id,
    required this.date,
    required this.weight,
    required this.bodyFat,
    required this.muscle,
    required this.water,
    required this.waist,
    required this.hip,
    required this.notes,
  });

  factory InBodyRecordModel.fromMap(Map<String, dynamic> map) => InBodyRecordModel(
        id: map['id'] as String,
        date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
        weight: (map['weight'] as num? ?? 0).toDouble(),
        bodyFat: (map['body_fat'] as num? ?? 0).toDouble(),
        muscle: (map['muscle'] as num? ?? 0).toDouble(),
        water: (map['water'] as num? ?? 0).toDouble(),
        waist: (map['waist'] as num? ?? 0).toDouble(),
        hip: (map['hip'] as num? ?? 0).toDouble(),
        notes: map['notes'] as String? ?? '',
      );
}
