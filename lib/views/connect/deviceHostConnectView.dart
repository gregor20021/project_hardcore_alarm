import 'package:alarm_app/models/alarm.dart';
import 'package:alarm_app/services/alarmService.dart';
import 'package:alarm_app/services/network/NetworkConnectHostService.dart';
import 'package:alarm_app/services/uiService.dart';
import 'package:alarm_app/widgets/mediumHeading.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:zeroconnect/zeroconnect.dart';

class DeviceHostConnectView extends StatefulWidget {
  const DeviceHostConnectView({super.key});

  @override
  State<DeviceHostConnectView> createState() => _DeviceHostConnectViewState();
}

class _DeviceHostConnectViewState extends State<DeviceHostConnectView> {

  NetworkConnectHostService networkHostService = NetworkConnectHostService();

  tryConnect() async {
    NetworkConnectHostService().exposeConnectNewDevice(onSuccessCallback: () {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Devices connected"),backgroundColor: Colors.green,));
      Navigator.of(context).popUntil((route) => route.isFirst);
    }, onErrorCallback: () {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error connecting, try again"),backgroundColor: Colors.red,));
    });
  }

  @override
  void initState() {
    super.initState();
    tryConnect();
  }

  @override
  void dispose() {
    super.dispose();
    NetworkConnectHostService().close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiService.getDefaultAppBar(),
      body: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
        Center(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Column(children: [
                MediumHeading(text: "Connecting to client",
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
                        "On the other device, go to the connect screen and scan the QR code."),
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
        ),
      ],),
    );
  }
}
