import 'package:flutter/material.dart';

class ClientProductDetailController {
  late BuildContext context;
  late Function refresh;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
  }
}
