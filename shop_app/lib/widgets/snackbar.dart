import 'package:flutter/material.dart';
import 'package:shop_app/Theme/theme.dart';

class Snackbar {
  static show(BuildContext? context, String text) {
    if (context == null) return null;

    FocusScope.of(context).requestFocus(FocusNode());

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        backgroundColor: MyColors.colorPrimary,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
