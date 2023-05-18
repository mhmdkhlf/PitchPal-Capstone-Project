import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:frontend_mobile/pages/view_sport_center_profile.dart';
import 'package:frontend_mobile/pages/book_field.dart';
import 'package:frontend_mobile/pages/review_sport_center.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/reservation.dart';
import '../data/player.dart';
import '../data/sport_center.dart';
import '../constants.dart';

class SportCenterCard extends StatelessWidget {
  const SportCenterCard({
    super.key,
    required this.sportCenter,
    required this.player,
  });

  final SportCenter sportCenter;
  final Player player;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        elevation: 10,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 5),
            ListTile(
              leading: const Icon(CustomIcon.soccerBall),
              title: Text(
                sportCenter.name,
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                """Location: ${sportCenter.location.place}
Distance: ${sportCenter.distanceFromPlayer == null ? 'N/A' : '${sportCenter.distanceFromPlayer} km'}""",
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Container(
              alignment: Alignment.center,
              child: sportCenter.imageByteArray != null
                  ? Image.memory(
                      sportCenter.imageByteArray!,
                      height: 168,
                      width: 300,
                    )
                  : Image.asset(
                      defaultSportCenterImagePath,
                      height: 168,
                      width: 300,
                    ),
            ),
            ButtonTheme(
              child: ButtonBar(
                children: [
                  ElevatedButton(
                    child: const Text(
                      'Book Field',
                      style: TextStyle(fontSize: 12),
                    ),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                      Dio dio = Dio();
                      final response = await dio.get(
                        '$apiRoute/getAllReservationsBySportCenter/${sportCenter.name}',
                      );
                      List<dynamic> reservationsData = response.data;
                      List<Reservation> reservations = reservationsData
                          .map((e) => Reservation.fromJson(e))
                          .toList();
                      if (context.mounted) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookField(
                              sportCenter: sportCenter,
                              reservations: reservations,
                              playerEmail: player.email,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  ElevatedButton(
                    child: const Text(
                      'Review',
                      style: TextStyle(fontSize: 12),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewSportCenter(
                          sportCenterName: sportCenter.name,
                          playerId: player.playerID!,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    child: const Text(
                      'Show More',
                      style: TextStyle(fontSize: 12),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewSportCenterProfile(
                            sportCenter: sportCenter,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    color: kDarkGreen,
                    icon: const Icon(Icons.location_pin),
                    onPressed: () => launchUrl(
                      Uri.parse(sportCenter.locationLink),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
