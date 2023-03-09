import 'package:flutter/material.dart';
// import 'pages/first_log_in_form.dart';
import 'pages/log_in.dart';
import 'dart:io';

final String apiRoute = Platform.isAndroid
    ? 'http://10.0.2.2:5000/api'
    : 'http://localhost:5000/api';

void main() async {
  runApp(const MyApp());
}

const Map<int, Color> color = {
  50: Color.fromRGBO(5, 74, 41, .1),
  100: Color.fromRGBO(5, 74, 41, .2),
  200: Color.fromRGBO(5, 74, 41, .3),
  300: Color.fromRGBO(5, 74, 41, .4),
  400: Color.fromRGBO(5, 74, 41, .5),
  500: Color.fromRGBO(5, 74, 41, .6),
  600: Color.fromRGBO(5, 74, 41, .7),
  700: Color.fromRGBO(5, 74, 41, .8),
  800: Color.fromRGBO(5, 74, 41, .9),
  900: Color.fromRGBO(5, 74, 41, 1),
};

MaterialColor materialColor = const MaterialColor(0xFF054A29, color);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pitch-Pal',
      theme: ThemeData(primarySwatch: materialColor),
      home: LogInPage(apiRoute: apiRoute),
      // home: const FirstLogInForm(), // using to display page in development
    );
  }
}
