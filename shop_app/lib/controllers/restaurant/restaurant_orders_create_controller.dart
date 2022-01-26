import 'package:flutter/material.dart';
import 'package:shop_app/models/response_model.dart';
import 'package:shop_app/provider/order_provider.dart';
import 'package:shop_app/provider/user_provider.dart';
import 'package:shop_app/controllers/secure_storage.dart';

import '../../models/order.dart';
import '../../models/user.dart';
import '../../widgets/widgets.dart';

class RestaurantOrderCreateController {
  late BuildContext context;
  late Function refresh;

  final SecureStogare _secureStogare = SecureStogare();

  int total = 0;
  Order? order;

  List<User>? listUser = [];
  final UsersProvider _userProvider = UsersProvider();
  final OrderProvider _orderProvider = OrderProvider();
  User? user;
  String? idDelivery;

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
    if (idDelivery != null) {
      order!.idDelivery = idDelivery;
      ResponseApi response = await _orderProvider.updateToDispached(order!);
      Snackbar.show(context, response.message);

      Navigator.pop(context, true);
    } else {
      Snackbar.show(context, 'Selecciona el repartidor');
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
