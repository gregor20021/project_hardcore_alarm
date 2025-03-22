import 'dart:convert';
import 'dart:io';

import 'package:alarm_app/models/alarm.dart';
import 'package:alarm_app/models/dissmissClient.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  StorageService._();

  static final String _alarmFileName = 'alarms.json';
  static final String _dismissableClientFileName = 'dismissclient.json';

  static Future<Directory> get _fileLocation async {
    return await getApplicationDocumentsDirectory();
  }

  static Future<void> writeAlarms(List<AlarmEntity> alarms) async {
    final file = File('${(await _fileLocation).path}/$_alarmFileName');
    final alarmsJson = alarms.map((alarm) => alarm.toJson()).toList();
    final alarmsString = jsonEncode(alarmsJson);
    if (await file.exists()) {
      await file.delete();
    }
    await file.writeAsString(alarmsString);
  }

  static Future<List<AlarmEntity>> readAlarms() async {
    try {
      final file = File('${(await _fileLocation).path}/$_alarmFileName');
      final alarmsString = await file.readAsString();
      final alarmsJson = jsonDecode(alarmsString);
      return alarmsJson.map<AlarmEntity>((json) => AlarmEntity.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<List<DismissClient>> writeDismissableClient(List<DismissClient> dismissClients) async {
    final file = File('${(await _fileLocation).path}/$_dismissableClientFileName');
    final dismissClientsJson = dismissClients.map((dismissClient) => dismissClient.toJson()).toList();
    final dismissClientsString = jsonEncode(dismissClientsJson);
    if (await file.exists()) {
      await file.delete();
    }
    await file.writeAsString(dismissClientsString);
    return dismissClients;
  }

  static Future<List<DismissClient>> readDismissableClients() async {
    try {
      final file = File('${(await _fileLocation).path}/$_dismissableClientFileName');
      final dismissClientsString = await file.readAsString();
      final dismissClientsJson = jsonDecode(dismissClientsString);
      return dismissClientsJson.map<DismissClient>((json) => DismissClient.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
}