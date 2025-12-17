import 'package:alarm_app/models/dissmissClient.dart';
import 'package:alarm_app/models/dto/connect/connectDevicesDtoResponse.dart';
import 'package:alarm_app/services/dismissClientsService.dart';
import 'package:alarm_app/services/network/NetworkClientService.dart';
import 'package:alarm_app/services/uiService.dart';
import 'package:alarm_app/widgets/mediumHeading.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../widgets/inlineButton.dart';

class DeviceClientConnectView extends StatefulWidget {
  const DeviceClientConnectView({super.key});

  @override
  State<DeviceClientConnectView> createState() => _DeviceClientConnectViewState();
}

class _DeviceClientConnectViewState extends State<DeviceClientConnectView> {
  bool useSnoozeQrCode = false;

  String? dismissQrCode;
  String? snoozeQrCode;

  bool isConnecting = false;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> processQrCode(String qrCode, bool forDismiss) async {
    if (forDismiss) {
      dismissQrCode = qrCode;
    } else {
      snoozeQrCode = qrCode;
    }
    setState(() {});
    return true;
  }

  scanQrCode({required bool forDismiss}) async {
    Future<bool> processQrCodeBare(qrCode) async {
      return processQrCode(qrCode, forDismiss);
    }
    Navigator.pushNamed(context, '/qrReader', arguments: processQrCodeBare);
  }

  tryConnect() async {
    ConnectDevicesDtoResponse? res = await NetworkClientService().connectNewDevice();
    if (res != null) {
      DismissClient dismissClient = res.dismissClient;
      if (dismissQrCode != null) {
        dismissClient.dismissQrCode = dismissQrCode;
      }
      if (snoozeQrCode != null && useSnoozeQrCode) {
        dismissClient.snoozeQrCode = snoozeQrCode;
      }
      DismissClientsService().addDismissClient(dismissClient);
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Alarm connected"),backgroundColor: Colors.green,));
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
      return;
    } else {
      await Future.delayed(Duration(seconds: 3));
      tryConnect();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiService.getDefaultAppBar(),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        if (isConnecting) Center(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Column(children: [
                MediumHeading(text: "Connecting to host",
                    icon: Icons.connect_without_contact),
                SizedBox(
                  width: 350,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "Please try to connect from the other device, once connected, the devices will remember each other."),
                  ),
                ),
                SizedBox(
                  width: 350,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "On the other device you have to connect as the main alarm host"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: LoadingAnimationWidget.flickr(
                    leftDotColor: Colors.white,
                    rightDotColor: Colors.grey,
                    size: 40,
                  ),
                ),
              ],),)
          ),
        ) else Center(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Column(children: [
                MediumHeading(text: "Scan QR Code",
                    icon: Icons.qr_code),
                SizedBox(
                  width: 350,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "Before you can connect to the host, you need to scan QR codes"),
                  ),
                ),
                Padding(padding: const EdgeInsets.only(left: 25.0, right: 25, top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.qr_code),
                      Expanded(child: Text("Use QR code to snooze"),),
                      Checkbox(value: useSnoozeQrCode, onChanged: (val) {
                        setState(() {
                          useSnoozeQrCode = val!;
                        });
                      }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      if (useSnoozeQrCode) Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              scanQrCode(forDismiss: false);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: snoozeQrCode != null
                                    ? Colors.greenAccent
                                    : Colors.white, width: 2,),),
                              shadowColor: Colors.transparent,),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.qr_code),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Scan snooze QR Code"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              scanQrCode(forDismiss: true);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: dismissQrCode != null
                                    ? Colors.greenAccent
                                    : Colors.white, width: 2,),),
                              shadowColor: Colors.transparent,),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.qr_code),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Scan dismiss QR Code"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 45,),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: InlineButton(
                    onPressed: () async {
                      if (dismissQrCode != null && (snoozeQrCode != null || !useSnoozeQrCode)) {
                        setState(() {
                          isConnecting = true;
                        });
                        tryConnect();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(useSnoozeQrCode ? "Please scan both QR codes first" : "Please scan the QR code first"), backgroundColor: Colors.red,));
                      }
                    },
                    text: "Connect",
                    icon: Icons.connect_without_contact,
                  ),
                ),
              ],),)
          ),
        ),
      ]),
    );
  }
}
