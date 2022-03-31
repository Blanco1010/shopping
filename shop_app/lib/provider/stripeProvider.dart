// ignore: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../models/stripe_transaction_response.dart';

import 'package:http/http.dart' as http;

class StripeProvider {
  static String secretAPI =
      'sk_test_51JFh5jKfThoPE1Io7EDKIJcNtx6Vmi7Cqfn3nbsO1xqwcllwsanQc9PN75ndjMzXf1DMTt1DTAieKZrE1gvmtWBr00EUhlbrsY';

  static String publicSecret =
      'pk_test_51JFh5jKfThoPE1Ioe9NjNnNzjqP3g4XknEJMO6xuXWPVCzqZuY0AZ57CDzhlhjxBvmj12j1UyybQUSrG6hzDty9100F74ItwRm';

  Map<String, String> headers = {
    'Authorization': 'Bearer $secretAPI',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  late Map<String, dynamic> paymentIntentData;

  // void init() {
  //   StripePayment.setOptions(
  //     StripeOptions(
  //       publishableKey: publicSecret,
  //       merchantId: 'test',
  //       androidPayMode: 'test',
  //     ),
  //   );
  // }

  Future<StripeTransactionResponse?> payWithCard(
      String amount, String currency) async {
    try {
      // var paymentMethod = await StripePayment.paymentRequestWithCardForm(
      //   CardFormPaymentRequest(),
      // );

      paymentIntentData = await createPaymentIntent(amount, currency);
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customerId: paymentIntentData['customer'],
          paymentIntentClientSecret: paymentIntentData['client_secret'],
          customerEphemeralKeySecret: paymentIntentData['ephemeralKey'],
          googlePay: true,
          applePay: true,
          testEnv: true,
          style: ThemeMode.system,
          merchantCountryCode: 'CO',
          merchantDisplayName: 'Flutter Stripe Store Demo',
        ),
      );

      StripeTransactionResponse responseStripe = await displayPaymentSheet();

      return responseStripe;

      // var response = await StripePayment.confirmPaymentIntent(
      //   PaymentIntent(
      //     clientSecret: paymentIntent['client_secret'],
      //     paymentMethodId: paymentMethod.id,
      //   ),
      // );

      // if (response.status == 'succeeded') {
      //   return StripeTransactionResponse('Transacción exitosa', true);
      // } else {
      //   return StripeTransactionResponse('Transacción fallo', false);
      // }
    } catch (error) {
      rethrow;
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      return StripeTransactionResponse('Transacción exitosa', true);
    } on StripeException catch (error) {
      return StripeTransactionResponse(error.toString(), false);
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      Uri uri = Uri.https('api.stripe.com', 'v1/payment_intents');

      var response = await http.post(uri, body: body, headers: headers);

      return jsonDecode(response.body.toString());
    } catch (e) {
      rethrow;
    }
  }

  calculateAmount(String amount) {
    final price = int.parse(amount) * 100;
    return price.toString();
  }
}
