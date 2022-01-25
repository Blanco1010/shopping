import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/api/environment.dart';
import 'package:shop_app/models/order.dart';
import 'package:shop_app/models/response_model.dart';
import 'package:http/http.dart' as http;

import '../controllers/secure_storage.dart';

class OrderProvider {
  final String _url = Environment.apiDilevery;
  final String _api = '/api/orders';
  late BuildContext context;
  late String token;
  late String id;

  Future init(BuildContext context, String token, String id) async {
    this.context = context;
    this.token = token;
    this.id = id;
  }

  Future<List<Order>> getByStatus(String status) async {
    try {
      final Uri url = Uri.http(_url, '$_api/findByUser/$status');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': token,
      };

      final res = await http.get(url, headers: headers);

      //NO AUTORIZADO
      if (res.statusCode == 401) {
        SecureStogare().logout(context, id);
      }

      final data = json.decode(res.body);

      List<Order> list = [];
      list.clear();

      if (data != null) {
        for (var element in data) {
          Order category = Order.fromMap(element);
          list.add(category);
        }
      }
      return list;
    } catch (error) {
      print(error);
      return [];
      // throw Exception(error);
    }
  }

  Future<ResponseApi> create(Order order) async {
    try {
      final Uri url = Uri.http(_url, '$_api/create');
      final bodyParams = order.toJson();

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
      print(error);
      return ResponseApi(success: false, message: 'error al crear order');
    }
  }
}
