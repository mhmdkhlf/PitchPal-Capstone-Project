import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:intl/intl.dart';
import 'package:frontend_mobile/pages/welcome.dart';
import '../components/input_textfield.dart';
import '../components/number_input_field.dart';
import '../components/submit_button.dart';
import '../data/player.dart';
import '../data/location.dart';
import '../constants.dart';

class FirstLogInForm extends StatefulWidget {
  const FirstLogInForm({
    super.key,
    required this.emailFromLogIn,
  });

  final String emailFromLogIn;

  @override
  State<FirstLogInForm> createState() => _FirstLogInFormState();
}

class _FirstLogInFormState extends State<FirstLogInForm> {
  XFile? imageFile;
  final ImagePicker _picker = ImagePicker();
  final nameController = TextEditingController();
  final dateInput = TextEditingController();
  late PhoneNumber phoneNumberInput;
  final locationController = TextEditingController();
  late Sex sexInput = Sex.male;
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  late Position positionInput = Position.attacker;
  final bioController = TextEditingController();

  final dio = Dio();
  final String apiRoute = Platform.isAndroid
      ? 'http://10.0.2.2:5000/api'
      : 'http://localhost:5000/api';

  void createProfile() async {
    final String imageName = //TODO: Picture to be stored in seperate collection
        imageFile == null ? 'default profile image' : imageFile!.name;
    final String fullName = nameController.text;
    final String email = widget.emailFromLogIn;
    final String phoneNumber = _getPhoneNumberString(phoneNumberInput);
    final String dateOfBirth = dateInput.text;
    final String location = locationController.text; //TODO: input geolocation
    final Sex sex = sexInput;
    final int weight = int.parse(weightController.text);
    final int height = int.parse(heightController.text);
    final Position position = positionInput;
    final String bio = bioController.text;

    final Player playerProfileToCreate = Player.createProfile(
      name: fullName,
      email: email,
      phoneNumber: phoneNumber,
      location: Location.fromInput(
        longitude: 0,
        latitude: 0,
        place: 'Beirut',
      ),
      dateOfBirth: dateOfBirth,
      position: position,
      sex: sex,
      height: height,
      weight: weight,
      bio: bio,
    );

    final response = await dio.post(
      '$apiRoute/newPlayerProfile',
      data: playerProfileToCreate.toJsonMapToCreatePlayer(),
    );
    if (response.statusCode == 200) {
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomePage(
              userEmail: email,
              role: 'player',
            ),
          ),
        );
      }
    } else {
      throw Exception('failed to create player profile');
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
                imageProfile(),
                const SizedBox(height: 20),
                InputTextField(
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
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('dd-MM-yyyy').format(pickedDate);
                          setState(() => dateInput.text = formattedDate);
                        } else {}
                      },
                    ),
                  ),
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
                const SizedBox(height: 5),
                InputTextField(
                  controller: locationController,
                  hintText: 'Location',
                ),
                const SizedBox(height: 20),
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
                InputTextField(
                  controller: bioController,
                  hintText: 'Bio (Optional)',
                  isMultiLine: true,
                ),
                const SizedBox(height: 5),
                const Divider(color: kDarkGreen),
                SubmitButton(text: 'Submit', onTap: createProfile),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          backgroundImage: imageFile == null
              ? const AssetImage('assets/profile.png')
              : FileImage(File(imageFile!.path)) as ImageProvider,
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: const Icon(
              Icons.camera_alt,
              color: kDarkGreen,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          const Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: const Text("Camera"),
            ),
            TextButton.icon(
              icon: const Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: const Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
      source: source,
    );
    setState(() {
      imageFile = pickedFile;
    });
  }
}
