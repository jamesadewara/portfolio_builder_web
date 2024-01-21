import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {super.key,
      required this.controller,
      this.validator,
      this.onChange,
      this.obscureText = false,
      this.maxLength = null,
      this.keyboardType = TextInputType.text,
      this.hintText = ""});
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  final TextInputType keyboardType;
  final String? Function(String? value)? validator;
  final String? Function(String? value)? onChange;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLength: maxLength,
      validator: validator,
      onChanged: onChange,
      decoration: InputDecoration(
        // labelText: ,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.shade800),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade600),
        ),
        filled: true,
        // fillColor: Colors.grey.shade300,
        hintText: hintText,
      ),
    );
  }
}
