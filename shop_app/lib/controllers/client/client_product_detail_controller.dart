import 'package:flutter/material.dart';
import 'package:shop_app/models/product.dart';

class ClientProductDetailController {
  late BuildContext context;
  late Function refresh;

  late Product product;

  Future init(BuildContext context, Function refresh, Product product) async {
    this.context = context;
    this.refresh = refresh;
    this.product = product;
  }
}
