import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  final String text;

  const NoDataWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/img/no_items.png',scale: 1,height: MediaQuery.of(context).size.height * 0.3,),
        Text(text),
      ],
    );
  }
}
