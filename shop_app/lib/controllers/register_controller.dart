import 'package:flutter/material.dart';

class RegisterController {
  BuildContext? context;
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController firstNameController = TextEditingController(text: '');
  TextEditingController lastNameController = TextEditingController(text: '');
  TextEditingController phoneNumberController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController confirmPassword = TextEditingController(text: '');

  Future? init(BuildContext context) {
    this.context = context;
  }

  void goToRegisterPage() {
    Navigator.pushNamed(context!, '/register');
  }

  void register() {
    String email = emailController.text.trim();
    String firstName = firstNameController.text.trim();
    String lastName = lastNameController.text.trim();
    String phoneNumber = phoneNumberController.text.trim();
    String password = passwordController.text.trim();
    String coPassword = confirmPassword.text.trim();

    print(email);
    print(firstName);
    print(lastName);
    print(phoneNumber);
    print(password);
    print(coPassword);
  }
}
