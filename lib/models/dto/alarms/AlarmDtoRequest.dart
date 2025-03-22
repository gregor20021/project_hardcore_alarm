import 'package:alarm_app/models/alarm.dart';

class AlarmDtoRequest {
  int? alarmId;
  AlarmEntity? alarm;

  AlarmDtoRequest({this.alarmId, this.alarm});

  AlarmDtoRequest.fromJson(Map<String, dynamic> json) {
    if (json['alarmId'] != null) {
      alarmId = json['alarmId'];
    }
    if (json['alarm'] != null) {
      alarm = AlarmEntity.fromJson(json['alarm']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (alarmId != null) {
      data['alarmId'] = alarmId;
    }
    if (alarm != null) {
      data['alarm'] = alarm!.toJson();
    }
    return data;
  }
}