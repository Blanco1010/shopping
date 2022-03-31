import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shop_app/controllers/secure_storage.dart';
import 'package:shop_app/models/category.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/models/user.dart';
import 'package:shop_app/provider/category_provider.dart';
import 'package:shop_app/provider/product_provider.dart';

import '../detail/client_product_detail_screen.dart';

class ClientProductsListController {
  late BuildContext context;
  late Function refresh;

  final SecureStogare _secureStogare = SecureStogare();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  final CategoryProvider _categoryProvider = CategoryProvider();
  final ProductsProvider _productsProvider = ProductsProvider();

  User? user;

  List<Category> categorys = [];

  Timer? searchOnStoppedTyping;
  String productName = '';

  // PushNotificationsProvider pushNotificationsProvider =
  //     PushNotificationsProvider();

  // final UsersProvider _usersProvider = UsersProvider();

  // List<String>? tokens = [];

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    user = User.fromJson(await _secureStogare.read('user'));

    _categoryProvider.init(context, user!.sessionToken, user!.id!);
    _productsProvider.init(context, user!.sessionToken, user!.id!);

    // _usersProvider.init(context, token: user!.sessionToken, id: user!.id);

    // tokens = await _usersProvider.getAdminsNotificationsTokens();
    // sendNotification();

    getCategories();
    refresh();
  }

  // void sendNotification() {
  //   List<String> registrationIds = [];

  //   for (String? token in tokens!) {
  //     if (token != null) {
  //       registrationIds.add(token);
  //     }
  //   }

  //   Map<String, dynamic> data = {'click_action': 'FLUTTER_NOTIFICATION_CLICK'};

  //   pushNotificationsProvider.sendMessageMultiple(
  //     registrationIds,
  //     data,
  //     'COMPRA EXITOSA',
  //     'Un cliente ha realizado un pedido',
  //   );
  // }

  void onChangeText(String text) {
    Duration duration = const Duration(milliseconds: 800);

    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping!.cancel();
      refresh();
    }
    searchOnStoppedTyping = Timer(duration, () {
      productName = text;
      refresh();
      debugPrint(productName);
    });
  }

  Future<List<Product>> getProducts(
    String idCategory,
    String productName,
  ) async {
    if (productName.isEmpty) {
      return await _productsProvider.getByCategory(idCategory);
    } else {
      return await _productsProvider.getByCategoryAndProductName(
        idCategory,
        productName,
      );
    }
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

  void goToOrdersList() {
    Navigator.pushNamed(context, '/client/orders/list');
  }

  void goToOrderCreateScreen() {
    Navigator.pushNamed(context, '/client/order/create');
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context, '/roles', (route) => false);
  }
}
