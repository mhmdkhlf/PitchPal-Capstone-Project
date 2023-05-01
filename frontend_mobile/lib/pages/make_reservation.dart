import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/submit_button.dart';
import '../components/response_dialog_box.dart';
import '../data/sport_center.dart';

class MakeReservation extends StatefulWidget {
  const MakeReservation({super.key, required this.sportCenter});

  final SportCenter sportCenter;

  @override
  State<MakeReservation> createState() => _MakeReservationState();
}

class _MakeReservationState extends State<MakeReservation> {
  bool isPublic = false;
  SelectedField selectedField = SelectedField(1);
  SelectedTime selectedTime = SelectedTime('');
  final TextEditingController dateInput = TextEditingController();

  List<String> getTimeSlots(
    String openingTime,
    String closingTime,
    int timeSlotDurationInMinutes,
  ) {
    List<String> times = [];
    DateTime start = DateTime.parse('2022-01-01 $openingTime:00');
    DateTime end = DateTime.parse('2022-01-01 $closingTime:00');
    while (start.isBefore(end) || start.isAtSameMomentAs(end)) {
      String time =
          '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
      times.add(time);
      start = start.add(Duration(minutes: timeSlotDurationInMinutes));
    }
    List<String> timeSlots = [];
    for (int i = 0; i < times.length - 1; i++) {
      timeSlots.add('${times[i]} - ${times[i + 1]}');
    }
    return timeSlots;
  }

  @override
  Widget build(BuildContext context) {
    List<String> timeSlots = getTimeSlots(
      widget.sportCenter.workingHours.startTime,
      widget.sportCenter.workingHours.endTime,
      90,
    );
    selectedTime.matchTime = timeSlots[0];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Make Reservation',
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Field #',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 20),
                  FieldsDropDown(
                    fieldNumbers: widget.sportCenter.fields
                        .map((e) => e.fieldNumber)
                        .toList(),
                    selectedField: selectedField,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 4,
                ),
                child: TextField(
                  controller: dateInput,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    labelText: 'Reservation Day',
                    border: InputBorder.none,
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 1),
                    );
                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      setState(() => dateInput.text = formattedDate);
                    }
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Reservation Time',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 20),
                  TimeSlotDropDown(
                    reservationTimes: timeSlots,
                    selectedTime: selectedTime,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Public Match',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 20),
                  Switch(
                    value: isPublic,
                    onChanged: (boolean) => setState(() => isPublic = boolean),
                  ),
                ],
              ),
              SubmitButton(
                text: 'Book The Field',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => (const ResponseDialogBox(
                        text: 'You Successfully Booked a Field',
                      )),
                    ),
                  );
                },
                fontSize: 18,
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class FieldsDropDown extends StatefulWidget {
  final List<int> fieldNumbers;
  final SelectedField selectedField;

  const FieldsDropDown({
    super.key,
    required this.fieldNumbers,
    required this.selectedField,
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
          widget.selectedField.fieldNumber = selectedItem!;
        });
      },
    );
  }
}

class SelectedField {
  SelectedField(this.fieldNumber);
  int fieldNumber;
}

class TimeSlotDropDown extends StatefulWidget {
  final List<String> reservationTimes;
  final SelectedTime selectedTime;

  const TimeSlotDropDown({
    super.key,
    required this.reservationTimes,
    required this.selectedTime,
  });

  @override
  State<TimeSlotDropDown> createState() => _TimeSlotDropDownState();
}

class _TimeSlotDropDownState extends State<TimeSlotDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.selectedTime.matchTime,
      items: widget.reservationTimes.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (String? selectedItem) {
        setState(() {
          widget.selectedTime.matchTime = selectedItem!;
        });
      },
    );
  }
}

class SelectedTime {
  SelectedTime(this.matchTime);
  String matchTime;
}
