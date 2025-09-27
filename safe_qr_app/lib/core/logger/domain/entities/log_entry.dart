import 'package:equatable/equatable.dart';
import 'log_level.dart';

/// Entidade que representa uma entrada de log
class LogEntry extends Equatable {
  final String id;
  final LogLevel level;
  final String message;
  final String? tag;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;
  final StackTrace? stackTrace;

  const LogEntry({
    required this.id,
    required this.level,
    required this.message,
    required this.timestamp,
    this.tag,
    this.metadata,
    this.stackTrace,
  });

  @override
  List<Object?> get props => [
        id,
        level,
        message,
        timestamp,
        tag,
        metadata,
        stackTrace,
      ];

  /// Cria uma entrada de log formatada
  String get formattedMessage {
    final buffer = StringBuffer();
    
    buffer.write('[${timestamp.toIso8601String()}] ');
    buffer.write('${level.emoji} ${level.name}');
    
    if (tag != null) {
      buffer.write(' [$tag]');
    }
    
    buffer.write(': $message');
    
    if (metadata != null && metadata!.isNotEmpty) {
      buffer.write(' | Metadata: $metadata');
    }
    
    return buffer.toString();
  }

  /// Cria uma cópia da entrada com novos valores
  LogEntry copyWith({
    String? id,
    LogLevel? level,
    String? message,
    String? tag,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
    StackTrace? stackTrace,
  }) {
    return LogEntry(
      id: id ?? this.id,
      level: level ?? this.level,
      message: message ?? this.message,
      tag: tag ?? this.tag,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
      stackTrace: stackTrace ?? this.stackTrace,
    );
  }
}
