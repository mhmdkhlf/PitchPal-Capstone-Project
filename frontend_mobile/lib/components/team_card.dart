import 'package:flutter/material.dart';
import '../pages/review_team.dart';
import '../pages/view_team_profile.dart';
import '../data/team.dart';

class TeamCard extends StatelessWidget {
  const TeamCard({
    super.key,
    required this.team,
    required this.playerId,
  });

  final String playerId;
  final Team team;

  String _getRole() {
    if (team.captainId == playerId && team.playerIds.contains(playerId)) {
      return 'Captain & Player';
    } else if (team.captainId == playerId) {
      return 'Captain';
    }
    return 'Player';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 5),
            ListTile(
              leading: const Icon(Icons.groups_3),
              title: Text(
                team.name,
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'Your role: ${_getRole()}',
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ButtonTheme(
              child: ButtonBar(
                children: [
                  ElevatedButton(
                    child: const Text(
                      'Review Team',
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewTeam(
                            team: team,
                            reviewerId: playerId,
                          ),
                        ),
                      );
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Show More'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewTeamProfile(
                            team: team,
                            userId: playerId,
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
