import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateNavigator extends StatefulWidget {
  final Function(DateTime) onDateChanged;
  final bool isPlayer;

  const DateNavigator({
    super.key,
    required this.onDateChanged,
    this.isPlayer = false,
  });

  @override
  State<DateNavigator> createState() => _DateNavigatorState();
}

class _DateNavigatorState extends State<DateNavigator> {
  DateTime _currentDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              DateTime today = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
              );
              if (widget.isPlayer &&
                  today.year == _currentDate.year &&
                  today.month == _currentDate.month &&
                  today.day == _currentDate.day) {
                return;
              }
              _currentDate = _currentDate.subtract(const Duration(days: 1));
            });
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
