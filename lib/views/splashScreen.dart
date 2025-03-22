import 'dart:developer';

import 'package:alarm_app/services/alarmService.dart';
import 'package:alarm_app/services/appIdService.dart';
import 'package:alarm_app/services/dismissClientsService.dart';
import 'package:alarm_app/services/network/NetworkHostService.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  bool loading = false;


  loadApp() {
    //preload stage
    Future.delayed(const Duration(milliseconds: 400), () async {
      if(mounted) {
        setState(() {
          loading = true;
        });

        await AppIdService().init();

        await AlarmService().init();

        await DismissClientsService().init();

        print(AppIdService().appId);

        await NetworkHostService().startBroadcasting();

        Future.delayed(const Duration(milliseconds: 700), () async {
          if(mounted) {
            Navigator.pushReplacementNamed(context, '/dashboard');
          }
        });
      }
    });
  }
  @override
  void initState() {
    super.initState();
    loadApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.access_alarms, size: 70,),
                  Text("Hardcore alarm", style: TextStyle(fontSize: 30)),
                  Text("Alarm for the toughest of sleepers"),
                ],
              ),
            ),
          ),
          loading ? Expanded(
            child: Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Theme.of(context).primaryColor,
                size: 40,
              ),
            ),
          ) : Spacer(),
        ],
      ),
    );
  }
}
