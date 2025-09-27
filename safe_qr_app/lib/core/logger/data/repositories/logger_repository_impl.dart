import '../../domain/entities/log_entry.dart';
import '../../domain/repositories/logger_repository.dart';

/// Implementação simples do repository de logs - apenas console
class LoggerRepositoryImpl implements LoggerRepository {
  @override
  Future<void> log(LogEntry entry) async {
    // Simples: só print no console
    print(entry.formattedMessage);
  }
}
