import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../controllers/client/client_address_map_controller.dart';

class ClientAddressMapScreen extends StatefulWidget {
  const ClientAddressMapScreen({Key? key}) : super(key: key);

  @override
  _ClientAddressMapScreenState createState() => _ClientAddressMapScreenState();
}

class _ClientAddressMapScreenState extends State<ClientAddressMapScreen> {
  final ClientAddressMapController _con = ClientAddressMapController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubica tu dirección en el mapa'),
        centerTitle: true,
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
