class StepsDayModel {
  StepsDayModel({
    required this.date,
    required this.steps,
    required this.target,
  });

  final DateTime date;
  final int steps;
  final int target;

  StepsDayModel copyWith({int? steps, int? target}) => StepsDayModel(
        date: date,
        steps: steps ?? this.steps,
        target: target ?? this.target,
      );

  Map<String, dynamic> toMap() => {
        'date': date.toIso8601String(),
        'steps': steps,
        'target': target,
      };

  factory StepsDayModel.fromMap(Map<String, dynamic> map) => StepsDayModel(
        date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
        steps: map['steps'] as int? ?? 0,
        target: map['target'] as int? ?? 0,
      );
}
