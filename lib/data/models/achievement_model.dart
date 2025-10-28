class AchievementModel {
  final String id;
  final String type;
  final DateTime date;
  final double value;
  final String label;

  AchievementModel({
    required this.id,
    required this.type,
    required this.date,
    required this.value,
    required this.label,
  });

  factory AchievementModel.fromMap(Map<String, dynamic> map) => AchievementModel(
        id: map['id'] as String,
        type: map['type'] as String? ?? '',
        date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
        value: (map['value'] as num? ?? 0).toDouble(),
        label: map['label'] as String? ?? '',
      );
}
