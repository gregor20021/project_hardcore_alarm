import 'package:alarm_app/services/httpServerService.dart';
import 'package:alarm_app/services/dismissClientsService.dart';
import 'package:alarm_app/widgets/screenHeading.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class WebServerQrSetupView extends StatefulWidget {
  const WebServerQrSetupView({super.key});

  @override
  State<WebServerQrSetupView> createState() => _WebServerQrSetupViewState();
}

class _WebServerQrSetupViewState extends State<WebServerQrSetupView> {
  String? dismissQrCode;
  String? snoozeQrCode;
  bool useSnoozeQrCode = false;

  @override
  void initState() {
    super.initState();
    _loadExistingQrCodes();
  }

  void _loadExistingQrCodes() {
    final dismissClients = DismissClientsService().dismissClients;
    final serverClient = dismissClients.where((c) => c.deviceId == 'server').toList();

    if (serverClient.isNotEmpty) {
      setState(() {
        dismissQrCode = serverClient.first.dismissQrCode;
        snoozeQrCode = serverClient.first.snoozeQrCode;
        useSnoozeQrCode = snoozeQrCode != null && snoozeQrCode!.isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool allScanned = dismissQrCode != null && (!useSnoozeQrCode || snoozeQrCode != null);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ScreenHeading(text: "Web Server QR Setup", icon: Icons.qr_code_scanner),
              const SizedBox(height: 20),
              const Text(
                "Scan the QR codes you want to use for dismissing and snoozing alarms from the web interface.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),

              // Dismiss QR Code
              Card(
                child: ListTile(
                  leading: Icon(
                    dismissQrCode != null ? Icons.check_circle : Icons.qr_code,
                    color: dismissQrCode != null ? Colors.green : null,
                  ),
                  title: const Text("Dismiss QR Code"),
                  subtitle: Text(dismissQrCode ?? "Not scanned"),
                  trailing: ElevatedButton(
                    onPressed: () => _scanQrCode(isDismiss: true),
                    child: const Text("Scan"),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Use Snooze QR Code Toggle
              SwitchListTile(
                title: const Text("Use separate QR code for snooze"),
                value: useSnoozeQrCode,
                onChanged: (value) {
                  setState(() {
                    useSnoozeQrCode = value;
                    if (!value) {
                      snoozeQrCode = null;
                    }
                  });
                },
              ),
              const SizedBox(height: 10),

              // Snooze QR Code (if enabled)
              if (useSnoozeQrCode)
                Card(
                  child: ListTile(
                    leading: Icon(
                      snoozeQrCode != null ? Icons.check_circle : Icons.qr_code,
                      color: snoozeQrCode != null ? Colors.green : null,
                    ),
                    title: const Text("Snooze QR Code"),
                    subtitle: Text(snoozeQrCode ?? "Not scanned"),
                    trailing: ElevatedButton(
                      onPressed: () => _scanQrCode(isDismiss: false),
                      child: const Text("Scan"),
                    ),
                  ),
                ),

              const SizedBox(height: 40),

              // Complete button
              ElevatedButton(
                onPressed: allScanned ? _completeSetup : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text("Complete Setup", style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _scanQrCode({required bool isDismiss}) async {
    String? scannedCode;
    await Navigator.of(context).pushNamed('/qrReader', arguments: (String code) async {
      scannedCode = code;
      return true;
    });

    if (scannedCode != null && scannedCode is String) {
      setState(() {
        if (isDismiss) {
          dismissQrCode = scannedCode;
        } else {
          snoozeQrCode = scannedCode;
        }
      });
    }
  }

  void _completeSetup() {
    if (dismissQrCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please scan the dismiss QR code"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Register the QR codes with the HTTP server
    HttpServerService().registerServerQrCodes(dismissQrCode!, snoozeQrCode);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Web server QR codes configured"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).pop(true);
  }
}
