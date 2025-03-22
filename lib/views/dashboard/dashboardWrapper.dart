import 'package:alarm/alarm.dart';
import 'package:alarm_app/services/alarmService.dart';
import 'package:alarm_app/services/dismissClientsService.dart';
import 'package:alarm_app/services/uiService.dart';
import 'package:alarm_app/views/dashboard/dashboardAlarmView.dart';
import 'package:alarm_app/views/dashboard/dashboardDismissalDevicesView.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class DashboardWrapper extends StatelessWidget {
  const DashboardWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    CarouselSliderController carouselController = CarouselSliderController();
    int currentIndex = 0;

    if (AlarmService().alarms?.isNotEmpty ?? false) {
      currentIndex = 0;
    } else if (DismissClientsService().getDismissClients().isNotEmpty) {
      currentIndex = 1;
    }

    return StatefulBuilder(
      builder: (context, setState) {
        return Scaffold(
          appBar: UiService.getDefaultAppBar(),
          endDrawer: UiService.getDrawer(context),
          body: LayoutBuilder(
              builder: (context, layout) {
                return CarouselSlider(items: [
                  DashboardAlarmView(),
                  DashboardDismissableView(),
                ], options: CarouselOptions(
                  height: layout.maxHeight,
                  viewportFraction: 1,
                  initialPage: currentIndex,
                  enableInfiniteScroll: false,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    currentIndex = index;
                    setState(() {});
                  },
                ), carouselController: carouselController,);
              }
          ),
          extendBody: false,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: Offset(0, -1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: () {
                    carouselController.jumpToPage(0);
                  }, icon: Icon(Icons.alarm, size: currentIndex == 0 ? 35 : 22,)),
                  IconButton(onPressed: () {
                    carouselController.jumpToPage(1);
                  }, icon: Icon(Icons.alarm_off, size: currentIndex == 1 ? 35 : 22,)),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
