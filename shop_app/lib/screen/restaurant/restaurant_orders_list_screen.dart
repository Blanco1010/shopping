import 'package:flutter/material.dart';

class RestaurantOrdersListScreen extends StatefulWidget {
  const RestaurantOrdersListScreen({Key? key}) : super(key: key);

  @override
  _RestaurantOrdersListScreenState createState() =>
      _RestaurantOrdersListScreenState();
}

class _RestaurantOrdersListScreenState
    extends State<RestaurantOrdersListScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Restaurant Orders'),
      ),
    );
  }
}
