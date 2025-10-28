class SleepPlanModel {
  SleepPlanModel({
    required this.bedtime,
    required this.wakeTime,
    this.notes = '',
  });

  final String bedtime;
  final String wakeTime;
  final String notes;

  SleepPlanModel copyWith({String? bedtime, String? wakeTime, String? notes}) => SleepPlanModel(
        bedtime: bedtime ?? this.bedtime,
        wakeTime: wakeTime ?? this.wakeTime,
        notes: notes ?? this.notes,
      );

  Map<String, dynamic> toMap() => {
        'bedtime': bedtime,
        'wake_time': wakeTime,
        'notes': notes,
      };

  factory SleepPlanModel.fromMap(Map<String, dynamic> map) => SleepPlanModel(
        bedtime: map['bedtime'] as String? ?? '22:30',
        wakeTime: map['wake_time'] as String? ?? '06:30',
        notes: map['notes'] as String? ?? '',
      );
}
