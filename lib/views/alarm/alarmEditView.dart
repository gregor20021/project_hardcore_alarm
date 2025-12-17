import 'package:alarm_app/models/dto/alarms/AlarmDtoRequest.dart';
import 'package:alarm_app/models/snoozeOptions.dart';
import 'package:alarm_app/models/alarm.dart';
import 'package:alarm_app/models/alarmSchedule.dart';
import 'package:alarm_app/services/alarmService.dart';
import 'package:alarm_app/services/network/NetworkClientService.dart';
import 'package:alarm_app/services/uiService.dart';
import 'package:alarm_app/widgets/editableHeading.dart';
import 'package:alarm_app/widgets/clockEdit.dart';
import 'package:alarm_app/widgets/inlineButton.dart';
import 'package:alarm_app/widgets/inputText.dart';
import 'package:alarm_app/widgets/smallTitle.dart';
import 'package:flutter/material.dart';

class AlarmEditView extends StatefulWidget {
  const AlarmEditView({super.key});

  @override
  State<AlarmEditView> createState() => _AlarmEditViewState();
}

class _AlarmEditViewState extends State<AlarmEditView> {
  TextEditingController headingController = TextEditingController(
    text: 'New Alarm',
  );
  ClockEditController clockController = ClockEditController(
    time: TimeOfDay(hour: 6, minute: 0),
  );
  TextEditingController descriptionController = TextEditingController();
  bool active = true;
  bool vibrate = true;
  bool repeat = true;

  int snoozeMinutes = 5;
  int snoozeRepeat = 0;
  int snoozeDecreaseMinutesPerSnooze = 2;

  String? soundPath = 'assets/alarm.mp3';
  int soundVolume = 80;

  bool monday = true;
  bool tuesday = true;
  bool wednesday = true;
  bool thursday = true;
  bool friday = true;
  bool saturday = true;
  bool sunday = true;

  String? clientId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is List) {
      if (args.isNotEmpty) {
        clientId = args[0];
      }
    }
  }

  bool validateFields() {
    String error = '';
    if (headingController.text.isEmpty) {
      error = 'Please enter a title';
    }
    if (soundPath == null) {
      error = 'Please select the sound';
    }
    if (error.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return false;
    } else {
      return true;
    }
  }

  saveAlarm() async {
    if (!validateFields()) {
      return;
    }

    AlarmEntity alarm = AlarmEntity(
      id: AlarmService().generateId(),
      title: headingController.text,
      description: descriptionController.text,
      active: active,
      schedule: AlarmSchedule(
        hour: clockController.pickedTime.hour,
        minute: clockController.pickedTime.minute,
        repeat: repeat,
        monday: monday,
        tuesday: tuesday,
        wednesday: wednesday,
        thursday: thursday,
        friday: friday,
        saturday: saturday,
        sunday: sunday,
      ),
      soundPath: soundPath!,
      volume: soundVolume,
      snoozeOptions: SnoozeOptions(
        minutes: snoozeMinutes,
        repeat: snoozeRepeat,
        vibrate: vibrate,
        decreaseMinutesPerSnooze: snoozeDecreaseMinutesPerSnooze,
      ),
    );

    if (clientId != null) {
      AlarmDtoRequest alarmDtoRequest = AlarmDtoRequest(alarm: alarm);
      await NetworkClientService().addNewAlarm(clientId!, alarmDtoRequest);
    } else {
      await AlarmService().addAlarm(alarm);
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiService.getDefaultAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 20.0,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: EditableHeading(
                            controller: headingController,
                            icon: Icons.access_alarms,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                          child: ClockEdit(controller: clockController),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 3,
                          ),
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text('M'),
                                        Checkbox(
                                          value: monday,
                                          onChanged: (val) {
                                            setState(() {
                                              monday = val!;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text('T'),
                                        Checkbox(
                                          value: tuesday,
                                          onChanged: (val) {
                                            setState(() {
                                              tuesday = val!;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text('W'),
                                        Checkbox(
                                          value: wednesday,
                                          onChanged: (val) {
                                            setState(() {
                                              wednesday = val!;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text('T'),
                                        Checkbox(
                                          value: thursday,
                                          onChanged: (val) {
                                            setState(() {
                                              thursday = val!;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text('F'),
                                        Checkbox(
                                          value: friday,
                                          onChanged: (val) {
                                            setState(() {
                                              friday = val!;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text('S'),
                                        Checkbox(
                                          value: saturday,
                                          onChanged: (val) {
                                            setState(() {
                                              saturday = val!;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text('S'),
                                        Checkbox(
                                          value: sunday,
                                          onChanged: (val) {
                                            setState(() {
                                              sunday = val!;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        InputField(
                          controller: descriptionController,
                          hintText: 'Description',
                          heading: "Description",
                          headingIcon: Icons.menu_outlined,
                          minLines: 4,
                          maxLines: 4,

                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 20),
                          child: SmallTitle(
                            icon: Icons.alarm,
                            title: "Details",
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.music_note,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Sound',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: const Text('Select'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: StatefulBuilder(
                              builder: (context, volumeSetState) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.volume_up,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          'Volume',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '$soundVolume%',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Slider(
                                      value: soundVolume.toDouble(),
                                      onChanged: (val) {
                                        volumeSetState(() {
                                          soundVolume = val.toInt();
                                        });
                                      },
                                      max: 100,
                                      min: 0,
                                      divisions: 10,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.vibration,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Vibrate',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const Spacer(),
                                StatefulBuilder(
                                  builder: (context, setState) {
                                    return Switch(
                                      value: vibrate,
                                      onChanged: (value) {
                                        setState(() {
                                          vibrate = value;
                                        });
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.notifications_active_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Active',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const Spacer(),
                                StatefulBuilder(
                                  builder: (context, setState) {
                                    return Switch(
                                      value: active,
                                      onChanged: (value) {
                                        setState(() {
                                          active = value;
                                        });
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.repeat,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Repeat',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const Spacer(),
                                StatefulBuilder(
                                  builder: (context, setState) {
                                    return Switch(
                                      value: repeat,
                                      onChanged: (value) {
                                        setState(() {
                                          repeat = value;
                                        });
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: StatefulBuilder(
                              builder: (context, slidersSetState) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.snooze,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          'Snooze',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          'for $snoozeMinutes min',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Slider(
                                      value: snoozeMinutes.toDouble(),
                                      onChanged: (val) {
                                        slidersSetState(() {
                                          snoozeMinutes = val.toInt();
                                          if (snoozeDecreaseMinutesPerSnooze >
                                              snoozeMinutes) {
                                            snoozeDecreaseMinutesPerSnooze =
                                                snoozeMinutes;
                                          }
                                        });
                                      },
                                      max: 20,
                                      min: 1,
                                      divisions: 20,
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.timer_off_sharp,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          'Snooze times',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          snoozeRepeat != 0
                                              ? 'max $snoozeRepeat times'
                                              : 'unlimited',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Slider(
                                      value: snoozeRepeat.toDouble(),
                                      onChanged: (val) {
                                        slidersSetState(() {
                                          snoozeRepeat = val.toInt();
                                        });
                                      },
                                      max: 5,
                                      min: 0,
                                      divisions: 5,
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.trending_down,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          'Decrease',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Spacer(),
                                        Flexible(
                                          child: Text(
                                            snoozeDecreaseMinutesPerSnooze != 0
                                                ? '-$snoozeDecreaseMinutesPerSnooze min/snooze'
                                                : 'No decrease',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Slider(
                                      value: snoozeDecreaseMinutesPerSnooze
                                          .toDouble(),
                                      onChanged: (val) {
                                        slidersSetState(() {
                                          snoozeDecreaseMinutesPerSnooze = val
                                              .toInt();
                                        });
                                      },
                                      max: snoozeMinutes.toDouble(),
                                      min: 0,
                                      divisions: snoozeMinutes,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InlineButton(
                        onPressed: () async {
                          await saveAlarm();
                        },
                        icon: Icons.add,
                        text: "Add alarm",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
