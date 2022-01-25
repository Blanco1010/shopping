import 'dart:convert';

class Product {
  String? id;
  String name;
  String description;
  String? imagen1;
  String? imagen2;
  String? imagen3;
  int price;
  int idCategory;
  int? quantity;

  Product({
    this.id,
    required this.name,
    required this.description,
    this.imagen1,
    this.imagen2,
    this.imagen3,
    required this.price,
    required this.idCategory,
    this.quantity,
  });

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"].toString(),
        name: json["name"],
        description: json["description"],
        imagen1: json["image1"],
        imagen2: json["image2"],
        imagen3: json["image3"],
        price: json["price"],
        idCategory: json["id_category"] ?? 0,
        quantity: json["quantity"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "image1": imagen1,
        "image2": imagen2,
        "image3": imagen3,
        "price": price,
        "id_category": idCategory,
        "quantity": quantity,
      };
}
