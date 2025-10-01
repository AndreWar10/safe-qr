import '../entities/qr_history_item.dart';
import '../repositories/history_repository.dart';

class GetScannedHistory {
  final HistoryRepository _repository;

  GetScannedHistory(this._repository);

  Future<List<QrHistoryItem>> call() async {
    return await _repository.getScannedHistory();
  }
}
