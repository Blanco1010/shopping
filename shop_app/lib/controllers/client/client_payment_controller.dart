import 'package:flutter/cupertino.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:shop_app/controllers/secure_storage.dart';
import 'package:shop_app/models/mercado_pago_document_type.dart';
import 'package:shop_app/provider/mercado_pago_provider.dart';

import '../../models/user.dart';

class ClientPaymentController {
  late BuildContext context;
  late Function refresh;
  GlobalKey<FormState> keyFrom = GlobalKey<FormState>();

  String cardNumber = '';
  String expireDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  List<MercadoPagoDocumentType> documentTypeList = [];
  final MercadoPagoProvider _mercadoPagoProvider = MercadoPagoProvider();
  User? user;

  String typeDocument = 'CC';

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    user = User.fromJson(await SecureStogare().read('user'));

    _mercadoPagoProvider.init(context, user!);
    getIdentificationTypes();
  }

  void getIdentificationTypes() async {
    documentTypeList = await _mercadoPagoProvider.getIdentificationTypes();
    refresh();
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    cardNumber = creditCardModel.cardNumber;
    expireDate = creditCardModel.expiryDate;
    cardHolderName = creditCardModel.cardHolderName;
    cvvCode = creditCardModel.cvvCode;
    isCvvFocused = creditCardModel.isCvvFocused;
    refresh();
  }
}
