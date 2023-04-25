import 'package:flutter/material.dart';
import 'package:frontend_mobile/data/sport_center.dart';

class FacilityInfo extends StatelessWidget {
  const FacilityInfo({super.key, required this.facility, re});

  final Facility facility;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              facility.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (facility.description.isNotEmpty) const SizedBox(height: 10),
            if (facility.description.isNotEmpty)
              Text(
                facility.description,
                maxLines: 3,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
