import 'star_rating.dart';

class SportCenterReview {
  String? uuid;
  final String sportCenterName;
  final String reviewerID;
  final String reviewText;
  final StarRating staffServiceScore;
  final StarRating facilityQualityScore;
  String? submissionDate;

  SportCenterReview({
    required this.uuid,
    required this.sportCenterName,
    required this.reviewerID,
    required this.reviewText,
    required this.staffServiceScore,
    required this.facilityQualityScore,
    required this.submissionDate,
  });

  factory SportCenterReview.fromJson(Map<String, dynamic> json) {
    return SportCenterReview(
      uuid: json['_id'],
      sportCenterName: json['sportCenterName'],
      reviewerID: json['reviewerID'],
      reviewText: json['reviewText'],
      staffServiceScore: StarRating.fromJson(json['staffServiceScore']),
      facilityQualityScore: StarRating.fromJson(json['facilityQualityScore']),
      submissionDate: json['submissionDate'],
    );
  }

  SportCenterReview.createReview({
    required this.sportCenterName,
    required this.reviewerID,
    required this.reviewText,
    required this.staffServiceScore,
    required this.facilityQualityScore,
  });

  Map<String, dynamic> toJsonMap() {
    return {
      'sportCenterName': sportCenterName,
      'reviewerID': reviewerID,
      'reviewText': reviewText,
      'facilityQualityScore': facilityQualityScore.toJsonMap(),
      'staffServiceScore': staffServiceScore.toJsonMap()
    };
  }

  @override
  String toString() {
    return toJsonMap().toString();
  }
}
