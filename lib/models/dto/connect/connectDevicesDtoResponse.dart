import 'package:alarm_app/models/dissmissClient.dart';

class ConnectDevicesDtoResponse {
  DismissClient dismissClient;
  ConnectDevicesDtoResponse({required this.dismissClient});

  factory ConnectDevicesDtoResponse.fromJson(Map<String, dynamic> json) {
    return ConnectDevicesDtoResponse(
      dismissClient: DismissClient.fromJson(json['dismissClient']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dismissClient': dismissClient.toJson(),
    };
  }
}