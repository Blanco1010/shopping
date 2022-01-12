import 'package:flutter/material.dart';
import 'package:shop_app/controllers/secure_storage.dart';
import 'package:shop_app/models/category.dart';
import 'package:shop_app/models/user.dart';
import 'package:shop_app/provider/category_provider.dart';

class ClientProductsListController {
  late BuildContext context;
  late Function refresh;
  final SecureStogare _secureStogare = SecureStogare();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  final CategoryProvider _categoryProvider = CategoryProvider();

  User? user;

  List categorys = [];

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    user = User.fromJson(await _secureStogare.read('user'));
    _categoryProvider.init(context, user!.sessionToken, user!.id!);
    getCategories();
    refresh();
  }

  void getCategories() async {
    categorys = await _categoryProvider.getAll();
    refresh();
  }

  void logout() {
    _secureStogare.logout(context, user!.id!);
  }

  void openDrawer() {
    key.currentState!.openDrawer();
  }

  void goToUpdate() {
    Navigator.pushNamed(context, '/client/update');
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context, '/roles', (route) => false);
  }
}
