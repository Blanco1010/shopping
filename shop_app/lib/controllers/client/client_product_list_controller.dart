import 'package:flutter/material.dart';
import 'package:shop_app/controllers/secure_storage.dart';
import 'package:shop_app/models/user.dart';

class ClientProductsListController {
  late BuildContext context;
  final SecureStogare _secureStogare = SecureStogare();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  User? user;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    user = User.fromJson(await _secureStogare.read('user'));
    refresh();
  }

  void logout() {
    _secureStogare.logout(context);
  }

  void openDrawer() {
    key.currentState!.openDrawer();
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context, '/roles', (route) => false);
  }
}
