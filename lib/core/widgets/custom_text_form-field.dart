// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    super.key,
    required this.labeltext,
    required this.controller,
    this.obscureText = false,
    this.validator,
  });
  final TextEditingController controller;
  final String labeltext;
  final bool obscureText;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,

      decoration: InputDecoration(
        labelText: labeltext,
        border: const OutlineInputBorder(),
      ),
      textDirection: TextDirection.rtl,
      validator: validator,
    );
  }
}
