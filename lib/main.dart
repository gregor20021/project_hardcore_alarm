import 'package:alarm_app/views/connect/deviceHostConnectView.dart';
import 'package:alarm_app/views/dashboard/dashboardWrapper.dart';
import 'package:alarm_app/views/dismiss/dismissAlarmListView.dart';
import 'package:alarm_app/views/dismiss/dismissAlarmView.dart';
import 'package:alarm_app/views/connect/deviceClientConnectView.dart';
import 'package:alarm_app/views/ring/alarmRingView.dart';
import 'package:alarm_app/views/alarm/alarmEditView.dart';
import 'package:alarm_app/views/dismiss/qrCodeScanner.dart';
import 'package:alarm_app/views/splashScreen.dart';
import 'package:alarm_app/views/connect/webServerQrSetupView.dart';
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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFFFF9800),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF9800),
          secondary: Color(0xFFFFB74D),
          surface: Color(0xFF1E1E1E),
          background: Color(0xFF121212),
          error: Color(0xFFCF6679),
          onPrimary: Colors.black,
          onSecondary: Colors.black,
          onSurface: Colors.white,
          onBackground: Colors.white,
          onError: Colors.black,
        ),
        cardColor: const Color(0xFF1E1E1E),
        dialogBackgroundColor: const Color(0xFF1E1E1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF9800),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E1E1E),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2A2A2A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFFF9800), width: 2),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const Color(0xFFFF9800);
            }
            return Colors.transparent;
          }),
          checkColor: MaterialStateProperty.all(Colors.black),
        ),
        sliderTheme: const SliderThemeData(
          activeTrackColor: Color(0xFFFF9800),
          inactiveTrackColor: Color(0xFF2A2A2A),
          thumbColor: Color(0xFFFF9800),
          overlayColor: Color(0x29FF9800),
        ),
      ),
      routes: {
        '/': (context) => const SplashView(),
        '/dashboard': (context) => const DashboardWrapper(),

        '/alarm/edit': (context) => const AlarmEditView(),

        '/connect/client': (context) => const DeviceClientConnectView(),
        '/connect/host' : (context) => const DeviceHostConnectView(),
        '/connect/webserver': (context) => const WebServerQrSetupView(),

        '/alarm/ring': (context) => const AlarmRingView(),

        '/qrReader': (context) => const QrCodeScanner(),

        '/dismiss/alarmlist': (context) => const DismissAlarmListView(),
        '/dismiss': (context) => const DismissAlarmView(),
      },
      navigatorKey: navigatorKey,
    );
  }
}
