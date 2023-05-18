import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:frontend_mobile/pages/view_match_players.dart';
import '../data/reservation.dart';
import '../data/player.dart';
import '../constants.dart';

class MatchCard extends StatelessWidget {
  final Reservation reservation;
  final bool publicMatch;
  final Player player;

  const MatchCard({
    super.key,
    required this.reservation,
    required this.player,
    this.publicMatch = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Card(
        color: kLightColor,
        elevation: 3,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 8),
                  Text(
                    reservation.reservationDate.substring(0, 10),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 20),
                  const Icon(Icons.access_time),
                  const SizedBox(width: 8),
                  Text(
                    '${reservation.reservationTime.startTime}-${reservation.reservationTime.endTime}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_pin),
                  const SizedBox(width: 8),
                  Text(
                    reservation.sportCenterName,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    child: const Text(
                      "See Players",
                      style: TextStyle(fontSize: 14),
                    ),
                    onPressed: () async {
                      Map<String, Player> idToPlayer = {};
                      final Dio dio = Dio();
                      final response = await dio.get(
                          '$apiRoute/getPlayerByEmail/${reservation.reserverEmail}');
                      Player reserverPlayer = Player.fromJson(response.data);
                      idToPlayer[reserverPlayer.playerID!] = reserverPlayer;
                      for (String playerId in reservation.teamOneIds!) {
                        final response =
                            await dio.get('$apiRoute/getPlayer/$playerId');
                        idToPlayer[playerId] = Player.fromJson(response.data);
                      }
                      for (String playerId in reservation.teamTwoIds!) {
                        final response =
                            await dio.get('$apiRoute/getPlayer/$playerId');
                        idToPlayer[playerId] = Player.fromJson(response.data);
                      }
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewMatchPlayers(
                              reservation: reservation,
                              players: idToPlayer,
                              reserverPlayer: reserverPlayer,
                              publicMatch: publicMatch,
                              player: player,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
