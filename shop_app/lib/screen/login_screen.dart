import 'package:flutter/material.dart';
import 'package:shop_app/Theme/theme.dart';
import 'package:shop_app/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Login'),
        //   centerTitle: true,
        //   elevation: 0,
        // ),
        body: LoginBackground(
          child: _LoginForm(),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Form(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
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
          ),
          SizedBox(height: size.height * 0.02),
          Container(
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
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
          ),
          SizedBox(height: size.height * 0.02),
          const _ButtonLogin(),
          SizedBox(height: size.height * 0.04),
          _ButtonDontHaveAccount(size: size)
        ],
      ),
    );
  }
}

class _ButtonDontHaveAccount extends StatelessWidget {
  const _ButtonDontHaveAccount({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('¿No tiene cuenta?'),
        SizedBox(width: size.width * 0.03),
        GestureDetector(
          onTap: () {},
          child: Text(
            'Registrasre',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: MyColors.colorPrimary,
            ),
          ),
        )
      ],
    );
  }
}

class _ButtonLogin extends StatelessWidget {
  const _ButtonLogin({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        child: const Text('Ingresar', style: TextStyle(fontSize: 25)),
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
