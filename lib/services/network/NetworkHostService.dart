import 'dart:convert';

import 'package:alarm_app/models/dissmissClient.dart';
import 'package:alarm_app/models/dto/alarms/AlarmDtoRequest.dart';
import 'package:alarm_app/models/dto/alarms/AlarmDtoResponse.dart';
import 'package:alarm_app/models/dto/connect/connectDevicesDtoRequest.dart';
import 'package:alarm_app/models/dto/connect/connectDevicesDtoResponse.dart';
import 'package:alarm_app/services/alarmService.dart';
import 'package:alarm_app/services/appIdService.dart';
import 'package:flutter/foundation.dart';
import 'package:zeroconnect/zeroconnect.dart';

class NetworkHostService {
  NetworkHostService._();
  static final NetworkHostService _instance = NetworkHostService._();
  factory NetworkHostService() => _instance;

  ZeroConnect zeroConnect = ZeroConnect();

  bool isAlarmAdvertising = false;

  Future<void> startBroadcasting() async {
    await zeroConnect.advertise(
      serviceId: AppIdService().appId,
      callback: (messageSock, nodeId, serviceId) async {
        try {
          String? requestId = await messageSock.recvString();
          await messageSock.sendString("OK");
          String? request = await messageSock.recvString();
          switch (requestId) {
            case "getAlarms":
              String response = await _getAlarms(request!);
              await messageSock.sendString(response);
              break;
            case "snoozeAlarm":
              String response = await _snoozeAlarm(request!);
              await messageSock.sendString(response);
              break;
            case "dismissAlarm":
              String response = await _dismissAlarm(request!);
              await messageSock.sendString(response);
              break;
            case "addNewAlarm":
              String response = await _addNewAlarm(request!);
              await messageSock.sendString(response);
              break;
            case "deleteAlarm":
              String response = await _deleteAlarm(request!);
              await messageSock.sendString(response);
              break;
            default:
              break;
          }
        } catch (e) {
          if (kDebugMode) {
            print("error while processing request: " + e.toString());
          }
        }
      },
    );
  }

  // processGetAlarms method (types: AlarmDtoRequest -> AlarmDtoResponse)
  Future<String> _getAlarms(String request) async {
    AlarmDtoRequest alarmDtoRequest = AlarmDtoRequest.fromJson(jsonDecode(request));

    AlarmDtoResponse alarmDtoResponse = AlarmDtoResponse();
    alarmDtoResponse.alarms = AlarmService().getAllAlarms();

    return jsonEncode(alarmDtoResponse.toJson());
  }

  // snoozeAlarm method (types: AlarmDtoRequest -> AlarmDtoResponse)
  Future<String> _snoozeAlarm(String request) async {
    AlarmDtoRequest alarmDtoRequest = AlarmDtoRequest.fromJson(jsonDecode(request));

    AlarmDtoResponse alarmDtoResponse = AlarmDtoResponse();
    bool success = await AlarmService().snoozeAlarm(alarmDtoRequest.alarmId!);
    alarmDtoResponse.success = success;

    return jsonEncode(alarmDtoResponse.toJson());
  }

  // dismissAlarm method (types: AlarmDtoRequest -> AlarmDtoResponse)
  Future<String> _dismissAlarm(String request) async {
    AlarmDtoRequest alarmDtoRequest = AlarmDtoRequest.fromJson(jsonDecode(request));

    AlarmDtoResponse alarmDtoResponse = AlarmDtoResponse();
    bool success = await AlarmService().dismissAlarm(alarmDtoRequest.alarmId!);
    alarmDtoResponse.success = success;

    return jsonEncode(alarmDtoResponse.toJson());
  }

  // add new alarm (types: AlarmDtoRequest -> AlarmDtoResponse)
  Future<String> _addNewAlarm(String request) async {
    AlarmDtoRequest alarmDtoRequest = AlarmDtoRequest.fromJson(jsonDecode(request));

    AlarmDtoResponse alarmDtoResponse = AlarmDtoResponse();
    bool success = await AlarmService().addAlarm(alarmDtoRequest.alarm!);
    alarmDtoResponse.success = success;

    return jsonEncode(alarmDtoResponse.toJson());
  }

  // delete alarm (types: AlarmDtoRequest -> AlarmDtoResponse)
  Future<String> _deleteAlarm(String request) async {
    AlarmDtoRequest alarmDtoRequest = AlarmDtoRequest.fromJson(jsonDecode(request));

    AlarmDtoResponse alarmDtoResponse = AlarmDtoResponse();
    bool success = await AlarmService().deleteAlarm(alarmDtoRequest.alarmId!);
    alarmDtoResponse.success = success;

    return jsonEncode(alarmDtoResponse.toJson());
  }
}
