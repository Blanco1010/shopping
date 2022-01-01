import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStogare {
  void save(String key, value) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: key, value: value);
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

  void logout(BuildContext context) async {
    await remove('user');
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
