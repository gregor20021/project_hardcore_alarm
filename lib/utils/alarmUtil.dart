import 'package:alarm_app/holders/SnoozeHolder.dart';
import 'package:alarm_app/models/alarm.dart';
import 'package:alarm_app/utils/timeUtil.dart';

class AlarmUtil {
  AlarmUtil._();

  static getFormattedAlarmTime(AlarmEntity alarm) {
    return '${TimeUtil.getFormattedTime(alarm.schedule.hour, alarm.schedule.minute)}';
  }

  static bool checkIfAlarmScheduledForRestOfDay(AlarmEntity alarmEntity, DateTime date) {
    bool isSet = false;
    switch (date.weekday) {
      case 1:
        isSet = alarmEntity.schedule.sunday;
        break;
      case 2:
        isSet = alarmEntity.schedule.monday;
        break;
      case 3:
        isSet = alarmEntity.schedule.tuesday;
        break;
      case 4:
        isSet = alarmEntity.schedule.wednesday;
        break;
      case 5:
        isSet = alarmEntity.schedule.thursday;
        break;
      case 6:
        isSet = alarmEntity.schedule.friday;
        break;
      case 7:
        isSet = alarmEntity.schedule.saturday;
        break;
    }
    if (isSet) {
      DateTime alarmTime = DateTime(date.year, date.month, date.day, alarmEntity.schedule.hour, alarmEntity.schedule.minute);
      if (date.isBefore(alarmTime)) {
        return true;
      }
    }
    return false;
  }

  static int getSnoozeMinutes(AlarmEntity alarmEntity, SnoozeHolder? snoozeHolder) {
    int snoozeMinutes = alarmEntity.snoozeOptions.minutes;
    if (snoozeHolder == null) {
      return snoozeMinutes;
    }
    if (alarmEntity.snoozeOptions.decreaseMinutesPerSnooze > 0) {
      snoozeMinutes -= alarmEntity.snoozeOptions.decreaseMinutesPerSnooze * (snoozeHolder.snoozeCount);
      if (snoozeMinutes < 0) {
        snoozeMinutes = 1;
      }
    }
    return snoozeMinutes;
  }
}