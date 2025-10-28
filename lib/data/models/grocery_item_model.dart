class GroceryItemModel {
  GroceryItemModel({
    required this.id,
    required this.title,
    this.checked = false,
  });

  final String id;
  final String title;
  final bool checked;

  GroceryItemModel copyWith({String? title, bool? checked}) => GroceryItemModel(
        id: id,
        title: title ?? this.title,
        checked: checked ?? this.checked,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'checked': checked,
      };

  factory GroceryItemModel.fromMap(Map<String, dynamic> map) => GroceryItemModel(
        id: map['id'] as String? ?? '',
        title: map['title'] as String? ?? '',
        checked: map['checked'] as bool? ?? false,
      );
}
