import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../components/textfield_input.dart';
import '../components/number_input_field.dart';
import '../constants.dart';

class NewSportCenterForm extends StatefulWidget {
  const NewSportCenterForm({super.key});

  @override
  State<NewSportCenterForm> createState() => _NewSportCenterFormState();
}

class _NewSportCenterFormState extends State<NewSportCenterForm> {
  final TextEditingController sportCenterNameController =
      TextEditingController();
  final TextEditingController googleMapsLinkController =
      TextEditingController();
  late PhoneNumber phoneNumberInput;
  final TextEditingController socialLinkController = TextEditingController();
  final TextEditingController numberOfFieldsController =
      TextEditingController();
  final TextEditingController facilitiesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'New Sport-Center Form',
            style: TextStyle(fontSize: 22),
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
                const Divider(color: kDarkGreen),
                const SizedBox(height: 20),
                TextFieldInput(
                  controller: sportCenterNameController,
                  hintText: 'Sport-Center Name',
                ),
                const SizedBox(height: 15),
                TextFieldInput(
                  controller: googleMapsLinkController,
                  hintText: 'Google-Maps link',
                ),
                const SizedBox(height: 15),
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
                const SizedBox(height: 15),
                TextFieldInput(
                  controller: socialLinkController,
                  hintText: 'Social media link',
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                      constraints: const BoxConstraints(maxWidth: 150),
                      child: NumberInputField(
                        controller: numberOfFieldsController,
                        hintText: "Nb of Fields",
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      children: const [
                        Text('input opening time'),
                        Text('input closing time'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                TextFieldInput(
                  controller: facilitiesController,
                  hintText: 'Facilities available',
                  isMultiLine: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
