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
  TextEditingController headingController = TextEditingController(text: 'New Alarm');
  ClockEditController clockController = ClockEditController(time: TimeOfDay(hour: 6, minute: 0));
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
      if(args.isNotEmpty) {
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error),
      ));
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
      id : AlarmService().generateId(),
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

    if(clientId != null) {
      AlarmDtoRequest alarmDtoRequest = AlarmDtoRequest(
        alarm: alarm,
      );
      await NetworkClientService().addNewAlarm(clientId!, alarmDtoRequest);
    } else {
      await AlarmService().addAlarm(alarm);
    }

    if(mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiService.getDefaultAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
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
                        child: ClockEdit(controller: clockController,),
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
                                      Checkbox(value: monday, onChanged: (val) {
                                        setState(() {
                                          monday = val!;
                                        });
                                      }),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('T'),
                                      Checkbox(value: tuesday, onChanged: (val) {
                                        setState(() {
                                          tuesday = val!;
                                        });
                                      }),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('W'),
                                      Checkbox(value: wednesday, onChanged: (val) {
                                        setState(() {
                                          wednesday = val!;
                                        });
                                      }),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('T'),
                                      Checkbox(value: thursday, onChanged: (val) {
                                        setState(() {
                                          thursday = val!;
                                        });
                                      }),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('F'),
                                      Checkbox(value: friday, onChanged: (val) {
                                        setState(() {
                                          friday = val!;
                                        });
                                      }),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('S'),
                                      Checkbox(value: saturday, onChanged: (val) {
                                        setState(() {
                                          saturday = val!;
                                        });
                                      }),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('S'),
                                      Checkbox(value: sunday, onChanged: (val) {
                                        setState(() {
                                          sunday = val!;
                                        });
                                      }),
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
                        child: SmallTitle(icon: Icons.alarm, title: "Details"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 3,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.music_note),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const Text('Sound'),
                            ),
                            Spacer(),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Select'),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 3,
                        ),                        child: StatefulBuilder(
                          builder: (context, volumeSetState) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.volume_up),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Text('Volume'),
                                    ),
                                    Spacer(),
                                    Text('Volume: $soundVolume'),
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
                                  divisions: 10,),
                              ],
                            );
                          }
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 3,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.vibration),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const Text('Vibrate'),
                            ),
                            Spacer(),
                            StatefulBuilder(
                              builder: (context, setState) {
                                return Checkbox(
                                  value: vibrate,
                                  onChanged: (value) {
                                    setState(() {
                                      vibrate = value!;
                                    });
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 3,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.notifications_active_outlined),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const Text('Active'),
                            ),
                            Spacer(),
                            StatefulBuilder(
                              builder: (context, setState) {
                                return Checkbox(
                                  value: active,
                                  onChanged: (value) {
                                    setState(() {
                                      active = value!;
                                    });
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 3,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.repeat),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const Text('Repeat'),
                            ),
                            Spacer(),
                            StatefulBuilder(
                              builder: (context, setState) {
                                return Checkbox(
                                  value: repeat,
                                  onChanged: (value) {
                                    setState(() {
                                      repeat = value!;
                                    });
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 10), 
                        child: StatefulBuilder(
                          builder: (context, slidersSetState) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.snooze),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Text('Snooze'),
                                    ),
                                    Spacer(),
                                    Text('for $snoozeMinutes minutes'),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Slider(value: snoozeMinutes.toDouble(),
                                    onChanged: (val) {
                                      slidersSetState(() {
                                        snoozeMinutes = val.toInt();
                                        if (snoozeDecreaseMinutesPerSnooze > snoozeMinutes) {
                                          snoozeDecreaseMinutesPerSnooze = snoozeMinutes;
                                        }
                                      });
                                    },
                                    max: 20,
                                    min: 1,
                                    divisions: 20,),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.timer_off_sharp),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Text('Snooze times'),
                                    ),
                                    Spacer(),
                                    if(snoozeRepeat != 0) Text('maximum $snoozeRepeat times') else const Text('unlimited times'),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Slider(value: snoozeRepeat.toDouble(),
                                    onChanged: (val) {
                                      slidersSetState(() {
                                        snoozeRepeat = val.toInt();
                                      });
                                    },
                                    max: 5,
                                    min: 0,
                                    divisions: 5,),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.trending_down),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Text('Decrease'),
                                    ),
                                    if(snoozeDecreaseMinutesPerSnooze !=
                                        0) Expanded(child: Text(
                                      'Decrese for $snoozeDecreaseMinutesPerSnooze minutes per snooze',
                                      textAlign: TextAlign.end,),
                                    ) else
                                      Expanded(child: const Text('No decrease',
                                        textAlign: TextAlign.end,),
                                      ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Slider(value: snoozeDecreaseMinutesPerSnooze.toDouble(),
                                    onChanged: (val) {
                                      slidersSetState(() {
                                        snoozeDecreaseMinutesPerSnooze = val.toInt();
                                      });
                                    },
                                    max: snoozeMinutes.toDouble(),
                                    min: 0,
                                    divisions: snoozeMinutes,),
                                ),
                              ],
                            );
                          }
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
                      child: InlineButton(onPressed: () async {
                        await saveAlarm();
                      },
                        icon: Icons.add,
                        text: "Add alarm",)
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
