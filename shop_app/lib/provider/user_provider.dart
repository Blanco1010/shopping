import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_app/api/environment.dart';
import 'package:shop_app/models/response_model.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../models/user.dart';

class UsersProvider {
  final String _url = Environment.apiDilevery;
  final String _api = '/api/users';

  late BuildContext context;

  Future init(BuildContext context) async {
    this.context = context;
  }

  Future<Stream?>? createWithImage(User user, File? image) async {
    try {
      final Uri url = Uri.http(_url, '$_api/create');
      final request = http.MultipartRequest('POST', url);

      if (image != null) {
        request.files.add(
          http.MultipartFile(
            'image',
            http.ByteStream(image.openRead().cast()),
            await image.length(),
            filename: basename(image.path),
          ),
        );
      }

      request.fields['user'] = json.encode(user);

      final response = await request.send();

      return response.stream.transform(utf8.decoder);
    } catch (error) {
      print('ERROR:  $error');
      return null;
    }
  }

  Future<ResponseApi> create(User user) async {
    try {
      final Uri url = Uri.http(_url, '$_api/create');
      final bodyParams = user.toJson();

      Map<String, String> headers = {'Content-Type': 'application/json'};

      final res = await http.post(url, headers: headers, body: bodyParams);

      final data = json.decode(res.body);

      ResponseApi responseApi = ResponseApi.fromMap(data);

      // ResponseApi responseApi = ResponseApi(
      //   success: data['success'],
      //   message: data['message'],
      //   data: data['data'],
      // );
      return responseApi;
    } catch (error) {
      return ResponseApi(
        success: false,
        message: 'error al crear usuario',
        error: 'El usuario ya existe',
      );
    }
  }

  Future<ResponseApi> login(String email, String password) async {
    try {
      final Uri url = Uri.http(_url, '$_api/login');
      final bodyParams = json.encode({'email': email, 'password': password});

      Map<String, String> headers = {'Content-Type': 'application/json'};

      final res = await http.post(url, headers: headers, body: bodyParams);

      final data = json.decode(res.body);

      ResponseApi responseApi = ResponseApi.fromMap(data);

      // ResponseApi responseApi = ResponseApi(
      //   success: data['success'],
      //   message: data['message'],
      //   data: data['data']['session_token'],
      // );

      return responseApi;
    } catch (error) {
      return ResponseApi(
        success: false,
        message: error.toString(),
        error: '',
      );
    }
  }
}
