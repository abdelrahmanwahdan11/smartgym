class SavedSearchModel {
  final String id;
  final String scope;
  final String query;
  final Map<String, dynamic> filters;
  final DateTime date;

  const SavedSearchModel({
    required this.id,
    required this.scope,
    required this.query,
    required this.filters,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'scope': scope,
        'query': query,
        'filters': filters,
        'date': date.toIso8601String(),
      };

  factory SavedSearchModel.fromMap(Map<String, dynamic> map) => SavedSearchModel(
        id: map['id'] as String,
        scope: map['scope'] as String? ?? '',
        query: map['query'] as String? ?? '',
        filters: (map['filters'] as Map<String, dynamic>?) ?? <String, dynamic>{},
        date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      );
}
