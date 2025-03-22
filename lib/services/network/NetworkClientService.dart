import 'dart:convert';

import 'package:alarm_app/models/dto/alarms/AlarmDtoRequest.dart';
import 'package:alarm_app/models/dto/alarms/AlarmDtoResponse.dart';
import 'package:alarm_app/models/dto/connect/connectDevicesDtoRequest.dart';
import 'package:alarm_app/models/dto/connect/connectDevicesDtoResponse.dart';
import 'package:zeroconnect/MessageSocket.dart';
import 'package:zeroconnect/zeroconnect.dart';

class NetworkClientService {
  NetworkClientService._();
  static final NetworkClientService _instance = NetworkClientService._();
  factory NetworkClientService() => _instance;

  ZeroConnect zeroConnect = ZeroConnect();
  Future<ConnectDevicesDtoResponse?> connectNewDevice() async {
    try {
      var messageSock = await zeroConnect.connectToFirst(serviceId: "connect", timeout: Duration(seconds: 3));
      if (messageSock == null) return null;

      ConnectDevicesDtoRequest connectDevicesDtoRequest = ConnectDevicesDtoRequest();
      await messageSock.sendString(
          jsonEncode(connectDevicesDtoRequest.toJson()));

      var response = await messageSock.recvString();
      messageSock.close();

      ConnectDevicesDtoResponse connectDevicesDtoResponse = ConnectDevicesDtoResponse
          .fromJson(jsonDecode(response!));

      return connectDevicesDtoResponse;
    } catch (e) {
      return null;
    }
  }

  Future<AlarmDtoResponse?> getAlarms(String deviceId, AlarmDtoRequest request) async {
    try {
      var messageSock = await zeroConnect.connectToFirst(serviceId: deviceId, timeout: Duration(seconds: 20));
      if (messageSock == null) return null;

      await messageSock.sendString("getAlarms");
      String? commandResponse = await messageSock.recvString();
      if (commandResponse != "OK") {
        messageSock.close();
      }

      await messageSock.sendString(jsonEncode(request.toJson()));

      var response = await messageSock.recvString();
      return AlarmDtoResponse.fromJson(jsonDecode(response!));
    } catch (e) {
      return null;
    }
  }

  Future<AlarmDtoResponse?> snoozeAlarm(String deviceId, AlarmDtoRequest request) async {
    try {
      var messageSock = await zeroConnect.connectToFirst(serviceId: deviceId, timeout: Duration(seconds: 20));
      if (messageSock == null) return null;

      await messageSock.sendString("snoozeAlarm");
      String? commandResponse = await messageSock.recvString();
      if (commandResponse != "OK") {
        messageSock.close();
      }

      await messageSock.sendString(jsonEncode(request.toJson()));

      var response = await messageSock.recvString();
      return AlarmDtoResponse.fromJson(jsonDecode(response!));
    } catch (e) {
      return null;
    }
  }

  Future<AlarmDtoResponse?> dismissAlarm(String deviceId, AlarmDtoRequest request) async {
    try {
      var messageSock = await zeroConnect.connectToFirst(serviceId: deviceId, timeout: Duration(seconds: 20));
      if (messageSock == null) return null;

      await messageSock.sendString("dismissAlarm");
      String? commandResponse = await messageSock.recvString();
      if (commandResponse != "OK") {
        messageSock.close();
      }

      await messageSock.sendString(jsonEncode(request.toJson()));

      var response = await messageSock.recvString();
      return AlarmDtoResponse.fromJson(jsonDecode(response!));
    } catch (e) {
      return null;
    }
  }

  Future<AlarmDtoResponse?> addNewAlarm(String deviceId, AlarmDtoRequest request) async {
    try {
      var messageSock = await zeroConnect.connectToFirst(serviceId: deviceId, timeout: Duration(seconds: 20));
      if (messageSock == null) return null;

      await messageSock.sendString("addNewAlarm");
      String? commandResponse = await messageSock.recvString();
      if (commandResponse != "OK") {
        messageSock.close();
      }

      await messageSock.sendString(jsonEncode(request.toJson()));

      var response = await messageSock.recvString();
      return AlarmDtoResponse.fromJson(jsonDecode(response!));
    } catch (e) {
      return null;
    }
  }

  Future<AlarmDtoResponse?> deleteAlarm(String deviceId, AlarmDtoRequest request) async {
    try {
      var messageSock = await zeroConnect.connectToFirst(serviceId: deviceId, timeout: Duration(seconds: 20));
      if (messageSock == null) return null;

      await messageSock.sendString("deleteAlarm");
      String? commandResponse = await messageSock.recvString();
      if (commandResponse != "OK") {
        messageSock.close();
      }

      await messageSock.sendString(jsonEncode(request.toJson()));

      var response = await messageSock.recvString();
      return AlarmDtoResponse.fromJson(jsonDecode(response!));
    } catch (e) {
      return null;
    }
  }

  void close() {
    zeroConnect.close();
  }
}