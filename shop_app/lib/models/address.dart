import 'dart:convert';

class Address {
  Address({
    this.id,
    required this.idUser,
    required this.address,
    required this.neightborhood,
    required this.lat,
    required this.lng,
  });

  String? id;
  String? idUser;
  String address;
  String neightborhood;
  double lat;
  double lng;

  factory Address.fromJson(String str) => Address.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Address.fromMap(Map<String, dynamic> json) => Address(
        id: json["id"].toString(),
        idUser: json["id_user"].toString(),
        address: json["address"],
        neightborhood: json["neightborhood"],
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "id_user": idUser,
        "address": address,
        "neightborhood": neightborhood,
        "lat": lat,
        "lng": lng,
      };
}
