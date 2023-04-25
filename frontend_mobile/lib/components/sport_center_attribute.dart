import 'package:flutter/material.dart';

class SportCenterAttribute extends StatelessWidget {
  const SportCenterAttribute({
    super.key,
    required this.text,
    this.icon,
    this.fontSize = 16.0,
  });

  final String text;
  final IconData? icon;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null)
          Row(
            children: [
              Icon(
                icon,
                size: 20,
              ),
              const SizedBox(width: 5),
            ],
          ),
        Text(
          text,
          style: TextStyle(fontSize: fontSize),
        ),
      ],
    );
  }
}
