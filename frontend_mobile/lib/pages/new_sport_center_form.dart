import 'package:flutter/material.dart';
import 'package:frontend_mobile/components/submit_button.dart';
import 'package:frontend_mobile/data/sport_center.dart';
import 'package:frontend_mobile/data/field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../components/textfield_input.dart';
import '../components/number_input_field.dart';
import '../components/sport_center_image.dart';
import '../components/time_input.dart';
import '../constants.dart';

class NewSportCenterForm extends StatefulWidget {
  const NewSportCenterForm({super.key});

  @override
  State<NewSportCenterForm> createState() => _NewSportCenterFormState();
}

class _NewSportCenterFormState extends State<NewSportCenterForm> {
  SportCenterPicture profilePicture =
      SportCenterPicture(path: defaultSportCenterImagePath);
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
  final List<FieldInput> fieldInputs = [];
  int numberOfFields = 0;

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
                const SizedBox(height: 20),
                SportCenterPictureInput(
                  profilePicture: profilePicture,
                ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      constraints: const BoxConstraints(maxWidth: 150),
                      child: NumberInputField(
                        controller: nbOfFieldsController,
                        hintText: "Nb of Fields",
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () => setState(() {
                        try {
                          numberOfFields = int.parse(nbOfFieldsController.text);
                        } on FormatException {
                          numberOfFields = 0;
                        }
                      }),
                      child: const Text(
                        "Fill out Field(s) info",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: numberOfFields,
                  itemBuilder: (context, index) {
                    for (int i = 0; i < numberOfFields; i++) {
                      fieldInputs.add(FieldInput(
                        sportCenterName: sportCenterNameController.text,
                        fieldNumber: i + 1,
                      ));
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Column(
                        children: [
                          Text(
                            'Field #${index + 1}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          NumberInputField(
                            controller:
                                fieldInputs[index].fieldLengthController,
                            hintText: 'Field Length',
                          ),
                          const SizedBox(height: 10),
                          NumberInputField(
                            controller: fieldInputs[index].fieldWidthController,
                            hintText: 'Field Width',
                          ),
                          const SizedBox(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Grass Type:',
                                style:
                                    TextStyle(color: kDarkGreen, fontSize: 16),
                              ),
                              Radio(
                                activeColor: kDarkGreen,
                                groupValue: fieldInputs[index].grassTypeInput,
                                value: Grass.grass,
                                onChanged: (value) => setState(() =>
                                    fieldInputs[index].grassTypeInput = value!),
                              ),
                              const Text('Grass'),
                              Radio(
                                activeColor: kDarkGreen,
                                groupValue: fieldInputs[index].grassTypeInput,
                                value: Grass.turf,
                                onChanged: (value) => setState(() =>
                                    fieldInputs[index].grassTypeInput = value!),
                              ),
                              const Text('Turf'),
                            ],
                          ),
                          const SizedBox(height: 3),
                          NumberInputField(
                            controller:
                                fieldInputs[index].reservationPriceController,
                            hintText: 'Reservation Price',
                          ),
                          const SizedBox(height: 10),
                          NumberInputField(
                            controller: fieldInputs[index]
                                .recommendedTeamSizeController,
                            hintText: 'Recommended Team size',
                          ),
                          if (index != numberOfFields - 1)
                            const Divider(thickness: 0.5, color: kDarkGreen),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 15),
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
}

class FieldInput {
  FieldInput({
    required this.sportCenterName,
    required this.fieldNumber,
  });

  final String sportCenterName;
  final int fieldNumber;
  final TextEditingController fieldLengthController = TextEditingController();
  final TextEditingController fieldWidthController = TextEditingController();
  final TextEditingController reservationPriceController =
      TextEditingController();
  late Grass grassTypeInput = Grass.turf;
  final TextEditingController recommendedTeamSizeController =
      TextEditingController();

  void createField() async {
    //TODO api call
  }
}
