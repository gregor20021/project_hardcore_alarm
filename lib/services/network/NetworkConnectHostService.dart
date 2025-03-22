import 'dart:convert';

import 'package:alarm_app/models/dissmissClient.dart';
import 'package:alarm_app/models/dto/connect/connectDevicesDtoRequest.dart';
import 'package:alarm_app/models/dto/connect/connectDevicesDtoResponse.dart';
import 'package:alarm_app/services/appIdService.dart';
import 'package:zeroconnect/zeroconnect.dart';

class NetworkConnectHostService {
  ZeroConnect zeroConnect = ZeroConnect();

  bool isAlarmAdvertising = false;

  void exposeConnectNewDevice({Function? onSuccessCallback, Function? onErrorCallback}) async {
    zeroConnect.advertise(
      serviceId: "connect",
      callback: (messageSock, nodeId, serviceId) async {
        try {
          String? requestBare = await messageSock.recvString();
          ConnectDevicesDtoRequest connectDevicesDtoRequest = ConnectDevicesDtoRequest
              .fromJson(jsonDecode(requestBare!));


          DismissClient dismissClient = DismissClient(
            deviceId: AppIdService().appId,
            deviceName: AppIdService().appId,
          );
          ConnectDevicesDtoResponse connectDevicesDtoResponse = ConnectDevicesDtoResponse(
            dismissClient: dismissClient,
          );

          messageSock.sendString(
              jsonEncode(connectDevicesDtoResponse.toJson()));
          zeroConnect.close();

          onSuccessCallback?.call();
        } catch (e) {
          onErrorCallback?.call();
        }
      },
    );
  }

  void close() {
    zeroConnect.close();
  }
}