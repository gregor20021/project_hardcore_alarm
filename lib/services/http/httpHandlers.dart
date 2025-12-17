import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:flutter/services.dart';
import 'package:alarm_app/services/alarmService.dart';
import 'package:alarm_app/services/dismissClientsService.dart';
import 'package:alarm_app/services/appIdService.dart';
import 'package:alarm_app/models/alarm.dart';
import 'package:alarm_app/models/alarmSchedule.dart';
import 'package:alarm_app/models/snoozeOptions.dart';

Future<Response> handleGetAlarms(Request request) async {
  try {
    final alarms = AlarmService().getAllAlarms();

    return Response.ok(
      jsonEncode({
        'success': true,
        'alarms': alarms?.map((a) => a.toJson()).toList() ?? [],
      }),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({
        'success': false,
        'error': e.toString(),
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Future<Response> handleCreateAlarm(Request request) async {
  try {
    final bodyString = await request.readAsString();
    final body = jsonDecode(bodyString);

    if (body['alarm'] == null) {
      return Response.badRequest(
        body: jsonEncode({
          'success': false,
          'error': 'Missing alarm data',
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final alarmJson = body['alarm'];
    final alarm = AlarmEntity(
      id: alarmJson['id'] ?? AlarmService().generateId(),
      title: alarmJson['title'] ?? '',
      description: alarmJson['description'] ?? '',
      active: alarmJson['active'] ?? true,
      schedule: AlarmSchedule.fromJson(alarmJson['schedule']),
      soundPath: alarmJson['soundPath'] ?? 'assets/alarm.mp3',
      volume: alarmJson['volume'] ?? 80,
      snoozeOptions: SnoozeOptions.fromJson(alarmJson['snoozeOptions']),
    );

    final success = await AlarmService().addAlarm(alarm);

    if (success) {
      return Response(201,
        body: jsonEncode({
          'success': true,
          'alarm': alarm.toJson(),
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } else {
      return Response.internalServerError(
        body: jsonEncode({
          'success': false,
          'error': 'Failed to create alarm',
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }
  } catch (e) {
    return Response.badRequest(
      body: jsonEncode({
        'success': false,
        'error': e.toString(),
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Future<Response> handleUpdateAlarm(Request request, String id) async {
  try {
    final alarmId = int.tryParse(id);
    if (alarmId == null) {
      return Response.badRequest(
        body: jsonEncode({
          'success': false,
          'error': 'Invalid alarm ID',
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final bodyString = await request.readAsString();
    final body = jsonDecode(bodyString);

    if (body['alarm'] == null) {
      return Response.badRequest(
        body: jsonEncode({
          'success': false,
          'error': 'Missing alarm data',
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final alarmJson = body['alarm'];
    final alarm = AlarmEntity(
      id: alarmId,
      title: alarmJson['title'] ?? '',
      description: alarmJson['description'] ?? '',
      active: alarmJson['active'] ?? true,
      schedule: AlarmSchedule.fromJson(alarmJson['schedule']),
      soundPath: alarmJson['soundPath'] ?? 'assets/alarm.mp3',
      volume: alarmJson['volume'] ?? 80,
      snoozeOptions: SnoozeOptions.fromJson(alarmJson['snoozeOptions']),
    );

    await AlarmService().updateAlarm(alarm);

    return Response.ok(
      jsonEncode({
        'success': true,
        'alarm': alarm.toJson(),
      }),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.badRequest(
      body: jsonEncode({
        'success': false,
        'error': e.toString(),
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Future<Response> handleDeleteAlarm(Request request, String id) async {
  try {
    final alarmId = int.tryParse(id);
    if (alarmId == null) {
      return Response.badRequest(
        body: jsonEncode({
          'success': false,
          'error': 'Invalid alarm ID',
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final success = await AlarmService().deleteAlarm(alarmId);

    return Response.ok(
      jsonEncode({
        'success': success,
      }),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.badRequest(
      body: jsonEncode({
        'success': false,
        'error': e.toString(),
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Future<Response> handleDismissAlarm(Request request, String id) async {
  try {
    final alarmId = int.tryParse(id);
    if (alarmId == null) {
      return Response.badRequest(
        body: jsonEncode({
          'success': false,
          'error': 'Invalid alarm ID',
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final bodyString = await request.readAsString();
    final body = jsonDecode(bodyString);
    final qrCode = body['qrCode'];

    if (qrCode == null || qrCode.toString().isEmpty) {
      return Response.badRequest(
        body: jsonEncode({
          'success': false,
          'error': 'QR code required',
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final clients = DismissClientsService().dismissClients;
    final validQr = clients?.any((c) => c.dismissQrCode == qrCode) ?? false;

    if (!validQr) {
      return Response.badRequest(
        body: jsonEncode({
          'success': false,
          'error': 'Invalid QR code',
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final success = await AlarmService().dismissAlarm(alarmId);

    return Response.ok(
      jsonEncode({
        'success': success,
      }),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.badRequest(
      body: jsonEncode({
        'success': false,
        'error': e.toString(),
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Future<Response> handleSnoozeAlarm(Request request, String id) async {
  try {
    final alarmId = int.tryParse(id);
    if (alarmId == null) {
      return Response.badRequest(
        body: jsonEncode({
          'success': false,
          'error': 'Invalid alarm ID',
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final bodyString = await request.readAsString();
    final body = jsonDecode(bodyString);
    final qrCode = body['qrCode'];

    final clients = DismissClientsService().dismissClients;
    final requiresQr = clients?.any((c) => c.snoozeQrCode != null) ?? false;

    if (requiresQr) {
      if (qrCode == null || qrCode.toString().isEmpty) {
        return Response.badRequest(
          body: jsonEncode({
            'success': false,
            'error': 'QR code required for snooze',
          }),
          headers: {'Content-Type': 'application/json'},
        );
      }

      final validQr = clients?.any((c) => c.snoozeQrCode == qrCode) ?? false;

      if (!validQr) {
        return Response.badRequest(
          body: jsonEncode({
            'success': false,
            'error': 'Invalid QR code',
          }),
          headers: {'Content-Type': 'application/json'},
        );
      }
    }

    final success = await AlarmService().snoozeAlarm(alarmId);

    return Response.ok(
      jsonEncode({
        'success': success,
      }),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.badRequest(
      body: jsonEncode({
        'success': false,
        'error': e.toString(),
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Future<Response> handleGetDismissClients(Request request) async {
  try {
    final clients = DismissClientsService().dismissClients ?? [];

    return Response.ok(
      jsonEncode({
        'clients': clients.map((c) => c.toJson()).toList(),
      }),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({
        'success': false,
        'error': e.toString(),
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Future<Response> handleGetServerInfo(Request request) async {
  try {
    return Response.ok(
      jsonEncode({
        'appId': AppIdService().appId,
        'serverVersion': '1.0.0',
        'deviceName': AppIdService().appId,
      }),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({
        'success': false,
        'error': e.toString(),
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Future<Response> handleServeIndex(Request request) async {
  try {
    final html = await rootBundle.loadString('assets/web/index.html');
    return Response.ok(
      html,
      headers: {'Content-Type': 'text/html'},
    );
  } catch (e) {
    return Response.notFound(
      jsonEncode({
        'success': false,
        'error': 'index.html not found',
      }),
    );
  }
}

Future<Response> handleServeStatic(Request request, String file) async {
  try {
    String contentType = 'text/plain';

    if (file.endsWith('.css')) {
      contentType = 'text/css';
    } else if (file.endsWith('.js')) {
      contentType = 'application/javascript';
    } else if (file.endsWith('.html')) {
      contentType = 'text/html';
    }

    final content = await rootBundle.loadString('assets/web/$file');
    return Response.ok(
      content,
      headers: {'Content-Type': contentType},
    );
  } catch (e) {
    return Response.notFound(
      jsonEncode({
        'success': false,
        'error': 'File not found',
      }),
    );
  }
}
