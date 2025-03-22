import 'package:alarm_app/utils/timeUtil.dart';
import 'package:flutter/material.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';

class ClockEdit extends StatefulWidget {
  final ClockEditController? controller;
  const ClockEdit({super.key, this.controller});

  @override
  State<ClockEdit> createState() => _ClockEditState();
}

class _ClockEditState extends State<ClockEdit> {
  @override
  Widget build(BuildContext context) {
    ClockEditController controller = widget.controller ?? ClockEditController();
    TimeOfDay pickedTime = controller.pickedTime;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TimePickerSpinner(
              locale: const Locale('en', ''),
              time: DateTime(2021, 1, 1, pickedTime.hour, pickedTime.minute),
              is24HourMode: true,
              alignment: Alignment.center,
              spacing: 20,
              itemHeight: 60,
              normalTextStyle: const TextStyle(fontSize: 24),
              highlightedTextStyle: const TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
              isForce2Digits: true,
              onTimeChange: (time) {
                setState(() {
                  pickedTime = TimeOfDay(hour: time.hour, minute: time.minute);
                  controller.pickedTime = pickedTime;
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}

class ClockEditController {
  TimeOfDay pickedTime = TimeOfDay.now();
  ClockEditController({TimeOfDay? time}) {
    if (time != null) {
      pickedTime = time;
    }
  }
}