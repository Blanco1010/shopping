import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/controllers/secure_storage.dart';

import '../../models/product.dart';

class ClientOrderCreateController {
  late BuildContext context;
  late Function refresh;

  final SecureStogare _secureStogare = SecureStogare();

  List<Product> selectProducts = [];
  int total = 0;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    for (var item
        in json.decode(await _secureStogare.read('order'))?.toList() ?? []) {
      selectProducts.add(Product.fromJson(item));
    }
    getTotal();
    refresh();
  }

  void getTotal() {
    total = selectProducts.fold(
        0, (value, element) => value + (element.price * element.quantity!));
    refresh();
  }

  void addItem(Product product) {
    int index = selectProducts.indexWhere((p) => p.id == product.id);
    selectProducts[index].quantity = selectProducts[index].quantity! + 1;
    _secureStogare.save('order', json.encode(selectProducts));
    getTotal();
    refresh();
  }

  void removeItem(Product product) {
    int index = selectProducts.indexWhere((p) => p.id == product.id);
    if (selectProducts[index].quantity! > 1) {
      selectProducts[index].quantity = selectProducts[index].quantity! - 1;
      _secureStogare.save('order', json.encode(selectProducts));
      getTotal();
      refresh();
    }
  }

  void goToAddress() {
    Navigator.pushNamed(context, '/client/address/list');
  }

  void deleteItem(Product product) {
    selectProducts.removeWhere((p) => p.id == product.id);
    _secureStogare.save('order', json.encode(selectProducts));
    refresh();
  }
}
