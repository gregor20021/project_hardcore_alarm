import 'package:alarm/alarm.dart';
import 'package:alarm_app/holders/SnoozeHolder.dart';
import 'package:alarm_app/models/alarm.dart';
import 'package:alarm_app/services/alarmService.dart';
import 'package:alarm_app/utils/alarmUtil.dart';
import 'package:alarm_app/utils/timeUtil.dart';
import 'package:flutter/material.dart';

class AlarmRingView extends StatefulWidget {
  const AlarmRingView({super.key});

  @override
  State<AlarmRingView> createState() => _AlarmRingViewState();
}

class _AlarmRingViewState extends State<AlarmRingView> {
  AlarmEntity? alarmEntity;
  SnoozeHolder? snoozeHolder;
  bool isDismissed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is AlarmEntity) {
      alarmEntity = args;
      snoozeHolder = AlarmService().getSnoozeHolderForAlarm(alarmEntity!.id);
      setupDismissHandler();
    }
  }

  void setupDismissHandler() {
    Alarm.ringing.listen((alarmSet) {
      if (isDismissed) {
        return;
      }
      if (alarmSet.alarms.where((alarm) => alarm.id == alarmEntity!.id).isEmpty) {
        isDismissed = true;
        if(mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.access_alarms, size: 40,),
                      if (alarmEntity != null)Text(TimeUtil.getFormattedTime(alarmEntity!.schedule.hour, alarmEntity!.schedule.minute), style: TextStyle(fontSize: 50)),
                      Text(alarmEntity?.title ?? "", style: TextStyle(fontSize: 30)),
                      Text(alarmEntity?.description ?? "", style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      AlarmService().snoozeAlarm(alarmEntity!.id);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.snooze)),
                          Text('Snooze ${AlarmUtil.getSnoozeMinutes(alarmEntity!, snoozeHolder)
                              .toString()}min'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
