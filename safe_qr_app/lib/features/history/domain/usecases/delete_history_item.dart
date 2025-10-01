import '../repositories/history_repository.dart';

class DeleteHistoryItem {
  final HistoryRepository _repository;

  DeleteHistoryItem(this._repository);

  Future<void> call(String id) async {
    await _repository.deleteHistoryItem(id);
  }
}
