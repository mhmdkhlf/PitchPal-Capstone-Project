import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/components/failed_request_dialog.dart';
import 'package:intl/intl.dart';
import 'package:frontend_mobile/pages/player_home.dart';
import '../components/textfield_input.dart';
import '../components/location_input.dart';
import '../components/number_input_field.dart';
import '../components/profile_picture.dart';
import '../components/phone_number_input.dart';
import '../components/submit_button.dart';
import '../data/player.dart';
import '../data/location.dart';
import '../constants.dart';

class PlayerCreateProfile extends StatefulWidget {
  const PlayerCreateProfile({
    super.key,
    required this.emailFromLogIn,
  });

  final String emailFromLogIn;

  @override
  State<PlayerCreateProfile> createState() => _PlayerCreateProfileState();
}

class _PlayerCreateProfileState extends State<PlayerCreateProfile> {
  ProfilePicture profilePicture = ProfilePicture(path: defaultProfilePath);
  final nameController = TextEditingController();
  final dateInput = TextEditingController();
  final UserPhoneNumber phoneNumberInput = UserPhoneNumber();
  final Location location = Location.initial();
  Sex sexInput = Sex.male;
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  Position positionInput = Position.attacker;
  final bioController = TextEditingController();

  final dio = Dio();
  final String apiRoute = Platform.isAndroid
      ? 'http://10.0.2.2:5000/api'
      : 'http://localhost:5000/api';

  void createProfile() async {
    if (nameController.text.isEmpty ||
        dateInput.text.isEmpty ||
        weightController.text.isEmpty ||
        heightController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return const FailedRequestDialog(
              errorText: 'You didn\'t answer all required fields');
        },
      );
      return;
    }
    if (!phoneNumberInput.isPhoneNumberValid()) {
      showDialog(
        context: context,
        builder: (context) {
          return const FailedRequestDialog(
              errorText: 'Phone Number is not filled correctly');
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
    final String fullName = nameController.text;
    final String email = widget.emailFromLogIn;
    final String phoneNumber = phoneNumberInput.getPhoneNumberString();
    final String dateOfBirth = dateInput.text;
    final Sex sex = sexInput;
    final int weight = int.parse(weightController.text);
    final int height = int.parse(heightController.text);
    final Position position = positionInput;
    final String bio = bioController.text;
    final Player playerProfile = Player.createProfile(
      name: fullName,
      email: email,
      phoneNumber: phoneNumber,
      location: location,
      dateOfBirth: dateOfBirth,
      position: position,
      sex: sex,
      height: height,
      weight: weight,
      description: bio,
    );
    try {
      final response = await dio.post(
        '$apiRoute/newPlayerProfile',
        data: playerProfile.toJsonMap(),
      );
      Player player = Player.fromJson(response.data);
      player.imageByteArray = await uploadImage(profilePicture, player.email);
      if (context.mounted) {
        Navigator.pop(context);
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
    } on DioError catch (e) {
      throw Exception(e.response);
    }
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
                ProfilePictureWidget(
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
                  child: Container(
                    decoration: ShapeDecoration(
                      color: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: kDarkGreen),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextField(
                      controller: dateInput,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        labelText: 'Date of Birth',
                        border: InputBorder.none,
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1940),
                          lastDate: DateTime(DateTime.now().year + 1),
                        );
                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          setState(() => dateInput.text = formattedDate);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: PhoneNumberInput(userPhoneNumber: phoneNumberInput),
                ),
                const SizedBox(height: 5),
                LocationInput(
                  location: location,
                ),
                const SizedBox(height: 15),
                const Divider(color: kDarkGreen),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sex:',
                      style: TextStyle(color: kDarkGreen, fontSize: 16),
                    ),
                    Radio(
                      activeColor: kDarkGreen,
                      groupValue: sexInput,
                      value: Sex.male,
                      onChanged: (value) => setState(() => sexInput = value!),
                    ),
                    const Text('Male'),
                    Radio(
                      activeColor: kDarkGreen,
                      groupValue: sexInput,
                      value: Sex.female,
                      onChanged: (value) => setState(() => sexInput = value!),
                    ),
                    const Text('Female'),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(60, 0, 10, 0),
                        child: NumberInputField(
                          controller: weightController,
                          hintText: 'Weight (kg)',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 60, 0),
                        child: NumberInputField(
                          controller: heightController,
                          hintText: 'Height (cm)',
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  'Select preferred position:',
                  style: TextStyle(color: kDarkGreen, fontSize: 16),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                      activeColor: kDarkGreen,
                      groupValue: positionInput,
                      value: Position.attacker,
                      onChanged: (value) =>
                          setState(() => positionInput = value!),
                    ),
                    const Text('Attacker'),
                    Radio(
                      activeColor: kDarkGreen,
                      groupValue: positionInput,
                      value: Position.midfielder,
                      onChanged: (value) =>
                          setState(() => positionInput = value!),
                    ),
                    const Text('Midfielder'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                      activeColor: kDarkGreen,
                      groupValue: positionInput,
                      value: Position.defender,
                      onChanged: (value) =>
                          setState(() => positionInput = value!),
                    ),
                    const Text('Defender'),
                    Radio(
                      activeColor: kDarkGreen,
                      groupValue: positionInput,
                      value: Position.goalKeeper,
                      onChanged: (value) =>
                          setState(() => positionInput = value!),
                    ),
                    const Text('Goalkeeper'),
                  ],
                ),
                const Divider(color: kDarkGreen),
                const SizedBox(height: 10),
                TextFieldInput(
                  controller: bioController,
                  hintText: 'Bio (Optional)',
                  isMultiLine: true,
                ),
                const SizedBox(height: 5),
                const Divider(color: kDarkGreen),
                SubmitButton(
                  text: 'Submit',
                  onTap: createProfile,
                  fontSize: 20,
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
