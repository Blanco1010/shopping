import 'package:flutter/material.dart';

import 'package:shop_app/Theme/theme.dart';
import 'package:shop_app/screen/client/installments/client_payment_installments.dart';

import '../../../models/mercado_pago_card_token.dart';
import '../../../models/mercado_pago_document_type.dart';

class ClientPaymentInstallmentsScreen extends StatefulWidget {
  const ClientPaymentInstallmentsScreen({
    Key? key,
    required this.mercadoPagoCardToken,
  }) : super(key: key);

  final MercadoPagoCardToken mercadoPagoCardToken;

  @override
  State<ClientPaymentInstallmentsScreen> createState() =>
      _ClientPaymentInstallmentsScreenState();
}

class _ClientPaymentInstallmentsScreenState
    extends State<ClientPaymentInstallmentsScreen> {
  final ClientPaymentInstallmentsController _con =
      ClientPaymentInstallmentsController();

  @override
  void initState() {
    super.initState();
    _con.init(context, refresh, widget.mercadoPagoCardToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coutas'),
        centerTitle: true,
        backgroundColor: MyColors.colorPrimary,
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back),
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textDescription(),
          _dropDownInstallments(),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: MediaQuery.of(context).size.height * 0.25,
        child: Column(
          children: [
            _textTotalPrice(),
            const Spacer(),
            _buttonNext(),
          ],
        ),
      ),
    );
  }

  Widget _textDescription() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: const Text(
        'En cuantas coutas?',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _textTotalPrice() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          const Text(
            'Total a pagar:',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            '${_con.total}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
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
              Icons.attach_money,
              color: Colors.white,
              size: 35,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              height: 60,
              child: const Center(
                child: Text(
                  'CONFIRMAR PAGO',
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

  Widget _dropDownInstallments() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              itemHeight: 50,
              alignment: Alignment.center,
              icon: const Icon(Icons.arrow_drop_down_circle_sharp),
              iconDisabledColor: Colors.grey,
              iconEnabledColor: MyColors.colorPrimary,
              elevation: 1,
              isExpanded: true,
              hint: const Text(
                'Seleccionar número de coutas',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              items: _dropDownItems([]),
              value: '',
              onChanged: (option) {
                refresh();
              },
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(
      List<MercadoPagoDocumentType> documents) {
    List<DropdownMenuItem<String>> list = [];
    for (var element in documents) {
      list.add(DropdownMenuItem(
        child: Container(
          margin: const EdgeInsets.only(top: 7),
          child: Text(element.id),
        ),
        value: element.id,
      ));
    }
    return list;
  }

  void refresh() {
    setState(() {});
  }
}
