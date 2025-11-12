import 'package:logging/logging.dart';

Logger configureLogger(String level) {
  Logger.root.level = _mapLevel(level);
  Logger.root.onRecord.listen((record) {
    final time = record.time.toIso8601String();
    final error = record.error != null ? ' error: ${record.error}' : '';
    final stackTrace = record.stackTrace != null ? '\n${record.stackTrace}' : '';
    // ignore: avoid_print
    print('[${record.level.name}] [$time] ${record.loggerName}: ${record.message}$error$stackTrace');
  });
  return Logger('SafeQrBack');
}

Level _mapLevel(String level) {
  switch (level.toUpperCase()) {
    case 'FINE':
      return Level.FINE;
    case 'FINER':
      return Level.FINER;
    case 'FINEST':
      return Level.FINEST;
    case 'WARNING':
      return Level.WARNING;
    case 'SEVERE':
      return Level.SEVERE;
    case 'SHOUT':
      return Level.SHOUT;
    case 'INFO':
    default:
      return Level.INFO;
  }
}
