import 'package:flutter/material.dart';
import 'package:shop_app/screen/screen.dart';

class Routes {
  static const initialHome = 'login';

  static Map<String, Widget Function(BuildContext context)> routes = {
    'login': (BuildContext context) => const LoginScreen(),
  };
}
