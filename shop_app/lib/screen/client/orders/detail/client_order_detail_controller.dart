import 'package:flutter/material.dart';
import 'package:shop_app/provider/order_provider.dart';
import 'package:shop_app/provider/user_provider.dart';
import 'package:shop_app/controllers/secure_storage.dart';

import '../../../../models/order.dart';
import '../../../../models/user.dart';
import '../../client_map_screen.dart';

class ClientOrderDetailCreateController {
  late BuildContext context;
  late Function refresh;

  final SecureStogare _secureStogare = SecureStogare();

  int total = 0;
  Order? order;

  List<User>? listUser = [];
  final UsersProvider _userProvider = UsersProvider();
  final OrderProvider _orderProvider = OrderProvider();
  User? user;

  Future init(BuildContext context, Function refresh, Order order) async {
    this.context = context;
    this.refresh = refresh;
    this.order = order;
    user = User.fromJson(await _secureStogare.read('user'));

    _userProvider.init(context, token: user!.sessionToken, id: user!.id!);

    _orderProvider.init(context, user!.sessionToken, user!.id!);

    getTotal();
    getUsers();
    refresh();
  }

  void updateOrder() async {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return ClientMapScreen(order: order);
        },
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation =
              CurvedAnimation(parent: animation, curve: Curves.easeInOut);

          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(curvedAnimation),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0, end: 1).animate(curvedAnimation),
              child: child,
            ),
          );
        },
      ),
    );
  }

  void getUsers() async {
    listUser = await _userProvider.getDeliveryMen();
    refresh();
  }

  void getTotal() {
    total = order!.products!
        .fold(0, (value, element) => value + element.quantity! * element.price);
    refresh();
  }
}
