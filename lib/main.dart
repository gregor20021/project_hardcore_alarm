import 'package:alarm_app/views/connect/deviceHostConnectView.dart';
import 'package:alarm_app/views/dashboard/dashboardWrapper.dart';
import 'package:alarm_app/views/dismiss/dismissAlarmListView.dart';
import 'package:alarm_app/views/dismiss/dismissAlarmView.dart';
import 'package:alarm_app/views/connect/deviceClientConnectView.dart';
import 'package:alarm_app/views/ring/alarmRingView.dart';
import 'package:alarm_app/views/alarm/alarmEditView.dart';
import 'package:alarm_app/views/dismiss/qrCodeScanner.dart';
import 'package:alarm_app/views/splashScreen.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    globals.navigatorKey = navigatorKey;
    return MaterialApp(
      title: 'Hardcore alarm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        brightness: Brightness.dark,
      ),
      routes: {
        '/': (context) => const SplashView(),
        '/dashboard': (context) => const DashboardWrapper(),

        '/alarm/edit': (context) => const AlarmEditView(),

        '/connect/client': (context) => const DeviceClientConnectView(),
        '/connect/host' : (context) => const DeviceHostConnectView(),

        '/alarm/ring': (context) => const AlarmRingView(),

        '/qrReader': (context) => const QrCodeScanner(),

        '/dismiss/alarmlist': (context) => const DismissAlarmListView(),
        '/dismiss': (context) => const DismissAlarmView(),
      },
      navigatorKey: navigatorKey,
    );
  }
}
