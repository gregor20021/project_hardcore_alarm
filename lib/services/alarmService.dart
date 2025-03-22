import 'dart:math';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/volume_settings.dart';
import 'package:alarm_app/globals.dart';
import 'package:alarm_app/holders/SnoozeHolder.dart';
import 'package:alarm_app/models/alarm.dart';
import 'package:alarm_app/models/alarmSchedule.dart';
import 'package:alarm_app/services/alarmStorageService.dart';
import 'package:alarm_app/utils/alarmUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:cron/cron.dart';

class AlarmService {
  static final AlarmService _instance = AlarmService._();
  factory AlarmService() => _instance;
  AlarmService._();

  List<AlarmEntity>? alarms;

  final List<Function> _listeners = [];

  List<SnoozeHolder> snoozeHolders = [];

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  void checkInitialized() {
    if (!_isInitialized) {
      throw Exception('AlarmService not initialized');
    }
  }

  Future<bool> init() async {
    try {
      if (_isInitialized) return false;
      _isInitialized = true;

      Alarm.init();
      await _retrieveAlarmsFromStorage();
      await _scheduleForToday();
      _setupScheduleDaily();
      await setAlarmHandler();
      return true;
    } catch (e) {
      _isInitialized = false;
      return false;
    }
  }

  Future<void> setAlarmHandler() async {
    Alarm.ringing.listen((alarmSet) {
      if (alarmSet.alarms.isEmpty) {
        return;
      }

      final alarm = alarmSet.alarms.first;
      final alarmEntity = getAlarmById(alarm.id);
      final context = navigatorKey!.currentState!.context;

      Navigator.of(context).popUntil((route) => route.settings.name != '/alarm/ring');

      Navigator.of(context).pushNamed('/alarm/ring', arguments: alarmEntity);
    });
  }

  AlarmEntity getAlarmById(int id) {
    checkInitialized();

    final alarm = alarms?.firstWhere((a) => a.id == id);
    if (alarm == null) {
      throw Exception('Alarm not found');
    }
    return alarm;
  }

  SnoozeHolder? getSnoozeHolderForAlarm(int id) {
    if (snoozeHolders.any((holder) => holder.alarmId == id)) {
      return snoozeHolders.firstWhere((holder) => holder.alarmId == id);
    }
    return null;
  }

  Future<bool> addAlarm(AlarmEntity alarm) async {
    checkInitialized();

    if (alarms != null && alarms!.any((a) => a.id == alarm.id)) {
      throw Exception('Alarm already exists');
    }
    alarms ??= List.empty();
    alarms!.add(alarm);
    await _syncAlarmsWithStorage();
    if (AlarmUtil.checkIfAlarmScheduledForRestOfDay(alarm, DateTime.now())) {
      await _scheduleAlarm(alarm, alarm.schedule.hour, alarm.schedule.minute);
    }
    _notifyListeners();
    return true;
  }

  int generateId() {
    int id = Random().nextInt(1000000);
    if (alarms != null && alarms!.any((a) => a.id == id)) {
      return generateId();
    }
    return id;
  }

  Future<void> updateAlarm(AlarmEntity alarm) async {
    checkInitialized();

    final index = alarms!.indexWhere((a) => a.id == alarm.id);
    if (index == -1) {
      throw Exception('Alarm not found');
    }
    alarms![index] = alarm;
    await _syncAlarmsWithStorage();
    await  Alarm.getAlarms().then((alarms) {
      if (alarms.any((a) => a.id == alarm.id)) {
        Alarm.stop(alarm.id);
      }
    });
    if (AlarmUtil.checkIfAlarmScheduledForRestOfDay(alarm, DateTime.now())) {
      await _scheduleAlarm(alarm, alarm.schedule.hour, alarm.schedule.minute);
    }

    removeSnoozeForAlarm(alarm.id);
    _notifyListeners();

  }

  Future<bool> deleteAlarm(int id) async {
    checkInitialized();

    final index = alarms!.indexWhere((a) => a.id == id);
    if (index == -1) {
      throw Exception('Alarm not found');
    }
    bool invalidTimeFrame = false;
    DateTime now = DateTime.now();
    int minutes = now.difference(DateTime.now().copyWith(hour: alarms![index].schedule.hour, minute: alarms![index].schedule.minute)).inMinutes;
    if (minutes > -5 && minutes < 90) {
      invalidTimeFrame = true;
    }
    if (invalidTimeFrame) {
      return false;
    }
    final alarm = alarms!.removeAt(index);
    await _syncAlarmsWithStorage();
    await  Alarm.getAlarms().then((alarms) {
      if (alarms.any((a) => a.id == alarm.id)) {
        Alarm.stop(alarm.id);
      }
    });

    removeSnoozeForAlarm(id);
    _notifyListeners();
    return true;
  }

  Future<bool> snoozeAlarm(int id) async {
    bool response = false;
    final alarm = getAlarmById(id);
    List<SnoozeHolder> holder = snoozeHolders.where((holder) => holder.alarmId == id).toList();
    if (holder.isNotEmpty) {
      if (alarm.snoozeOptions.repeat != 0 && holder.last.snoozeCount >= alarm.snoozeOptions.repeat) {
        return false;
      }
      SnoozeHolder snoozeHolder = holder.last;
      snoozeHolder.snoozeCount += 1;
      int minutes = alarm.snoozeOptions.minutes;
      minutes = AlarmUtil.getSnoozeMinutes(alarm, snoozeHolder);
      snoozeHolder.nextSnoozeTime =
          DateTime.now().add(Duration(minutes: minutes));
    } else {
      snoozeHolders.add(SnoozeHolder(
        alarmId: id,
        snoozeCount: 1,
        nextSnoozeTime: DateTime.now().add(
            Duration(minutes: alarm.snoozeOptions.minutes)),
      ),);
    }
    await Alarm.getAlarms().then((alarms) {
      if (alarms.any((a) => a.id == id)) {
        Alarm.stop(id);
        response = true;
      }
    });
    _scheduleAlarm(alarm, DateTime.now().hour, DateTime.now().minute, snoozeHolder: snoozeHolders.last,);

    _notifyListeners();

    return response;
  }

  Future<bool> dismissAlarm(int id) async {
    bool response = false;
    await Alarm.getAlarms().then((alarms) {
      if (alarms.any((a) => a.id == id)) {
        Alarm.stop(id);
        response = true;
      }
    });
    removeSnoozeForAlarm(id);

    _notifyListeners();

    return response;
  }

  void removeSnoozeForAlarm(int id) {
    List<SnoozeHolder> toRemove = [];
    for (final holder in snoozeHolders) {
      if (holder.alarmId == id) {
        toRemove.add(holder);
      }
    }
    for (final holder in toRemove) {
      snoozeHolders.remove(holder);
      Alarm.getAlarms().then((alarms) {
        if (alarms.any((a) => a.id == holder.alarmId)) {
          Alarm.stop(holder.alarmId);
        }
      });
    }
  }

  void _setupScheduleDaily() {
    final cron = Cron();
    cron.schedule(Schedule.parse('0 0 * * *'), () {
      _scheduleForToday();
    });
  }

  Future<void> _scheduleForToday() async {
    DateTime now = DateTime.now();
    alarms = getAllAlarms();

    await Alarm.stopAll();

    for (final alarm in alarms!) {
      if (!AlarmUtil.checkIfAlarmScheduledForRestOfDay(alarm, now)) {
        continue;
      }
      AlarmSchedule schedule = alarm.schedule;
      int hour = schedule.hour;
      int minute = schedule.minute;
      await _scheduleAlarm(alarm, hour, minute);
    }
  }

  Future<void> _scheduleAlarm(AlarmEntity alarm, int hour, int minute, {SnoozeHolder? snoozeHolder}) async {
    DateTime time = DateTime.now().copyWith(
      hour: hour,
      minute: minute,
      second: 0,
      millisecond: 0,
    );
    if (snoozeHolder != null) {
      time = snoozeHolder.nextSnoozeTime;
    }
    final alarmSettings = AlarmSettings(
      id: alarm.id,
      dateTime: time,
      assetAudioPath: alarm.soundPath,
      loopAudio: true,
      vibrate: true,
      warningNotificationOnKill: true,
      androidFullScreenIntent: true,
      volumeSettings: VolumeSettings.fixed(volume: alarm.volume / 100, volumeEnforced: true,),
      notificationSettings: NotificationSettings(
        title: alarm.title,
        body: alarm.description,
      ),
    );

    await Alarm.set(alarmSettings: alarmSettings);
  }

  List<AlarmEntity> getAllAlarms() {
    checkInitialized();

    return alarms ?? List.empty();
  }

  Future<void> _syncAlarmsWithStorage() async {
    await StorageService.writeAlarms(alarms ?? List.empty());
  }

  Future<void> _retrieveAlarmsFromStorage() async {
    alarms = await StorageService.readAlarms();
  }

  void addListener(Function listener) {
    _listeners.add(listener);
  }

  void removeListener(Function listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

}
