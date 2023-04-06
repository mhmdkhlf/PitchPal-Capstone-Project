import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/components/submit_button.dart';
import 'package:frontend_mobile/data/location.dart';
import 'package:frontend_mobile/data/sport_center.dart';
import 'package:frontend_mobile/data/field.dart';
import 'package:frontend_mobile/data/time_slot.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../components/textfield_input.dart';
import '../components/number_input_field.dart';
import '../components/sport_center_image.dart';
import '../components/time_input.dart';
import '../components/location_input.dart';
import '../constants.dart';

final dio = Dio();
final String apiRoute = Platform.isAndroid
    ? 'http://10.0.2.2:5000/api'
    : 'http://localhost:5000/api';

class NewSportCenterForm extends StatefulWidget {
  const NewSportCenterForm({super.key});

  @override
  State<NewSportCenterForm> createState() => _NewSportCenterFormState();
}

class _NewSportCenterFormState extends State<NewSportCenterForm> {
  SportCenterPicture sportCenterPicture =
      SportCenterPicture(path: defaultSportCenterImagePath);
  final TextEditingController sportCenterNameController =
      TextEditingController();
  final TextEditingController googleMapsLinkController =
      TextEditingController();
  late PhoneNumber phoneNumberInput;
  TimeInput openingTimeInput = TimeInput(
    timeInput: const TimeOfDay(hour: 10, minute: 0),
  );
  TimeInput closingTimeInput = TimeInput(
    timeInput: const TimeOfDay(hour: 22, minute: 0),
  );
  final TextEditingController fbLinkController = TextEditingController();
  final TextEditingController instaLinkController = TextEditingController();
  final TextEditingController nbOfFieldsController = TextEditingController();
  final List<FacilityInput> facilitiesInput = [];
  final List<FieldInput> fieldInputs = [];
  int numberOfFields = 0;

  Future<void> createSportCenter() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    final String sportCenterName = sportCenterNameController.text;
    final String phoneNumber = _getPhoneNumberString(phoneNumberInput);
    final String googleMapsLink = googleMapsLinkController.text;
    final LongLat position = await _getPositionFromLink(googleMapsLink);
    String address = await getCurrentAdress(position);
    final List<Facility> facilities = [];
    for (FacilityInput facilityInput in facilitiesInput) {
      Facility facility = Facility(
        name: facilityInput.nameController.text,
        description: facilityInput.descriptionController.text,
      );
      facilities.add(facility);
    }
    final SportCenter sportCenter = SportCenter.createProfile(
      name: sportCenterName,
      location: Location.fromInput(
        latitude: position.latitude,
        longitude: position.longitude,
        place: address,
      ),
      locationLink: googleMapsLink,
      phoneNumber: phoneNumber,
      nbOfFields: numberOfFields,
      workingHours: TimeSlot.fromInput(
        startTime: openingTimeInput.getTimeString(),
        endTime: closingTimeInput.getTimeString(),
      ),
      facilitiesAvailable: facilities,
      linkToFB: fbLinkController.text,
      linkToInsta: instaLinkController.text,
    );
    try {
      final response = await dio.post(
        '$apiRoute/newSportCenter',
        data: sportCenter.toJsonMap(),
      );
      if (response.statusCode != 200) {
        throw Exception("Invalid status code for sport center post");
      }
    } on DioError catch (e) {
      throw Exception(e.stackTrace);
    }
    List<bool> uploadResults = [];
    for (FieldInput field in fieldInputs) {
      uploadResults.add(await field.uploadField());
    }
    final bool isUploadSuccessfull = uploadResults.every((element) => element);
    if (!isUploadSuccessfull) {
      throw Exception('Fields did not upload properly');
    }
    await uploadImage(sportCenterPicture, sportCenterName);
    if (context.mounted) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  Future<LongLat> _getPositionFromLink(String googleMapsLink) async {
    try {
      final response = await dio.post(
        '$apiRoute/linkToCoordinates',
        data: {"link": googleMapsLink},
      );
      return LongLat(
        longitude: response.data['longitude'],
        latitude: response.data['latitude'],
      );
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
                  profilePicture: sportCenterPicture,
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
                    fieldInputs.clear();
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
                            hintText: 'Reservation Price in \$',
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

  Future<bool> uploadField() async {
    final Field field = Field.createProfile(
      sportCenterName: sportCenterName,
      fieldNumber: fieldNumber,
      fieldLength: int.tryParse(fieldLengthController.text) ?? 0,
      fieldWidth: int.tryParse(fieldWidthController.text) ?? 0,
      reservationPrice: int.tryParse(reservationPriceController.text) ?? 0,
      grassType: grassTypeInput,
      recommendedTeamSize:
          int.tryParse(recommendedTeamSizeController.text) ?? 0,
    );
    try {
      final response = await dio.post(
        '$apiRoute/newField',
        data: field.toJsonMap(),
      );
      return response.statusCode == 200;
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }
}
