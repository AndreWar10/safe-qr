/// Níveis de log disponíveis no sistema
enum LogLevel {
  debug('DEBUG', '🐛'),
  info('INFO', 'ℹ️'),
  warning('WARNING', '⚠️'),
  error('ERROR', '❌'),
  success('SUCCESS', '✅');

  const LogLevel(this.name, this.emoji);

  final String name;
  final String emoji;

  /// Converte string para LogLevel
  static LogLevel fromString(String level) {
    switch (level.toUpperCase()) {
      case 'DEBUG':
        return LogLevel.debug;
      case 'INFO':
        return LogLevel.info;
      case 'WARNING':
        return LogLevel.warning;
      case 'ERROR':
        return LogLevel.error;
      case 'SUCCESS':
        return LogLevel.success;
      default:
        return LogLevel.info;
    }
  }
}
