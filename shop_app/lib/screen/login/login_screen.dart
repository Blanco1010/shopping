import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shop_app/Theme/theme.dart';
import 'package:shop_app/controllers/login/login_controller.dart';
import 'package:shop_app/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              const LoginBackground(),
              _LoginForm(),
            ],
          ),
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
      key: _loginController.formKey,
      child: Column(
        children: [
          FadeInRight(
            delay: const Duration(seconds: 2),
            duration: const Duration(seconds: 1),
            from: 200,
            child: _textFieldEmail(size, _loginController.emailController),
          ),
          SizedBox(height: size.height * 0.02),
          FadeInLeft(
            delay: const Duration(seconds: 2),
            duration: const Duration(seconds: 1),
            from: 200,
            child:
                _textFieldPassword(size, _loginController.passwordController),
          ),
          SizedBox(height: size.height * 0.02),
          FadeIn(
            delay: const Duration(seconds: 3),
            duration: const Duration(seconds: 1),
            child: _buttonLogin(size, _loginController),
          ),
          SizedBox(height: size.height * 0.05),
          _buttonDontHaveAccount(size)
        ],
      ),
    );
  }

  _buttonLogin(Size size, LoginController loginController) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.15),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => loginController.login(),
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

  _buttonDontHaveAccount(Size size) {
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
          onTap: () => _loginController.goToRegisterPage(),
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
        labelText: 'Contraseña',
        formProperty: 'password',
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        textController: textController,
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
        labelText: 'Correo eletrónico',
        formProperty: 'email',
        keyboardType: TextInputType.emailAddress,
        textController: textController,
      ),
    );
  }
}
