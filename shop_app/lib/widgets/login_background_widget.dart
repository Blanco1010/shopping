import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class LoginBackground extends StatefulWidget {
  const LoginBackground({Key? key}) : super(key: key);

  @override
  State<LoginBackground> createState() => _LoginBackgroundState();
}

class _LoginBackgroundState extends State<LoginBackground>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? transition;

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
            top: size.height * 0.05,
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
