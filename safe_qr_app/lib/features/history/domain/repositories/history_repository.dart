import '../entities/qr_history_item.dart';

abstract class HistoryRepository {
  Future<List<QrHistoryItem>> getHistory();
  Future<List<QrHistoryItem>> getGeneratedHistory();
  Future<List<QrHistoryItem>> getScannedHistory();
  Future<void> saveHistoryItem(QrHistoryItem item);
  Future<void> deleteHistoryItem(String id);
  Future<void> clearHistory();
  Future<void> clearGeneratedHistory();
  Future<void> clearScannedHistory();
}
