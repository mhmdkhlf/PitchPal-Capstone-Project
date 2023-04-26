class Team {
  String? uuid;
  final String name;
  final String captainId;
  List<String> playerIds = [];
  num? averageMoralRating;
  num? averageSkillRating;
  int? numberOfRatings;

  Team({
    required this.uuid,
    required this.name,
    required this.captainId,
    required this.playerIds,
    required this.averageMoralRating,
    required this.averageSkillRating,
    required this.numberOfRatings,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      uuid: json['_id'],
      name: json['name'],
      captainId: json['captainId'],
      playerIds: (json['playerIds'] as List<dynamic>)
          .map((id) => id as String)
          .toList(),
      averageSkillRating: json['averageSkillRating'],
      averageMoralRating: json['averageMoralRating'],
      numberOfRatings: json['numberOfRatings'],
    );
  }

  Team.createProfile({
    required this.name,
    required this.captainId,
    required this.playerIds,
  });

  Map<String, dynamic> toJsonMap() {
    return {
      'name': name,
      'captainId': captainId,
      'playerIds': playerIds,
    };
  }

  @override
  String toString() {
    return '''uuid = $uuid; name = $name; captainId = $captainId;
playerIds = $playerIds;
numberOfRating: $numberOfRatings; averageMoralRating: $averageMoralRating; averageSkillRating: $averageSkillRating''';
  }
}
