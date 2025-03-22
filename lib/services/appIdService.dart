import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AppIdService {
  AppIdService._();

  static final AppIdService _instance = AppIdService._();

  factory AppIdService() => _instance;

  late String _appId;

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('appId')) {
      _appId = prefs.getString('appId')!;
    } else {
      _appId = _prepareId(Uuid().v4());
      prefs.setString('appId', _appId);
    }
  }

  static String _prepareId(String id) {
    return id.substring(0, 12).replaceAll('-', '');
  }

  String get appId => _appId;
}