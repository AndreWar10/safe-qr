import '../entities/qr_history_item.dart';
import '../repositories/history_repository.dart';

class GetHistory {
  final HistoryRepository _repository;

  GetHistory(this._repository);

  Future<List<QrHistoryItem>> call() async {
    return await _repository.getHistory();
  }
}
