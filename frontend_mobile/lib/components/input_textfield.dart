import 'package:flutter/material.dart';
import '../constants.dart';

class InputTextField extends StatelessWidget {
  const InputTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.isMultiLine = false,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool isMultiLine;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        style: const TextStyle(color: kLightColor),
        controller: controller,
        obscureText: obscureText,
        cursorColor: kPrimaryColor,
        keyboardType:
            isMultiLine ? TextInputType.multiline : TextInputType.text,
        maxLines: isMultiLine ? 3 : 1,
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
