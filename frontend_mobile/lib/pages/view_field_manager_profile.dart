import 'package:flutter/material.dart';
import '../components/contact_info_field.dart';
import '../data/field_manager.dart';
import '../constants.dart';

class ViewFieldManagerProfile extends StatelessWidget {
  const ViewFieldManagerProfile({
    super.key,
    required this.fieldManager,
  });

  final FieldManager fieldManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                CircleAvatar(
                  radius: 81.0,
                  backgroundColor: kDarkColor,
                  child: CircleAvatar(
                    radius: 80.0,
                    backgroundImage: fieldManager.imageByteArray != null
                        ? Image.memory(fieldManager.imageByteArray!).image
                        : const AssetImage(defaultProfilePath),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  fieldManager.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  fieldManager.sportCenterName,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 15),
                const Divider(color: kDarkColor),
                const SizedBox(height: 15),
                const Text(
                  'Contact Info',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),
                ContactInfoField(
                  field: 'Phone Number',
                  value: fieldManager.mobileNumber,
                ),
                const SizedBox(height: 10),
                ContactInfoField(
                  field: 'Email',
                  value: fieldManager.email,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
