import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../components/rating_display.dart';
import '../data/player.dart';
import '../data/team.dart';
import '../constants.dart';

class ViewTeamProfile extends StatelessWidget {
  const ViewTeamProfile({
    super.key,
    required this.team,
  });

  final Team team;

  Future<Map<String, Player>> getPlayers() async {
    Map<String, Player> idToPlayer = {};
    final Dio dio = Dio();
    final response = await dio.get('$apiRoute/getPlayer/${team.captainId}');
    idToPlayer[team.captainId] = Player.fromJson(response.data);
    for (String playerId in team.playerIds) {
      final response = await dio.get('$apiRoute/getPlayer/$playerId');
      idToPlayer[playerId] = Player.fromJson(response.data);
    }
    return idToPlayer;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPlayers(),
      builder: (context, players) {
        if (players.hasData) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        team.name,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Divider(color: kDarkColor),
                      const SizedBox(height: 10),
                      Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          style: const TextStyle(fontSize: 18),
                          children: [
                            const TextSpan(
                              text: 'Captain: ',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            TextSpan(
                              text: players.data![team.captainId]!.name,
                            ),
                            TextSpan(
                              text: ' (#${team.captainId})',
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Squad has ${team.playerIds.length} players:',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: team.playerIds.length,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text.rich(
                                textAlign: TextAlign.center,
                                TextSpan(
                                  style: const TextStyle(fontSize: 18),
                                  children: [
                                    TextSpan(
                                      text: players
                                          .data![team.playerIds[index]]!.name,
                                    ),
                                    TextSpan(
                                      text: ' (#${team.playerIds[index]})',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 5),
                      const Divider(color: kDarkColor),
                      const SizedBox(height: 7),
                      Text.rich(
                        TextSpan(
                          style: const TextStyle(fontSize: 18),
                          children: <TextSpan>[
                            const TextSpan(
                              text: 'Average Ratings ',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: '(${team.numberOfRatings} reviews)',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RatingDisplay(
                        attribute: 'Sportsmanship',
                        rating: team.averageMoralRating ?? 0,
                      ),
                      const SizedBox(height: 2),
                      RatingDisplay(
                        attribute: '    Skill Level     ',
                        rating: team.averageSkillRating ?? 0,
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        if (players.hasError) {
          return Center(child: Text(players.error.toString()));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
