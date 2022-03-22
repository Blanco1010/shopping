import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_app/api/environment.dart';
import 'package:shop_app/controllers/secure_storage.dart';
import 'package:shop_app/models/response_model.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../models/user.dart';

class UsersProvider {
  final String _url = Environment.apiDilevery;
  final String _api = '/api/users';

  late BuildContext context;
  String? token;
  String? id;

  List<User> toList = [];

  Future init(BuildContext context, {String? token, String? id}) async {
    this.context = context;
    this.token = token;
    this.id = id;
  }

  Future<List<User>?>? getDeliveryMen() async {
    try {
      final Uri url = Uri.http(_url, '$_api/findDeliveryMen');
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': token!
      };

      final res = await http.get(url, headers: headers);

      //NO AUTORIZADO
      if (res.statusCode == 401) {
        SecureStogare().logout(context, id!);
      }

      final data = json.decode(res.body);

      if (data != null) {
        data.forEach((element) {
          User user = User.fromMap(element);
          toList.add(user);
        });
      }

      return toList;
    } catch (error) {
      return null;
    }
  }

  Future<List<String>?>? getAdminsNotificationsTokens() async {
    try {
      final Uri url = Uri.http(_url, '$_api/getAdminsNotificationTokens');
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': token!
      };

      final res = await http.get(url, headers: headers);

      //NO AUTORIZADO
      if (res.statusCode == 401) {
        SecureStogare().logout(context, id!);
      }

      final data = json.decode(res.body);
      final tokens = List<String>.from(data);

      return tokens;
    } catch (error) {
      return null;
    }
  }

  Future<User?>? getById(String id) async {
    try {
      final Uri url = Uri.http(_url, '$_api/findById/$id');
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': token!
      };

      final res = await http.get(url, headers: headers);

      //NO AUTORIZADO
      if (res.statusCode == 401) {
        SecureStogare().logout(context, id);
      }

      final data = json.decode(res.body);

      User user = User.fromMap(data);
      return user;
    } catch (error) {
      return null;
    }
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

      request.fields['user'] = user.toJson();

      final response = await request.send();

      return response.stream.transform(utf8.decoder);
    } catch (error) {
      return null;
    }
  }

  Future<Stream?>? update(User user, File? image) async {
    try {
      final Uri url = Uri.http(_url, '$_api/update');
      final request = http.MultipartRequest('PUT', url);

      request.headers['Authorization'] = token!;

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

      request.fields['user'] = user.toJson();

      final response = await request.send();

      if (response.statusCode == 401) {
        SecureStogare().logout(context, id!);
      }

      return response.stream.transform(utf8.decoder);
    } catch (error) {
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

      return responseApi;
    } catch (error) {
      return ResponseApi(
        success: false,
        message: error.toString(),
        error: '',
      );
    }
  }

  Future<ResponseApi> logout(String idUser) async {
    try {
      final Uri url = Uri.http(_url, '$_api/logout');
      final bodyParams = json.encode({'id': idUser});

      Map<String, String> headers = {'Content-Type': 'application/json'};

      final res = await http.post(url, headers: headers, body: bodyParams);

      final data = json.decode(res.body);

      ResponseApi responseApi = ResponseApi.fromMap(data);

      return responseApi;
    } catch (error) {
      return ResponseApi(
        success: false,
        message: 'Hubo un error al cerrar la sesion',
      );
    }
  }

  Future<ResponseApi> updateNotificationToken(
      String idUser, String tokenNotification) async {
    try {
      final Uri url = Uri.http(_url, '$_api/updateNotificationToken');
      final bodyParams = json.encode({
        'id': idUser,
        'notification_token': tokenNotification,
      });

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': token!
      };

      final res = await http.put(url, headers: headers, body: bodyParams);

      if (res.statusCode == 401) {
        SecureStogare().logout(context, id!);
      }

      final data = json.decode(res.body);

      ResponseApi responseApi = ResponseApi.fromMap(data);

      return responseApi;
    } catch (error) {
      return ResponseApi(
        success: false,
        message: 'error al crear token',
        error: '',
      );
    }
  }
}
