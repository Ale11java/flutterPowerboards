import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  const LoginTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.suffixIcon,
    this.validator,
    this.autofocus = false,
    this.textInputAction = TextInputAction.done,
    this.keyboardType,
    this.obscureText = false,
    this.onFieldSubmitted,
  });

  final TextInputAction textInputAction;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool autofocus;
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;

  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      controller: controller,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        suffixIcon: suffixIcon,
        suffixIconConstraints: const BoxConstraints(maxHeight: 46),
      ),
    );
  }
}
