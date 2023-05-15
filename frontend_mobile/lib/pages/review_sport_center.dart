import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dio/dio.dart';
import '../data/sport_center_review.dart';
import '../data/star_rating.dart';
import '../components/textfield_input.dart';
import '../components/response_dialog_box.dart';
import '../components/submit_button.dart';
import '../constants.dart';

class ReviewSportCenter extends StatelessWidget {
  const ReviewSportCenter({
    super.key,
    required this.playerId,
    required this.sportCenterName,
  });

  final String playerId;
  final String sportCenterName;

  Future<SportCenterReview> getReview() async {
    final Dio dio = Dio();
    try {
      final Response response = await dio.post(
        '$apiRoute/getReviewBySportCenterNameAndReviewerId',
        data: {
          'sportCenterName': sportCenterName,
          'reviewerID': playerId,
        },
      );
      if (response.data == null) {
        return SportCenterReview(
          uuid: null, // null uuid to indicate null return from response
          facilityQualityScore: StarRating.fromInput(value: 1),
          staffServiceScore: StarRating.fromInput(value: 1),
          reviewText: '',
          reviewerID: '',
          sportCenterName: '',
          submissionDate: '',
        );
      }
      return SportCenterReview.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception(e.stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Review $sportCenterName',
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: FutureBuilder(
            future: getReview(),
            builder: (context, review) {
              final TextEditingController reviewTextInput;
              final StarRating facilityQualityInput;
              final StarRating staffServiceInput;
              if (review.hasData) {
                SportCenterReview oldReview = review.data!;
                if (oldReview.uuid != null) {
                  // there is an older review
                  reviewTextInput =
                      TextEditingController(text: oldReview.reviewText);
                  facilityQualityInput = StarRating.fromInput(
                    value: oldReview.facilityQualityScore.value,
                  );
                  staffServiceInput = StarRating.fromInput(
                    value: oldReview.staffServiceScore.value,
                  );
                } else {
                  // everything new
                  reviewTextInput = TextEditingController();
                  facilityQualityInput = StarRating.fromInput(value: 1);
                  staffServiceInput = StarRating.fromInput(value: 1);
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
                          'Staff Service: ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        RatingBar.builder(
                          initialRating: staffServiceInput.value.toDouble(),
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) =>
                              staffServiceInput.value = rating,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Facility Quality: ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        RatingBar.builder(
                          initialRating: facilityQualityInput.value.toDouble(),
                          allowHalfRating: true,
                          direction: Axis.horizontal,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) =>
                              facilityQualityInput.value = rating,
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
                        SportCenterReview reviewToUpload =
                            SportCenterReview.createReview(
                          sportCenterName: sportCenterName,
                          reviewerID: playerId,
                          reviewText: reviewTextInput.text,
                          staffServiceScore: staffServiceInput,
                          facilityQualityScore: facilityQualityInput,
                        );
                        try {
                          if (oldReview.uuid == null) {
                            // new Review
                            try {
                              final Response newReviewResponse = await dio.post(
                                '$apiRoute/newSportCenterReview',
                                data: reviewToUpload.toJsonMap(),
                              );
                              if (newReviewResponse.statusCode != 200) {
                                throw Exception("Invalid status code");
                              }
                              final Response updateResponse = await dio.patch(
                                '$apiRoute/updateSportCenterAverageRatingInCaseOfNewReview',
                                data: {
                                  'sportCenterName':
                                      reviewToUpload.sportCenterName,
                                  'newQualityReviewValue':
                                      reviewToUpload.facilityQualityScore.value,
                                  'newStaffReviewValue':
                                      reviewToUpload.staffServiceScore.value,
                                },
                              );
                              if (updateResponse.statusCode != 200) {
                                throw Exception("Invalid status code");
                              }
                            } on DioError catch (e) {
                              throw Exception(e.stackTrace);
                            }
                          } else {
                            // there already exists a review from this player to same Sportcenter
                            try {
                              final Response updateReviewResponse =
                                  await dio.patch(
                                "$apiRoute/updateSportCenterReview/${oldReview.uuid}",
                                data: {
                                  'staffServiceScore': reviewToUpload
                                      .staffServiceScore
                                      .toJsonMap(),
                                  'facilityQualityScore': reviewToUpload
                                      .facilityQualityScore
                                      .toJsonMap(),
                                  'reviewText': reviewToUpload.reviewText,
                                  'submissionDate': DateTime.now().toString(),
                                },
                              );
                              if (updateReviewResponse.statusCode != 200) {
                                throw Exception("Invalid status code");
                              }
                              final Response updateAverageResponse =
                                  await dio.patch(
                                '$apiRoute/updateSportCenterAverageRatingInCaseOfNewEdit',
                                data: {
                                  'sportCenterName':
                                      reviewToUpload.sportCenterName,
                                  'oldQualityReviewValue':
                                      oldReview.facilityQualityScore.value,
                                  'oldStaffReviewValue':
                                      oldReview.staffServiceScore.value,
                                  'newQualityReviewValue':
                                      reviewToUpload.facilityQualityScore.value,
                                  'newStaffReviewValue':
                                      reviewToUpload.staffServiceScore.value,
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
