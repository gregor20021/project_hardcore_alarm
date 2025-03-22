import 'package:alarm_app/models/alarm.dart';
import 'package:alarm_app/models/dissmissClient.dart';
import 'package:alarm_app/services/dismissClientsService.dart';
import 'package:alarm_app/utils/alarmUtil.dart';
import 'package:alarm_app/widgets/weekScheduleIndicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SmallDismissClientTile extends StatelessWidget {
  final Function()? deleteCallback;
  final DismissClient dismissClient;
  final Function()? onClick;

  static const double sizeHeight = 120;
  static const double sizeWidth = 250;

  const SmallDismissClientTile({
    super.key,
    required this.dismissClient,
    this.deleteCallback,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onClick?.call();
      },
      child: Card(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: sizeHeight,
            maxHeight: sizeHeight,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.devices_sharp, size: 40),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dismissClient.deviceName ?? "Unnamed device",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    DismissClientsService().removeDismissClient(dismissClient);
                    deleteCallback?.call();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
