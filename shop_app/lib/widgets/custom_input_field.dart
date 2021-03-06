import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String? hintText;
  final String? labelText;

  final int? max;
  final int? maxLength;
  final IconData? icon;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextEditingController? textController;
  final String? Function(String?)? validator;
  final bool expand;

  final Map<String, String>? formValues;

  const CustomInputField({
    Key? key,
    this.hintText,
    this.labelText,
    this.icon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.formValues,
    this.textController,
    this.validator,
    this.max,
    required this.expand,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      maxLines: obscureText ? 1 : max,
      cursorColor: const Color.fromARGB(255, 65, 65, 65),
      autofocus: false,
      // initialValue: '',
      textCapitalization: TextCapitalization.words,
      keyboardType: keyboardType,
      obscureText: obscureText,
      controller: textController,
      // onChanged: (value) => formValues![formProperty] = value,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,

      decoration: InputDecoration(
        labelStyle: const TextStyle(color: Color.fromARGB(255, 65, 65, 65)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        border: InputBorder.none,
        hintText: hintText,
        labelText: labelText,

        // prefixIcon: Icon( Icons.verified_user_outlined ),
        suffixIcon: suffixIcon == null ? null : Icon(suffixIcon),
        prefixIcon: icon == null
            ? null
            : Icon(
                icon,
                color: const Color.fromARGB(255, 65, 65, 65),
              ),
      ),
    );
  }
}
