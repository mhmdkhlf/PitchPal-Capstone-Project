import 'dart:typed_data';

class FieldManager {
  String? uuid;
  Uint8List? imageByteArray;
  final String name;
  final String email;
  final String mobileNumber;
  final String sportCenterName;

  FieldManager({
    required this.uuid,
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.sportCenterName,
  });

  factory FieldManager.fromJson(Map<String, dynamic> json) {
    return FieldManager(
      uuid: json['_id'],
      name: json['name'],
      email: json['email'],
      mobileNumber: json['mobileNumber'],
      sportCenterName: json['sportCenterName'],
    );
  }

  FieldManager.createProfile({
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.sportCenterName,
  });

  Map<String, dynamic> toJsonMap() {
    return {
      'name': name,
      'email': email,
      'mobileNumber': mobileNumber,
      'sportCenterName': sportCenterName,
    };
  }

  @override
  String toString() {
    return '''uuid = $uuid; name = $name;  sportCenterName = $sportCenterName;
email = $email; mobileNumber = $mobileNumber;''';
  }
}
