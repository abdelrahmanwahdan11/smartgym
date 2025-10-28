import 'dart:async';

import 'package:flutter/material.dart';

class DebouncedSearchBar extends StatefulWidget {
  const DebouncedSearchBar({
    super.key,
    required this.onChanged,
    this.hintText,
    this.debounce = const Duration(milliseconds: 250),
  });

  final ValueChanged<String> onChanged;
  final String? hintText;
  final Duration debounce;

  @override
  State<DebouncedSearchBar> createState() => _DebouncedSearchBarState();
}

class _DebouncedSearchBarState extends State<DebouncedSearchBar> {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: widget.hintText ?? 'Search',
        prefixIcon: const Icon(Icons.search),
      ),
      onChanged: (value) {
        _timer?.cancel();
        _timer = Timer(widget.debounce, () => widget.onChanged(value));
      },
    );
  }
}
