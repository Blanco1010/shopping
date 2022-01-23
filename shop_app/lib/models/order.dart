import 'dart:convert';

import 'product.dart';

class Order {
  String? id;
  String idClient;
  String idAddress;
  double lat;
  double lng;
  String status;
  int? timestamp;
  List<Product> products = [];
  List<Order>? orders = [];

  Order({
    this.id,
    required this.idClient,
    required this.idAddress,
    required this.lat,
    required this.lng,
    required this.status,
    this.timestamp,
    required this.products,
    this.orders,
  });

  factory Order.fromJson(String str) => Order.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Order.fromMap(Map<String, dynamic> json) => Order(
        id: json["id"] ?? 'null',
        idClient: json["id_client"],
        idAddress: json["id_address"],
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
        status: json["status"],
        timestamp: json["timestamp"] ?? 'null',
        products: List<Product>.from(
          json['products'].map((e) => Product.fromJson(e)) ?? [],
        ),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "id_client": idClient,
        "id_address": idAddress,
        "lat": lat,
        "lng": lng,
        "status": status,
        "timestamp": timestamp,
        "products": products
      };
}
