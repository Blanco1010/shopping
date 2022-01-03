import 'package:flutter/material.dart';
import 'package:shop_app/controllers/secure_storage.dart';

class RestaurantOrdersListController {
  late BuildContext context;
  SecureStogare secureStogare = SecureStogare();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  Future init(BuildContext context) async {
    this.context = context;
  }

  void logout() {
    secureStogare.logout(context);
  }

  void openDrawer() {
    key.currentState!.openDrawer();
  }
}
