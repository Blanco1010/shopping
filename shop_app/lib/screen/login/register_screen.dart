import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shop_app/controllers/login/register_controller.dart';

import '../../Theme/theme.dart';
import '../../widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final registerCo = RegisterController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      registerCo.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Stack(
            children: [
              Positioned(
                top: size.height * 0.08,
                left: size.width * 0.08,
                child: GestureDetector(
                  onTap: () => registerCo.back(),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: MyColors.colorPrimary,
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Form(
                  key: registerCo.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.05),
                      _imageUser(size),
                      SizedBox(height: size.height * 0.04),
                      _textFieldEmail(size, registerCo.emailController),
                      SizedBox(height: size.height * 0.01),
                      _textFieldFirstName(size, registerCo.firstNameController),
                      SizedBox(height: size.height * 0.01),
                      _textFieldLastName(size, registerCo.lastNameController),
                      SizedBox(height: size.height * 0.01),
                      _textFieldNumberPhone(
                          size, registerCo.phoneNumberController),
                      SizedBox(height: size.height * 0.01),
                      _textFieldPassword(size, registerCo.passwordController),
                      SizedBox(height: size.height * 0.01),
                      _textFieldConfirmPassword(
                        size,
                        registerCo.confirmPassword,
                        registerCo.passwordController,
                      ),
                      SizedBox(height: size.height * 0.02),
                      _buttonRegister(size, registerCo),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageUser(Size size) {
    return GestureDetector(
      onTap: registerCo.showAlertDialog,
      child: CircleAvatar(
        backgroundColor: MyColors.colorPrimary,
        backgroundImage: registerCo.imageFile == null
            ? const AssetImage('assets/img/user.png') as ImageProvider
            : FileImage(registerCo.imageFile!),
        radius: size.width * 0.15,
      ),
    );
  }

  _textFieldPassword(Size size, TextEditingController textController) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      decoration: BoxDecoration(
        color: MyColors.primaryOpactyColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: CustomInputField(
        validator: (value) {
          if (value.toString().length <= 8) {
            return 'Mínimo ocho caracteres';
          }
        },
        icon: Icons.lock,
        textController: textController,
        labelText: 'Contraseña',
        formProperty: 'password',
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
      ),
    );
  }

  _textFieldConfirmPassword(
    Size size,
    TextEditingController textController,
    TextEditingController textController2,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      decoration: BoxDecoration(
        color: MyColors.primaryOpactyColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: CustomInputField(
        validator: (value) {
          if (textController2.value != textController.value) {
            return 'Las contraseñas no coinciden';
          }
        },
        icon: Icons.lock,
        textController: textController,
        labelText: 'Confirmar contraseña',
        formProperty: 'password',
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
      ),
    );
  }

  _textFieldEmail(Size size, TextEditingController textController) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      decoration: BoxDecoration(
        color: MyColors.primaryOpactyColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: CustomInputField(
        validator: (value) {
          RegExp exp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

          if (exp.hasMatch(value.toString()) != true) {
            return 'Tienes que darnos un email válido';
          }
        },
        icon: Icons.email,
        textController: textController,
        labelText: 'Correo eletrónico',
        formProperty: 'email',
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  _textFieldFirstName(Size size, TextEditingController textController) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      decoration: BoxDecoration(
        color: MyColors.primaryOpactyColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: CustomInputField(
        validator: (value) {
          if (value.toString().isEmpty == true) {
            return 'Debes llenar el campo';
          }
        },
        icon: Icons.person_pin_circle_rounded,
        textController: textController,
        labelText: 'Nombre',
        formProperty: 'firstname',
        keyboardType: TextInputType.name,
      ),
    );
  }

  _textFieldLastName(Size size, TextEditingController textController) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      decoration: BoxDecoration(
        color: MyColors.primaryOpactyColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: CustomInputField(
        validator: (value) {
          if (value.toString().isEmpty == true) {
            return 'Debes llenar el campo';
          }
        },
        icon: Icons.person_pin_circle_outlined,
        textController: textController,
        labelText: 'Apellido',
        formProperty: 'lastname',
        keyboardType: TextInputType.name,
      ),
    );
  }

  _textFieldNumberPhone(Size size, TextEditingController textController) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      decoration: BoxDecoration(
        color: MyColors.primaryOpactyColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: CustomInputField(
        validator: null,
        icon: Icons.phone,
        textController: textController,
        labelText: 'Telefono ',
        formProperty: 'lastname',
        keyboardType: TextInputType.number,
      ),
    );
  }

  _buttonRegister(Size size, RegisterController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: registerCo.isLoading == false ? controller.register : null,
        child: const Text('Registrarse', style: TextStyle(fontSize: 25)),
        style: ElevatedButton.styleFrom(
          primary: MyColors.colorPrimary,
          padding: EdgeInsets.symmetric(
            vertical: size.height * 0.02,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
