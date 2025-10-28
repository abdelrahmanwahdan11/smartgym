typedef SearchField<T> = Iterable<String> Function(T item);

class SearchService {
  List<T> search<T>(List<T> items, String query, SearchField<T> fieldSelector) {
    if (query.trim().isEmpty) {
      return items;
    }
    final normalizedQuery = query.toLowerCase();
    return items.where((item) {
      final fields = fieldSelector(item);
      final flattened = fields.join(' ').toLowerCase();
      return flattened.contains(normalizedQuery);
    }).toList();
  }
}
