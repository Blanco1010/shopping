import 'dart:convert';

class Category {
  String? id;
  String name;
  String description;
  List<Category> toList = [];

  Category({
    this.id,
    required this.name,
    required this.description,
  });

  factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        id: json["id"] ?? 'null',
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toMap() => {
        "id": id ?? 'null',
        "name": name,
        "description": description,
      };
}
