import 'dart:io';
import 'package:dotenv/dotenv.dart' as dotenv;

class AppConfig {
  AppConfig({
    required this.host,
    required this.port,
    required this.logLevel,
  });

  final String host;
  final int port;
  final String logLevel;

  static AppConfig fromEnv() {
    final env = dotenv.DotEnv(includePlatformEnvironment: true)..load();
    final host = env['HOST'] ?? InternetAddress.anyIPv4.address;
    final port = int.tryParse(env['PORT'] ?? '') ?? 8080;
    final logLevel = env['LOG_LEVEL'] ?? 'INFO';
    return AppConfig(host: host, port: port, logLevel: logLevel);
  }
}
