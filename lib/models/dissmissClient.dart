class DismissClient {
  String? deviceId;
  String? deviceName;
  String? qrCode;

  DismissClient({
    this.deviceId,
    this.deviceName,
    this.qrCode,
  });

  DismissClient.fromJson(Map<String, dynamic> json) {
    deviceId = json['deviceId'];
    deviceName = json['deviceName'];
    if (json['qrCode'] != null) {
      qrCode = json['qrCode'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deviceId'] = deviceId;
    data['deviceName'] = deviceName;
    if (qrCode != null) {
      data['qrCode'] = qrCode;
    }
    return data;
  }
}