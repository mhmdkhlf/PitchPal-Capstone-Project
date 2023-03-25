class Location {
  String? uuid;
  final int longitude;
  final int latitude;
  final String place;

  Location({
    required this.uuid,
    required this.latitude,
    required this.longitude,
    required this.place,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      uuid: json['_id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      place: json['place'],
    );
  }

  Location.fromInput({
    required this.latitude,
    required this.longitude,
    required this.place,
  });

  Map<String, dynamic> toJsonMap() {
    return {
      'longitude': longitude,
      'latitude': latitude,
      'place': place,
    };
  }

  @override
  String toString() {
    return '''uuid = $uuid; latitude = $latitude; longitude = $longitude;
place = $place;''';
  }
}
