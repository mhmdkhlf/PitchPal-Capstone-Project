import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/components/submit_button.dart';
import 'package:frontend_mobile/data/location.dart';
import 'package:frontend_mobile/data/sport_center.dart';
import 'package:frontend_mobile/data/field.dart';
import 'package:frontend_mobile/data/time_slot.dart';
import '../components/response_dialog_box.dart';
import '../components/location_input.dart';
import '../components/number_input_field.dart';
import '../components/phone_number_input.dart';
import '../components/sport_center_image.dart';
import '../components/textfield_input.dart';
import '../components/time_input.dart';
import '../constants.dart';

class CreateSportCenter extends StatefulWidget {
  const CreateSportCenter({super.key});

  @override
  State<CreateSportCenter> createState() => _CreateSportCenterState();
}

class _CreateSportCenterState extends State<CreateSportCenter> {
  SportCenterPicture sportCenterPicture =
      SportCenterPicture(path: defaultSportCenterImagePath);
  final TextEditingController sportCenterNameController =
      TextEditingController();
  final TextEditingController googleMapsLinkController =
      TextEditingController();
  UserPhoneNumber phoneNumberInput = UserPhoneNumber();
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
    if (sportCenterNameController.text.isEmpty ||
        googleMapsLinkController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => const ResponseDialogBox(
          text: 'You didn\'t answer all required fields',
        ),
      );
      return;
    }
    if (numberOfFields < 1) {
      showDialog(
        context: context,
        builder: (context) => const ResponseDialogBox(
          text: 'You have to add at least one Field',
        ),
      );
      return;
    }
    if (!phoneNumberInput.isPhoneNumberValid()) {
      showDialog(
        context: context,
        builder: (context) => const ResponseDialogBox(
          text: 'Phone Number is not filled correctly',
        ),
      );
      return;
    }
    List<bool> areFieldsInfoFilled = [];
    for (FieldInput fieldInput in fieldInputs) {
      areFieldsInfoFilled.add(fieldInput.isFieldInfoFilled());
    }
    final bool isAllFieldsInfoFilled = areFieldsInfoFilled.every(
      (element) => element,
    );
    if (!isAllFieldsInfoFilled) {
      showDialog(
        context: context,
        builder: (context) => const ResponseDialogBox(
          text: 'Some of the Fields you added have missing values',
        ),
      );
      return;
    }
    List<bool> areFacilitiesInfoFilled = [];
    for (FacilityInput facilityInput in facilitiesInput) {
      areFacilitiesInfoFilled.add(facilityInput.isFacilityInfoFilled());
    }
    final bool isAllFacilitiesInfoFilled = areFacilitiesInfoFilled.every(
      (element) => element,
    );
    if (!isAllFacilitiesInfoFilled) {
      showDialog(
        context: context,
        builder: (context) => const ResponseDialogBox(
          text: "Some of the Facilities you added don't have a name",
        ),
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
    final String googleMapsLink = googleMapsLinkController.text;
    Map<String, dynamic> locationResponse =
        await _getPositionFromLinkResponse(googleMapsLink);
    if (_isGoogleMapsLinkNotValid(locationResponse)) {
      if (context.mounted) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => ResponseDialogBox(
            text: locationResponse['error'],
          ),
        );
      }
      return;
    }
    final Dio dio = Dio();
    final String sportCenterName = sportCenterNameController.text;
    final String phoneNumber = phoneNumberInput.getPhoneNumberString();
    final LongLat position = _getPositionFromResponse(locationResponse);
    final String address = await getCurrentAdress(position);
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
      uploadResults.add(await field.uploadField(sportCenterName));
    }
    final bool isUploadSuccessfull = uploadResults.every((element) => element);
    if (!isUploadSuccessfull) {
      throw Exception('Fields did not upload properly');
    }
    await uploadImage(sportCenterPicture, sportCenterName);
    if (context.mounted) {
      Navigator.pop(context);
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => const ResponseDialogBox(
          text: 'You Successfully registered a Sport Center',
        ),
      );
    }
  }

  Future<Map<String, dynamic>> _getPositionFromLinkResponse(
      String googleMapsLink) async {
    final Dio dio = Dio();
    try {
      final response = await dio.post(
        '$apiRoute/linkToCoordinates',
        data: {"link": googleMapsLink},
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  bool _isGoogleMapsLinkNotValid(Map<String, dynamic> response) {
    return response.containsKey('error');
  }

  LongLat _getPositionFromResponse(Map<String, dynamic> response) {
    return LongLat(
      longitude: response['longitude'],
      latitude: response['latitude'],
    );
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
                  child: PhoneNumberInput(
                    userPhoneNumber: phoneNumberInput,
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
                      'Opening Time ',
                      style: TextStyle(fontSize: 16),
                    ),
                    openingTimeInput,
                    const SizedBox(width: 10),
                    const Text(
                      'Closing Time ',
                      style: TextStyle(fontSize: 16),
                    ),
                    closingTimeInput,
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(color: kDarkGreen, thickness: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Number of Fields',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: NumberInputField(
                          controller: nbOfFieldsController,
                          hintText: "?   ",
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => setState(() {
                          numberOfFields =
                              int.tryParse(nbOfFieldsController.text) ?? 0;
                        }),
                        child: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: numberOfFields,
                  itemBuilder: (context, index) {
                    if (fieldInputs.isEmpty) {
                      for (int i = 0; i < numberOfFields; i++) {
                        fieldInputs.add(
                          FieldInput(
                            fieldNumber: i + 1,
                          ),
                        );
                      }
                    } else {
                      int diff = fieldInputs.length - numberOfFields;
                      if (diff > 0) {
                        for (int i = 0; i < diff; i++) {
                          fieldInputs.removeLast();
                        }
                      } else {
                        int old = fieldInputs.length;
                        for (int i = old; i < numberOfFields; i++) {
                          fieldInputs.add(
                            FieldInput(
                              fieldNumber: i + 1,
                            ),
                          );
                        }
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          Text(
                            'Field #${index + 1}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Dimensions:',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: NumberInputField(
                                  controller:
                                      fieldInputs[index].fieldLengthController,
                                  hintText: 'Length',
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: NumberInputField(
                                  controller:
                                      fieldInputs[index].fieldWidthController,
                                  hintText: 'Width',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Grass Type:',
                                style: TextStyle(fontWeight: FontWeight.w500),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: NumberInputField(
                                  controller: fieldInputs[index]
                                      .reservationPriceController,
                                  hintText: 'Price in \$',
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: NumberInputField(
                                  controller: fieldInputs[index]
                                      .recommendedTeamSizeController,
                                  hintText: 'Team Size',
                                ),
                              ),
                            ],
                          ),
                          index != numberOfFields - 1
                              ? const Divider(thickness: 0.8, color: kDarkGreen)
                              : const SizedBox(height: 10),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(color: kDarkGreen, thickness: 1),
                const Text(
                  'Social Media Pages',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                TextFieldInput(
                  controller: fbLinkController,
                  hintText: 'Facebook link (Optional)',
                ),
                const SizedBox(height: 15),
                TextFieldInput(
                  controller: instaLinkController,
                  hintText: 'Instagram link (Optional)',
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
                          hintText: 'Description (Optional)',
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

  bool isFacilityInfoFilled() => nameController.text.isNotEmpty;
}

class FieldInput {
  FieldInput({
    required this.fieldNumber,
  });

  final int fieldNumber;
  final TextEditingController fieldLengthController = TextEditingController();
  final TextEditingController fieldWidthController = TextEditingController();
  final TextEditingController reservationPriceController =
      TextEditingController();
  final TextEditingController recommendedTeamSizeController =
      TextEditingController();
  Grass grassTypeInput = Grass.turf;

  bool isFieldInfoFilled() {
    return int.tryParse(fieldLengthController.text) != null &&
        int.tryParse(fieldWidthController.text) != null &&
        int.tryParse(reservationPriceController.text) != null &&
        int.tryParse(recommendedTeamSizeController.text) != null;
  }

  Future<bool> uploadField(String sportCenterName) async {
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
    final Dio dio = Dio();
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
