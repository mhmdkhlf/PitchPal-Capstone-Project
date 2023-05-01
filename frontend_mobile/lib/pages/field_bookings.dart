import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/sport_center.dart';
import '../data/reservation.dart';

class FieldBookings extends StatefulWidget {
  const FieldBookings({
    super.key,
    required this.sportCenter,
    required this.reservations,
  });

  final SportCenter sportCenter;
  final List<Reservation> reservations;

  @override
  State<FieldBookings> createState() => _FieldBookingsState();
}

class _FieldBookingsState extends State<FieldBookings> {
  final SelectedField _selectedField = SelectedField(1);
  DateTime _selectedDate = DateTime.now();

  void _handleDateChanged(DateTime newDate) =>
      setState(() => _selectedDate = newDate);

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
                  selectedField: _selectedField,
                ),
              ],
            ),
            const SizedBox(height: 10),
            DateNavigator(onDateChanged: _handleDateChanged),
            const SizedBox(height: 10),
            Column(
              children: List.generate(
                timeSlots.length - 1,
                (index) => _ReservationTimeSlot(
                  time: '${timeSlots[index]} - ${timeSlots[index + 1]}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
}

class _ReservationTimeSlot extends StatelessWidget {
  final String time;

  const _ReservationTimeSlot({
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
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
                time,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Reservation Status: ',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Reserver/Players Names & IDs',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DateNavigator extends StatefulWidget {
  final Function(DateTime) onDateChanged;

  const DateNavigator({
    super.key,
    required this.onDateChanged,
  });

  @override
  State<DateNavigator> createState() => _DateNavigatorState();
}

class _DateNavigatorState extends State<DateNavigator> {
  DateTime _currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            setState(
              () =>
                  _currentDate = _currentDate.subtract(const Duration(days: 1)),
            );
            widget.onDateChanged(_currentDate);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        const SizedBox(width: 10.0),
        Text(
          DateFormat('EEE, MMM d, yyyy').format(_currentDate),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 10.0),
        IconButton(
          onPressed: () {
            setState(
              () => _currentDate = _currentDate.add(const Duration(days: 1)),
            );
            widget.onDateChanged(_currentDate);
          },
          icon: const Icon(Icons.arrow_forward_ios),
        ),
      ],
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
