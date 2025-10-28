class ProviderChangeModel {
  final String id;
  final String entity;
  final String operation;
  final Map<String, dynamic> snapshot;
  final DateTime date;

  const ProviderChangeModel({
    required this.id,
    required this.entity,
    required this.operation,
    required this.snapshot,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'entity': entity,
        'operation': operation,
        'snapshot': snapshot,
        'date': date.toIso8601String(),
      };

  factory ProviderChangeModel.fromMap(Map<String, dynamic> map) => ProviderChangeModel(
        id: map['id'] as String,
        entity: map['entity'] as String? ?? '',
        operation: map['operation'] as String? ?? '',
        snapshot: (map['snapshot'] as Map<String, dynamic>?) ?? <String, dynamic>{},
        date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      );
}
