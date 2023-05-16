import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'view_team_reviews.dart';
import 'review_team.dart';
import '../components/rating_display.dart';
import '../data/player.dart';
import '../data/team.dart';
import '../data/team_review.dart';
import '../constants.dart';

class ViewTeamProfile extends StatefulWidget {
  const ViewTeamProfile({
    super.key,
    required this.team,
    required this.userId,
  });

  final Team team;
  final String userId;

  @override
  State<ViewTeamProfile> createState() => _ViewTeamProfileState();
}

class _ViewTeamProfileState extends State<ViewTeamProfile> {
  String reviewsButtonsText = 'Display Reviews';
  bool reviewsDisplayed = false;
  List<TeamReview>? teamReviews;

  void toggleButton() async {
    teamReviews ??= await getReviews();
    setState(() {
      if (reviewsDisplayed) {
        reviewsDisplayed = false;
        reviewsButtonsText = 'Display Reviews';
      } else {
        reviewsDisplayed = true;
        reviewsButtonsText = 'Hide Reviews';
      }
    });
  }

  Future<List<TeamReview>> getReviews() async {
    Dio dio = Dio();
    final response = await dio.get(
      '$apiRoute/getATeamReviews/${widget.team.name}',
    );
    List<dynamic> reviewsData = response.data;
    List<TeamReview> reviews =
        reviewsData.map((e) => TeamReview.fromJson(e)).toList();
    return reviews;
  }

  Future<Map<String, Player>> getPlayers() async {
    Map<String, Player> idToPlayer = {};
    final Dio dio = Dio();
    final response =
        await dio.get('$apiRoute/getPlayer/${widget.team.captainId}');
    idToPlayer[widget.team.captainId] = Player.fromJson(response.data);
    for (String playerId in widget.team.playerIds) {
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
                        widget.team.name,
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
                              text: players.data![widget.team.captainId]!.name,
                            ),
                            TextSpan(
                              text: ' (#${widget.team.captainId})',
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
                        'Squad has ${widget.team.playerIds.length} players:',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.team.playerIds.length,
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
                                          .data![widget.team.playerIds[index]]!
                                          .name,
                                    ),
                                    TextSpan(
                                      text:
                                          ' (#${widget.team.playerIds[index]})',
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
                              text: '(${widget.team.numberOfRatings} reviews)',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RatingDisplay(
                        attribute: 'Skill Level',
                        rating: widget.team.averageSkillRating ?? 0,
                      ),
                      const SizedBox(height: 2),
                      RatingDisplay(
                        attribute: 'Morality',
                        rating: widget.team.averageMoralRating ?? 0,
                      ),
                      const SizedBox(height: 15),
                      const Divider(color: kDarkColor),
                      ElevatedButton(
                        onPressed: toggleButton,
                        child: Text(
                          reviewsButtonsText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      if (reviewsDisplayed)
                        ViewTeamReviews(
                          team: widget.team,
                          reviews: teamReviews!,
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              child: const Center(
                child: Text(
                  'Add review',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewTeam(
                      team: widget.team,
                      reviewerId: widget.userId,
                    ),
                  ),
                );
              },
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
