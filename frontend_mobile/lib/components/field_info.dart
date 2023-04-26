import 'package:flutter/material.dart';
import '../components/sport_center_attribute.dart';
import '../data/field.dart';

class FieldInfo extends StatelessWidget {
  const FieldInfo({
    super.key,
    required this.field,
  });

  final Field field;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Field #${field.fieldNumber}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            SportCenterAttribute(
              text: 'Reservation Price: ${field.reservationPrice}\$',
              fontSize: 14,
            ),
            const SizedBox(height: 10),
            SportCenterAttribute(
              text: 'Dimensions: ${field.fieldLength}x${field.fieldWidth}m',
              fontSize: 14,
            ),
            const SizedBox(height: 10),
            SportCenterAttribute(
              text: 'Grass type: ${field.grassType.value}',
              fontSize: 14,
            ),
            const SizedBox(height: 10),
            SportCenterAttribute(
              text: 'Team size: ${field.recommendedTeamSize} players',
              fontSize: 14,
            ),
          ],
        ),
      ),
    );
  }
}
