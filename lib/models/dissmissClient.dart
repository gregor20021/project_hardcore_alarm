class DismissClient {
  String? deviceId;
  String? deviceName;
  String? dismissQrCode;
  String? snoozeQrCode;

  DismissClient({
    this.deviceId,
    this.deviceName,
    this.dismissQrCode,
    this.snoozeQrCode,
  });

  DismissClient.fromJson(Map<String, dynamic> json) {
    deviceId = json['deviceId'];
    deviceName = json['deviceName'];
    if (json['dismissQrCode'] != null) {
      dismissQrCode = json['dismissQrCode'];
    }
    if (json['snoozeQrCode'] != null) {
      snoozeQrCode = json['snoozeQrCode'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deviceId'] = deviceId;
    data['deviceName'] = deviceName;
    if (dismissQrCode != null) {
      data['dismissQrCode'] = dismissQrCode;
    }
    if (snoozeQrCode != null) {
      data['snoozeQrCode'] = snoozeQrCode;
    }
    return data;
  }
}