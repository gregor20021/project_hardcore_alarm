import 'package:alarm_app/models/dto/connect/connectDevicesDtoResponse.dart';
import 'package:alarm_app/services/dismissClientsService.dart';
import 'package:alarm_app/services/network/NetworkClientService.dart';
import 'package:alarm_app/services/uiService.dart';
import 'package:alarm_app/widgets/mediumHeading.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DeviceClientConnectView extends StatefulWidget {
  const DeviceClientConnectView({super.key});

  @override
  State<DeviceClientConnectView> createState() => _DeviceClientConnectViewState();
}

class _DeviceClientConnectViewState extends State<DeviceClientConnectView> {
  String? qrCode;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> processQrCode(String qrCode) async {
    this.qrCode = qrCode;
    setState(() {});
    tryConnect();
    return true;
  }

  scanQrCode() {
    Navigator.pushNamed(context, '/qrReader', arguments: processQrCode);
  }

  tryConnect() async {
    ConnectDevicesDtoResponse? res = await NetworkClientService().connectNewDevice();
    if (res != null) {
      res.dismissClient.qrCode = qrCode;
      DismissClientsService().addDismissClient(res.dismissClient);
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
        if (qrCode != null) Center(
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
                        "Before you can connect to an alarm, you need to scan the qr code from the other device"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      scanQrCode();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.qr_code),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Scan QR Code"),
                        ),
                      ],
                    ),
                  ),
                )
              ],),)
          ),
        ),
      ]),
    );
  }
}
