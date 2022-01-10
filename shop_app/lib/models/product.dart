import 'dart:convert';

class Product {
  String? id;
  String name;
  String description;
  String? imagen1;
  String? imagen2;
  String? imagen3;
  double price;
  int idCategory;
  int quantity;

  Product({
    this.id,
    required this.name,
    required this.description,
    this.imagen1,
    this.imagen2,
    this.imagen3,
    required this.price,
    required this.idCategory,
    required this.quantity,
  });

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        imagen1: json["imagen1"],
        imagen2: json["imagen2"],
        imagen3: json["imagen3"],
        price: json["price"].toDouble(),
        idCategory: json["idCategory"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "imagen1": imagen1,
        "imagen2": imagen2,
        "imagen3": imagen3,
        "price": price,
        "idCategory": idCategory,
        "quantity": quantity,
      };
}
