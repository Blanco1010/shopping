import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:shop_app/api/environment.dart';
import 'package:shop_app/models/mercado_pago_document_type.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class MercadoPagoProvider {
  final String _urlMercadoPago = 'api.mercadopago.com';

  final _mercadoPageCredentials = Environment.mercadoPagoCredentials;

  late BuildContext context;
  late User user;

  Future init(BuildContext context, User user) async {
    this.context = context;
    this.user = user;
  }

  Future<List<MercadoPagoDocumentType>> getIdentificationTypes() async {
    try {
      final url = Uri.https(
        _urlMercadoPago,
        '/v1/identification_types',
        {
          'access_token': _mercadoPageCredentials.accessToken,
        },
      );

      final res = await http.get(url);

      final data = json.decode(res.body);

      final result = MercadoPagoDocumentType.fromJsonList(data);

      return result.documentTypeList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<http.Response?> createCardToken({
    required String cvv,
    required String expirationYear,
    required int expirationMonth,
    required String cardNumber,
    required String documentNumber,
    required String documentId,
    required String cardHolderName,
  }) async {
    try {
      final url = Uri.https(
        _urlMercadoPago,
        '/v1/card_tokens',
        {
          'public_key': _mercadoPageCredentials.publicKey,
        },
      );

      final body = {
        'security_code': cvv,
        'expiration_year': expirationYear,
        'expiration_month': expirationMonth,
        'card_number': cardNumber,
        'card_holder': {
          'identification': {
            'number': documentNumber,
            'type': documentId,
          },
          'name': cardHolderName,
        }
      };

      final res = await http.post(url, body: json.encode(body));

      return res;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
