import 'location.dart';

class Player {
  const Player({
    required this.uuid,
    required this.playerID,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.location,
    required this.picture,
    required this.age,
    required this.height,
    required this.weight,
    required this.sex,
    required this.averageMoralityRating,
    required this.averageSkillRating,
    required this.numberOfReviews,
    required this.position,
  });

  final String uuid;
  final String playerID;
  final String name;
  final String email;
  final String phoneNumber;
  final Location location;
  final String picture;
  final int age;
  final num height, weight;
  final Sex sex;
  final num averageMoralityRating;
  final num averageSkillRating;
  final int numberOfReviews;
  final Position position;

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      uuid: json['_id'],
      playerID: json['playerID'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      location: Location.fromJson(json['location']),
      picture: json['picture'],
      age: json['age'],
      height: json['height'],
      weight: json['weight'],
      sex: Sex.values.firstWhere((e) => e.value == json['sex']),
      averageMoralityRating: json['averageMoralityRating'],
      averageSkillRating: json['averageSkillRating'],
      numberOfReviews: json['numberOfReviews'],
      position: Position.values.firstWhere((e) => e.value == json['position']),
    );
  }

  @override
  String toString() {
    return '''uuid = $uuid; playerID = $playerID; name = $name;
email = $email; phoneNumber = $phoneNumber;
location: $location;
age = $age; picture = $picture; height = $height; weight = $weight;
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
