import 'package:flutter/cupertino.dart';
import 'package:flutter_credit_card/credit_card_model.dart';

class ClientPaymentController {
  late BuildContext context;
  late Function refresh;
  GlobalKey<FormState> keyFrom = GlobalKey<FormState>();

  String cardNumber = '';
  String expireDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
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
