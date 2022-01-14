import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shop_app/controllers/client/client_product_detail_controller.dart';

class ClientProductDetailScreen extends StatefulWidget {
  const ClientProductDetailScreen({Key? key}) : super(key: key);

  @override
  _ClientProductDetailState createState() => _ClientProductDetailState();
}

class _ClientProductDetailState extends State<ClientProductDetailScreen> {
  final ClientProductDetailController _clientProductDetailController =
      ClientProductDetailController();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _clientProductDetailController.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.87,
        child: const Text('PRODUCT DETAILS'));
  }

  void refresh() {
    setState(() {});
  }
}
