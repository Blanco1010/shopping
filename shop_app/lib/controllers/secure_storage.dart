import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shop_app/provider/user_provider.dart';

class SecureStogare {
  void save(String key, value) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: key, value: value.toString());
  }

  Future<String> read(String key) async {
    const storage = FlutterSecureStorage();
    String value = await storage.read(key: key) ?? 'null';
    return value;
  }

  Future<bool> contains(String key) {
    const storage = FlutterSecureStorage();
    return storage.containsKey(key: key);
  }

  Future<void> remove(String key) async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: key);
  }

  void logout(BuildContext context, String id) async {
    UsersProvider userProvider = UsersProvider();
    userProvider.init(context);
    userProvider.logout(id);
    await remove('user');
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
