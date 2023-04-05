import 'package:flutter/material.dart';
import 'package:frontend_mobile/components/submit_button.dart';
import 'package:frontend_mobile/data/sport_center.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../components/textfield_input.dart';
import '../components/number_input_field.dart';
import '../components/time_input.dart';
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
  TimeInput openingTimeInput =
      TimeInput(timeInput: const TimeOfDay(hour: 10, minute: 0));
  TimeInput closingTimeInput =
      TimeInput(timeInput: const TimeOfDay(hour: 22, minute: 0));
  final TextEditingController fbLinkController = TextEditingController();
  final TextEditingController instaLinkController = TextEditingController();
  final TextEditingController nbOfFieldsController = TextEditingController();
  final List<FacilityInput> facilitiesInput = [];

  void createSportCenter() async {
    //TODO api call
  }

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
                // TODO: input sport center profile picture photo
                const SizedBox(height: 20),
                TextFieldInput(
                  controller: sportCenterNameController,
                  hintText: 'Sport-Center Name',
                ),
                const SizedBox(height: 15),
                TextFieldInput(
                  controller: googleMapsLinkController,
                  hintText: 'Google Maps link',
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
                const Divider(color: kDarkGreen, thickness: 1),
                const Text(
                  'Working Hours',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Opening Time: ',
                      style: TextStyle(fontSize: 16),
                    ),
                    openingTimeInput,
                    const SizedBox(width: 10),
                    const Text(
                      'Closing Time: ',
                      style: TextStyle(fontSize: 16),
                    ),
                    closingTimeInput,
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(color: kDarkGreen, thickness: 1),
                Container(
                  padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                  constraints: const BoxConstraints(maxWidth: 150),
                  child: NumberInputField(
                    controller: nbOfFieldsController,
                    hintText: "Nb of Fields",
                  ),
                ),
                // TODO: figure out field input will be done
                const SizedBox(width: 20),
                const Divider(color: kDarkGreen, thickness: 1),
                const Text(
                  'Social Media Pages',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                TextFieldInput(
                  controller: fbLinkController,
                  hintText: 'Facebook link',
                ),
                const SizedBox(height: 15),
                TextFieldInput(
                  controller: instaLinkController,
                  hintText: 'Instagram link',
                ),
                const SizedBox(height: 10),
                const Divider(color: kDarkGreen, thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Facilities Available',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () =>
                          setState(() => facilitiesInput.add(FacilityInput())),
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(width: 5),
                    ElevatedButton(
                      onPressed: () => setState(() {
                        if (facilitiesInput.isNotEmpty) {
                          facilitiesInput.removeLast();
                        }
                      }),
                      child: const Icon(Icons.remove),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: facilitiesInput.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          'Facility #${index + 1}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        TextFieldInput(
                          controller: facilitiesInput[index].nameController,
                          hintText: 'Facility name',
                        ),
                        const SizedBox(height: 10),
                        TextFieldInput(
                          controller:
                              facilitiesInput[index].descriptionController,
                          hintText: 'Description',
                          isMultiLine: true,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),
                const Divider(color: kDarkGreen, thickness: 1),
                SubmitButton(
                  text: 'Submit',
                  onTap: createSportCenter,
                  fontSize: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FacilityInput {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  TextEditingController get getNameController {
    return nameController;
  }

  TextEditingController get getDescriptionController {
    return descriptionController;
  }
}
