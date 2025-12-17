import 'package:alarm/alarm.dart';
import 'package:alarm_app/services/alarmService.dart';
import 'package:alarm_app/services/dismissClientsService.dart';
import 'package:alarm_app/services/uiService.dart';
import 'package:alarm_app/views/dashboard/dashboardAlarmView.dart';
import 'package:alarm_app/views/dashboard/dashboardDismissalDevicesView.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class DashboardWrapper extends StatefulWidget {
  const DashboardWrapper({super.key});

  @override
  State<DashboardWrapper> createState() => _DashboardWrapperState();
}

class _DashboardWrapperState extends State<DashboardWrapper> {
  CarouselSliderController carouselController = CarouselSliderController();
  int currentIndex = 0;
  Function? _dismissClientsListener;

  @override
  void initState() {
    super.initState();
    _dismissClientsListener = () {
      if (mounted) {
        setState(() {});
      }
    };
    DismissClientsService().addListener(_dismissClientsListener!);
  }

  @override
  void dispose() {
    if (_dismissClientsListener != null) {
      DismissClientsService().removeListener(_dismissClientsListener!);
    }
    super.dispose();
  }

  bool _hasNonServerClients() {
    return DismissClientsService()
        .getDismissClients()
        .where((client) => client.deviceId != 'server')
        .isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final hasDevices = _hasNonServerClients();
    final carouselItems = hasDevices
        ? [
            const DashboardAlarmView(),
            const DashboardDismissableView(),
          ]
        : [
            const DashboardAlarmView(),
          ];

    return Scaffold(
      endDrawer: UiService.getDrawer(context),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, layout) {
              if (!hasDevices) {
                return const DashboardAlarmView();
              }

              return CarouselSlider(
                items: carouselItems,
                options: CarouselOptions(
                  height: layout.maxHeight,
                  viewportFraction: 1,
                  initialPage: currentIndex,
                  enableInfiniteScroll: false,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                     });
                  },
                ),
                carouselController: carouselController,
              );
            }
          ),
          Positioned(
            top: 40,
            right: 16,
            child: Builder(
              builder: (BuildContext scaffoldContext) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                    onPressed: () {
                      Scaffold.of(scaffoldContext).openEndDrawer();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      extendBody: false,
      bottomNavigationBar: !hasDevices
          ? null
          : Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        carouselController.jumpToPage(0);
                      },
                      icon: Icon(
                        Icons.alarm,
                        size: currentIndex == 0 ? 35 : 22,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        carouselController.jumpToPage(1);
                      },
                      icon: Icon(
                        Icons.alarm_off,
                        size: currentIndex == 1 ? 35 : 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
