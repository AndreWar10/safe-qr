import '../entities/log_level.dart';
import '../usecases/log_message.dart';

/// Serviço principal de logging da aplicação
class LoggerService {
  final LogMessage _logMessage;

  LoggerService({
    required LogMessage logMessage,
  }) : _logMessage = logMessage;

  /// Log de debug - para desenvolvimento
  Future<void> debug(String message, {String? tag, Map<String, dynamic>? metadata}) async {
    await _logMessage(
      level: LogLevel.debug,
      message: message,
      tag: tag,
      metadata: metadata,
    );
  }

  /// Log de informação - eventos normais
  Future<void> info(String message, {String? tag, Map<String, dynamic>? metadata}) async {
    await _logMessage(
      level: LogLevel.info,
      message: message,
      tag: tag,
      metadata: metadata,
    );
  }

  /// Log de sucesso - operações bem-sucedidas
  Future<void> success(String message, {String? tag, Map<String, dynamic>? metadata}) async {
    await _logMessage(
      level: LogLevel.success,
      message: message,
      tag: tag,
      metadata: metadata,
    );
  }

  /// Log de warning - situações que merecem atenção
  Future<void> warning(String message, {String? tag, Map<String, dynamic>? metadata}) async {
    await _logMessage(
      level: LogLevel.warning,
      message: message,
      tag: tag,
      metadata: metadata,
    );
  }

  /// Log de erro - erros que não quebram a aplicação
  Future<void> error(String message, {String? tag, Map<String, dynamic>? metadata, StackTrace? stackTrace}) async {
    await _logMessage(
      level: LogLevel.error,
      message: message,
      tag: tag,
      metadata: metadata,
      stackTrace: stackTrace,
    );
  }

  /// Log de erro com exceção
  Future<void> errorWithException(String message, dynamic exception, {String? tag}) async {
    await error(
      message,
      tag: tag,
      metadata: {
        'exception': exception.toString(),
        'exceptionType': exception.runtimeType.toString(),
      },
      stackTrace: StackTrace.current,
    );
  }
}
