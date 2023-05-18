import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../data/field_manager.dart';
import '../data/sport_center.dart';
import '../data/reservation.dart';
import '../data/time_slot.dart';
import '../components/date_navigator.dart';
import '../constants.dart';

class ReservationManagement extends StatefulWidget {
  const ReservationManagement({
    super.key,
    required this.sportCenter,
    required this.reservations,
    required this.fieldManager,
  });

  final FieldManager fieldManager;
  final SportCenter sportCenter;
  final List<Reservation> reservations;

  @override
  State<ReservationManagement> createState() => _ReservationManagementState();
}

class _ReservationManagementState extends State<ReservationManagement> {
  final SelectedField selectedField = SelectedField(1);
  DateTime selectedDate = DateTime.now();

  void _handleDateChanged(DateTime newDate) =>
      setState(() => selectedDate = newDate);

  void _handleFieldChanged(int newFieldNb) =>
      setState(() => selectedField.fieldNumber = newFieldNb);

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

  Future<Reservation> makeReservation(TimeSlot timeSlot, String comment) async {
    final Dio dio = Dio();
    try {
      final response = await dio.post(
        '$apiRoute/makeReservation',
        data: Reservation.makeReservation(
          reserverEmail: widget.fieldManager.email,
          reserverType: ReserverType.fieldManager,
          sportCenterName: widget.sportCenter.name,
          isPublic: false,
          fieldNumber: selectedField.fieldNumber,
          reservationDate: DateFormat('yyyy-MM-dd').format(selectedDate),
          reservationTime: timeSlot,
          reservationStatus: ReservationStatus.accepted,
          teamOneIds: [],
          teamTwoIds: [],
          comment: comment,
        ).toJsonMap(),
      );
      Reservation newReservation = Reservation.fromJson(response.data);
      widget.reservations.add(newReservation);
      return newReservation;
    } on DioError catch (e) {
      throw Exception(e.stackTrace);
    }
  }

  Future<void> deleteReservation(String reservationId) async {
    final Dio dio = Dio();
    try {
      final response = await dio.delete(
        '$apiRoute/deleteReservation/$reservationId',
      );
      widget.reservations
          .removeWhere((element) => element.uuid == reservationId);
      if (response.statusCode != 200) {
        throw Exception("Invalid status code for reservation delete");
      }
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
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Selected Field',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 20),
                FieldsDropDown(
                  fieldNumbers: widget.sportCenter.fields
                      .map((e) => e.fieldNumber)
                      .toList(),
                  onFieldChanged: _handleFieldChanged,
                ),
              ],
            ),
            const SizedBox(height: 10),
            DateNavigator(onDateChanged: _handleDateChanged),
            const SizedBox(height: 10),
            Column(
              children: List.generate(
                timeSlots.length - 1,
                (index) => ReservationTimeSlot(
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
                  deleteReservation: deleteReservation,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ReservationTimeSlot extends StatefulWidget {
  final TimeSlot timeSlot;
  Reservation? reservation;
  final Future<Reservation> Function(TimeSlot, String) makeReservation;
  final Future<void> Function(String) deleteReservation;

  ReservationTimeSlot({
    super.key,
    required this.timeSlot,
    required this.reservation,
    required this.makeReservation,
    required this.deleteReservation,
  });

  @override
  State<ReservationTimeSlot> createState() => _ReservationTimeSlotState();
}

class _ReservationTimeSlotState extends State<ReservationTimeSlot> {
  TextEditingController reservationCommentInput = TextEditingController();

  Future<Reservation> updateReservationStatus(
      ReservationStatus newStatus) async {
    final Dio dio = Dio();
    try {
      final response = await dio.patch(
        '$apiRoute/editReservationStatus',
        data: {
          'reservationId': widget.reservation!.uuid,
          'status': newStatus.value,
        },
      );
      Reservation updatedReservation = Reservation.fromJson(response.data);
      return updatedReservation;
    } on DioError catch (e) {
      throw Exception(e.stackTrace);
    }
  }

  Future<void> makeReservationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Are you sure you want to reserve this slot?',
            textAlign: TextAlign.center,
          ),
          content: TextField(
            controller: reservationCommentInput,
            decoration: const InputDecoration(
              hintText: '(Comment about reservation)',
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                _makeReservation(reservationCommentInput.text);
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

  Future<void> areYouSureDialog(String message, Function function) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure about this?'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                function();
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

  void _makeReservation(String comment) async {
    Reservation newReservation =
        await widget.makeReservation(widget.timeSlot, comment);
    setState(() => widget.reservation = newReservation);
  }

  void _deleteReservation() async {
    widget.deleteReservation(
      widget.reservation!.uuid!,
    );
    setState(() => widget.reservation = null);
  }

  void _acceptReservation() async {
    Reservation updatedReservation = await updateReservationStatus(
      ReservationStatus.accepted,
    );
    setState(
      () => widget.reservation!.reservationStatus =
          updatedReservation.reservationStatus,
    );
  }

  void _rejectReservation() async {
    Reservation updatedReservation = await updateReservationStatus(
      ReservationStatus.rejected,
    );
    setState(
      () => widget.reservation!.reservationStatus =
          updatedReservation.reservationStatus,
    );
  }

  @override
  Widget build(BuildContext context) {
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
            if (widget.reservation == null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    'Not Reserved',
                    style: TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await makeReservationDialog();
                    },
                    child: const Text(
                      'Reserve Slot',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            if (widget.reservation != null &&
                widget.reservation!.reservationStatus ==
                    ReservationStatus.pending)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text.rich(
                      TextSpan(
                        style: const TextStyle(fontSize: 14),
                        children: [
                          const TextSpan(
                            text: 'Reservation is ',
                          ),
                          TextSpan(
                            text: widget.reservation!.reservationStatus.value,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  ButtonTheme(
                    child: ButtonBar(
                      alignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () async {
                              await areYouSureDialog(
                                'Do you want to accept this pending reservation?',
                                _acceptReservation,
                              );
                            },
                            icon: const Icon(Icons.check),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () async {
                              areYouSureDialog(
                                'Do you want to reject this pending reservation?',
                                _rejectReservation,
                              );
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            if (widget.reservation != null &&
                widget.reservation!.reservationStatus !=
                    ReservationStatus.pending)
              widget.reservation!.reserverType == ReserverType.player
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text.rich(
                            TextSpan(
                              style: const TextStyle(fontSize: 14),
                              children: [
                                const TextSpan(
                                  text: 'Player reservation got ',
                                ),
                                TextSpan(
                                  text: widget
                                      .reservation!.reservationStatus.value,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (widget.reservation!.reservationStatus ==
                            ReservationStatus.rejected)
                          Tooltip(
                            message: 'Delete reservation',
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: ElevatedButton(
                                onPressed: () async {
                                  await areYouSureDialog(
                                    'Do you want to delete this reservation?',
                                    _deleteReservation,
                                  );
                                },
                                child: const Icon(Icons.delete),
                              ),
                            ),
                          ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Reserved',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Tooltip(
                          message: 'Delete reservation',
                          child: ElevatedButton(
                            onPressed: () async {
                              await areYouSureDialog(
                                'Do you want to delete this reservation?',
                                _deleteReservation,
                              );
                            },
                            child: Row(
                              children: const [
                                Text(
                                  'Delete Reservation  ',
                                  style: TextStyle(fontSize: 12),
                                ),
                                Icon(Icons.delete),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            if (widget.reservation != null)
              Column(
                children: [
                  const Divider(thickness: 1),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      'Reserver is a ${widget.reservation!.reserverType.value}, their email is:',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      widget.reservation!.reserverEmail,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (widget.reservation != null &&
                      widget.reservation!.comment != null &&
                      widget.reservation!.comment!.isNotEmpty)
                    Column(
                      children: [
                        const Divider(thickness: 1),
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: Text(
                            widget.reservation!.comment!,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            const SizedBox(height: 7),
          ],
        ),
      ),
    );
  }
}

class FieldsDropDown extends StatefulWidget {
  final List<int> fieldNumbers;
  final Function(int) onFieldChanged;

  const FieldsDropDown({
    super.key,
    required this.fieldNumbers,
    required this.onFieldChanged,
  });

  @override
  State<FieldsDropDown> createState() => _FieldsDropDownState();
}

class _FieldsDropDownState extends State<FieldsDropDown> {
  int _currentFieldNb = 1;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: _currentFieldNb,
      items: widget.fieldNumbers.map((int item) {
        return DropdownMenuItem<int>(
          value: item,
          child: Text(item.toString()),
        );
      }).toList(),
      onChanged: (int? selectedItem) {
        setState(() {
          _currentFieldNb = selectedItem!;
        });
        widget.onFieldChanged(_currentFieldNb);
      },
    );
  }
}

class SelectedField {
  SelectedField(this.fieldNumber);
  int fieldNumber;
}
