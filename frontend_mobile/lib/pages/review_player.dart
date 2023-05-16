import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dio/dio.dart';
import '../data/player.dart';
import '../data/player_review.dart';
import '../data/star_rating.dart';
import '../components/textfield_input.dart';
import '../components/response_dialog_box.dart';
import '../components/submit_button.dart';
import '../constants.dart';

class ReviewPlayer extends StatelessWidget {
  const ReviewPlayer({
    super.key,
    required this.player,
    required this.reviewerId,
  });

  final Player player;
  final String reviewerId;

  Future<PlayerReview> getReview() async {
    final Dio dio = Dio();
    try {
      final Response response = await dio.post(
        '$apiRoute/getReviewByPlayerIdandReviewerId',
        data: {
          'playerID': player.playerID,
          'reviewerID': reviewerId,
        },
      );
      if (response.data == null) {
        return PlayerReview(
          uuid: null,
          playerID: '',
          reviewerID: '',
          commentText: '',
          moralityScore: StarRating.fromInput(value: 0),
          skillScore: StarRating.fromInput(value: 0),
          submissionDate: '',
        );
      }
      return PlayerReview.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception(e.stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Review ${player.name}',
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: FutureBuilder(
            future: getReview(),
            builder: (context, review) {
              final TextEditingController reviewTextInput;
              final StarRating moralityInput;
              final StarRating skillInput;
              if (review.hasData) {
                PlayerReview oldReview = review.data!;
                if (oldReview.uuid != null) {
                  // there is an older review
                  reviewTextInput =
                      TextEditingController(text: oldReview.commentText);
                  moralityInput = StarRating.fromInput(
                    value: oldReview.moralityScore.value,
                  );
                  skillInput = StarRating.fromInput(
                    value: oldReview.skillScore.value,
                  );
                } else {
                  // everything new
                  reviewTextInput = TextEditingController();
                  moralityInput = StarRating.fromInput(value: 1);
                  skillInput = StarRating.fromInput(value: 1);
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFieldInput(
                      controller: reviewTextInput,
                      hintText: 'Review Text',
                      isMultiLine: true,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Morality: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        RatingBar.builder(
                          initialRating: skillInput.value.toDouble(),
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) => skillInput.value = rating,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Skill Level: ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        RatingBar.builder(
                          initialRating: moralityInput.value.toDouble(),
                          allowHalfRating: true,
                          direction: Axis.horizontal,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) =>
                              moralityInput.value = rating,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SubmitButton(
                      text: 'Submit Review',
                      onTap: () async {
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );
                        }
                        final Dio dio = Dio();
                        PlayerReview reviewToUpload = PlayerReview.createReview(
                          playerID: player.playerID!,
                          reviewerID: reviewerId,
                          commentText: reviewTextInput.text,
                          skillScore: skillInput,
                          moralityScore: moralityInput,
                        );
                        try {
                          if (oldReview.uuid == null) {
                            // new Review
                            try {
                              final Response newReviewResponse = await dio.post(
                                '$apiRoute/newPlayerReview',
                                data: reviewToUpload.toJsonMap(),
                              );
                              if (newReviewResponse.statusCode != 200) {
                                throw Exception("Invalid status code");
                              }
                              final Response updateResponse = await dio.patch(
                                '$apiRoute/updatePlayerAverageRatingInCaseOfNewReview',
                                data: {
                                  'playerID': reviewToUpload.playerID,
                                  'newSkillReviewValue':
                                      reviewToUpload.skillScore.value,
                                  'newMoralReviewValue':
                                      reviewToUpload.moralityScore.value,
                                },
                              );
                              if (updateResponse.statusCode != 200) {
                                throw Exception("Invalid status code");
                              }
                            } on DioError catch (e) {
                              throw Exception(e.stackTrace);
                            }
                          } else {
                            // there already exists a review from this player to same player
                            try {
                              final Response updateReviewResponse =
                                  await dio.patch(
                                "$apiRoute/updateReview/${oldReview.uuid}",
                                data: {
                                  'moralityScore':
                                      reviewToUpload.moralityScore.toJsonMap(),
                                  'skillScore':
                                      reviewToUpload.skillScore.toJsonMap(),
                                  'commentText': reviewToUpload.commentText,
                                  'submissionDate': DateTime.now().toString(),
                                },
                              );
                              if (updateReviewResponse.statusCode != 200) {
                                throw Exception("Invalid status code");
                              }
                              final Response updateAverageResponse =
                                  await dio.patch(
                                '$apiRoute/updatePlayerAverageRatingInCaseOfNewEdit',
                                data: {
                                  'playerID': reviewToUpload.playerID,
                                  'oldSkillReviewValue':
                                      oldReview.skillScore.value,
                                  'oldMoralReviewValue':
                                      oldReview.moralityScore.value,
                                  'newSkillReviewValue':
                                      reviewToUpload.skillScore.value,
                                  'newMoralReviewValue':
                                      reviewToUpload.moralityScore.value,
                                },
                              );
                              if (updateAverageResponse.statusCode != 200) {
                                throw Exception("Invalid status code");
                              }
                            } on DioError catch (e) {
                              throw Exception(e.stackTrace);
                            }
                          }
                        } on DioError catch (e) {
                          throw Exception(e.stackTrace);
                        }
                        if (context.mounted) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => (const ResponseDialogBox(
                                text: 'You Successfully submitted a Review',
                              )),
                            ),
                          );
                        }
                      },
                      fontSize: 18,
                    ),
                    const SizedBox(height: 50),
                  ],
                );
              } else if (review.hasError) {
                return Center(child: Text(review.error.toString()));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
