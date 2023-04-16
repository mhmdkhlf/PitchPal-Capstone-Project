class TimeSlot {
  String? uuid;
  final String startTime;
  final String endTime;

  TimeSlot({
    required this.uuid,
    required this.startTime,
    required this.endTime,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      uuid: json['_id'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }

  TimeSlot.fromInput({
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJsonMap() {
    return {
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  @override
  String toString() {
    return '$startTime - $endTime';
  }
}
