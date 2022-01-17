import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shop_app/Theme/theme.dart';
import 'package:shop_app/widgets/no_data_widget.dart';
import '../../controllers/client/client_address_list_controller.dart';

class ClientAddressListScreen extends StatefulWidget {
  const ClientAddressListScreen({Key? key}) : super(key: key);

  @override
  _ClientAddressListScreenState createState() =>
      _ClientAddressListScreenState();
}

class _ClientAddressListScreenState extends State<ClientAddressListScreen> {
  final ClientAddressListController _con = ClientAddressListController();

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
        title: const Text('Dirección'),
        centerTitle: true,
        actions: [
          _iconAdd(),
        ],
      ),
      body: Column(children: [
        _textSelectAddress(),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 50),
            child: NoDataWidget(text: 'Agregar una nueva dirección')),
        _buttonNewAddress(),
      ]),
      bottomNavigationBar: _buttonAccept(),
    );
  }

  Widget _buttonNewAddress() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.green,
        ),
        onPressed: () {
          _con.goToNewAddress();
        },
        child: const Text(
          'Nueva dirección',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buttonAccept() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: MyColors.colorPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        onPressed: () {},
        child: const Text(
          'ACEPTAR',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Container _textSelectAddress() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 20),
      child: const Text(
        'Elige donde recibir tus compras',
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Container _iconAdd() {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () => _con.goToNewAddress(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
