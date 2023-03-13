import 'location.dart';

class Player {
  const Player({
    // TODO: remove non required elements from constructor
    required this.uuid,
    required this.playerID,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.location,
    required this.picture,
    required this.dateOfBirth,
    required this.height,
    required this.weight,
    required this.sex,
    required this.averageMoralityRating,
    required this.averageSkillRating,
    required this.numberOfReviews,
    required this.position,
    required this.bio,
  });

  final String uuid;
  final String playerID;
  final String name;
  final String email;
  final String phoneNumber;
  final Location location;
  final String picture;
  final String dateOfBirth;
  final num height, weight;
  final Sex sex;
  final num averageMoralityRating;
  final num averageSkillRating;
  final int numberOfReviews;
  final Position position;
  final String bio;

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      uuid: json['_id'],
      playerID: json['playerID'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      location: Location.fromJson(json['location']),
      picture: json['picture'],
      dateOfBirth: json['dateOfBirth'],
      height: json['height'],
      weight: json['weight'],
      sex: Sex.values.firstWhere((e) => e.value == json['sex']),
      position: Position.values.firstWhere((e) => e.value == json['position']),
      averageMoralityRating: json['averageMoralityRating'],
      averageSkillRating: json['averageSkillRating'],
      numberOfReviews: json['numberOfReviews'],
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJsonMapToCreatePlayer() {
    return {
      'playerID': playerID,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'location': location,
      'picture': picture,
      'dateOfBirth': dateOfBirth,
      'height': height,
      'weight': weight,
      'sex': sex,
      'position': position,
      'bio': bio,
    };
  }

  @override
  String toString() {
    return '''uuid = $uuid; playerID = $playerID; name = $name;
email = $email; phoneNumber = $phoneNumber;
location: $location;
dateOfBirth = $dateOfBirth; picture = $picture; height = $height; weight = $weight;
sex = $sex; averageMoralityRating = $averageMoralityRating; averageSkillRating = $averageSkillRating;
numberOfReviews = $numberOfReviews; position = $position;''';
  }
}

enum Sex {
  male('M'),
  female('F');

  final String value;
  const Sex(this.value);
}

enum Position {
  goalKeeper('goal keeper'),
  defender('defender'),
  midfielder('midfielder'),
  attacker('attacker');

  final String value;
  const Position(this.value);
}
