import 'package:flutter/material.dart';
import 'package:shop_app/models/response_model.dart';
import 'package:shop_app/models/user.dart';
import 'package:shop_app/provider/user_provider.dart';
import 'package:shop_app/widgets/snackbar.dart';

class RegisterController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  BuildContext? context;
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController firstNameController = TextEditingController(text: '');
  TextEditingController lastNameController = TextEditingController(text: '');
  TextEditingController phoneNumberController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController confirmPassword = TextEditingController(text: '');

  UsersProvider userProvider = UsersProvider();

  Future? init(BuildContext context) {
    this.context = context;
    userProvider.init(context);
  }

  void goToRegisterPage() {
    Navigator.pushNamed(context!, '/register');
  }

  void register() async {
    if (formKey.currentState!.validate()) {
      String email = emailController.text.trim();
      String firstName = firstNameController.text.trim();
      String lastName = lastNameController.text.trim();
      String phoneNumber = phoneNumberController.text.trim();
      String password = passwordController.text.trim();

      User user = User(
        email: email,
        name: firstName,
        lastname: lastName,
        password: password,
        phone: phoneNumber,
      );

      ResponseApi responseApi = await userProvider.create(user);
      print('RESPUESTA: ${responseApi.toJson()}');
      print(responseApi.toJson());
      if (responseApi.success == false) {
        Snackbar.show(context, responseApi.message);
      }
    }

    // print(email);
    // print(firstName);
    // print(lastName);
    // print(phoneNumber);
    // print(password);
    // print(coPassword);
  }

  void back() {
    Navigator.pop(context!);
  }
}
