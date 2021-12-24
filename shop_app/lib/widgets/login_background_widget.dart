import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  final Widget child;
  const LoginBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          _LoginIcon(),
          child,
        ],
      ),
    );
  }
}

class _LoginIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        margin: EdgeInsets.only(
          top: size.height * 0.1,
          bottom: size.height * 0.1,
        ),
        child: Stack(
          children: [
            Image.asset(
              'assets/img/icon1.png',
              width: size.width * 0.7,
            ),
            Image.asset(
              'assets/img/icon2.png',
              width: size.width * 0.7,
            ),
          ],
        ));
  }
}
