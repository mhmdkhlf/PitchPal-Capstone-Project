import 'package:flutter/material.dart';
import '../components/rating_display.dart';
import '../data/sport_center.dart';
import '../data/sport_center_review.dart';

class ViewSportCenterReviews extends StatelessWidget {
  const ViewSportCenterReviews({
    super.key,
    required this.sportCenter,
    required this.reviews,
  });

  final SportCenter sportCenter;
  final List<SportCenterReview> reviews;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: List.generate(
            reviews.length,
            (index) => Column(
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Review submitted by ',
                                ),
                                TextSpan(
                                  text: reviews[index].reviewerID,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' on ',
                                ),
                                TextSpan(
                                  text: reviews[index]
                                      .submissionDate!
                                      .substring(0, 10),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Divider(),
                        RatingDisplay(
                          attribute: 'Facility Quality',
                          rating: reviews[index].facilityQualityScore.value,
                        ),
                        RatingDisplay(
                          attribute: 'Staff service',
                          rating: reviews[index].staffServiceScore.value,
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Review text: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                TextSpan(
                                  text: reviews[index].reviewText,
                                ),
                              ],
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
