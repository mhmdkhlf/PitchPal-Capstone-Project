import 'package:flutter/material.dart';
import '../components/rating_display.dart';
import '../data/team.dart';
import '../data/team_review.dart';

class ViewTeamReviews extends StatelessWidget {
  const ViewTeamReviews({
    super.key,
    required this.team,
    required this.reviews,
  });

  final Team team;
  final List<TeamReview> reviews;

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          'No reviews to display...',
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
      );
    }
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: List.generate(
            reviews.length,
            (index) => Column(
              children: [
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 3),
                          Text.rich(
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
                          const Divider(),
                          RatingDisplay(
                            attribute: 'Skill Level',
                            rating: reviews[index].skillLevel.value,
                          ),
                          RatingDisplay(
                            attribute: 'Morality',
                            rating: reviews[index].moralityScore.value,
                          ),
                          const Divider(),
                          Text.rich(
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
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
