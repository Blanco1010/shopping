import 'package:flutter/material.dart';
import 'package:shop_app/controllers/secure_storage.dart';
import 'package:shop_app/models/order.dart';
import 'package:shop_app/models/user.dart';
import 'package:shop_app/provider/order_provider.dart';
import 'package:shop_app/screen/restaurant/restaurant_orders_create_screen.dart';

class DeliveryOrdersListController {
  late BuildContext context;
  late Function refresh;
  SecureStogare secureStogare = SecureStogare();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  User? user;

  List<String> status = ['DESPACHADO', 'EN CAMINO', 'ENTREGADO'];
  final OrderProvider _orderProvider = OrderProvider();

  final SecureStogare _secureStogare = SecureStogare();

  Future init(BuildContext context, Function refresh) async {
    user = User.fromJson(await _secureStogare.read('user'));
    this.context = context;
    this.refresh = refresh;
    _orderProvider.init(context, user!.sessionToken, user!.id!);
    refresh();
  }

  Future<List<Order>> getOrders(String status) async {
    if (user?.id != null) {
      return await _orderProvider.getByDeliveryStatus(user!.id!, status);
    } else {
      return [];
    }
  }

  void goToPageOrders(Order order) async {
    bool isUpdated = await Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return RestaurantOrderCreateScreen(order: order);
            },
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              final curvedAnimation =
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut);

              return FadeTransition(
                opacity: Tween(begin: 0.0, end: 1.0).animate(curvedAnimation),
                child: FadeTransition(
                  opacity:
                      Tween<double>(begin: 0, end: 1).animate(curvedAnimation),
                  child: child,
                ),
              );
            },
          ),
        ) ??
        false;
    if (isUpdated) {
      refresh();
    }
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
