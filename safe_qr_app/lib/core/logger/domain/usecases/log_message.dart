import '../entities/log_entry.dart';
import '../entities/log_level.dart';
import '../repositories/logger_repository.dart';

/// Use case para logar uma mensagem
class LogMessage {
  final LoggerRepository repository;

  LogMessage(this.repository);

  /// Loga uma mensagem com nível específico
  Future<void> call({
    required LogLevel level,
    required String message,
    String? tag,
    Map<String, dynamic>? metadata,
    StackTrace? stackTrace,
  }) async {
    final entry = LogEntry(
      id: _generateId(),
      level: level,
      message: message,
      tag: tag,
      timestamp: DateTime.now(),
      metadata: metadata,
      stackTrace: stackTrace,
    );

    await repository.log(entry);
  }

  /// Gera ID único para o log
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
           (DateTime.now().microsecond.toString().padLeft(6, '0'));
  }
}
