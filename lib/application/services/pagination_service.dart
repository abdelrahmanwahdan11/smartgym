class PaginationService {
  List<T> page<T>(List<T> source, int page, int pageSize) {
    final start = page * pageSize;
    if (start >= source.length) {
      return [];
    }
    final end = (start + pageSize).clamp(0, source.length);
    return source.sublist(start, end);
  }
}
