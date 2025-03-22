import 'package:alarm_app/models/alarm.dart';
import 'package:alarm_app/models/dissmissClient.dart';
import 'package:alarm_app/models/dto/alarms/AlarmDtoRequest.dart';
import 'package:alarm_app/models/dto/alarms/AlarmDtoResponse.dart';
import 'package:alarm_app/services/network/NetworkClientService.dart';
import 'package:alarm_app/services/uiService.dart';
import 'package:alarm_app/utils/timeUtil.dart';
import 'package:alarm_app/widgets/inlineButton.dart';
import 'package:alarm_app/widgets/mediumHeading.dart';
import 'package:flutter/material.dart';

class DismissAlarmView extends StatefulWidget {
  const DismissAlarmView({super.key});

  @override
  State<DismissAlarmView> createState() => _DismissAlarmViewState();
}

class _DismissAlarmViewState extends State<DismissAlarmView> {
  bool dismissLoading = false;
  bool snoozeLoading = false;

  AlarmEntity? alarm;
  DismissClient? selectedClient;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is List) {
      alarm = args[0];
      selectedClient = args[1];
    }
  }

  Future<void> dismiss() async {
    String? scannedCode;
    await Navigator.pushNamed(context, '/qrReader', arguments: (code) async {
      if (selectedClient?.qrCode != null && code == selectedClient!.qrCode) {
        scannedCode = code;
        return true;
      } else {
        return false;
      }
    });

    if (scannedCode == selectedClient?.qrCode) {
      AlarmDtoRequest req = AlarmDtoRequest();
      req.alarmId = alarm!.id;
      AlarmDtoResponse? res = await NetworkClientService().dismissAlarm(selectedClient!.deviceId!, req);
      if (res == null || res.success != true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to dismiss alarm")));
        }
      } else {
        if (mounted) {
          Navigator.pop(context);
        }
      }
    }
  }

  Future<void> snooze() async {
    AlarmDtoRequest req = AlarmDtoRequest();
    req.alarmId = alarm!.id;
    AlarmDtoResponse? res = await NetworkClientService().snoozeAlarm(
        selectedClient!.deviceId!, req);
    if (res == null || res.success != true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to snooze alarm")));
      }
    } else {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiService.getDefaultAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Dismiss Alarm',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            MediumHeading(text: alarm?.title ?? "Alarm", icon: Icons.alarm_off),
            Text(
              alarm!.description,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Text(
              TimeUtil.getFormattedTime(alarm?.schedule.hour ?? 0, alarm?.schedule.minute ?? 0),
              style: TextStyle(fontSize: 50, color: Colors.white),
            ),
            SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InlineButton(onPressed: () async {
                await dismiss();
              }, icon: Icons.alarm_off, text: "Dismiss", height: 100,)
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InlineButton(onPressed: () async {
                await snooze();
              }, icon: Icons.snooze, text: "Snooze", height: 100,)
            ),

          ],
        ),
      ),
    );
  }
}
