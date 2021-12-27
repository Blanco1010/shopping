import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final IconData? icon;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextEditingController? textController;

  final String formProperty;
  final Map<String, String>? formValues;

  const CustomInputField({
    Key? key,
    this.hintText,
    this.labelText,
    this.helperText,
    this.icon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    required this.formProperty,
    this.formValues,
    this.textController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: const Color.fromARGB(255, 65, 65, 65),
      maxLines: 1,
      autofocus: false,
      // initialValue: '',
      textCapitalization: TextCapitalization.words,
      keyboardType: keyboardType,
      obscureText: obscureText,
      controller: textController,
      // onChanged: (value) => formValues![formProperty] = value,
      validator: (value) {
        if (value == null) return 'Este campo es requerido';
        return value.length < 3 ? 'Mínimo de 3 letras' : null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: Color.fromARGB(255, 65, 65, 65)),

        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        border: InputBorder.none,
        hintText: hintText,
        labelText: labelText,
        helperText: helperText,
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
