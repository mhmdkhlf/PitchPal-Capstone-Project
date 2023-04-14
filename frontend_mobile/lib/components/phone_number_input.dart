import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../constants.dart';

class UserPhoneNumber {
  PhoneNumber? phoneNumber;
  Country country = countries.firstWhere((element) => element.code == 'LB');

  bool isPhoneNumberValid() {
    if (phoneNumber == null) {
      return false;
    }
    return phoneNumber!.number.length >= country.minLength &&
        phoneNumber!.number.length <= country.maxLength;
  }

  String getPhoneNumberString() {
    if (phoneNumber == null) {
      return '';
    }
    final String countryCode = phoneNumber!.countryCode;
    final String number = phoneNumber!.number;
    return '$countryCode $number';
  }
}

class PhoneNumberInput extends StatelessWidget {
  const PhoneNumberInput({super.key, required this.userPhoneNumber});

  final UserPhoneNumber userPhoneNumber;

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      decoration: const InputDecoration(
        fillColor: kDarkGreen,
        labelText: 'Phone Number',
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 3),
        ),
      ),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
      initialCountryCode: 'LB',
      onChanged: (phone) {
        userPhoneNumber.phoneNumber = phone;
      },
      onCountryChanged: (country) => userPhoneNumber.country = country,
    );
  }
}
