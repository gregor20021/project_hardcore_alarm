import 'package:flutter/material.dart';

class UiService {
  UiService._();

  static AppBar getDefaultAppBar() {
    return AppBar(
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Icon(Icons.alarm),
          ),
          const Text('Alarm'),
        ],
      ),
      scrolledUnderElevation: 0.0,
    );
  }

  static Drawer getDrawer(BuildContext context) {
    return Drawer(
      width: 240,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.alarm, size: 35),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text('Alarm'),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
                const Text('Alarm for the toughest of sleepers', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.alarm),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text('Dismiss connect as host'),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/connect/host');
            },
          ),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.alarm_off),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text('Dismiss connect as client'),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/connect/client');
            },
          ),
        ],
      ),
    );
  }
}