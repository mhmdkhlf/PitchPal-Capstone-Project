import 'package:flutter/material.dart';
import '../constants.dart';

// ignore: must_be_immutable
class TimeInput extends StatefulWidget {
  TimeInput({
    super.key,
    required this.timeInput,
  });
  TimeOfDay timeInput;

  String getTimeString() {
    String hour = timeInput.hour.toString().padLeft(2, '0');
    String minute = timeInput.minute.toString().padLeft(2, '0');
    return '$defaultDatePrefixForTimeAttributes$hour:$minute';
  }

  @override
  State<TimeInput> createState() => _TimeInputState();
}

class _TimeInputState extends State<TimeInput> {
  @override
  Widget build(BuildContext context) {
    final hour = widget.timeInput.hour.toString().padLeft(2, '0');
    final minute = widget.timeInput.minute.toString().padLeft(2, '0');
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        backgroundColor: kPrimaryColor,
        shape: const StadiumBorder(),
        side: const BorderSide(
          width: 2,
          color: kDarkGreen,
        ),
      ),
      onPressed: () async {
        TimeOfDay? newTime = await showTimePicker(
          context: context,
          initialTime: widget.timeInput,
        );
        if (newTime == null) return;
        setState(() => widget.timeInput = newTime);
      },
      child: Text(
        '$hour:$minute',
        style: const TextStyle(
          fontSize: 16,
          color: kDarkGreen,
        ),
      ),
    );
  }
}
