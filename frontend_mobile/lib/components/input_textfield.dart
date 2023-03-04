import 'package:flutter/material.dart';
import '../constants.dart';

class InputTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const InputTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        style: const TextStyle(color: kLightColor),
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kDarkGreen),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kLightColor),
          ),
          fillColor: kDarkGreen,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(color: kLighterDark),
        ),
      ),
    );
  }
}
