import 'package:alarm_app/models/dissmissClient.dart';
import 'package:alarm_app/services/alarmStorageService.dart';

class DismissClientsService {
  DismissClientsService._();
  static final DismissClientsService _instance = DismissClientsService._();
  factory DismissClientsService() => _instance;

  bool _isInicialized = false;
  List<DismissClient> dismissClients = new List.empty(growable: true);

  Future<void> init() async {
    if (_isInicialized) return;
    _isInicialized = true;
    for (var alarm in await StorageService.readDismissableClients()) {
      dismissClients.add(alarm);
    }
  }
  List<DismissClient> getDismissClients() {
    return dismissClients;
  }

  void addDismissClient(DismissClient dismissClient) {
    if (!_isInicialized) {
      throw Exception("DismissClientsService not inicialized");
    }
    dismissClients.add(dismissClient);
    StorageService.writeDismissableClient(dismissClients);
  }

  void removeDismissClient(DismissClient dismissClient) {
    if (!_isInicialized) {
      throw Exception("DismissClientsService not inicialized");
    }
    dismissClients.remove(dismissClient);
    StorageService.writeDismissableClient(dismissClients);
  }
}