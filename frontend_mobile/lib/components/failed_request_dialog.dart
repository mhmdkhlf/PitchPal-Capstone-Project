import 'package:flutter/material.dart';
import '../constants.dart';

class FailedRequestDialog extends StatelessWidget {
  const FailedRequestDialog({
    super.key,
    required this.errorText,
  });

  final String errorText;

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
          errorText,
          style: const TextStyle(
            color: kDarkColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
