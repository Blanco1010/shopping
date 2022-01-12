import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

import 'package:flutter/material.dart';
import 'package:shop_app/api/environment.dart';

import 'package:http/http.dart' as http;
import 'package:shop_app/models/product.dart';

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
    print(product.toJson());
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
      print('ERROR:  $error');
      return null;
    }
  }
}
