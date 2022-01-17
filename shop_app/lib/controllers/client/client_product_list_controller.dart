import 'package:flutter/material.dart';
import 'package:shop_app/controllers/secure_storage.dart';
import 'package:shop_app/models/category.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/models/user.dart';
import 'package:shop_app/provider/category_provider.dart';
import 'package:shop_app/provider/product_provider.dart';

import '../../screen/client/client_product_detail_screen.dart';

class ClientProductsListController {
  late BuildContext context;
  late Function refresh;

  final SecureStogare _secureStogare = SecureStogare();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  final CategoryProvider _categoryProvider = CategoryProvider();
  final ProductsProvider _productsProvider = ProductsProvider();

  User? user;

  List<Category> categorys = [];

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    user = User.fromJson(await _secureStogare.read('user'));

    _categoryProvider.init(context, user!.sessionToken, user!.id!);
    _productsProvider.init(context, user!.sessionToken, user!.id!);

    getCategories();
    refresh();
  }

  Future<List<Product>> getProducts(String idCategory) async {
    return await _productsProvider.getByCategory(idCategory);
  }

  void getCategories() async {
    categorys = await _categoryProvider.getAll();
    refresh();
  }

  void goToProductDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientProductDetailScreen(
          product: product,
        ),
      ),
    );
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

  void goToOrderCreateScreen() {
    Navigator.pushNamed(context, '/client/order/create');
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context, '/roles', (route) => false);
  }
}
