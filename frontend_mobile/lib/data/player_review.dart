import 'star_rating.dart';

class PlayerReview {
  String? uuid;
  final String playerID;
  final String reviewerID;
  final String commentText;
  final StarRating moralityScore;
  final StarRating skillScore;
  String? submissionDate;

  PlayerReview({
    required this.uuid,
    required this.playerID,
    required this.reviewerID,
    required this.commentText,
    required this.moralityScore,
    required this.skillScore,
    required this.submissionDate,
  });

  factory PlayerReview.fromJson(Map<String, dynamic> json) {
    return PlayerReview(
      uuid: json['_id'],
      playerID: json['playerID'],
      reviewerID: json['reviewerID'],
      commentText: json['commentText'],
      moralityScore: StarRating.fromJson(json['moralityScore']),
      skillScore: StarRating.fromJson(json['skillScore']),
      submissionDate: json['submissionDate'],
    );
  }

  PlayerReview.createReview({
    required this.playerID,
    required this.reviewerID,
    required this.commentText,
    required this.moralityScore,
    required this.skillScore,
  });

  Map<String, dynamic> toJsonMap() {
    return {
      'playerID': playerID,
      'reviewerID': reviewerID,
      'commentText': commentText,
      'skillScore': skillScore.toJsonMap(),
      'moralityScore': moralityScore.toJsonMap()
    };
  }

  @override
  String toString() {
    return toJsonMap().toString();
  }
}
