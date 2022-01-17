import 'package:flutter/material.dart';

class ClientAddressListController {
  late BuildContext context;
  late Function refresh;

  Future init(BuildContext context, Function refresh) async {
    this.refresh = refresh;
    this.context = context;
  }

  void goToNewAddress() {
    Navigator.pushNamed(context, '/client/address/create');
  }
}
