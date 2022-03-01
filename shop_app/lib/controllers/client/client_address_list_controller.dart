import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/controllers/secure_storage.dart';
import 'package:shop_app/models/address.dart';

import 'package:shop_app/provider/address_provider.dart';
import 'package:shop_app/provider/order_provider.dart';

import '../../models/order.dart';
import '../../models/product.dart';
import '../../models/response_model.dart';
import '../../models/user.dart';

class ClientAddressListController {
  late BuildContext context;
  late Function refresh;
  List<Address> address = [];
  final AddressProvider _addressProvider = AddressProvider();
  User? user;
  List<Product> selectProducts = [];
  int radioValue = 0;

  final OrderProvider _orderProvider = OrderProvider();

  final SecureStogare _secureStogare = SecureStogare();

  Future init(BuildContext context, Function refresh) async {
    this.refresh = refresh;
    this.context = context;
    user = User.fromJson(await SecureStogare().read('user'));
    _addressProvider.init(context, user!.sessionToken!, user!.id!);
    _orderProvider.init(context, user!.sessionToken!, user!.id!);
    refresh();
  }

  void createOrder() async {
    Navigator.pushNamed(context, '/client/payment/');

    Address a = Address.fromJson(await _secureStogare.read('address'));

    for (var item
        in json.decode(await _secureStogare.read('order'))?.toList() ?? []) {
      selectProducts.add(
        Product.fromJson(item),
      );
    }

    Order order = Order(
      idAddress: a.id!,
      idClient: user!.id!,
      lat: a.lat,
      lng: a.lng,
      products: selectProducts,
      status: '',
      timestamp: null,
    );

    ResponseApi response = await _orderProvider.create(order);

    selectProducts.clear();

    print(response.message);
  }

  void handleRadoiValueChange(int value) {
    radioValue = value;
    _secureStogare.save('address', address[value].toJson());
    refresh();
  }

  Future<List<Address>> getAddress() async {
    address = await _addressProvider.getByUser();
    Address a;
    int index = 0;

    if (await _secureStogare.read('address') != 'null') {
      a = Address.fromJson(await _secureStogare.read('address'));
      index = address.indexWhere((element) => element.id == a.id);
    }

    if (index != -1) {
      radioValue = index;
    }
    print(index);
    return address;
  }

  void goToNewAddress() async {
    var result = await Navigator.pushNamed(context, '/client/address/create');

    if (result != null) {
      if (result as bool) {
        refresh();
      }
    }
  }
}
