import 'dart:async';
import 'package:logging/logging.dart';
import 'package:safe_qr_back/core/app_config.dart';
import 'package:safe_qr_back/core/logger.dart';
import 'package:safe_qr_back/presentation/http/router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

Future<void> main(List<String> args) async {
  final config = AppConfig.fromEnv();
  final rootLogger = configureLogger(config.logLevel);
  rootLogger.info('Bootstrapping Safe QR backend...');

  final router = AppRouter(
    logger: rootLogger,
  ).build();
  final httpLogger = Logger('SafeQrBack.Http');
  final handler = const Pipeline()
      .addMiddleware(_requestLogging(httpLogger))
      .addMiddleware(_cors())
      .addMiddleware(_jsonMimeType())
      .addHandler(router.call);

  final server = await shelf_io.serve(
    handler,
    config.host,
    config.port,
  );
  rootLogger.info('Server listening on http://${server.address.host}:${server.port}');
}

Middleware _cors() {
  return (Handler innerHandler) {
    return (Request request) async {
      final response = await innerHandler(request);
      return response.change(headers: {
        ...response.headers,
        'access-control-allow-origin': '*',
        'access-control-allow-headers': 'content-type',
        'access-control-allow-methods': 'GET, POST, OPTIONS',
      });
    };
  };
}

Middleware _jsonMimeType() {
  return (Handler innerHandler) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: {
          'access-control-allow-origin': '*',
          'access-control-allow-headers': 'content-type',
          'access-control-allow-methods': 'GET, POST, OPTIONS',
        });
      }

      final response = await innerHandler(request);
      if (response.headers['content-type'] != null) {
        return response;
      }

      return response.change(
        headers: {
          ...response.headers,
          'content-type': 'application/json',
        },
      );
    };
  };
}

Middleware _requestLogging(Logger logger) {
  return (Handler innerHandler) {
    return (Request request) async {
      final stopwatch = Stopwatch()..start();
      try {
        final response = await innerHandler(request);
        stopwatch.stop();
        logger.info(
          '${request.method} ${request.requestedUri} -> ${response.statusCode} in ${stopwatch.elapsedMilliseconds}ms',
        );
        return response;
      } catch (error, stackTrace) {
        stopwatch.stop();
        logger.severe(
          '${request.method} ${request.requestedUri} failed after ${stopwatch.elapsedMilliseconds}ms',
          error,
          stackTrace,
        );
        rethrow;
      }
    };
  };
}
