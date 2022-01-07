import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/controllers/secure_storage.dart';
import 'package:shop_app/models/response_model.dart';
import 'package:shop_app/models/user.dart';
import 'package:shop_app/provider/user_provider.dart';
import 'package:shop_app/widgets/widgets.dart';

class ClientUpdateController {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  BuildContext? context;

  UsersProvider userProvider = UsersProvider();

  final ImagePicker _picker = ImagePicker();

  late Function refresh;

  File? imageFile;

  bool isLoading = false;

  final SecureStogare _secureStogare = SecureStogare();

  User? user;

  TextEditingController firstNameController = TextEditingController(text: '');
  TextEditingController lastNameController = TextEditingController(text: '');
  TextEditingController phoneNumberController = TextEditingController(text: '');

  Future? init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _secureStogare.read('user'));
    userProvider.init(context, token: user?.sessionToken);
    firstNameController.text = user!.name;
    lastNameController.text = user!.lastname;
    phoneNumberController.text = user!.phone;
    refresh();
  }

  void goToRegisterPage() {
    Navigator.pushNamed(context!, '/register');
  }

  void update() async {
    if (formKey.currentState!.validate()) {
      String firstName = firstNameController.text.trim();
      String lastName = lastNameController.text.trim();
      String phoneNumber = phoneNumberController.text.trim();

      User myUser = User(
        id: user!.id,
        name: firstName,
        lastname: lastName,
        phone: phoneNumber,
      );

      if (imageFile == null) {
        myUser.image = user?.image;
      }

      isLoading = true;
      _showLoadingIndicator(context!);
      Stream? stream = await userProvider.update(myUser, imageFile);
      stream?.listen(
        (res) async {
          Navigator.pop(context!);

          ResponseApi responseApi = ResponseApi.fromJson(res);

          if (responseApi.success == true) {
            user = await userProvider.getById(myUser.id!); //Get data user
            _secureStogare.save('user', user!.toJson());

            Future.delayed(const Duration(seconds: 2), () {
              isLoading = false;
              Navigator.pushNamedAndRemoveUntil(
                  context!, '/client/products/list', (route) => false);
            });
            Snackbar.show(context, responseApi.message);
          } else {
            Snackbar.show(context, responseApi.message);
          }
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
