class SavedFilterModel {
  final String id;
  final String scope;
  final Map<String, dynamic> payload;
  final String label;

  const SavedFilterModel({
    required this.id,
    required this.scope,
    required this.payload,
    required this.label,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'scope': scope,
        'payload': payload,
        'label': label,
      };

  factory SavedFilterModel.fromMap(Map<String, dynamic> map) => SavedFilterModel(
        id: map['id'] as String,
        scope: map['scope'] as String? ?? '',
        payload: (map['payload'] as Map<String, dynamic>?) ?? <String, dynamic>{},
        label: map['label'] as String? ?? '',
      );
}
