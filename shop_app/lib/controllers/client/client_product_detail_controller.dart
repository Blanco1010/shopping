import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/controllers/secure_storage.dart';
import 'package:shop_app/models/product.dart';

import '../../widgets/snackbar.dart';

class ClientProductDetailController {
  late BuildContext context;
  late Function refresh;

  late Product product;

  int counter = 1;
  int price = 0;

  final SecureStogare _secureStogare = SecureStogare();

  List<Product> selectProducts = [];

  Future init(BuildContext context, Function refresh, Product product) async {
    this.context = context;
    this.refresh = refresh;
    this.product = product;
    price = product.price;

    // _secureStogare.remove('order');

    for (var item
        in json.decode(await _secureStogare.read('order'))?.toList() ?? []) {
      selectProducts.add(Product.fromJson(item));
    }
    // print(selectProducts);
  }

  void addToBag() {
    int index = selectProducts.indexWhere((p) => p.id == product.id);

    if (index == -1) {
      product.quantity ??= 1;
      selectProducts.add(product);
    } else {
      selectProducts[index].quantity = counter;
    }

    _secureStogare.save('order', json.encode(selectProducts));
    Snackbar.show(context, 'Producto agregado');
  }

  void addItem() {
    counter++;
    price = product.price * counter;
    product.quantity = counter;
    refresh();
  }

  void removeItem() {
    if (counter > 1) {
      counter--;
      price = product.price * counter;
      product.quantity = counter;
      refresh();
    }
  }
}
