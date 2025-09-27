import '../entities/log_entry.dart';

/// Repository abstrato para operações de log
abstract class LoggerRepository {
  /// Salva uma entrada de log
  Future<void> log(LogEntry entry);
}
