import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/controllers/secure_storage.dart';
import 'package:shop_app/models/address.dart';
import 'package:shop_app/provider/address_provider.dart';

import '../../models/user.dart';

class ClientAddressListController {
  late BuildContext context;
  late Function refresh;
  List<Address> address = [];
  final AddressProvider _addressProvider = AddressProvider();
  User? user;

  int radioValue = 0;

  final SecureStogare _secureStogare = SecureStogare();

  Future init(BuildContext context, Function refresh) async {
    this.refresh = refresh;
    this.context = context;
    user = User.fromJson(await SecureStogare().read('user'));
    _addressProvider.init(context, user!.sessionToken!, user!.id!);
    refresh();
  }

  void handleRadoiValueChange(int value) {
    radioValue = value;
    _secureStogare.save('address', address[value].toJson());
    refresh();
  }

  Future<List<Address>> getAddress() async {
    address = await _addressProvider.getByUser();

    Address a = Address.fromJson(await _secureStogare.read('address'));

    int index = address.indexWhere((element) => element.id == a.id);

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
