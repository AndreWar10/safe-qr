import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/qr_history_item.dart';
import '../../domain/usecases/get_generated_history.dart';
import '../../domain/usecases/get_scanned_history.dart';
import '../../domain/usecases/save_history_item.dart';
import '../../domain/usecases/delete_history_item.dart';
import '../../domain/usecases/clear_history.dart';

class HistoryState extends Equatable {
  final List<QrHistoryItem> generatedHistory;
  final List<QrHistoryItem> scannedHistory;
  final bool isLoading;
  final String? errorMessage;

  const HistoryState({
    required this.generatedHistory,
    required this.scannedHistory,
    required this.isLoading,
    this.errorMessage,
  });

  const HistoryState.initial()
      : generatedHistory = const [],
        scannedHistory = const [],
        isLoading = false,
        errorMessage = null;

  const HistoryState.loading()
      : generatedHistory = const [],
        scannedHistory = const [],
        isLoading = true,
        errorMessage = null;

  const HistoryState.loaded({
    required List<QrHistoryItem> generatedHistory,
    required List<QrHistoryItem> scannedHistory,
  }) : generatedHistory = generatedHistory,
       scannedHistory = scannedHistory,
       isLoading = false,
       errorMessage = null;

  const HistoryState.error(String message)
      : generatedHistory = const [],
        scannedHistory = const [],
        isLoading = false,
        errorMessage = message;

  @override
  List<Object?> get props => [generatedHistory, scannedHistory, isLoading, errorMessage];

  HistoryState copyWith({
    List<QrHistoryItem>? generatedHistory,
    List<QrHistoryItem>? scannedHistory,
    bool? isLoading,
    String? errorMessage,
  }) {
    return HistoryState(
      generatedHistory: generatedHistory ?? this.generatedHistory,
      scannedHistory: scannedHistory ?? this.scannedHistory,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class HistoryCubit extends Cubit<HistoryState> {
  final GetGeneratedHistory _getGeneratedHistory;
  final GetScannedHistory _getScannedHistory;
  final SaveHistoryItem _saveHistoryItem;
  final DeleteHistoryItem _deleteHistoryItem;
  final ClearHistory _clearHistory;

  HistoryCubit({
    required GetGeneratedHistory getGeneratedHistory,
    required GetScannedHistory getScannedHistory,
    required SaveHistoryItem saveHistoryItem,
    required DeleteHistoryItem deleteHistoryItem,
    required ClearHistory clearHistory,
  })  : _getGeneratedHistory = getGeneratedHistory,
        _getScannedHistory = getScannedHistory,
        _saveHistoryItem = saveHistoryItem,
        _deleteHistoryItem = deleteHistoryItem,
        _clearHistory = clearHistory,
        super(const HistoryState.initial());

  Future<void> loadHistory() async {
    emit(const HistoryState.loading());
    
    try {
      final generatedHistory = await _getGeneratedHistory();
      final scannedHistory = await _getScannedHistory();
      
      emit(HistoryState.loaded(
        generatedHistory: generatedHistory,
        scannedHistory: scannedHistory,
      ));
    } catch (e) {
      emit(HistoryState.error('Erro ao carregar histórico: ${e.toString()}'));
    }
  }

  Future<void> saveHistoryItem(QrHistoryItem item) async {
    try {
      await _saveHistoryItem(item);
      await loadHistory(); // Recarrega o histórico
    } catch (e) {
      emit(HistoryState.error('Erro ao salvar item: ${e.toString()}'));
    }
  }

  Future<void> deleteHistoryItem(String id) async {
    try {
      await _deleteHistoryItem(id);
      await loadHistory(); // Recarrega o histórico
    } catch (e) {
      emit(HistoryState.error('Erro ao deletar item: ${e.toString()}'));
    }
  }

  Future<void> clearAllHistory() async {
    try {
      await _clearHistory();
      emit(const HistoryState.loaded(
        generatedHistory: [],
        scannedHistory: [],
      ));
    } catch (e) {
      emit(HistoryState.error('Erro ao limpar histórico: ${e.toString()}'));
    }
  }
}
