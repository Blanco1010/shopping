import 'package:flutter/material.dart';
import 'package:shop_app/models/response_model.dart';
import 'package:shop_app/provider/order_provider.dart';
import 'package:shop_app/provider/user_provider.dart';
import 'package:shop_app/controllers/secure_storage.dart';

import '../../models/order.dart';
import '../../models/user.dart';
import '../../widgets/widgets.dart';

class DeliveryOrderCreateController {
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
    ResponseApi response = await _orderProvider.updateToOnTheWay(order!);

    if (response.success) {
      Navigator.pushNamed(context, '/delivery/map', arguments: order);
    }
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
