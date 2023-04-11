import 'package:flutter/material.dart';
import 'package:frontend_mobile/constants.dart';
import 'package:dio/dio.dart';
import 'package:frontend_mobile/pages/sign_up.dart';
import 'package:frontend_mobile/pages/home.dart';
import 'package:frontend_mobile/pages/player_create_profile.dart';
import 'package:frontend_mobile/pages/new_sport_center_form.dart';
import 'package:frontend_mobile/pages/field_manager_create_profile.dart';
import '../components/submit_button.dart';
import '../components/textfield_input.dart';
import '../components/failed_request_dialog.dart';
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
        try {
          response = await dio.post(
            '$apiRoute/isFirstTimeLogIn',
            data: {
              "userType": role,
              "userEmail": email,
            },
          );
          bool isNewUser = response.data['result'];
          if (isNewUser) {
            if (context.mounted) {
              Navigator.pop(context);
              if (role == 'player') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayerCreateProfile(
                      emailFromLogIn: email,
                    ),
                  ),
                );
              } else if (role == 'field manager') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FieldManagerCreateProfile(
                      emailFromLogIn: email,
                    ),
                  ),
                );
              }
            }
          } else {
            if (context.mounted) {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(
                    userEmail: email,
                    role: role,
                  ),
                ),
              );
            }
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
                const SizedBox(height: 30),
                if (widget.comingFromSignUp)
                  const Text("Log In with you new account",
                      style: TextStyle(
                        color: kDarkGreen,
                        fontSize: 20,
                      )),
                const SizedBox(height: 35),
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
                const SizedBox(height: 30),
                SubmitButton(
                  text: 'Log In',
                  onTap: logUserIn,
                  fontSize: 20,
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
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(
                    color: kDarkGreen,
                    thickness: 1.2,
                  ),
                ),
                const SizedBox(height: 5),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Want to register your Sports-Center?',
                      style: TextStyle(color: kDarkColor),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NewSportCenterForm(),
                          ),
                        )
                      },
                      child: const Text(
                        'Register it here',
                        style: TextStyle(
                          color: kDarkColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
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
