import 'package:flutter/material.dart';
import 'package:portfolio_builder_app/control/validators.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {super.key,
      required this.controller,
      this.validate = "empty",
      this.obscureText = false,
      this.keyboardType = TextInputType.text,
      this.hintText = ""});
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  final TextInputType keyboardType;
  final String validate;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: (value) {
        switch (validate) {
          case "email":
            validateEmail(value!);
        }
        return null;
      },
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
