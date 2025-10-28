import 'package:flutter/material.dart';

class PaginatorListView extends StatefulWidget {
  const PaginatorListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.onEndReached,
    this.padding,
    this.hasMore = true,
    this.physics,
    this.threshold,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final VoidCallback onEndReached;
  final EdgeInsetsGeometry? padding;
  final bool hasMore;
  final ScrollPhysics? physics;
  final double? threshold;

  static const double defaultThreshold = 0.85;

  @override
  State<PaginatorListView> createState() => _PaginatorListViewState();
}

class _PaginatorListViewState extends State<PaginatorListView> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (!widget.hasMore) return;
    final trigger = widget.threshold ?? defaultThreshold;
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent * trigger) {
      widget.onEndReached();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.hasMore ? widget.itemCount + 1 : widget.itemCount;
    return ListView.builder(
      controller: _controller,
      padding: widget.padding,
      physics: widget.physics,
      itemCount: total,
      itemBuilder: (context, index) {
        if (index >= widget.itemCount) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: LinearProgressIndicator()),
          );
        }
        return widget.itemBuilder(context, index);
      },
    );
  }
}
