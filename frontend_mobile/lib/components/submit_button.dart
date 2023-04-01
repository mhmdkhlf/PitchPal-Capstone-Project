import 'package:flutter/material.dart';
import 'package:frontend_mobile/constants.dart';

class SubmitButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final double fontSize;

  const SubmitButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.fontSize,
  });

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
            style: TextStyle(
              color: kLightColor,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
