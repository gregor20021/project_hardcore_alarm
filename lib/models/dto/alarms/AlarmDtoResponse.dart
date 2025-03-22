import 'package:alarm_app/models/alarm.dart';

class AlarmDtoResponse {
  AlarmEntity? alarm;
  bool? success = true;
  List<AlarmEntity>? alarms;

  AlarmDtoResponse({this.alarm, this.alarms});

  AlarmDtoResponse.fromJson(Map<String, dynamic> json) {
    alarm = json['alarm'] != null ? AlarmEntity.fromJson(json['alarm']) : null;
    if (json['success'] != null) {
      success = json['success'];
    }
    if (json['alarms'] != null) {
      alarms = <AlarmEntity>[];
      json['alarms'].forEach((v) {
        alarms!.add(AlarmEntity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (alarm != null) {
      data['alarm'] = alarm!.toJson();
    }
    if (success != null) {
      data['success'] = success;
    }
    if (alarms != null) {
      data['alarms'] = alarms!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}