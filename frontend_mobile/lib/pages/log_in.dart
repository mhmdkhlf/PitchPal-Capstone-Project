import 'package:flutter/material.dart';
import 'package:frontend_mobile/constants.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frontend_mobile/pages/welcome.dart';
import '../components/log_in_button.dart';
import '../components/input_textfield.dart';
import '../data/auth.dart';

final dio = Dio();
final String apiRoute = Platform.isAndroid
    ? 'http://10.0.2.2:5000/api'
    : 'http://localhost:5000/api';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LogInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void logUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    final Auth auth = Auth(
      email: emailController.text,
      password: passwordController.text,
    );
    try {
      Response response = await dio.post(
        '$apiRoute/logIn',
        data: auth.toJsonMap(),
      );
      if (response.statusCode == 200) {
        String email = response.data['email'];
        if (context.mounted) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WelcomePage(
                userEmail: email,
              ),
            ),
          );
        }
      }
    } on DioError catch (e) {
      String error = e.response?.data['error'];
      Navigator.pop(context);
      failedLogInMessage(error);
    }
  }

  void failedLogInMessage(String error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kLightColor,
          title: Center(
            child: Text(
              error,
              style: const TextStyle(color: kDarkColor),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                const Image(
                  image: AssetImage('assets/logo.png'),
                  height: 100,
                  width: 200,
                  fit: BoxFit.fitWidth,
                ),
                const SizedBox(height: 50),
                InputTextField(
                  controller: emailController,
                  hintText: 'Username',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                InputTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                MyButton(
                  onTap: logUserIn,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(color: kDarkColor),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Register now',
                      style: TextStyle(
                        color: kDarkColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
