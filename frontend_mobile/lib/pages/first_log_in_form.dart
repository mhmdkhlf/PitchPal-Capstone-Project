import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../components/input_textfield.dart';
import '../components/number_input_field.dart';
import '../data/player.dart';
import '../constants.dart';

class FirstLogInForm extends StatefulWidget {
  const FirstLogInForm({super.key});

  @override
  State<FirstLogInForm> createState() => _FirstLogInFormState();
}

class _FirstLogInFormState extends State<FirstLogInForm> {
  final nameController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final bioController = TextEditingController();
  late Position position = Position.attacker;
  late Sex sex = Sex.male;
  late PhoneNumber phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Image(
                    image: AssetImage('assets/logo.png'),
                    height: 100,
                    width: 200,
                    fit: BoxFit.fitWidth,
                  ),
                  const SizedBox(height: 35),
                  InputTextField(
                    controller: nameController,
                    hintText: 'Full Name',
                  ),
                  const SizedBox(height: 20),
                  IntlPhoneField(
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2),
                      ),
                    ),
                    initialCountryCode: 'LB',
                    onChanged: (phone) => phoneNumber = phone,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: kDarkGreen, width: 2),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Sex:',
                          style: TextStyle(color: kDarkGreen, fontSize: 16),
                        ),
                        RadioListTile<Sex>(
                          title: const Text('Male'),
                          activeColor: kDarkGreen,
                          dense: true,
                          groupValue: sex,
                          value: Sex.male,
                          onChanged: (value) => setState(() => sex = value!),
                        ),
                        RadioListTile<Sex>(
                          title: const Text('Female'),
                          activeColor: kDarkGreen,
                          dense: true,
                          groupValue: sex,
                          value: Sex.female,
                          onChanged: (value) => setState(() => sex = value!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  NumberInputField(
                    controller: weightController,
                    hintText: 'Weight (kg)',
                  ),
                  const SizedBox(height: 15),
                  NumberInputField(
                    controller: heightController,
                    hintText: 'Height (cm)',
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: kDarkGreen, width: 2),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Select preferred position:',
                          style: TextStyle(color: kDarkGreen, fontSize: 16),
                        ),
                        RadioListTile<Position>(
                          title: const Text('Attacker'),
                          activeColor: kDarkGreen,
                          dense: true,
                          groupValue: position,
                          value: Position.attacker,
                          onChanged: (value) =>
                              setState(() => position = value!),
                        ),
                        RadioListTile<Position>(
                          title: const Text('Midfielder'),
                          activeColor: kDarkGreen,
                          dense: true,
                          groupValue: position,
                          value: Position.midfielder,
                          onChanged: (value) =>
                              setState(() => position = value!),
                        ),
                        RadioListTile<Position>(
                          title: const Text('Defender'),
                          activeColor: kDarkGreen,
                          dense: true,
                          groupValue: position,
                          value: Position.defender,
                          onChanged: (value) =>
                              setState(() => position = value!),
                        ),
                        RadioListTile<Position>(
                          title: const Text('Goalkeeper'),
                          activeColor: kDarkGreen,
                          dense: true,
                          groupValue: position,
                          value: Position.goalKeeper,
                          onChanged: (value) =>
                              setState(() => position = value!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  InputTextField(
                    controller: bioController,
                    hintText: 'Bio (Optional)',
                    isMultiLine: true,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
