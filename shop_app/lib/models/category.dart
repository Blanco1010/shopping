import 'dart:convert';

class Category {
  String name;
  String description;

  Category({
    required this.name,
    required this.description,
  });

  factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "description": description,
      };
}
