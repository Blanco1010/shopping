import 'package:flutter/material.dart';

class DeliveryOrdersListScreen extends StatefulWidget {
  const DeliveryOrdersListScreen({Key? key}) : super(key: key);

  @override
  _DeliveryOrdersListScreenState createState() =>
      _DeliveryOrdersListScreenState();
}

class _DeliveryOrdersListScreenState extends State<DeliveryOrdersListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Delivery Orders'),
      ),
    );
  }
}
