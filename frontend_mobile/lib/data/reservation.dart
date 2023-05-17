import 'time_slot.dart';

class Reservation {
  String? uuid;
  final String reserverEmail;
  final ReserverType reserverType;
  final String sportCenterName;
  final int fieldNumber;
  final bool isPublic;
  ReservationStatus reservationStatus;
  final String reservationDate;
  final TimeSlot reservationTime;
  final List<String>? teamOneIds;
  final List<String>? teamTwoIds;
  final String? comment;

  Reservation({
    required this.uuid,
    required this.reserverEmail,
    required this.reserverType,
    required this.sportCenterName,
    required this.isPublic,
    required this.fieldNumber,
    required this.reservationDate,
    required this.reservationTime,
    required this.reservationStatus,
    required this.teamOneIds,
    required this.teamTwoIds,
    required this.comment,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      uuid: json['_id'],
      reserverEmail: json['reserverEmail'],
      reserverType: ReserverType.values.firstWhere(
        (e) => e.value == json['reserverType'],
      ),
      sportCenterName: json['sportCenterName'],
      isPublic: json['isPublic'],
      fieldNumber: json['fieldNumber'],
      reservationDate: json['reservationDate'],
      reservationTime: TimeSlot.fromJson(json['reservationTime']),
      reservationStatus: ReservationStatus.values.firstWhere(
        (e) => e.value == json['reservationStatus'],
      ),
      teamOneIds: (json['teamOneIds'] as List<dynamic>)
          .map((id) => id as String)
          .toList(),
      teamTwoIds: (json['teamTwoIds'] as List<dynamic>)
          .map((id) => id as String)
          .toList(),
      comment: json['comment'],
    );
  }

  Reservation.makeReservation({
    required this.reserverEmail,
    required this.reserverType,
    required this.sportCenterName,
    required this.isPublic,
    required this.fieldNumber,
    required this.reservationDate,
    required this.reservationTime,
    required this.reservationStatus,
    required this.teamOneIds,
    required this.teamTwoIds,
    required this.comment,
  });

  Map<String, dynamic> toJsonMap() {
    return {
      'reserverEmail': reserverEmail,
      'reserverType': reserverType.value,
      'sportCenterName': sportCenterName,
      'isPublic': isPublic,
      'fieldNumber': fieldNumber,
      'reservationDate': reservationDate,
      'reservationTime': reservationTime.toJsonMap(),
      'reservationStatus': reservationStatus.value,
      'teamOneIds': teamOneIds,
      'teamTwoIds': teamTwoIds,
      'comment': comment,
    };
  }

  @override
  String toString() {
    return toJsonMap().toString();
  }
}

enum ReserverType {
  player('Player'),
  fieldManager('FieldManager');

  final String value;
  const ReserverType(this.value);
}

enum ReservationStatus {
  pending('pending'),
  accepted('accepted'),
  rejected('rejected');

  final String value;
  const ReservationStatus(this.value);
}
