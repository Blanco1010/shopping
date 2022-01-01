import 'dart:convert';

class User {
  String? id;
  String email;
  String name;
  String lastname;
  String phone;
  dynamic image;
  String? password;
  dynamic isAvailabe;
  dynamic sessionToken;
  DateTime? createdAt;
  DateTime? updateAt;

  User({
    this.id,
    required this.email,
    required this.name,
    required this.lastname,
    required this.phone,
    this.image,
    this.password,
    this.isAvailabe,
    this.sessionToken,
    this.createdAt,
    this.updateAt,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        lastname: json["lastname"],
        phone: json["phone"],
        image: json["image"],
        password: json["password"] ?? 'null',
        isAvailabe: json["is_availabe"],
        sessionToken: json["session_token"],
        createdAt: (json["created_at"]),
        updateAt: (json["update_at"]),
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
      };
}
