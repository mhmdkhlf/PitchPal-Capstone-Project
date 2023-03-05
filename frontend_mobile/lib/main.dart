import 'package:flutter/material.dart';
import 'dart:io';
import 'pages/log_in.dart';
import 'constants.dart';

final String apiRoute = Platform.isAndroid
    ? 'http://10.0.2.2:5000/api'
    : 'http://localhost:5000/api';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pitch-Pal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: kPrimaryColor,
          secondary: kLightColor,
        ),
      ),
      home: LogInPage(apiRoute: apiRoute),
    );
  }
}
