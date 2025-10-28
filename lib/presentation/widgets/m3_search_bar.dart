import 'dart:async';

import 'package:flutter/material.dart';

class M3SearchBar extends StatefulWidget {
  const M3SearchBar({
    super.key,
    required this.onQueryChanged,
    this.onSubmitted,
    this.hintText,
    this.suggestions = const <String>[],
    this.debounce = const Duration(milliseconds: 250),
    this.leading,
  });

  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String>? onSubmitted;
  final String? hintText;
  final List<String> suggestions;
  final Duration debounce;
  final Widget? leading;

  @override
  State<M3SearchBar> createState() => _M3SearchBarState();
}

class _M3SearchBarState extends State<M3SearchBar> {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          hintText: widget.hintText,
          leading: widget.leading ?? const Icon(Icons.search),
          onChanged: (value) => _onChanged(value, controller),
          onSubmitted: (value) {
            widget.onSubmitted?.call(value);
            widget.onQueryChanged(value);
            controller.closeView(value);
          },
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        final query = controller.text.trim().toLowerCase();
        if (widget.suggestions.isEmpty) {
          return const Iterable<Widget>.empty();
        }
        final filtered = widget.suggestions
            .where((item) =>
                query.isEmpty || item.toLowerCase().contains(query))
            .take(6);
        return filtered.map(
          (item) => ListTile(
            title: Text(item),
            onTap: () {
              controller.closeView(item);
              controller.text = item;
              widget.onQueryChanged(item);
              widget.onSubmitted?.call(item);
            },
          ),
        );
      },
    );
  }

  void _onChanged(String value, SearchController controller) {
    _timer?.cancel();
    _timer = Timer(widget.debounce, () {
      widget.onQueryChanged(value);
    });
    if (value.isNotEmpty && widget.suggestions.isNotEmpty) {
      controller.openView();
    } else {
      controller.closeView(value);
    }
  }
}
