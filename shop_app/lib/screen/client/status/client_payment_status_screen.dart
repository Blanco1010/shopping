import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

import 'package:shop_app/Theme/theme.dart';

class ClientPaymentStatusScreen extends StatefulWidget {
  const ClientPaymentStatusScreen({Key? key}) : super(key: key);

  @override
  State<ClientPaymentStatusScreen> createState() =>
      _ClientPaymentStatusScreenState();
}

class _ClientPaymentStatusScreenState extends State<ClientPaymentStatusScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _clipPathOval(),
          _textDetail(),
          _textDetailStatus(),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: MediaQuery.of(context).size.height * 0.25,
        child: _buttonNext(),
      ),
    );
  }

  Widget _textDetail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: const Text(
        'Tu orden fue procesada exitosamente',
        style: TextStyle(
          fontSize: 17,
        ),
      ),
    );
  }

  Widget _textDetailStatus() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: const Text(
        'Mira el estado de tu compra en la sección de MIS PEDIDOS',
        style: TextStyle(
          fontSize: 17,
        ),
      ),
    );
  }

  Widget _clipPathOval() {
    return ClipPath(
      clipper: OvalBottomBorderClipper(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: double.infinity,
        color: MyColors.colorPrimary,
        child: SafeArea(
          child: Column(
            children: const [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 150,
              ),
              Text(
                'Gracias por su compra',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonNext() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 35,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              height: 60,
              child: const Center(
                child: Text(
                  'FINALIZAR COMPRA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
