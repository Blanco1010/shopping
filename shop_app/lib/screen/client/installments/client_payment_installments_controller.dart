import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:shop_app/controllers/secure_storage.dart';
import 'package:shop_app/models/address.dart';
import 'package:shop_app/models/mercado_pago_card_token.dart';
import 'package:shop_app/models/mercado_pago_installment.dart';

import 'package:shop_app/models/mercado_pago_issuer.dart';
import 'package:shop_app/models/mercado_pago_payment.dart';

import 'package:shop_app/provider/mercado_pago_provider.dart';
import 'package:shop_app/widgets/snackbar.dart';

import '../../../models/mercado_pago_payment_method_installments.dart';
import '../../../models/order.dart';
import '../../../models/product.dart';
import '../../../models/user.dart';
import '../../../widgets/loading_indicator.dart';

class ClientPaymentInstallmentsController {
  late BuildContext context;
  late Function refresh;

  final MercadoPagoProvider _mercadoPagoProvider = MercadoPagoProvider();
  User? user;

  late MercadoPagoCardToken cardToken;

  List<Product> selectProducts = [];
  int total = 0;

  MercadoPagoPaymentMethodInstallments? installments;
  List<MercadoPagoInstallment>? installmentsList = [];
  MercadoPagoIssuer? issuer;
  late MercadoPagoPayment creditCardPayment;

  String selectedInstallment = '';

  late String typeDocument;
  late String documentNumber;

  late Address addres;

  Future init(
    BuildContext context,
    Function refresh,
    MercadoPagoCardToken cardToken,
    String documentNumber,
    String typeDocument,
  ) async {
    this.context = context;
    this.refresh = refresh;
    this.cardToken = cardToken;

    this.typeDocument = typeDocument;
    this.documentNumber = documentNumber;

    user = User.fromJson(await SecureStogare().read('user'));

    _mercadoPagoProvider.init(context, user!);

    for (var item
        in json.decode(await SecureStogare().read('order'))?.toList() ?? []) {
      selectProducts.add(Product.fromJson(item));
    }
    addres = Address.fromJson(await SecureStogare().read('address'));
    getTotal();
    getInstallments();
  }

  void getInstallments() async {
    installments = await _mercadoPagoProvider.getInstallments(
      cardToken.firstSixDigits,
      total,
    );
    print('Installments: ${installments?.toJson()}');

    installmentsList = installments!.payerCosts;
    issuer = installments!.issuer;
    selectedInstallment = installmentsList![0].installments.toString();
    refresh();
  }

  void getTotal() {
    total = selectProducts.fold(
        0, (value, element) => value + (element.price * element.quantity!));
    refresh();
  }

  void createPay() async {
    if (selectedInstallment == '') {
      Snackbar.show(context, 'Debes seleccionar el número de coutas');
    }

    Order order = Order(
      idAddress: addres.id!,
      idClient: user!.id!,
      products: selectProducts,
    );

    _showLoadingIndicator(context);

    Response? response = await _mercadoPagoProvider.createPayment(
      cardId: cardToken.cardId,
      transactionAmount: total.toDouble(),
      installments: int.parse(selectedInstallment),
      paymentMethodId: installments!.paymentMethodId!,
      paymentTypeId: installments!.paymentTypeId!,
      issuerId: installments!.issuer!.id!,
      emailCustomer: user!.email!,
      cardToken: cardToken.id,
      identificationType: typeDocument,
      identificationNumber: documentNumber,
      order: order,
    );

    Navigator.pop(context);

    if (response != null) {
      final data = json.decode(response.body);
      if (response.statusCode == 201) {
        print('SE GENERO UN PAGO ${response.body}');

        final data = json.decode(response.body);
        creditCardPayment = MercadoPagoPayment.fromJsonMap(data);
        print('CREDIT CART PAYMENT ${creditCardPayment.toJson()}');
      }

      if (response.statusCode == 501) {
        if (data['err']['status'] == 400) {
          badRequestProcess(data);
        } else {
          badTokenProcess(data['status'], installments!);
        }
      }
    }
  }

  ///SI SE RECIBE UN STATUS 400
  void badRequestProcess(dynamic data) {
    Map<String, String> paymentErrorCodeMap = {
      '3034': 'Informacion de la tarjeta invalida',
      '205': 'Ingresa el número de tu tarjeta',
      '208': 'Digita un mes de expiración',
      '209': 'Digita un año de expiración',
      '212': 'Ingresa tu documento',
      '213': 'Ingresa tu documento',
      '214': 'Ingresa tu documento',
      '220': 'Ingresa tu banco emisor',
      '221': 'Ingresa el nombre y apellido',
      '224': 'Ingresa el código de seguridad',
      'E301': 'Hay algo mal en el número. Vuelve a ingresarlo.',
      'E302': 'Revisa el código de seguridad',
      '316': 'Ingresa un nombre válido',
      '322': 'Revisa tu documento',
      '323': 'Revisa tu documento',
      '324': 'Revisa tu documento',
      '325': 'Revisa la fecha',
      '326': 'Revisa la fecha'
    };
    String? errorMessage;
    print('CODIGO ERROR ${data['err']['cause'][0]['code']}');

    if (paymentErrorCodeMap.containsKey('${data['err']['cause'][0]['code']}')) {
      print('ENTRO IF');
      errorMessage = paymentErrorCodeMap['${data['err']['cause'][0]['code']}'];
    } else {
      errorMessage = 'No pudimos procesar tu pago';
    }
    Snackbar.show(context, errorMessage!);
    // Navigator.pop(context);
  }

  void badTokenProcess(
      String status, MercadoPagoPaymentMethodInstallments installments) {
    Map<String, String> badTokenErrorCodeMap = {
      '106': 'No puedes realizar pagos a usuarios de otros paises.',
      '109':
          '${installments.paymentMethodId} no procesa pagos en $selectedInstallment cuotas',
      '126': 'No pudimos procesar tu pago.',
      '129':
          '${installments.paymentMethodId} no procesa pagos del monto seleccionado.',
      '145': 'No pudimos procesar tu pago',
      '150': 'No puedes realizar pagos',
      '151': 'No puedes realizar pagos',
      '160': 'No pudimos procesar tu pago',
      '204':
          '${installments.paymentMethodId} no está disponible en este momento.',
      '801':
          'Realizaste un pago similar hace instantes. Intenta nuevamente en unos minutos',
    };
    String? errorMessage;
    if (badTokenErrorCodeMap.containsKey(status.toString())) {
      errorMessage = badTokenErrorCodeMap[status];
    } else {
      errorMessage = 'No pudimos procesar tu pago';
    }
    Snackbar.show(context, errorMessage!);
    // Navigator.pop(context);
  }

  Future<dynamic> _showLoadingIndicator(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: const AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
            backgroundColor: Colors.black,
            content: LoadingIndicator(text: 'Realizando transacción'),
          ),
        );
      },
    );
  }
}
