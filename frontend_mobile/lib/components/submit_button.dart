import 'package:flutter/material.dart';
import 'package:frontend_mobile/constants.dart';

class SubmitButton extends StatelessWidget {
  final String text;
  final Function() onTap;

  const SubmitButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
        decoration: BoxDecoration(
          color: kDarkGreen,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: kLightColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
