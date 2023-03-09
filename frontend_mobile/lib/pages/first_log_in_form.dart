import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:intl/intl.dart';
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
  final dateInput = TextEditingController();
  final locationController = TextEditingController();
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Image(
                  image: AssetImage('assets/logo.png'),
                  height: 100,
                  width: 200,
                  fit: BoxFit.fitWidth,
                ),
                const SizedBox(height: 30),
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
                    onChanged: (phone) => phoneNumber = phone,
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
                      groupValue: sex,
                      value: Sex.male,
                      onChanged: (value) => setState(() => sex = value!),
                    ),
                    const Text('Male'),
                    Radio(
                      activeColor: kDarkGreen,
                      groupValue: sex,
                      value: Sex.female,
                      onChanged: (value) => setState(() => sex = value!),
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
                      groupValue: position,
                      value: Position.attacker,
                      onChanged: (value) => setState(() => position = value!),
                    ),
                    const Text('Attacker'),
                    Radio(
                      activeColor: kDarkGreen,
                      groupValue: position,
                      value: Position.midfielder,
                      onChanged: (value) => setState(() => position = value!),
                    ),
                    const Text('Midfielder'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                      activeColor: kDarkGreen,
                      groupValue: position,
                      value: Position.defender,
                      onChanged: (value) => setState(() => position = value!),
                    ),
                    const Text('Defender'),
                    Radio(
                      activeColor: kDarkGreen,
                      groupValue: position,
                      value: Position.goalKeeper,
                      onChanged: (value) => setState(() => position = value!),
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
