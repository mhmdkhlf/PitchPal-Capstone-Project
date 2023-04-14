import 'package:flutter/material.dart';

class ContactInfoField extends StatelessWidget {
  const ContactInfoField({
    super.key,
    required this.field,
    required this.value,
  });

  final String field;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text.rich(
        textAlign: TextAlign.center,
        TextSpan(
          style: const TextStyle(fontSize: 18),
          children: <TextSpan>[
            TextSpan(
              text: '$field:',
              style: const TextStyle(decoration: TextDecoration.underline),
            ),
            TextSpan(
              text: ' $value',
            ),
          ],
        ),
      ),
    );
  }
}
