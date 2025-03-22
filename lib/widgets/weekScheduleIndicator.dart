import 'package:alarm_app/models/alarmSchedule.dart';
import 'package:flutter/cupertino.dart';

class WeekScheduleIndicator extends StatelessWidget {
  final AlarmSchedule schedule;

  const WeekScheduleIndicator({super.key, required this.schedule});

  static const double indicatorSize = 10;
  static const double dayTextSize = 10;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text('M', style: TextStyle(fontSize: dayTextSize),),
            Icon(schedule.monday ? CupertinoIcons.circle_fill : CupertinoIcons
                .circle, size: indicatorSize,)
          ],
        ),
        Column(
          children: [
            Text('T', style: TextStyle(fontSize: dayTextSize),),
            Icon(schedule.tuesday ? CupertinoIcons.circle_fill : CupertinoIcons
                .circle, size: indicatorSize,)

          ],
        ),
        Column(
          children: [
            Text('W', style: TextStyle(fontSize: dayTextSize),),
            Icon(schedule.wednesday ? CupertinoIcons.circle_fill : CupertinoIcons
                .circle, size: indicatorSize,)

          ],
        ),
        Column(
          children: [
            Text('T', style: TextStyle(fontSize: dayTextSize),),
            Icon(schedule.thursday ? CupertinoIcons.circle_fill : CupertinoIcons
                .circle, size: indicatorSize,)

          ],
        ),
        Column(
          children: [
            Text('F', style: TextStyle(fontSize: dayTextSize),),
            Icon(schedule.friday ? CupertinoIcons.circle_fill : CupertinoIcons
                .circle, size: indicatorSize,)

          ],
        ),
        Column(
          children: [
            Text('S', style: TextStyle(fontSize: dayTextSize),),
            Icon(schedule.saturday ? CupertinoIcons.circle_fill : CupertinoIcons
                .circle, size: indicatorSize,)

          ],
        ),
        Column(
          children: [
            Text('S', style: TextStyle(fontSize: dayTextSize),),
            Icon(schedule.sunday ? CupertinoIcons.circle_fill : CupertinoIcons
                .circle, size: indicatorSize,)
          ],
        ),
      ],
    );
  }
}
