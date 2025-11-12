import '../../domain/services/logger_service.dart';
import '../../../../injection.dart';

/// Helper global para acesso fácil ao AppLogger
class AppLogger {
  static LoggerService get _service => getIt<LoggerService>();

  /// Log de debug - para desenvolvimento
  static Future<void> debug(String message,
      {String? tag, Map<String, dynamic>? metadata}) async {
    await _service.debug(message, tag: tag, metadata: metadata);
  }

  /// Log de informação - eventos importantes
  static Future<void> info(String message,
      {String? tag, Map<String, dynamic>? metadata}) async {
    await _service.info(message, tag: tag, metadata: metadata);
  }

  /// Log de sucesso - operações bem-sucedidas
  static Future<void> success(String message,
      {String? tag, Map<String, dynamic>? metadata}) async {
    await _service.success(message, tag: tag, metadata: metadata);
  }

  /// Log de aviso - problemas potenciais
  static Future<void> warning(String message,
      {String? tag, Map<String, dynamic>? metadata}) async {
    await _service.warning(message, tag: tag, metadata: metadata);
  }

  /// Log de erro - erros que não quebram a aplicação
  static Future<void> error(String message,
      {String? tag,
      Map<String, dynamic>? metadata,
      StackTrace? stackTrace}) async {
    await _service.error(message,
        tag: tag, metadata: metadata, stackTrace: stackTrace);
  }

  /// Log de erro com exceção
  static Future<void> errorWithException(String message, dynamic exception,
      {String? tag}) async {
    await _service.errorWithException(message, exception, tag: tag);
  }
}
