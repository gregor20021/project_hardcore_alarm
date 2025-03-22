import 'package:alarm_app/models/alarm.dart';
import 'package:alarm_app/utils/alarmUtil.dart';
import 'package:alarm_app/widgets/weekScheduleIndicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SmallAlarmTile extends StatelessWidget {
  final AlarmEntity alarm;
  final List<ElevatedButton>? buttons;
  final Future Function(AlarmEntity)? onDeleted;
  final Function()? onClick;

  static const double size = 170;

  const SmallAlarmTile({super.key, required this.alarm, this.buttons, this.onDeleted, this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick?.call();
      },
      child: Card(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: size,
            maxHeight: size,
            minWidth: size,
            maxWidth: size,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                        child: FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  alarm.title,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if(onDeleted != null) Builder(
                        builder: (context) {
                          bool loading = false;
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  if(context.mounted) {
                                    setState(() {
                                      loading = true;
                                    });
                                  }

                                  await onDeleted!(alarm);

                                  if(context.mounted) {
                                    setState(() {
                                      loading = false;
                                    });
                                  }
                                },
                              );
                            }
                          );
                        }
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${AlarmUtil.getFormattedAlarmTime(alarm)}',
                        style: const TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: WeekScheduleIndicator(schedule: alarm.schedule),
                ),
                SizedBox(
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: buttons != null ? buttons!.map((e) {
                      return Padding(padding: const EdgeInsets.all(8.0),
                          child: e);
                    }).toList() : [
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
