class Location {
  const Location(
      {required this.uuid, required this.latitude, required this.longitude});

  final String uuid;
  final int longitude;
  final int latitude;

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        uuid: json['_id'],
        latitude: json['latitude'],
        longitude: json['longitude']);
  }

  @override
  String toString() {
    return 'uuid = $uuid; latitude = $latitude; longitude = $longitude';
  }
}
