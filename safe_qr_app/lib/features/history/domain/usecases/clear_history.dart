import '../repositories/history_repository.dart';

class ClearHistory {
  final HistoryRepository _repository;

  ClearHistory(this._repository);

  Future<void> call() async {
    await _repository.clearHistory();
  }
}
