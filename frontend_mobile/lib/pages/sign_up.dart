import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/pages/log_in.dart';
import '../components/textfield_input.dart';
import '../components/submit_button.dart';
import '../components/failed_request_dialog.dart';
import '../data/auth.dart';
import '../constants.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  late Role role = Role.player;

  void signUpUser() async {
    final String apiRoute = Platform.isAndroid
        ? 'http://10.0.2.2:5000/api'
        : 'http://localhost:5000/api';
    if (!confirmPassword()) {
      showDialog(
        context: context,
        builder: (context) {
          return const FailedRequestDialog(errorText: 'Passwords do not match');
        },
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    final SignUpRequest auth = SignUpRequest(
      email: emailController.text,
      password: passwordController.text,
      role: role,
    );
    final dio = Dio();
    try {
      Response response = await dio.post(
        '$apiRoute/signUp',
        data: auth.toJsonMap(),
      );
      final String email = response.data['user']['email'];
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LogInPage(
              emailFromSignUp: email,
              comingFromSignUp: true,
            ),
          ),
        );
      }
    } on DioError catch (e) {
      String error = e.response?.data['error'];
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return FailedRequestDialog(errorText: error);
        },
      );
    }
  }

  bool confirmPassword() =>
      passwordController.text == confirmPasswordController.text;

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
                const SizedBox(height: 80),
                const Image(
                  image: AssetImage('assets/logo.png'),
                  height: 100,
                  width: 200,
                  fit: BoxFit.fitWidth,
                ),
                const SizedBox(height: 15),
                const Text(
                  'Register below with your details!',
                  style: TextStyle(
                    color: kDarkGreen,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                TextFieldInput(
                  controller: emailController,
                  hintText: 'Email',
                ),
                const SizedBox(height: 10),
                TextFieldInput(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                TextFieldInput(
                  controller: confirmPasswordController,
                  hintText: 'Confirm password',
                  obscureText: true,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('User Type:'),
                    Radio(
                      activeColor: kDarkGreen,
                      groupValue: role,
                      value: Role.player,
                      onChanged: (value) => setState(() {
                        role = value!;
                      }),
                    ),
                    const Text('Player'),
                    Radio(
                      activeColor: kDarkGreen,
                      groupValue: role,
                      value: Role.fieldManager,
                      onChanged: (value) => setState(() {
                        role = value!;
                      }),
                    ),
                    const Text('Field Manager'),
                  ],
                ),
                const SizedBox(width: 50),
                SubmitButton(
                  text: 'Sign Up',
                  onTap: signUpUser,
                  fontSize: 20,
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'I am a member!',
                      style: TextStyle(color: kDarkColor),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LogInPage(),
                          ),
                        )
                      },
                      child: const Text(
                        'Log in now',
                        style: TextStyle(
                          color: kDarkColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
