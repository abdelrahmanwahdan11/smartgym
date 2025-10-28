import 'package:flutter/material.dart';

class SegmentedControl<T> extends StatelessWidget {
  const SegmentedControl({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.labelBuilder,
  });

  final List<T> options;
  final T value;
  final ValueChanged<T> onChanged;
  final String Function(T value)? labelBuilder;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: options.map((option) {
        final isSelected = option == value;
        return ChoiceChip(
          label: Text(labelBuilder?.call(option) ?? option.toString()),
          selected: isSelected,
          onSelected: (_) => onChanged(option),
        );
      }).toList(),
    );
  }
}
