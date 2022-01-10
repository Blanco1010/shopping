import 'package:flutter/material.dart';
import 'package:shop_app/controllers/secure_storage.dart';
import 'package:shop_app/models/user.dart';

class RestaurantOrdersListController {
  late BuildContext context;
  SecureStogare secureStogare = SecureStogare();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  User? user;

  final SecureStogare _secureStogare = SecureStogare();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    user = User.fromJson(await _secureStogare.read('user'));
    refresh();
  }

  void logout() {
    secureStogare.logout(context, user!.id!);
  }

  void openDrawer() {
    key.currentState!.openDrawer();
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context, '/roles', (route) => false);
  }

  void goToCategoryCreate() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/restaurant/categories/create',
      (route) => false,
    );
  }

  void goToProductCreate() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/restaurant/product/create',
      (route) => false,
    );
  }
}
