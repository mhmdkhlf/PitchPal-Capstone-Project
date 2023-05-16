import 'star_rating.dart';

class TeamReview {
  String? uuid;
  final String teamName;
  final String reviewerID;
  final String reviewText;
  final StarRating moralityScore;
  final StarRating skillLevel;
  String? submissionDate;

  TeamReview({
    required this.uuid,
    required this.teamName,
    required this.reviewerID,
    required this.reviewText,
    required this.moralityScore,
    required this.skillLevel,
    required this.submissionDate,
  });

  factory TeamReview.fromJson(Map<String, dynamic> json) {
    return TeamReview(
      uuid: json['_id'],
      teamName: json['teamName'],
      reviewerID: json['reviewerID'],
      reviewText: json['reviewText'],
      moralityScore: StarRating.fromJson(json['moralityScore']),
      skillLevel: StarRating.fromJson(json['skillLevel']),
      submissionDate: json['submissionDate'],
    );
  }

  TeamReview.createReview({
    required this.teamName,
    required this.reviewerID,
    required this.reviewText,
    required this.moralityScore,
    required this.skillLevel,
  });

  Map<String, dynamic> toJsonMap() {
    return {
      'teamName': teamName,
      'reviewerID': reviewerID,
      'reviewText': reviewText,
      'skillLevel': skillLevel.toJsonMap(),
      'moralityScore': moralityScore.toJsonMap()
    };
  }

  @override
  String toString() {
    return toJsonMap().toString();
  }
}
