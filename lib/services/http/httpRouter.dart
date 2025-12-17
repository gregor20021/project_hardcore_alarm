import 'package:shelf_router/shelf_router.dart';
import 'package:alarm_app/services/http/httpHandlers.dart';

Router createRouter() {
  final router = Router();

  router.get('/api/alarms', handleGetAlarms);
  router.post('/api/alarms', handleCreateAlarm);
  router.put('/api/alarms/<id>', handleUpdateAlarm);
  router.delete('/api/alarms/<id>', handleDeleteAlarm);
  router.post('/api/alarms/<id>/dismiss', handleDismissAlarm);
  router.post('/api/alarms/<id>/snooze', handleSnoozeAlarm);
  router.get('/api/dismiss-clients', handleGetDismissClients);
  router.get('/api/server-info', handleGetServerInfo);

  router.get('/', handleServeIndex);
  router.get('/<file>', handleServeStatic);

  return router;
}
