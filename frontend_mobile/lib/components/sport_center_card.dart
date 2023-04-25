import 'package:flutter/material.dart';
import 'package:frontend_mobile/pages/view_sport_center_profile.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/sport_center.dart';
import '../constants.dart';

class SportCenterCard extends StatelessWidget {
  const SportCenterCard({
    super.key,
    required this.sportCenter,
  });

  final SportCenter sportCenter;

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
                'Location: ${sportCenter.location.place} + (distance from player)',
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
                    child: const Text('Google Maps'),
                    onPressed: () => launchUrl(
                      Uri.parse(sportCenter.locationLink),
                    ),
                  ),
                  ElevatedButton(
                    child: const Text('Show More'),
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
                  const SizedBox(width: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
