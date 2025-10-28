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
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final VoidCallback onEndReached;
  final EdgeInsetsGeometry? padding;
  final bool hasMore;
  final ScrollPhysics? physics;

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
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent * 0.85) {
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
    return ListView.builder(
      controller: _controller,
      padding: widget.padding,
      physics: widget.physics,
      itemCount: widget.itemCount,
      itemBuilder: widget.itemBuilder,
    );
  }
}
