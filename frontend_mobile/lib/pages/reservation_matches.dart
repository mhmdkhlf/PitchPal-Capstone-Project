import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../components/match_card.dart';
import '../components/player_reservation_card.dart';
import '../data/player.dart';
import '../data/time_slot.dart';
import '../data/reservation.dart';
import '../constants.dart';

class ReservationsAndMatches extends StatefulWidget {
  const ReservationsAndMatches({
    super.key,
    required this.player,
  });

  final Player player;

  @override
  State<ReservationsAndMatches> createState() => _ReservationsAndMatchesState();
}

class _ReservationsAndMatchesState extends State<ReservationsAndMatches> {
  Future<List<Reservation>> getReservations() async {
    Dio dio = Dio();
    try {
      final response = await dio.get(
        '$apiRoute/getAllReservationsByEmail/${widget.player.email}',
      );
      return (response.data as List)
          .map((data) => Reservation.fromJson(data))
          .toList();
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }

  Future<List<Reservation>> getPublicMatches() async {
    Dio dio = Dio();
    try {
      final response = await dio.get(
        '$apiRoute/getUpcomingPublicMatches',
      );
      return (response.data as List)
          .map((data) => Reservation.fromJson(data))
          .toList();
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }

  Future<List<Reservation>> getUpcomingMatches() async {
    Dio dio = Dio();
    try {
      final response = await dio.post(
        '$apiRoute/getAPlayersUpcomingMatches',
        data: {
          'id': widget.player.playerID,
          'email': widget.player.email,
        },
      );
      return (response.data as List)
          .map((data) => Reservation.fromJson(data))
          .toList();
    } on DioError catch (e) {
      throw Exception(e.response);
    }
  }

  Future<Map<String, List<Reservation>>>
      getReservationsAndUpcomingMatchesAndPublicMatches() async {
    List<Reservation> upcomingMatches = await getUpcomingMatches();
    List<Reservation> publicMatches = await getPublicMatches();
    publicMatches = publicMatches.where((publicMatch) {
      Reservation reservation = upcomingMatches.firstWhere(
        (element) => element.uuid == publicMatch.uuid,
        orElse: (() => Reservation(
              uuid: null,
              reserverEmail: '',
              reserverType: ReserverType.fieldManager,
              sportCenterName: '',
              isPublic: false,
              fieldNumber: 0,
              reservationDate: '',
              reservationTime: TimeSlot.fromInput(startTime: '', endTime: ''),
              reservationStatus: ReservationStatus.pending,
              teamOneIds: [],
              teamTwoIds: [],
              comment: '',
            )),
      );
      return reservation.uuid == null;
    }).toList();
    return {
      "reservations": await getReservations(),
      "upcoming matches": upcomingMatches,
      "public matches": publicMatches,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getReservationsAndUpcomingMatchesAndPublicMatches(),
      builder: (context, reservations) {
        if (reservations.hasData) {
          return SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Text(
                    'Hey ${widget.player.name}!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(thickness: 1),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Here are your upcoming matches',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (reservations.data!['upcoming matches']!.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'You have no upcoming matches...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  Column(
                    children: List.generate(
                      reservations.data!['upcoming matches']!.length,
                      (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MatchCard(
                          reservation:
                              reservations.data!['upcoming matches']![index],
                          player: widget.player,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(thickness: 1),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Here is the history all your reservations',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (reservations.data!['reservations']!.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'You have no previous reservations...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: reservations.data!['reservations']!.length,
                        itemBuilder: (context, index) => PlayerReservationCard(
                          reservation:
                              reservations.data!['reservations']![index],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(thickness: 1),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Here are some Public Matches that you can join',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (reservations.data!['public matches']!.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Currently, there are no \nupcoming public matches...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  Column(
                    children: List.generate(
                      reservations.data!['public matches']!.length,
                      (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MatchCard(
                          reservation:
                              reservations.data!['public matches']![index],
                          publicMatch: true,
                          player: widget.player,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        }
        if (reservations.hasError) {
          return Center(child: Text(reservations.error.toString()));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
