import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/api/environment.dart';
import 'package:shop_app/models/response_model.dart';

import 'package:http/http.dart' as http;

import '../models/user.dart';

class UsersProvider {
  final String _url = Environment.apiDilevery;
  final String _api = '/api/users';

  late BuildContext context;

  Future? init(BuildContext context) {
    this.context = context;
  }

  Future<ResponseApi> create(User user) async {
    try {
      final Uri url = Uri.http(_url, '$_api/create');
      final bodyParams = user.toJson();

      Map<String, String> headers = {'Content-Type': 'application/json'};

      final res = await http.post(url, headers: headers, body: bodyParams);

      final data = json.decode(res.body);

      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (error) {
      print('Error: $error');
      return ResponseApi(
        success: false,
        message: 'error al crear usuario',
        error: error.toString(),
      );
    }
  }
}
