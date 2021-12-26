import 'package:flutter/material.dart';

import '../Theme/theme.dart';
import '../widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: size.height * 0.08,
            left: size.width * 0.08,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back_ios,
                color: MyColors.colorPrimary,
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _imageUser(size),
                SizedBox(height: size.height * 0.04),
                _textFieldEmail(size),
                SizedBox(height: size.height * 0.02),
                _textFieldFirstName(size),
                SizedBox(height: size.height * 0.02),
                _textFieldLastName(size),
                SizedBox(height: size.height * 0.02),
                _textFieldNumberPhone(size),
                SizedBox(height: size.height * 0.02),
                _textFieldPassword(size),
                SizedBox(height: size.height * 0.02),
                _textFieldConfirmPassword(size),
                SizedBox(height: size.height * 0.02),
                _buttonRegister(size),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _imageUser(Size size) {
    return CircleAvatar(
      backgroundColor: MyColors.colorPrimary,
      child: Icon(
        Icons.account_circle,
        size: size.width * 0.2,
        color: Colors.white,
      ),
      radius: size.width * 0.15,
    );
  }

  _textFieldPassword(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      decoration: BoxDecoration(
        color: MyColors.primaryOpactyColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const CustomInputField(
        icon: Icons.lock,
        labelText: 'Contraseña',
        formProperty: 'password',
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
      ),
    );
  }

  _textFieldConfirmPassword(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      decoration: BoxDecoration(
        color: MyColors.primaryOpactyColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const CustomInputField(
        icon: Icons.lock,
        labelText: 'Confirmar contraseña',
        formProperty: 'password',
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
      ),
    );
  }

  _textFieldEmail(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      decoration: BoxDecoration(
        color: MyColors.primaryOpactyColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const CustomInputField(
        icon: Icons.email,
        labelText: 'Correo eletrónico',
        formProperty: 'email',
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  _textFieldFirstName(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      decoration: BoxDecoration(
        color: MyColors.primaryOpactyColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const CustomInputField(
        icon: Icons.person_pin_circle_rounded,
        labelText: 'Nombre',
        formProperty: 'firstname',
        keyboardType: TextInputType.name,
      ),
    );
  }

  _textFieldLastName(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      decoration: BoxDecoration(
        color: MyColors.primaryOpactyColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const CustomInputField(
        icon: Icons.person_pin_circle_outlined,
        labelText: 'Apellido',
        formProperty: 'lastname',
        keyboardType: TextInputType.name,
      ),
    );
  }

  _textFieldNumberPhone(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      decoration: BoxDecoration(
        color: MyColors.primaryOpactyColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const CustomInputField(
        icon: Icons.phone,
        labelText: 'Telefono ',
        formProperty: 'lastname',
        keyboardType: TextInputType.number,
      ),
    );
  }

  _buttonRegister(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
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
}
