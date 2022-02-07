import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop_app/api/environment.dart';
import 'package:shop_app/models/mercado_pago_document_type.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class MercadoPagoProvider {
  String _urlMercadoPage = 'api.mercadopago.com';

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
        _urlMercadoPage,
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
}
