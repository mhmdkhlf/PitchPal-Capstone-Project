import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({
    super.key,
    required this.userEmail,
    required this.role,
  });

  final String userEmail, role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome user with role=$role & email=$userEmail',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
