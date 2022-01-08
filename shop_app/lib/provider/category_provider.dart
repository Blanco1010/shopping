import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/api/environment.dart';
import 'package:shop_app/models/response_model.dart';
import 'package:http/http.dart' as http;

import '../controllers/secure_storage.dart';
import '../models/category.dart';

class CategoryProvider {
  final String _url = Environment.apiDilevery;
  final String _api = '/api/category';
  late BuildContext context;
  late String token;
  late String id;

  Future init(BuildContext context, String token, String id) async {
    this.context = context;
    this.token = token;
  }

  Future<ResponseApi> create(Category category) async {
    try {
      final Uri url = Uri.http(_url, '$_api/create');
      final bodyParams = category.toJson();

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': token,
      };

      final res = await http.post(url, headers: headers, body: bodyParams);

//NO AUTORIZADO
      if (res.statusCode == 401) {
        SecureStogare().logout(context, id);
      }

      final data = json.decode(res.body);

      ResponseApi responseApi = ResponseApi.fromMap(data);

      return responseApi;
    } catch (error) {
      return ResponseApi(success: false, message: 'error al crear categoria');
    }
  }
}
