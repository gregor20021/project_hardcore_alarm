import 'package:alarm_app/models/alarm.dart';
import 'package:alarm_app/services/uiService.dart';
import 'package:alarm_app/utils/timeUtil.dart';
import 'package:alarm_app/widgets/inlineButton.dart';
import 'package:alarm_app/widgets/mediumHeading.dart';
import 'package:flutter/material.dart';

class DismissView extends StatefulWidget {
  const DismissView({super.key});

  @override
  State<DismissView> createState() => _DismissViewState();
}

class _DismissViewState extends State<DismissView> {
  bool dismissLoading = false;
  bool snoozeLoading = false;

  AlarmEntity? alarm;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is AlarmEntity) {
      alarm = args;
    }
  }

  void connectCode() {
    Navigator.pushNamed(context, '/qrReader', arguments: (code) {

    });
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
              'Connect alarms together',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Text(
              'Connect alarms together, choose one as the main alarm host and the other as the dismiss client of the alarm',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: InlineButton(onPressed: () async {

                }, icon: Icons.alarm, text: "Main alarm host",)
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: InlineButton(onPressed: () async {

                }, icon: Icons.alarm_off, text: "Dissmiss client",)
            ),
          ],
        ),
      ),
    );
  }
}
