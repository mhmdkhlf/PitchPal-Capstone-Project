import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:frontend_mobile/constants.dart';
import 'package:frontend_mobile/pages/sign_up.dart';
import 'package:frontend_mobile/pages/player_home.dart';
import 'package:frontend_mobile/pages/field_manager_home.dart';
import 'package:frontend_mobile/pages/create_player_profile.dart';
import 'package:frontend_mobile/pages/create_sport_center.dart';
import 'package:frontend_mobile/pages/create_field_manager_profile.dart';
import '../components/submit_button.dart';
import '../components/textfield_input.dart';
import '../components/failed_request_dialog.dart';
import '../data/auth.dart';
import '../data/player.dart';
import '../data/field_manager.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({
    super.key,
    this.emailFromSignUp = '',
    this.comingFromSignUp = false,
  });

  final String emailFromSignUp;
  final bool comingFromSignUp;

  @override
  State<LogInPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LogInPage> {
  late TextEditingController emailController =
      TextEditingController(text: widget.emailFromSignUp);
  final passwordController = TextEditingController();

  void logUserIn() async {
    final Dio dio = Dio();
    final String apiRoute = Platform.isAndroid
        ? 'http://10.0.2.2:5000/api'
        : 'http://localhost:5000/api';
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
    try {
      Response logInResponse = await dio.post(
        '$apiRoute/logIn',
        data: auth.toJsonMap(),
      );
      String email = logInResponse.data['email'];
      String role = logInResponse.data['user']['role'];
      try {
        Response isNewUserResponse = await dio.post(
          '$apiRoute/isFirstTimeLogIn',
          data: {
            "userType": role,
            "userEmail": email,
          },
        );
        bool isNewUser = isNewUserResponse.data['result'];
        if (isNewUser) {
          if (role == 'player') {
            _routeNewPlayerFormToProfileCreation(email);
          } else if (role == 'field manager') {
            _routeNewFieldManagerToProfileCreation(email);
          }
        } else {
          if (role == 'player') {
            _routePlayerToHomePage(email);
          } else if (role == 'field manager') {
            _routeFieldManagerToHomePage(email);
          }
        }
      } on DioError catch (e) {
        String error = e.response?.data['error'];
        if (context.mounted) {
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

  void _routePlayerToHomePage(String email) async {
    final response = await dio.get(
      '$apiRoute/getPlayerByEmail/$email',
    );
    Player player = Player.fromJson(response.data);
    final imageResponse = await dio.get(
      '$apiRoute/getProfilePictureByEmail/${player.email}',
    );
    if (imageResponse.data != null) {
      List<dynamic> dynamicList = imageResponse.data['img']['data']['data'];
      List<int> intList = dynamicList.map((e) => e as int).toList();
      Uint8List imageData = Uint8List.fromList(intList);
      player.imageByteArray = imageData;
    }
    if (context.mounted) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlayerHomePage(
            player: player,
          ),
        ),
      );
    }
  }

  void _routeFieldManagerToHomePage(String email) async {
    final response = await dio.get(
      '$apiRoute/getManager/$email',
    );
    FieldManager fieldManager = FieldManager.fromJson(response.data);
    final imageResponse = await dio.get(
      '$apiRoute/getProfilePictureByEmail/${fieldManager.email}',
    );
    if (imageResponse.data != null) {
      List<dynamic> dynamicList = imageResponse.data['img']['data']['data'];
      List<int> intList = dynamicList.map((e) => e as int).toList();
      Uint8List imageData = Uint8List.fromList(intList);
      fieldManager.imageByteArray = imageData;
    }
    if (context.mounted) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FieldManagerHomePage(
            fieldManager: fieldManager,
          ),
        ),
      );
    }
  }

  void _routeNewPlayerFormToProfileCreation(String email) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerCreateProfile(emailFromLogIn: email),
      ),
    );
  }

  void _routeNewFieldManagerToProfileCreation(String email) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FieldManagerCreateProfile(
          emailFromLogIn: email,
        ),
      ),
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
                const SizedBox(height: 80),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 3, color: kDarkColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Image(
                    image: AssetImage('assets/logo.png'),
                    height: 100,
                    width: 200,
                    fit: BoxFit.fitWidth,
                  ),
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
                            builder: (context) => const SignUpPage(),
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
                            builder: (context) => const CreateSportCenter(),
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
