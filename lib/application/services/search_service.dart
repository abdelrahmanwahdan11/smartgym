import 'synonyms_service.dart';

typedef SearchField<T> = Iterable<String> Function(T item);

class SearchService {
  SearchService(this.synonymsService);

  final SynonymsService synonymsService;

  List<T> search<T>(List<T> items, String query, SearchField<T> fieldSelector) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return items;
    }
    final baseTerms = trimmed.toLowerCase().split(RegExp(r'\s+')).where((e) => e.isNotEmpty);
    final expandedTerms = synonymsService.expandTerms(baseTerms);
    return items.where((item) {
      final fields = fieldSelector(item);
      final flattened = fields.join(' ').toLowerCase();
      return expandedTerms.any(flattened.contains);
    }).toList();
  }
}
