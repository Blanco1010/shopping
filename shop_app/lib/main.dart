import 'package:flutter/material.dart';
import 'package:shop_app/Theme/theme.dart';
import 'package:shop_app/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop app',
      debugShowCheckedModeBanner: false,
      routes: Routes.routes,
      initialRoute: Routes.initialHome,
      theme: themeData,
    );
  }
}
