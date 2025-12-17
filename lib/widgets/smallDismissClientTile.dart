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
        elevation: 3,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: sizeHeight,
              maxHeight: sizeHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.devices_sharp,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dismissClient.deviceName ?? "Unnamed device",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dismissClient.deviceId ?? "",
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: Theme.of(context).colorScheme.error,
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
      ),
    );
  }
}
