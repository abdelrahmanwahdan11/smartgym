class HydrationLogModel {
  HydrationLogModel({
    required this.date,
    required this.mlTotal,
  });

  final DateTime date;
  final int mlTotal;

  HydrationLogModel copyWith({int? mlTotal}) => HydrationLogModel(
        date: date,
        mlTotal: mlTotal ?? this.mlTotal,
      );

  Map<String, dynamic> toMap() => {
        'date': date.toIso8601String(),
        'ml_total': mlTotal,
      };

  factory HydrationLogModel.fromMap(Map<String, dynamic> map) => HydrationLogModel(
        date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
        mlTotal: map['ml_total'] as int? ?? 0,
      );
}
