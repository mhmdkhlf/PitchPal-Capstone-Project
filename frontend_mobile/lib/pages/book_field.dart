import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:frontend_mobile/constants.dart';
import 'package:intl/intl.dart';
import '../components/date_navigator.dart';
import '../components/field_info.dart';
import '../data/reservation.dart';
import '../data/time_slot.dart';
import '../data/sport_center.dart';

class BookField extends StatefulWidget {
  const BookField({
    super.key,
    required this.sportCenter,
    required this.reservations,
    required this.playerEmail,
  });

  final String playerEmail;
  final SportCenter sportCenter;
  final List<Reservation> reservations;

  @override
  State<BookField> createState() => _BookFieldState();
}

class _BookFieldState extends State<BookField> {
  bool isPublicInput = false;
  final SelectedField selectedField = SelectedField(1);
  final TextEditingController dateInput = TextEditingController();
  DateTime selectedDate = DateTime.now();

  void _handleDateChanged(DateTime newDate) =>
      setState(() => selectedDate = newDate);

  List<String> getTimeSlots(
    String openingTime,
    String closingTime,
    int timeSlotDurationInMinutes,
  ) {
    List<String> timeSlots = [];
    DateTime start = DateTime.parse('2022-01-01 $openingTime:00');
    DateTime end = DateTime.parse('2022-01-01 $closingTime:00');
    while (start.isBefore(end) || start.isAtSameMomentAs(end)) {
      String time =
          '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
      timeSlots.add(time);
      start = start.add(Duration(minutes: timeSlotDurationInMinutes));
    }
    return timeSlots;
  }

  Reservation? getReservation({
    required int fieldNb,
    required String reservationDate,
    required String reservationStartTime,
    required String reservationEndTime,
  }) {
    Reservation reservation = widget.reservations.firstWhere(
      (reservation) =>
          reservation.fieldNumber == fieldNb &&
          reservation.reservationDate.substring(0, 10) ==
              reservationDate.substring(0, 10) &&
          reservation.reservationTime.startTime == reservationStartTime &&
          reservation.reservationTime.endTime == reservationEndTime,
      orElse: (() => Reservation(
            uuid: null,
            reserverEmail: '',
            reserverType: ReserverType.fieldManager,
            sportCenterName: '',
            isPublic: false,
            fieldNumber: 0,
            reservationDate: '',
            reservationTime: TimeSlot.fromInput(startTime: '', endTime: ''),
            reservationStatus: ReservationStatus.pending,
            teamOneIds: [],
            teamTwoIds: [],
            comment: '',
          )),
    );
    if (reservation.uuid == null) {
      // indication of no reservation found
      return null;
    }
    return reservation;
  }

  void _updateSelectedField(int newFieldNb) {
    setState(() {
      selectedField.fieldNumber = newFieldNb;
    });
  }

  Future<Reservation> makeReservation(TimeSlot timeSlot) async {
    final Dio dio = Dio();
    try {
      final response = await dio.post(
        '$apiRoute/makeReservation',
        data: Reservation.makeReservation(
          reserverEmail: widget.playerEmail,
          reserverType: ReserverType.player,
          sportCenterName: widget.sportCenter.name,
          isPublic: isPublicInput,
          fieldNumber: selectedField.fieldNumber,
          reservationDate: DateFormat('yyyy-MM-dd').format(selectedDate),
          reservationTime: timeSlot,
          reservationStatus: ReservationStatus.pending,
          teamOneIds: [],
          teamTwoIds: [],
          comment: '',
        ).toJsonMap(),
      );
      Reservation newReservation = Reservation.fromJson(response.data);
      widget.reservations.add(newReservation);
      return newReservation;
    } on DioError catch (e) {
      throw Exception(e.stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> timeSlots = getTimeSlots(
      widget.sportCenter.workingHours.startTime,
      widget.sportCenter.workingHours.endTime,
      90,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Make Reservation',
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Select Field:  ',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 5),
                    FieldsDropDown(
                      fieldNumbers: widget.sportCenter.fields
                          .map((e) => e.fieldNumber)
                          .toList(),
                      selectedField: selectedField,
                      updateSelectedField: _updateSelectedField,
                    ),
                    const SizedBox(width: 20),
                    FieldInfo(
                      field: widget.sportCenter.fields.firstWhere((element) =>
                          element.fieldNumber == selectedField.fieldNumber),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Do you want the match to be public ?',
                      style: TextStyle(fontSize: 16),
                    ),
                    Checkbox(
                      value: isPublicInput,
                      onChanged: (boolean) =>
                          setState(() => isPublicInput = boolean!),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                DateNavigator(
                  onDateChanged: _handleDateChanged,
                  isPlayer: true,
                ),
                const SizedBox(height: 10),
                Column(
                  children: List.generate(
                    timeSlots.length - 1,
                    (index) => BookableTimeSlot(
                      timeSlot: TimeSlot.fromInput(
                        startTime: timeSlots[index],
                        endTime: timeSlots[index + 1],
                      ),
                      reservation: getReservation(
                        fieldNb: selectedField.fieldNumber,
                        reservationDate:
                            DateFormat('yyyy-MM-dd').format(selectedDate),
                        reservationStartTime: timeSlots[index],
                        reservationEndTime: timeSlots[index + 1],
                      ),
                      makeReservation: makeReservation,
                      // deleteReservation: deleteReservation,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class BookableTimeSlot extends StatefulWidget {
  BookableTimeSlot({
    super.key,
    required this.timeSlot,
    required this.reservation,
    required this.makeReservation,
  });

  final Future<Reservation> Function(TimeSlot) makeReservation;
  final TimeSlot timeSlot;
  Reservation? reservation;

  @override
  State<BookableTimeSlot> createState() => _BookableTimeSlotState();
}

class _BookableTimeSlotState extends State<BookableTimeSlot> {
  TextEditingController reservationCommentInput = TextEditingController();

  Future<void> makeReservationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Are you sure about this?',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Do you want to reserve this slot?',
          ),
          actions: [
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                _makeReservation();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _makeReservation() async {
    Reservation newReservation = await widget.makeReservation(widget.timeSlot);
    setState(() => widget.reservation = newReservation);
  }

  @override
  Widget build(BuildContext context) {
    bool isReserved = widget.reservation != null &&
        widget.reservation!.reservationStatus != ReservationStatus.rejected;
    bool isPending = widget.reservation != null &&
        widget.reservation!.reservationStatus == ReservationStatus.pending;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 10,
      ),
      child: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${widget.timeSlot.startTime} - ${widget.timeSlot.endTime}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Divider(thickness: 1),
            isReserved
                ? Container(
                    color: isPending ? Colors.yellow : Colors.red,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      isPending
                          ? 'Reservatin Pending Approval'
                          : 'Field Booked',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isPending ? kDarkColor : kLightColor,
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      await makeReservationDialog();
                    },
                    child: const Text(
                      'Reserve time slot',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
            if (isReserved) const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class FieldsDropDown extends StatefulWidget {
  final List<int> fieldNumbers;
  final SelectedField selectedField;
  final Function(int) updateSelectedField;

  const FieldsDropDown({
    super.key,
    required this.fieldNumbers,
    required this.selectedField,
    required this.updateSelectedField,
  });

  @override
  State<FieldsDropDown> createState() => _FieldsDropDownState();
}

class _FieldsDropDownState extends State<FieldsDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: widget.selectedField.fieldNumber,
      items: widget.fieldNumbers.map((int item) {
        return DropdownMenuItem<int>(
          value: item,
          child: Text(item.toString()),
        );
      }).toList(),
      onChanged: (int? selectedItem) {
        setState(() {
          widget.updateSelectedField(selectedItem!);
        });
      },
    );
  }
}

class SelectedField {
  SelectedField(this.fieldNumber);
  int fieldNumber;
}
