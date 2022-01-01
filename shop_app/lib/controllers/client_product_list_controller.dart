import 'package:flutter/material.dart';
import 'package:shop_app/controllers/secure_storage.dart';

class ClientProductsListController {
  late BuildContext context;
  SecureStogare secureStogare = SecureStogare();

  Future init(BuildContext context) async {
    this.context = context;
  }

  logout() {
    secureStogare.logout(context);
  }
}
