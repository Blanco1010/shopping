import 'package:stripe_payment/stripe_payment.dart';

class StripeTransactionResponse {
  String message;
  bool success;

  StripeTransactionResponse(this.message, this.success);
}
