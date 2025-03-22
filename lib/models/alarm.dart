import 'package:alarm_app/models/snoozeOptions.dart';
import 'package:alarm_app/models/alarmSchedule.dart';

class AlarmEntity {
  int id;
  String title;
  String description;
  bool active;
  AlarmSchedule schedule;
  String soundPath;
  int volume;
  SnoozeOptions snoozeOptions;


  AlarmEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.active,
    required this.schedule,
    required this.soundPath,
    required this.volume,
    required this.snoozeOptions,
  });

  factory AlarmEntity.fromJson(Map<String, dynamic> json) {
    return AlarmEntity(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      active: json['active'],
      schedule: AlarmSchedule.fromJson(json['schedule']),
      soundPath: json['soundPath'],
      volume: json['volume'],
      snoozeOptions: SnoozeOptions.fromJson(json['snoozeOptions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'active': active,
      'schedule': schedule.toJson(),
      'soundPath': soundPath,
      'volume': volume,
      'snoozeOptions': snoozeOptions.toJson(),
    };
  }
}