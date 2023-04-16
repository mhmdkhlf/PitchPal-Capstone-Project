class Field {
  Field({
    required this.uuid,
    required this.fieldNumber,
    required this.fieldWidth,
    required this.fieldLength,
    required this.reservationPrice,
    required this.sportCenterName,
    required this.grassType,
    required this.recommendedTeamSize,
  });

  String? uuid;
  final String sportCenterName;
  final int fieldNumber;
  final int fieldLength;
  final int fieldWidth;
  final int reservationPrice;
  final Grass grassType;
  final int recommendedTeamSize;

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      uuid: json['_id'],
      sportCenterName: json['sportCenterName'],
      fieldNumber: json['fieldNumber'],
      fieldLength: json['fieldLength'],
      fieldWidth: json['fieldWidth'],
      reservationPrice: json['reservationPrice'],
      grassType: Grass.values.firstWhere((e) => e.value == json['grassType']),
      recommendedTeamSize: json['recommendedTeamSize'],
    );
  }

  Field.createProfile({
    required this.sportCenterName,
    required this.fieldNumber,
    required this.fieldLength,
    required this.fieldWidth,
    required this.reservationPrice,
    required this.grassType,
    required this.recommendedTeamSize,
  });

  Map<String, dynamic> toJsonMap() {
    return {
      'sportCenterName': sportCenterName,
      'fieldNumber': fieldNumber,
      'fieldWidth': fieldWidth,
      'fieldLength': fieldLength,
      'reservationPrice': reservationPrice,
      'grassType': grassType.value,
      'recommendedTeamSize': recommendedTeamSize
    };
  }

  @override
  String toString() {
    return '''uuid = $uuid; sportCenterName = $sportCenterName;  sportCenterName = $sportCenterName;
fieldNumber = $fieldNumber; fieldLength = $fieldWidth; fieldWidth
reservationPrice = $reservationPrice; grassType: $grassType;
recommendedTeamSize; $recommendedTeamSize''';
  }
}

enum Grass {
  turf('turf'),
  grass('grass');

  final String value;
  const Grass(this.value);
}
