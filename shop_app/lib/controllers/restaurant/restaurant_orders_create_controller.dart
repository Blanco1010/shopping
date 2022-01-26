import 'package:flutter/material.dart';
import 'package:shop_app/controllers/secure_storage.dart';

import '../../models/order.dart';

class RestaurantOrderCreateController {
  late BuildContext context;
  late Function refresh;

  final SecureStogare _secureStogare = SecureStogare();

  int total = 0;
  Order? order;

  Future init(BuildContext context, Function refresh, Order order) async {
    this.context = context;
    this.refresh = refresh;
    this.order = order;

    getTotal();
    refresh();
  }

  void getTotal() {
    total = order!.products!
        .fold(0, (value, element) => value + element.quantity! * element.price);
    refresh();
  }
}
