import 'package:flutter/material.dart';

class ClientAddressMapController {
  late BuildContext context;
  late Function refresh;

  Future init(BuildContext context, Function refresh) async {
    this.refresh = refresh;
    this.context = context;
  }
}
