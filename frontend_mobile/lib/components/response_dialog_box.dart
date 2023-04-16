import 'package:flutter/material.dart';
import '../constants.dart';

class ResponseDialogBox extends StatelessWidget {
  const ResponseDialogBox({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          child: const Text('OK'),
          onPressed: () => Navigator.pop(context),
        )
      ],
      backgroundColor: kLightColor,
      elevation: 15,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: kDarkColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
