import 'package:flutter/material.dart';
import 'package:frontend_mobile/constants.dart';
import 'package:dio/dio.dart';
import 'package:frontend_mobile/pages/sign_up.dart';
import 'package:frontend_mobile/pages/welcome.dart';
import '../components/submit_button.dart';
import '../components/input_textfield.dart';
import '../components/failed_auth_dialog.dart';
import '../data/auth.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({
    super.key,
    required this.apiRoute,
    this.emailFromSignUp = '',
    this.comingFromSignUp = false,
  });

  final String apiRoute;
  final String emailFromSignUp;
  final bool comingFromSignUp;

  @override
  State<LogInPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LogInPage> {
  late TextEditingController emailController =
      TextEditingController(text: widget.emailFromSignUp);
  final passwordController = TextEditingController();
  late String apiRoute = widget.apiRoute;

  void logUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    final LogInRequest auth = LogInRequest(
      email: emailController.text,
      password: passwordController.text,
    );
    final dio = Dio();
    try {
      Response response = await dio.post(
        '$apiRoute/logIn',
        data: auth.toJsonMap(),
      );
      String email = response.data['email'];
      String role = response.data['user']['role'];
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomePage(
              userEmail: email,
              role: role,
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
          return FailedAuthDialog(errorText: error);
        },
      );
    }
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
                const SizedBox(height: 35),
                if (widget.comingFromSignUp)
                  const Text("Log In with you new account",
                      style: TextStyle(
                        color: kDarkGreen,
                        fontSize: 20,
                        // fontWeight: FontWeight.bold,
                      )),
                const SizedBox(height: 35),
                InputTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                InputTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 40),
                SubmitButton(
                  text: 'Log In',
                  onTap: logUserIn,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(color: kDarkColor),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpPage(
                              apiRoute: apiRoute,
                            ),
                          ),
                        )
                      },
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: kDarkColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
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
