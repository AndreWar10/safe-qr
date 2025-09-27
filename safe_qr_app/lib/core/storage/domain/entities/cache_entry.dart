import 'package:equatable/equatable.dart';

class CacheEntry<T> extends Equatable {
  final String key;
  final T value;
  final DateTime timestamp;

  const CacheEntry({
    required this.key,
    required this.value,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [key, value, timestamp];
}
