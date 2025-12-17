import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:alarm_app/services/http/httpRouter.dart';
import 'package:alarm_app/services/http/httpMiddleware.dart';
import 'package:alarm_app/services/dismissClientsService.dart';
import 'package:alarm_app/models/dissmissClient.dart';
import 'package:alarm_app/services/sslCertificateService.dart';

class HttpServerService {
  HttpServerService._();
  static final HttpServerService _instance = HttpServerService._();
  factory HttpServerService() => _instance;

  HttpServer? _server;
  bool _isInitialized = false;
  bool _isRunning = false;
  int _port = 8080;
  String? _serverUrl;

  static const String _prefKey = 'httpServerEnabled';

  Future<bool> init() async {
    if (_isInitialized) return true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final autoStart = prefs.getBool(_prefKey) ?? false;

      _isInitialized = true;

      if (autoStart) {
        return await start();
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> start() async {
    if (_isRunning) return true;

    try {
      final ip = await _getLocalIpAddress();
      if (ip == null) {
        return false;
      }

      _port = await _findAvailablePort();

      final handler = applyMiddleware(createRouter().call);

      // Create security context for HTTPS
      final securityContext = SslCertificateService().createSecurityContext();

      _server = await shelf_io.serve(
        handler,
        InternetAddress.anyIPv4,
        _port,
        securityContext: securityContext,
      );

      _serverUrl = 'https://$ip:$_port';
      _isRunning = true;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefKey, true);

      return true;
    } catch (e) {
      _isRunning = false;
      return false;
    }
  }

  bool hasServerQrCodes() {
    final dismissClients = DismissClientsService().dismissClients;
    return dismissClients.any((c) => c.deviceId == 'server');
  }

  void registerServerQrCodes(String dismissQr, String? snoozeQr) {
    final dismissClients = DismissClientsService().dismissClients;
    final existingClient = dismissClients.where((c) => c.deviceId == 'server').toList();

    if (existingClient.isEmpty) {
      final serverClient = DismissClient(
        deviceId: 'server',
        deviceName: 'Web Server',
        dismissQrCode: dismissQr,
        snoozeQrCode: snoozeQr,
      );
      DismissClientsService().addDismissClient(serverClient);
    } else {
      existingClient.first.dismissQrCode = dismissQr;
      existingClient.first.snoozeQrCode = snoozeQr; 
    }
  }

  Future<bool> stop() async {
    if (!_isRunning || _server == null) return true;

    try {
      await _server!.close(force: true);
      _server = null;
      _serverUrl = null;
      _isRunning = false;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefKey, false);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> _getLocalIpAddress() async {
    try {
      final info = NetworkInfo();
      final wifiIP = await info.getWifiIP();
      return wifiIP;
    } catch (e) {
      return null;
    }
  }

  Future<int> _findAvailablePort() async {
    final ports = [8080, 8081, 8082, 8083];

    for (final port in ports) {
      try {
        final server = await ServerSocket.bind(InternetAddress.anyIPv4, port);
        await server.close();
        return port;
      } catch (e) {
        continue;
      }
    }

    return 8080;
  }

  bool get isInitialized => _isInitialized;
  bool get isRunning => _isRunning;
  String? get serverUrl => _serverUrl;
  int get port => _port;
}
