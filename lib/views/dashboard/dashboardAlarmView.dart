import 'dart:ffi';

import 'package:alarm_app/models/alarm.dart';
import 'package:alarm_app/services/alarmService.dart';
import 'package:alarm_app/services/uiService.dart';
import 'package:alarm_app/widgets/currentTimeDisplay.dart';
import 'package:alarm_app/widgets/mediumHeading.dart';
import 'package:alarm_app/widgets/smallAlarmTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardAlarmView extends StatefulWidget {
  const DashboardAlarmView({super.key});

  @override
  State<DashboardAlarmView> createState() => _DashboardAlarmViewState();
}

class _DashboardAlarmViewState extends State<DashboardAlarmView> {

  Function? _listener;
  @override
  void initState() {
    super.initState();
    _listener = () {
      if(mounted) {
        setState(() {});
      }
    };
    AlarmService().addListener(_listener!);
  }

  @override
  void dispose() {
    super.dispose();
    AlarmService().removeListener(_listener!);
  }

  @override
  Widget build(BuildContext context) {
    bool vertical = MediaQuery.of(context).size.width < 600;
    final List<AlarmEntity> alarms = AlarmService().getAllAlarms();

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Flex(
            direction: vertical ? Axis.vertical : Axis.horizontal,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 30,
                ),
                child: CurrentTime(),
              ),
              Expanded(
                child: Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MediumHeading(text: "Alarms", icon: Icons.alarm),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.start,
                          children: [
                            for (AlarmEntity alarm in alarms)
                              SmallAlarmTile(alarm: alarm, onDeleted: (alarm) async {
                                await AlarmService().deleteAlarm(alarm.id);
                                setState(() {});
                              }),
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
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                heroTag: 'add',
                onPressed: () async {
                  await Navigator.pushNamed(context, '/alarm/edit');
                },
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      resizeToAvoidBottomInset: true,
    );
  }
}
