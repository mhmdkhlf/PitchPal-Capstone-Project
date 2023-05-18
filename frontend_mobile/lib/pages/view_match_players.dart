import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../components/response_dialog_box.dart';
import '../components/textfield_input.dart';
import '../data/reservation.dart';
import '../data/player.dart';
import '../constants.dart';

class ViewMatchPlayers extends StatefulWidget {
  const ViewMatchPlayers({
    super.key,
    required this.reservation,
    required this.players,
    required this.reserverPlayer,
    required this.player,
    this.publicMatch = false,
  });

  final Player player;
  final Reservation reservation;
  final Map<String, Player> players;
  final Player reserverPlayer;
  final bool publicMatch;

  @override
  State<ViewMatchPlayers> createState() => _ViewMatchPlayersState();
}

class _ViewMatchPlayersState extends State<ViewMatchPlayers> {
  final TextEditingController playerTeam1Input = TextEditingController();
  final TextEditingController playerTeam2Input = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Reservation reservation = widget.reservation;
    Map<String, Player> players = widget.players;
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Players',
      )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  style: const TextStyle(fontSize: 18),
                  children: [
                    TextSpan(
                      text: 'Resever: ${widget.reserverPlayer.name}',
                    ),
                    TextSpan(
                      text: ' (#${widget.reserverPlayer.playerID})',
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Team-1 players',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
              if (reservation.teamOneIds!.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Team-1 doesn't have players",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: reservation.teamOneIds!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                            style: const TextStyle(fontSize: 18),
                            children: [
                              TextSpan(
                                text: players[reservation.teamOneIds![index]]!
                                    .name,
                              ),
                              TextSpan(
                                text: ' (#${reservation.teamOneIds![index]})',
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
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              const Text(
                'Team-2 players',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
              if (reservation.teamTwoIds!.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Team-2 doesn't have players",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: reservation.teamTwoIds!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                            style: const TextStyle(fontSize: 18),
                            children: [
                              TextSpan(
                                text: players[reservation.teamTwoIds![index]]!
                                    .name,
                              ),
                              TextSpan(
                                text: ' (#${reservation.teamTwoIds![index]})',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              widget.publicMatch
                  ? Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            'Join this Match',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              Dio dio = Dio();
                              String playerId = widget.player.playerID!;
                              final response = await dio.post(
                                '$apiRoute/addPlayerToMatch',
                                data: {
                                  'playerId': playerId,
                                  'reservationId': reservation.uuid,
                                  'teamNumber': 1
                                },
                              );
                              if (response.statusCode != 200) {
                                throw Exception('api error');
                              }
                              setState(() {
                                widget.reservation.teamOneIds!.add(playerId);
                                widget.players[playerId] = widget.player;
                              });
                              if (context.mounted) {
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  builder: (context) => const ResponseDialogBox(
                                    text: 'You joined team-1',
                                  ),
                                );
                              }
                            } on DioError catch (e) {
                              throw Exception(e.stackTrace);
                            }
                          },
                          child: const Text(
                            'Join Team-1',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              Dio dio = Dio();
                              String playerId = widget.player.playerID!;
                              final response = await dio.post(
                                '$apiRoute/addPlayerToMatch',
                                data: {
                                  'playerId': playerId,
                                  'reservationId': reservation.uuid,
                                  'teamNumber': 2
                                },
                              );
                              if (response.statusCode != 200) {
                                throw Exception('api error');
                              }
                              setState(() {
                                widget.reservation.teamOneIds!.add(playerId);
                                widget.players[playerId] = widget.player;
                              });
                              if (context.mounted) {
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  builder: (context) => const ResponseDialogBox(
                                    text: 'You joined team-2',
                                  ),
                                );
                              }
                            } on DioError catch (e) {
                              throw Exception(e.stackTrace);
                            }
                          },
                          child: const Text(
                            'Join Team-2',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            'Add Player to match',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 100),
                          child: TextFieldInput(
                            controller: playerTeam1Input,
                            hintText: 'player-id',
                          ),
                        ),
                        const SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              final String playerId = playerTeam1Input.text;
                              if (playerId.length == 7 &&
                                  int.tryParse(playerId.substring(0, 3)) !=
                                      null &&
                                  int.tryParse(playerId.substring(4, 7)) !=
                                      null &&
                                  playerId[3] == '-') {
                                final Dio dio = Dio();
                                try {
                                  final response = await dio.get(
                                    '$apiRoute/getPlayer/$playerId',
                                  );
                                  Player player =
                                      Player.fromJson(response.data);
                                  if (response.data != null) {
                                    final response = await dio.post(
                                      '$apiRoute/addPlayerToMatch',
                                      data: {
                                        'playerId': playerId,
                                        'reservationId': reservation.uuid,
                                        'teamNumber': 1
                                      },
                                    );
                                    if (response.statusCode != 200) {
                                      throw Exception('api error');
                                    }
                                    setState(() {
                                      widget.reservation.teamOneIds!
                                          .add(playerId);
                                      widget.players[playerId] = player;
                                    });
                                    if (context.mounted) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => ResponseDialogBox(
                                          text: '$playerId was added to team-1',
                                        ),
                                      );
                                    }
                                  } else {
                                    if (context.mounted) {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const ResponseDialogBox(
                                          text:
                                              'No player has the ID you specified',
                                        ),
                                      );
                                    }
                                  }
                                } on DioError catch (e) {
                                  throw Exception(e.stackTrace);
                                }
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => const ResponseDialogBox(
                                    text:
                                        'Invalid player IDs format\n(should be like -> 000-000)',
                                  ),
                                );
                              }
                            } on DioError catch (e) {
                              throw Exception(e.response);
                            }
                          },
                          child: const Text('Add Player to team-1'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              final String playerId = playerTeam1Input.text;
                              if (playerId.length == 7 &&
                                  int.tryParse(playerId.substring(0, 3)) !=
                                      null &&
                                  int.tryParse(playerId.substring(4, 7)) !=
                                      null &&
                                  playerId[3] == '-') {
                                final Dio dio = Dio();
                                try {
                                  final response = await dio.get(
                                    '$apiRoute/getPlayer/$playerId',
                                  );
                                  Player player =
                                      Player.fromJson(response.data);
                                  if (response.data != null) {
                                    final response = await dio.post(
                                      '$apiRoute/addPlayerToMatch',
                                      data: {
                                        'playerId': playerId,
                                        'reservationId': reservation.uuid,
                                        'teamNumber': 2
                                      },
                                    );
                                    if (response.statusCode != 200) {
                                      throw Exception('api error');
                                    }
                                    setState(() {
                                      widget.reservation.teamTwoIds!
                                          .add(playerId);
                                      widget.players[playerId] = player;
                                    });
                                    if (context.mounted) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => ResponseDialogBox(
                                          text: '$playerId was added to team-2',
                                        ),
                                      );
                                    }
                                  } else {
                                    if (context.mounted) {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const ResponseDialogBox(
                                          text:
                                              'No player has the ID you specified',
                                        ),
                                      );
                                    }
                                  }
                                } on DioError catch (e) {
                                  throw Exception(e.stackTrace);
                                }
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => const ResponseDialogBox(
                                    text:
                                        'Invalid player IDs format\n(should be like -> 000-000)',
                                  ),
                                );
                              }
                            } on DioError catch (e) {
                              throw Exception(e.response);
                            }
                          },
                          child: const Text('Add Player to team-2'),
                        ),
                      ],
                    ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
