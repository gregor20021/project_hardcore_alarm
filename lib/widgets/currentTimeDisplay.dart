import 'dart:async';

import 'package:alarm_app/utils/timeUtil.dart';
import 'package:flutter/material.dart';

class CurrentTime extends StatefulWidget {
  const CurrentTime({super.key});

  @override
  State<CurrentTime> createState() => _CurrentTimeState();
}

class _CurrentTimeState extends State<CurrentTime> {

  void reloadTime() {
    DateTime now = DateTime.now();
    int milliseconds = (60 - now.second) * 1000 - now.millisecond;

    Future.delayed(Duration(milliseconds: milliseconds), () {
      if (mounted) {
        setState(() {});
        reloadTime();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    reloadTime();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
      Text(
        TimeUtil.getFormattedDateTime(now, showTime: false),
        style: const TextStyle(fontSize: 20),
      ),
      Text(
        TimeUtil.getFormattedTime(now.hour, now.minute),
        style: const TextStyle(fontSize: 50),
      ),
      Text(
        TimeUtil.getWeekday(now.weekday),
        style: const TextStyle(fontSize: 20),
      ),
    ],);
  }
}
