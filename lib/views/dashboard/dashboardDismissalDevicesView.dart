
import 'package:alarm_app/models/dissmissClient.dart';
import 'package:alarm_app/services/dismissClientsService.dart';
import 'package:alarm_app/widgets/mediumHeading.dart';
import 'package:alarm_app/widgets/smallDismissClientTile.dart';
import 'package:flutter/material.dart';

class DashboardDismissableView extends StatefulWidget {
  const DashboardDismissableView({super.key});

  @override
  State<DashboardDismissableView> createState() => _DashboardDismissableViewState();
}

class _DashboardDismissableViewState extends State<DashboardDismissableView> {

  List<DismissClient> dismissClients = DismissClientsService().getDismissClients();

  @override
  Widget build(BuildContext context) {
    bool vertical = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Flex(
            direction: vertical ? Axis.vertical : Axis.horizontal,
            children: [
              Expanded(
                child: Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MediumHeading(text: "Dismiss alarm on device", icon: Icons.alarm_off),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.start,
                          children: [
                            ...dismissClients.map((e) => SmallDismissClientTile(dismissClient: e, deleteCallback: () {
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                  title: Text("Delete dismiss client"),
                                  content: Text("Are you sure you want to delete this dismiss client?"),
                                  actions: [
                                    TextButton(onPressed: () {
                                      Navigator.of(context).pop();
                                    }, child: Text("Cancel")),
                                    TextButton(onPressed: () {
                                      DismissClientsService().removeDismissClient(e);
                                      setState(() {});
                                    }, child: Text("Delete")),
                                  ],
                                );
                              });
                            },onClick: () {
                              setState(() {
                                Navigator.of(context).pushNamed("/dismiss/alarmlist", arguments: e);
                              });
                            },)),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      resizeToAvoidBottomInset: true,
    );
  }
}
