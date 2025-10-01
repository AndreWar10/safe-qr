import '../entities/qr_history_item.dart';
import '../repositories/history_repository.dart';

class SaveHistoryItem {
  final HistoryRepository _repository;

  SaveHistoryItem(this._repository);

  Future<void> call(QrHistoryItem item) async {
    await _repository.saveHistoryItem(item);
  }
}
