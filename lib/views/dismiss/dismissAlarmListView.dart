import 'package:alarm_app/models/dissmissClient.dart';
import 'package:alarm_app/models/dto/alarms/AlarmDtoRequest.dart';
import 'package:alarm_app/models/dto/alarms/AlarmDtoResponse.dart';
import 'package:alarm_app/services/alarmService.dart';
import 'package:alarm_app/services/network/NetworkClientService.dart';
import 'package:alarm_app/services/uiService.dart';
import 'package:alarm_app/widgets/mediumHeading.dart';
import 'package:alarm_app/widgets/smallAlarmTile.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DismissAlarmListView extends StatefulWidget {
  const DismissAlarmListView({super.key});

  @override
  State<DismissAlarmListView> createState() => _DismissAlarmListViewState();
}

class _DismissAlarmListViewState extends State<DismissAlarmListView> {
  NetworkClientService networkClientService = NetworkClientService();

  bool loaded = false;
  DismissClient? selectedClient;
  AlarmDtoResponse? res;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is DismissClient) {
      selectedClient = args;
      loadData();
    }
  }

  loadData() async {
    if (mounted) {
      setState(() {
        loaded = false;
      });
    }
    try {
      res = await networkClientService.getAlarms(
        selectedClient!.deviceId!,
        AlarmDtoRequest(),
      );
      if (mounted) {
        setState(() {
          loaded = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to load data")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool vertical = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: UiService.getDefaultAppBar(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Skeletonizer(
          enabled: !loaded,
          child: Center(
            child: Flex(
              direction: vertical ? Axis.vertical : Axis.horizontal,
              children: [
                Expanded(
                  child: Flex(
                    direction: Axis.vertical,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MediumHeading(
                          text: "Dismissable alarms",
                          icon: Icons.alarm_off,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.start,
                            children: [
                              for (var e in res?.alarms ?? [])
                                SmallAlarmTile(
                                  alarm: e,
                                  onClick: () {
                                    Navigator.of(context).pushNamed(
                                      "/dismiss",
                                      arguments: [e, selectedClient],
                                    );
                                  },
                                  onDeleted: (alarmEntity) async {
                                    AlarmDtoRequest e = AlarmDtoRequest();
                                    e.alarmId = alarmEntity.id;
                                    await networkClientService.deleteAlarm(
                                      selectedClient!.deviceId!,
                                      e,
                                    );
                                    loadData();
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            "/alarm/edit",
                            arguments: [selectedClient!.deviceId],
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.add),
                              ),
                              Text("Add alarm"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      resizeToAvoidBottomInset: true,
    );
  }
}
