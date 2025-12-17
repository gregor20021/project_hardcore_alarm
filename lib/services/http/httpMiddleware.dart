import 'dart:convert';
import 'package:shelf/shelf.dart';

Middleware createCorsMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        });
      }

      final response = await handler(request);

      return response.change(headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      });
    };
  };
}

Middleware createLoggingMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      final startTime = DateTime.now();
      final response = await handler(request);
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime).inMilliseconds;

      print('[${startTime.toIso8601String()}] ${request.method} ${request.url.path} - ${response.statusCode} (${duration}ms)');

      return response;
    };
  };
}

Middleware createErrorHandlingMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      try {
        return await handler(request);
      } catch (e, stackTrace) {
        print('Error handling request: $e');
        print('Stack trace: $stackTrace');

        return Response.internalServerError(
          body: jsonEncode({
            'success': false,
            'error': 'Internal server error',
          }),
          headers: {'Content-Type': 'application/json'},
        );
      }
    };
  };
}

Handler applyMiddleware(Handler handler) {
  return const Pipeline()
      .addMiddleware(createCorsMiddleware())
      .addMiddleware(createLoggingMiddleware())
      .addMiddleware(createErrorHandlingMiddleware())
      .addHandler(handler);
}
