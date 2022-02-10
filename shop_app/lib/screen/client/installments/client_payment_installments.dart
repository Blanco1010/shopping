import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shop_app/controllers/secure_storage.dart';
import 'package:shop_app/models/mercado_pago_card_token.dart';

import 'package:shop_app/provider/mercado_pago_provider.dart';

import '../../../models/product.dart';
import '../../../models/user.dart';

class ClientPaymentInstallmentsController {
  late BuildContext context;
  late Function refresh;

  final MercadoPagoProvider _mercadoPagoProvider = MercadoPagoProvider();
  User? user;

  late MercadoPagoCardToken cardToken;

  List<Product> selectProducts = [];
  int total = 0;

  Future init(
    BuildContext context,
    Function refresh,
    MercadoPagoCardToken cardToken,
  ) async {
    this.context = context;
    this.refresh = refresh;
    this.cardToken = cardToken;

    user = User.fromJson(await SecureStogare().read('user'));

    _mercadoPagoProvider.init(context, user!);

    for (var item
        in json.decode(await SecureStogare().read('order'))?.toList() ?? []) {
      selectProducts.add(Product.fromJson(item));
    }
    getTotal();
  }

  void getTotal() {
    total = selectProducts.fold(
        0, (value, element) => value + (element.price * element.quantity!));
    refresh();
  }
}
