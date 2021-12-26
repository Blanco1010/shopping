import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shop_app/Theme/theme.dart';
import 'package:shop_app/controllers/login_controller.dart';
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

class _LoginForm extends StatefulWidget {
  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final LoginController _loginController = LoginController();

  @override
  void initState() {
    super.initState();

    // when the screen is ready create a controller.
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      _loginController.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Form(
      child: Column(
        children: [
          FadeInRight(
            delay: const Duration(seconds: 2),
            duration: const Duration(seconds: 1),
            from: 200,
            child: Container(
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
            ),
          ),
          SizedBox(height: size.height * 0.02),
          FadeInLeft(
            delay: const Duration(seconds: 2),
            duration: const Duration(seconds: 1),
            from: 200,
            child: Container(
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
            ),
          ),
          SizedBox(height: size.height * 0.02),
          FadeIn(
            delay: const Duration(seconds: 3),
            duration: const Duration(seconds: 1),
            child: const _ButtonLogin(),
          ),
          SizedBox(height: size.height * 0.04),
          _ButtonDontHaveAccount(
            size: size,
            loginController: _loginController,
          )
        ],
      ),
    );
  }
}

class _ButtonDontHaveAccount extends StatelessWidget {
  const _ButtonDontHaveAccount({
    Key? key,
    required this.size,
    required this.loginController,
  }) : super(key: key);

  final Size size;
  final LoginController loginController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FadeInLeft(
            delay: const Duration(seconds: 3),
            duration: const Duration(seconds: 1),
            from: 200,
            child: const Text('¿No tienes cuenta?')),
        SizedBox(width: size.width * 0.03),
        GestureDetector(
          onTap: () => loginController.goToRegisterPage(),
          child: FadeInRight(
            delay: const Duration(seconds: 3),
            duration: const Duration(seconds: 1),
            from: 200,
            child: Text(
              'Registrarse',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: MyColors.colorPrimary,
              ),
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
