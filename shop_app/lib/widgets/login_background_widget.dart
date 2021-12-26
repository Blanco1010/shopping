import 'package:animate_do/animate_do.dart';
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

class _LoginIcon extends StatefulWidget {
  @override
  State<_LoginIcon> createState() => _LoginIconState();
}

class _LoginIconState extends State<_LoginIcon>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? transition;
  Animation<double>? transitionUp;
  Animation<double>? transitionDown;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    transition = Tween(begin: -400.0, end: 10.0)
        .animate(CurvedAnimation(parent: controller!, curve: Curves.easeOut));

    controller!.addListener(() {
      if (controller!.status == AnimationStatus.completed) {
        transition = Tween(begin: 0.0, end: 10.0).animate(
            CurvedAnimation(parent: controller!, curve: Curves.easeInOutSine));
        controller!.reverse();
      }
      if (controller!.status == AnimationStatus.dismissed) {
        controller!.forward();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller!.forward();

    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.only(
            top: size.height * 0.1,
            bottom: size.height * 0.1,
          ),
          child: Stack(
            children: [
              Transform.translate(
                offset: Offset(0, transition!.value),
                child: Image.asset(
                  'assets/img/icon1.png',
                  width: size.width * 0.7,
                ),
              ),
              FadeInRight(
                duration: const Duration(seconds: 3),
                from: 400,
                child: Image.asset(
                  'assets/img/icon2.png',
                  width: size.width * 0.7,
                ),
              ),
            ],
          ),
        );
      },
      animation: controller!,
    );
  }
}
