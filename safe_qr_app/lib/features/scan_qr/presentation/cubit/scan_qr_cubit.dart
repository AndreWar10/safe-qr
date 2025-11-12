import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/scan_state.dart';
import '../../domain/services/qr_security_validator.dart';
import '../../domain/usecases/validate_qr_security.dart';
import '../../domain/usecases/save_scanned_qr_code.dart';
import '../../../history/domain/entities/qr_history_item.dart';
import '../../../history/domain/usecases/save_history_item.dart';
import '../../../history/presentation/cubit/history_cubit.dart';
import '../../domain/entities/scanned_qr_data.dart';

class ScanQrCubit extends Cubit<ScanState> {
  final ValidateQrSecurity _validateQrSecurity;
  final SaveScannedQrCode _saveScannedQrCode;
  final SaveHistoryItem _saveHistoryItem;
  final HistoryCubit _historyCubit;

  ScanQrCubit({
    required ValidateQrSecurity validateQrSecurity,
    required SaveScannedQrCode saveScannedQrCode,
    required SaveHistoryItem saveHistoryItem,
    required HistoryCubit historyCubit,
  })  : _validateQrSecurity = validateQrSecurity,
        _saveScannedQrCode = saveScannedQrCode,
        _saveHistoryItem = saveHistoryItem,
        _historyCubit = historyCubit,
        super(const ScanState.initial());

  void startScanning() {
    emit(const ScanState.scanning());
  }

  void stopScanning() {
    emit(const ScanState.success());
  }

  void setPermissionStatus(bool hasPermission) {
    emit(state.copyWith(hasPermission: hasPermission));
  }

  void setError(String message) {
    emit(ScanState.error(message));
  }

  void setPermissionDenied() {
    emit(const ScanState.permissionDenied());
  }

  void setCameraNotAvailable() {
    emit(const ScanState.cameraNotAvailable());
  }

  Future<ScannedQrData?> processScannedQr(String qrContent) async {
    try {
      emit(const ScanState.scanning());

      // Valida a segurança do QR Code
      final scannedData = await _validateQrSecurity(qrContent);

      // Salva no histórico do scanner
      await _saveScannedQrCode(scannedData);

      // Salva no histórico geral
      await _saveToHistory(scannedData);

      emit(const ScanState.success());
      return scannedData;
    } on QrSecurityException catch (error) {
      emit(ScanState.error(error.message));
      return null;
    } catch (e) {
      emit(ScanState.error(
          'Erro ao processar QR Code. Tente novamente mais tarde.'));
      return null;
    }
  }

  /// Salva o QR Code escaneado no histórico geral
  Future<void> _saveToHistory(ScannedQrData scannedData) async {
    try {
      final historyItem = QrHistoryItem(
        id: scannedData.scannedAt.millisecondsSinceEpoch.toString(),
        content: scannedData.content,
        title: scannedData.title,
        type: QrHistoryType.scanned,
        createdAt: scannedData.scannedAt,
        qrType: scannedData.qrType,
        securityLevel: scannedData.securityLevel.name,
        securityMessage: scannedData.securityMessage,
      );

      await _saveHistoryItem(historyItem);

      // Notifica o HistoryCubit para recarregar
      _historyCubit.loadHistory();

      debugPrint(
          '✅ QR Code escaneado salvo no histórico: ${scannedData.content}');
    } catch (e) {
      // Log do erro, mas não interrompe o fluxo principal
      debugPrint('❌ Erro ao salvar no histórico: $e');
    }
  }

  void reset() {
    emit(const ScanState.initial());
  }
}
