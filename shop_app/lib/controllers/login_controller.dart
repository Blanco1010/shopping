import 'package:flutter/material.dart';

class LoginController {
  BuildContext? context;
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');

  Future? init(BuildContext context) {
    this.context = context;
  }

  void goToRegisterPage() {
    Navigator.pushNamed(context!, '/register');
  }

  void login() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    print('EMAIL: $email PASSWORD: $password');
  }
}
