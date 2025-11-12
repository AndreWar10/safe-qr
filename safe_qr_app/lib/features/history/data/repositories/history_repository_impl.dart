// ignore_for_file: avoid_print

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/entities/qr_history_item.dart';
import '../../domain/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final SharedPreferences _prefs;
  static const String _historyKey = 'qr_history';

  HistoryRepositoryImpl(this._prefs);

  @override
  Future<List<QrHistoryItem>> getHistory() async {
    final jsonString = _prefs.getString(_historyKey);
    if (jsonString == null) {
      print('📝 Nenhum histórico encontrado');
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      final items = jsonList
          .map((json) => QrHistoryItem.fromJson(json))
          .toList()
        ..sort((a, b) =>
            b.createdAt.compareTo(a.createdAt)); // Mais recentes primeiro

      print('📝 Histórico carregado: ${items.length} itens');
      return items;
    } catch (e) {
      print('❌ Erro ao carregar histórico: $e');
      return [];
    }
  }

  @override
  Future<List<QrHistoryItem>> getGeneratedHistory() async {
    final allHistory = await getHistory();
    return allHistory
        .where((item) => item.type == QrHistoryType.generated)
        .toList();
  }

  @override
  Future<List<QrHistoryItem>> getScannedHistory() async {
    final allHistory = await getHistory();
    return allHistory
        .where((item) => item.type == QrHistoryType.scanned)
        .toList();
  }

  @override
  Future<void> saveHistoryItem(QrHistoryItem item) async {
    final existingHistory = await getHistory();

    // Remove item existente se já existe (para atualizar)
    existingHistory.removeWhere((existing) => existing.id == item.id);

    // Adiciona o novo item
    existingHistory.add(item);

    // Mantém apenas os últimos 100 itens para não ocupar muito espaço
    if (existingHistory.length > 100) {
      existingHistory.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      existingHistory.removeRange(100, existingHistory.length);
    }

    final jsonList = existingHistory.map((item) => item.toJson()).toList();
    await _prefs.setString(_historyKey, jsonEncode(jsonList));

    // Log para debug
    print('✅ Histórico salvo: ${item.type.name} - ${item.content}');
  }

  @override
  Future<void> deleteHistoryItem(String id) async {
    final existingHistory = await getHistory();
    existingHistory.removeWhere((item) => item.id == id);

    final jsonList = existingHistory.map((item) => item.toJson()).toList();
    await _prefs.setString(_historyKey, jsonEncode(jsonList));
  }

  @override
  Future<void> clearHistory() async {
    await _prefs.remove(_historyKey);
  }

  @override
  Future<void> clearGeneratedHistory() async {
    final existingHistory = await getHistory();
    final filteredHistory = existingHistory
        .where((item) => item.type != QrHistoryType.generated)
        .toList();

    final jsonList = filteredHistory.map((item) => item.toJson()).toList();
    await _prefs.setString(_historyKey, jsonEncode(jsonList));
  }

  @override
  Future<void> clearScannedHistory() async {
    final existingHistory = await getHistory();
    final filteredHistory = existingHistory
        .where((item) => item.type != QrHistoryType.scanned)
        .toList();

    final jsonList = filteredHistory.map((item) => item.toJson()).toList();
    await _prefs.setString(_historyKey, jsonEncode(jsonList));
  }
}
