import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/api/environment.dart';
import 'package:shop_app/models/address.dart';
import 'package:shop_app/models/response_model.dart';
import 'package:http/http.dart' as http;

import '../controllers/secure_storage.dart';

class AddressProvider {
  final String _url = Environment.apiDilevery;
  final String _api = '/api/address';
  late BuildContext context;
  late String token;
  late String id;

  Future init(BuildContext context, String token, String id) async {
    this.context = context;
    this.token = token;
    this.id = id;
  }

  Future<List<Address>> getByUser() async {
    try {
      final Uri url = Uri.http(_url, '$_api/findByUser/$id');

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

      List<Address> list = [];

      if (data != null) {
        for (var element in data) {
          // Category category = Category.fromJson(element as String);
          Address category = Address(
            id: element['id'],
            idUser: element['id_user'],
            address: element['address'],
            lat: double.parse(element['lat']),
            lng: double.parse(element['lng']),
            neightborhood: element['neightborhood'],
          );
          list.add(category);
        }
      }

      return list;
    } catch (error) {
      return [];
    }
  }

  Future<ResponseApi> create(Address address) async {
    try {
      final Uri url = Uri.http(_url, '$_api/create');
      final bodyParams = address.toJson();

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
