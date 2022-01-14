import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

import 'package:flutter/material.dart';
import 'package:shop_app/api/environment.dart';

import 'package:http/http.dart' as http;
import 'package:shop_app/models/product.dart';

import '../controllers/secure_storage.dart';

class ProductsProvider {
  final String _url = Environment.apiDilevery;
  final String _api = '/api/products';
  late BuildContext context;
  late String token;
  late String id;

  Future init(BuildContext context, String token, String id) async {
    this.context = context;
    this.token = token;
  }

  Future<Stream?>? create(Product product, List<File>? images) async {
    try {
      final Uri url = Uri.http(_url, '$_api/create');
      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = token;
      request.headers['Content-Type'] = 'application/json';

      for (int i = 0; i < images!.length; i++) {
        request.files.add(
          http.MultipartFile(
            'image',
            http.ByteStream(images[i].openRead().cast()),
            await images[i].length(),
            filename: basename(images[i].path),
          ),
        );
      }

      request.fields['product'] = product.toJson();

      final response = await request.send();

      return response.stream.transform(utf8.decoder);
    } catch (error) {
      return null;
    }
  }

  Future<List<Product>> getByCategory(String idCategory) async {
    try {
      final Uri url = Uri.http(_url, '$_api/findByCategory/$idCategory');

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

      List<Product> list = [];

      if (data != null) {
        for (var element in data) {
          Product product = Product(
            name: element['name'],
            description: element['description'],
            id: element['id'],
            idCategory: int.parse(element['id_category']),
            price: int.parse(element['price']),
            imagen1: element['image1'],
            imagen2: element['image2'],
            imagen3: element['image3'],
            quantity: element['quantity'],
          );
          list.add(product);
        }
      }
      return list;
    } catch (error) {
      return [];
    }
  }
}
