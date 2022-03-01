// import 'dart:convert';

// import 'package:flutter/cupertino.dart';

// import 'package:shop_app/api/environment.dart';
// import 'package:shop_app/models/mercado_pago_document_type.dart';
// import 'package:http/http.dart' as http;
// import 'package:shop_app/models/mercado_pago_payment_method_installments.dart';

// import '../controllers/secure_storage.dart';
// import '../models/order.dart';
// import '../models/user.dart';

// class MercadoPagoProvider {
//   final String _urlMercadoPago = 'api.mercadopago.com';
//   final String _url = Environment.apiDilevery;

//   final _mercadoPageCredentials = Environment.mercadoPagoCredentials;

//   late BuildContext context;
//   late User user;

//   Future init(BuildContext context, User user) async {
//     this.context = context;
//     this.user = user;
//   }

//   Future<List<MercadoPagoDocumentType>> getIdentificationTypes() async {
//     try {
//       final url = Uri.http(
//         _urlMercadoPago,
//         '/v1/identification_types',
//         {
//           'access_token': _mercadoPageCredentials.accessToken,
//         },
//       );

//       final res = await http.get(url);

//       final data = json.decode(res.body);

//       final result = MercadoPagoDocumentType.fromJsonList(data);

//       return result.documentTypeList;
//     } catch (e) {
//       print(e);
//       return [];
//     }
//   }

//   Future<http.Response?>? createPayment({
//     required String cardId,
//     required double transactionAmount,
//     required int installments,
//     required String paymentMethodId,
//     required String paymentTypeId,
//     required String issuerId,
//     required String emailCustomer,
//     required String cardToken,
//     required String identificationType,
//     required String identificationNumber,
//     required Order order,
//   }) async {
//     try {
//       Uri url = Uri.http(
//         _url,
//         '/api/payments/createPay',
//         {
//           'public_key': _mercadoPageCredentials.publicKey,
//         },
//       );

//       Map<String, dynamic> body = {
//         'order': order,
//         'card_id': cardId,
//         'description': 'Flutter Delivery Blanco',
//         'transaction_amount': transactionAmount,
//         'installments': installments,
//         'payment_method_id': paymentMethodId,
//         'payment_type:id': paymentTypeId,
//         'token': cardToken,
//         'issuer_id': issuerId,
//         'payer': {
//           'email': emailCustomer,
//           'identification': {
//             'type': identificationType,
//             'number': identificationNumber
//           },
//         }
//       };

//       String bodyParams = json.encode(body);

//       Map<String, String> headers = {
//         'Content-Type': 'application/json',
//         'Authorization': user.sessionToken,
//       };

//       final res = await http.post(url, headers: headers, body: bodyParams);

//       if (res.statusCode == 401) {
//         SecureStogare().logout(context, user.id!);
//       }

//       return res;
//     } catch (error) {
//       print(error);
//       return null;
//     }
//   }

//   Future<MercadoPagoPaymentMethodInstallments?> getInstallments(
//     String bin,
//     int amount,
//   ) async {
//     try {
//       final url = Uri.https(
//         _urlMercadoPago,
//         '/v1/payment_methods/installments',
//         {
//           'access_token': _mercadoPageCredentials.accessToken,
//           'bin': bin,
//           'amount': '${amount}',
//         },
//       );

//       final res = await http.get(url);

//       final data = json.decode(res.body);

//       final result = MercadoPagoPaymentMethodInstallments.fromJsonList(data);

//       return result.installmentList.first;
//     } catch (e) {
//       print('PRUEBA');
//       print(e);
//       return null;
//     }
//   }

//   Future<http.Response?> createCardToken({
//     required String cvv,
//     required String expirationYear,
//     required int expirationMonth,
//     required String cardNumber,
//     required String documentNumber,
//     required String documentId,
//     required String cardHolderName,
//   }) async {
//     try {
//       final url = Uri.https(
//         _urlMercadoPago,
//         '/v1/card_tokens',
//         {
//           'public_key': _mercadoPageCredentials.publicKey,
//         },
//       );

//       final body = {
//         'security_code': cvv,
//         'expiration_year': expirationYear,
//         'expiration_month': expirationMonth,
//         'card_number': cardNumber,
//         'card_holder': {
//           'identification': {
//             'number': documentNumber,
//             'type': documentId,
//           },
//           'name': cardHolderName,
//         }
//       };

//       final res = await http.post(url, body: json.encode(body));

//       return res;
//     } catch (error) {
//       print(error);
//       return null;
//     }
//   }
// }
