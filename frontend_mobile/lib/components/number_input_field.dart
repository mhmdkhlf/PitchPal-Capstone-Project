import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';

class NumberInputField extends StatelessWidget {
  const NumberInputField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: kLightColor),
      controller: controller,
      textAlign: TextAlign.center,
      cursorColor: kPrimaryColor,
      keyboardType: const TextInputType.numberWithOptions(decimal: false),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        TextInputFormatter.withFunction(
          (oldValue, newValue) => newValue.copyWith(
            text: newValue.text.replaceAll('.', ','),
          ),
        ),
      ],
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
    );
  }
}
