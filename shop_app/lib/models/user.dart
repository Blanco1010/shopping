import 'dart:convert';

import 'package:shop_app/models/rol.dart';

class User {
  String? id;
  String? email;
  String name;
  String lastname;
  String? phone;
  dynamic image;
  String? password;
  dynamic isAvailabe;
  dynamic sessionToken;
  DateTime? createdAt;
  DateTime? updateAt;
  List<Rol>? roles = [];

  User({
    this.id,
    this.email,
    required this.name,
    required this.lastname,
    required this.phone,
    this.image,
    this.password,
    this.isAvailabe,
    this.sessionToken,
    this.createdAt,
    this.updateAt,
    this.roles,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"] is int ? json['id'].toString() : json['id'],
        email: json["email"] ?? '',
        name: json["name"] ?? '',
        lastname: json["lastname"] ?? '',
        phone: json["phone"] ?? '',
        image: json["image"],
        password: json["password"] ?? '',
        isAvailabe: json["is_availabe"] ?? '',
        sessionToken: json["session_token"] ?? '',
        createdAt: json["created_at"],
        updateAt: json["update_at"],
        roles: json['roles'] == null
            ? []
            : List<Rol>.from(
                json['roles'].map(
                  (e) {
                    if (e is String) {
                      return Rol.fromJson(e);
                    }
                    return Rol.fromMap(e);
                  },
                ),
              ),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "email": email,
        "name": name,
        "lastname": lastname,
        "phone": phone,
        "image": image,
        "password": password,
        "is_availabe": isAvailabe,
        "session_token": sessionToken,
        "created_at": createdAt?.toIso8601String(),
        "update_at": updateAt?.toIso8601String(),
        "roles": roles,
      };
}
