import 'package:flutter/material.dart';
import 'package:alarm_app/services/httpServerService.dart';

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
      width: 280,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.alarm,
                              size: 32,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Hardcore Alarm',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'For the toughest sleepers',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Text(
                      'CONNECTIONS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.smartphone,
                    title: 'Connect as Host',
                    subtitle: 'Share alarms with devices',
                    onTap: () => Navigator.of(context).pushNamed('/connect/host'),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.devices,
                    title: 'Connect as Client',
                    subtitle: 'Receive alarms from host',
                    onTap: () => Navigator.of(context).pushNamed('/connect/client'),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Divider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    child: Text(
                      'WEB ACCESS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  StatefulBuilder(
                    builder: (context, setState) {
                      final serverService = HttpServerService();
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: serverService.isRunning
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.surface,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: serverService.isRunning
                                      ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.web,
                                  color: serverService.isRunning
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'HTTP Server',
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    serverService.isRunning
                                        ? serverService.serverUrl ?? 'Running'
                                        : 'Enable web access',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: serverService.isRunning
                                          ? Theme.of(context).colorScheme.primary
                                          : null,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text("Enabled:"),
                                      Spacer(),
                                      Switch(
                                        value: serverService.isRunning,
                                        onChanged: (bool value) async {
                                          if (value) {
                                            if (context.mounted) {
                                              final result = await Navigator.of(context).pushNamed('/connect/webserver');
                                              if (result != true) {
                                                setState(() {});
                                                return;
                                              }
                                            }
                                      
                                            final success = await serverService.start();
                                            if (success && context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Server started: ${serverService.serverUrl}'),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            } else if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Failed to start server'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          } else {
                                            await serverService.stop();
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Server stopped')),
                                              );
                                            }
                                          }
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              )
            : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}