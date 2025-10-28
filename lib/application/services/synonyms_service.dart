import 'package:get/get.dart';

class SynonymsService extends GetxService {
  SynonymsService({Map<String, List<String>>? custom}) : _synonyms = custom ?? _default;

  final Map<String, List<String>> _synonyms;

  static final Map<String, List<String>> _default = {
    'yoga': ['يوغا'],
    'hiit': ['هيت', 'هييت'],
    'strength': ['قوة'],
    'cycling': ['دراجة', 'سبن'],
  };

  List<String> expandTerms(Iterable<String> terms) {
    final expanded = <String>{};
    for (final term in terms) {
      expanded.add(term.toLowerCase());
      final matches = _synonyms[term.toLowerCase()];
      if (matches != null) {
        expanded.addAll(matches.map((e) => e.toLowerCase()));
      }
      for (final entry in _synonyms.entries) {
        if (entry.value.map((e) => e.toLowerCase()).contains(term.toLowerCase())) {
          expanded.add(entry.key.toLowerCase());
        }
      }
    }
    return expanded.toList();
  }

  Map<String, List<String>> get all => _synonyms;
}
