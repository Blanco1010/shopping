import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/models/response_model.dart';
import 'package:shop_app/models/user.dart';
import 'package:shop_app/provider/user_provider.dart';
import 'package:shop_app/widgets/widgets.dart';

class RegisterController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  BuildContext? context;

  UsersProvider userProvider = UsersProvider();

  final ImagePicker _picker = ImagePicker();
  late Function refresh;

  File? imageFile;

  bool isLoading = false;

  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController firstNameController = TextEditingController(text: '');
  TextEditingController lastNameController = TextEditingController(text: '');
  TextEditingController phoneNumberController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController confirmPassword = TextEditingController(text: '');

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    await userProvider.init(context);
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

      isLoading = true;
      _showLoadingIndicator(context!);
      Stream? stream = await userProvider.createWithImage(user, imageFile);
      stream?.listen(
        (res) {
          Navigator.pop(context!);

          // ResponseApi responseApi = await userProvider.create(user);
          ResponseApi responseApi = ResponseApi.fromJson(res);

          if (responseApi.success == true) {
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pushReplacementNamed(context!, '/login');
            });
            Snackbar.show(context, responseApi.message);
          } else {
            Snackbar.show(context, responseApi.message);
          }
          isLoading = false;
        },
      );
    }
  }

  Future selectImage(ImageSource imageSource) async {
    final XFile? image = await _picker.pickImage(source: imageSource);

    if (image != null) {
      imageFile = File(image.path);
      refresh();
    }
    Navigator.pop(context!);
  }

  void showAlertDialog() {
    Widget galleyButton = MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        selectImage(ImageSource.gallery);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 3),
        ),
        height: 100,
        width: 100,
        child: Icon(
          Icons.image,
          size: MediaQuery.of(context!).size.height * 0.1,
        ),
      ),
    );

    Widget cameraButton = MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        selectImage(ImageSource.camera);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 3),
        ),
        height: 100,
        width: 100,
        child: Icon(
          Icons.camera_alt_outlined,
          size: MediaQuery.of(context!).size.height * 0.1,
        ),
      ),
    );

    Widget alertDialog = AlertDialog(
      alignment: Alignment.center,
      content: SizedBox(
        height: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            cameraButton,
            galleyButton,
          ],
        ),
      ),
    );

    showDialog(
        context: context!,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void back() {
    Navigator.pop(context!);
  }

  Future<dynamic> _showLoadingIndicator(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: const AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
            backgroundColor: Colors.black,
            content: LoadingIndicator(text: 'Guardando'),
          ),
        );
      },
    );
  }
}
