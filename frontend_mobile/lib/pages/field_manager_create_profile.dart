import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:frontend_mobile/pages/home.dart';
import '../components/textfield_input.dart';
import '../components/submit_button.dart';
import '../components/profile_picture.dart';
import '../components/failed_request_dialog.dart';
import '../pages/new_sport_center_form.dart';
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
  bool isSportCenterRegistered = true;

  final dio = Dio();
  final String apiRoute = Platform.isAndroid
      ? 'http://10.0.2.2:5000/api'
      : 'http://localhost:5000/api';

  void createProfile() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
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
      if (response.statusCode != 200) {
        throw Exception('Invalid status code on field manager post');
      }
      if (context.mounted) {
        Navigator.pop(context);
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
    } on DioError catch (e) {
      String error = e.response?.data['error'];
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return FailedRequestDialog(errorText: error);
          },
        );
      }
    }
    await uploadImage(profilePicture, widget.emailFromLogIn);
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
                TextFieldInput(
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
                const Divider(color: kDarkGreen),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Is your sport-center registered?',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 10),
                    ToggleButtons(
                      direction: Axis.horizontal,
                      onPressed: (int index) {
                        setState(() => isSportCenterRegistered = index == 0);
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      selectedBorderColor: kDarkGreen,
                      selectedColor: kLightColor,
                      fillColor: kDarkGreen,
                      color: kDarkGreen,
                      constraints: const BoxConstraints(
                        minHeight: 30.0,
                        minWidth: 60.0,
                      ),
                      isSelected: [
                        isSportCenterRegistered,
                        !isSportCenterRegistered
                      ],
                      children: const [
                        Text('Yes'),
                        Text('No'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                isSportCenterRegistered
                    ? Column(
                        children: [
                          TextFieldInput(
                            controller: sportCenterController,
                            hintText: 'Sport-Center Name',
                          ),
                          const SizedBox(height: 10),
                          SubmitButton(
                            text: 'Submit',
                            onTap: createProfile,
                            fontSize: 20,
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            '(You must register your sport-center before creating you manager account)',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                          SubmitButton(
                            text: 'Register Sport-Center',
                            fontSize: 14,
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NewSportCenterForm(),
                                ),
                              )
                            },
                          ),
                        ],
                      ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
