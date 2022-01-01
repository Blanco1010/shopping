import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shop_app/controllers/client_product_list_controller.dart';

class ClientProductsListScreen extends StatefulWidget {
  const ClientProductsListScreen({Key? key}) : super(key: key);

  @override
  _ClientProductsListScreenState createState() =>
      _ClientProductsListScreenState();
}

class _ClientProductsListScreenState extends State<ClientProductsListScreen> {
  ClientProductsListController co = ClientProductsListController();
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      co.init(context);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: co.logout,
          child: const Text('Cerrar sesion'),
        ),
      ),
    );
  }
}
