import 'package:flutter/material.dart';
import '../data/reservation.dart';

class PlayerReservationCard extends StatelessWidget {
  const PlayerReservationCard({
    super.key,
    required this.reservation,
  });

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    bool isPending = reservation.reservationStatus == ReservationStatus.pending;
    Color cardColor;
    if (isPending) {
      cardColor = Colors.yellow.shade400;
    } else if (reservation.reservationStatus == ReservationStatus.accepted) {
      cardColor = Colors.green.shade400;
    } else {
      cardColor = Colors.red.shade400;
    }
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        color: cardColor,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 5),
            ListTile(
              title: Text(
                '${reservation.reservationDate.substring(0, 10)}; ${reservation.reservationTime.startTime}-${reservation.reservationTime.endTime}, at ${reservation.sportCenterName}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  isPending
                      ? 'Reservation is still pending'
                      : 'Reservation got ${reservation.reservationStatus.value}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
