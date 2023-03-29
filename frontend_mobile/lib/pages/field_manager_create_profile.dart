import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:frontend_mobile/pages/home.dart';
import '../components/input_textfield.dart';
import '../components/submit_button.dart';
import '../components/profile_picture_input.dart';
import '../data/field_manager.dart';
import '../constants.dart';

class FieldManagerCreateProfile extends StatefulWidget {
  const FieldManagerCreateProfile({
    super.key,
    required this.emailFromLogIn,
  });

  final String emailFromLogIn;

  @override
  State<FieldManagerCreateProfile> createState() =>
      _FieldManagerCreateProfileState();
}

class _FieldManagerCreateProfileState extends State<FieldManagerCreateProfile> {
  ProfilePicture profilePicture = ProfilePicture(path: defaultProfilePath);
  final nameController = TextEditingController();
  late PhoneNumber phoneNumberInput;
  final sportCenterController = TextEditingController();

  final dio = Dio();
  final String apiRoute = Platform.isAndroid
      ? 'http://10.0.2.2:5000/api'
      : 'http://localhost:5000/api';

  void createProfile() async {
    await uploadImage(profilePicture, widget.emailFromLogIn);
    final String fullName = nameController.text;
    final String email = widget.emailFromLogIn;
    final String phoneNumber = _getPhoneNumberString(phoneNumberInput);
    final String sportCenterName = sportCenterController.text;
    final FieldManager fieldManagerProfile = FieldManager.createProfile(
      name: fullName,
      email: email,
      mobileNumber: phoneNumber,
      sportCenterName: sportCenterName,
    );
    try {
      final response = await dio.post(
        '$apiRoute/newManagerProfile',
        data: fieldManagerProfile.toJsonMap(),
      );
      if (response.statusCode == 200) {
        if (context.mounted) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                userEmail: email,
                role: 'field manager',
              ),
            ),
          );
        }
      }
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }

  String _getPhoneNumberString(PhoneNumber phoneNumber) {
    final String countryCode = phoneNumber.countryCode;
    final String number = phoneNumber.number;
    return '$countryCode $number';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Create your Profile',
            style: TextStyle(
              color: kLightColor,
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                ProfilePictureInput(
                  profilePicture: profilePicture,
                ),
                const SizedBox(height: 20),
                InputTextField(
                  controller: nameController,
                  hintText: 'Full Name',
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: IntlPhoneField(
                    decoration: const InputDecoration(
                      fillColor: kDarkGreen,
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 3),
                      ),
                    ),
                    initialCountryCode: 'LB',
                    onChanged: (phone) => phoneNumberInput = phone,
                  ),
                ),
                const SizedBox(height: 8),
                InputTextField(
                  controller: sportCenterController,
                  hintText: 'Sports Center Name',
                ),
                const SizedBox(height: 20),
                SubmitButton(text: 'Submit', onTap: createProfile),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
