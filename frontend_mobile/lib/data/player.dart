import 'location.dart';
import 'dart:typed_data';

class Player {
  String? uuid;
  String? playerID;
  Uint8List? imageByteArray;
  final String name;
  final String email;
  final String phoneNumber;
  final Location location;
  final String dateOfBirth;
  final Sex sex;
  final Position position;
  num? height;
  num? weight;
  String? description;
  num? averageMoralityRating;
  num? averageSkillRating;
  int? numberOfReviews;

  Player({
    required this.uuid,
    required this.playerID,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.location,
    required this.dateOfBirth,
    required this.height,
    required this.weight,
    required this.sex,
    required this.averageMoralityRating,
    required this.averageSkillRating,
    required this.numberOfReviews,
    required this.position,
    required this.description,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      uuid: json['_id'],
      playerID: json['playerID'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      location: Location.fromJson(json['location']),
      dateOfBirth: json['dateOfBirth'],
      height: json['height'],
      weight: json['weight'],
      sex: Sex.values.firstWhere((e) => e.value == json['sex']),
      position: Position.values.firstWhere((e) => e.value == json['position']),
      averageMoralityRating: json['averageMoralityRating'],
      averageSkillRating: json['averageSkillRating'],
      numberOfReviews: json['numberOfReviews'],
      description: json['description'],
    );
  }

  Player.createProfile({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.location,
    required this.dateOfBirth,
    required this.position,
    required this.sex,
    this.height,
    this.weight,
    this.description,
  });

  Map<String, dynamic> toJsonMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'location': location.toJsonMap(),
      'dateOfBirth': dateOfBirth,
      'position': position.value,
      'sex': sex.value,
      'height': height ?? 0,
      'weight': weight ?? 0,
      'description': description ?? '',
    };
  }

  @override
  String toString() {
    return '''uuid = $uuid; playerID = $playerID; name = $name;
email = $email; phoneNumber = $phoneNumber;
location: $location;
dateOfBirth = $dateOfBirth; height = $height; weight = $weight; sex = $sex;
averageMoralityRating = $averageMoralityRating; averageSkillRating = $averageSkillRating;
numberOfReviews = $numberOfReviews; position = $position; description: $description''';
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
