import 'package:flutter/material.dart';
import '../../domain/entities/log_entry.dart';
import '../../domain/repositories/logger_repository.dart';

class LoggerRepositoryImpl implements LoggerRepository {
  @override
  Future<void> log(LogEntry entry) async => debugPrint(entry.formattedMessage);
}
