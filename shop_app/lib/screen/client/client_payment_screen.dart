import 'package:flutter/material.dart';

import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:shop_app/Theme/theme.dart';
import 'package:shop_app/controllers/client/client_payment_controller.dart';

import '../../models/mercado_pago_document_type.dart';

class ClientPaymentScreen extends StatefulWidget {
  const ClientPaymentScreen({Key? key}) : super(key: key);

  @override
  State<ClientPaymentScreen> createState() => _ClientPaymentScreenState();
}

class _ClientPaymentScreenState extends State<ClientPaymentScreen> {
  final ClientPaymentController _con = ClientPaymentController();

  @override
  void initState() {
    super.initState();
    _con.init(context, refresh);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagos'),
        centerTitle: true,
        backgroundColor: MyColors.colorPrimary,
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back),
          onTap: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          CreditCardWidget(
            cardNumber: _con.cardNumber,
            expiryDate: _con.expireDate,
            cardHolderName: _con.cardHolderName,
            cvvCode: _con.cvvCode,
            showBackView: false,
            isChipVisible: false,
            isHolderNameVisible: true,
            labelCardHolder: 'NOMBRE Y APELLIDO',
            onCreditCardWidgetChange: (creditCardBrand) {},
          ),
          CreditCardForm(
            formKey: _con.keyFrom, // Required
            onCreditCardModelChange: _con.onCreditCardModelChange, // Required
            themeColor: MyColors.colorPrimary,
            obscureCvv: true,
            obscureNumber: true,
            isHolderNameVisible: true,
            isCardNumberVisible: true,
            isExpiryDateVisible: true,
            cardNumberDecoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Número de la tarjeta',
              hintText: 'XXXX XXXX XXXX XXXX',
            ),
            expiryDateDecoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Fecha de expiración',
              hintText: 'XX/XX',
            ),
            cvvCodeDecoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'CVV',
              hintText: 'XXX',
            ),
            cardHolderDecoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nombre del titular',
            ),
            expiryDate: '',
            cardHolderName: '',
            cardNumber: '',
            cvvCode: '',
          ),
          _documentInfo(),
          _buttonNext(),
        ],
      ),
    );
  }

  Widget _buttonNext() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () {
          _con.createCardToken();
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.payment,
              color: Colors.white,
              size: 35,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              height: 60,
              child: const Center(
                child: Text(
                  'CONTINUAR',
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

  Widget _documentInfo() {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 16),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: Material(
              elevation: 2.0,
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(5.0),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
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
                      'Tipo doc',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    items: _dropDownItems(_con.documentTypeList),
                    value: _con.typeDocument,
                    onChanged: (option) {
                      _con.typeDocument = option!;
                      refresh();
                    },
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: TextField(
              controller: _con.documentNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Número de documento',
              ),
            ),
          )
        ],
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
