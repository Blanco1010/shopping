// To parse this JSON data, do
//
//     final rol = rolFromMap(jsonString);

import 'dart:convert';

class Rol {
  Rol({
    required this.id,
    required this.name,
    required this.image,
    required this.route,
  });

  dynamic id;
  String name;
  dynamic image;
  String route;

  factory Rol.fromJson(String str) => Rol.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Rol.fromMap(Map<String, dynamic> json) => Rol(
        id: json["id"] is int ? json['id'].toString() : json['id'],
        name: json["name"],
        image: json["image"],
        route: json["route"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "image": image,
        "route": route,
      };
}
