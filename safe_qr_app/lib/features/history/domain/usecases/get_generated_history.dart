import '../entities/qr_history_item.dart';
import '../repositories/history_repository.dart';

class GetGeneratedHistory {
  final HistoryRepository _repository;

  GetGeneratedHistory(this._repository);

  Future<List<QrHistoryItem>> call() async {
    return await _repository.getGeneratedHistory();
  }
}
