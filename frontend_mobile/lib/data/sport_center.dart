import 'location.dart';
import 'time_slot.dart';

class SportCenter {
  String? uuid;
  final String name;
  final String locationLink;
  final Location location;
  final String phoneNumber;
  final int nbOfFields;
  final TimeSlot workingHours;
  String? linkToFB;
  String? linkToInsta;
  List<Facility>? facilitiesAvailable;
  num? facilityQualityAverageRating;
  num? staffServiceAverageRating;
  int? nbOfRatings;

  SportCenter({
    required this.uuid,
    required this.name,
    required this.location,
    required this.locationLink,
    required this.phoneNumber,
    required this.nbOfFields,
    required this.workingHours,
    required this.linkToFB,
    required this.linkToInsta,
    required this.facilitiesAvailable,
    required this.staffServiceAverageRating,
    required this.facilityQualityAverageRating,
    required this.nbOfRatings,
  });

  factory SportCenter.fromJson(Map<String, dynamic> json) {
    return SportCenter(
      uuid: json['uuid'],
      name: json['name'],
      location: Location.fromJson(json['location']),
      locationLink: json['locationLink'],
      phoneNumber: json['phoneNumber'],
      nbOfFields: json['nbOfFields'],
      workingHours: json['workingHours'],
      linkToFB: json['linkToFB'],
      linkToInsta: json['linkToInsta'],
      facilitiesAvailable: json['facilitiesAvailable'],
      staffServiceAverageRating: json['staffServiceAverageRating'],
      facilityQualityAverageRating: json['facilityQualityAverageRating'],
      nbOfRatings: json['nbOfRatings'],
    );
  }

  SportCenter.createProfile({
    required this.name,
    required this.location,
    required this.locationLink,
    required this.phoneNumber,
    required this.nbOfFields,
    required this.workingHours,
    this.linkToFB,
    this.linkToInsta,
    this.facilitiesAvailable,
  });

  Map<String, dynamic> toJsonMap() {
    return {
      'name': name,
      'location': location.toJsonMap(),
      'locationLink': locationLink,
      'phoneNumber': phoneNumber,
      'nbOfFields': nbOfFields,
      'workingHours': workingHours.toJsonMap(),
      'linkToFB': linkToFB ?? '',
      'linkToInsta': linkToInsta ?? '',
      'facilitiesAvailable': facilitiesAvailable == null
          ? []
          : facilitiesAvailable!
              .map((facility) => facility.toJsonMap())
              .toList(),
      'facilityQualityAverageRating': facilityQualityAverageRating ?? 0.0,
      'staffServiceAverageRating': staffServiceAverageRating ?? 0.0,
      'nbOfRatings': nbOfRatings ?? 0,
    };
  }

  @override
  String toString() {
    return '''uuid = $uuid; name = $name; location: $location;
locationLink: $locationLink
    ''';
  }
}

class Facility {
  final String name;
  final String description;

  const Facility({
    required this.name,
    required this.description,
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJsonMap() {
    return {
      'name': name,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'name: $name; description: $description';
  }
}
