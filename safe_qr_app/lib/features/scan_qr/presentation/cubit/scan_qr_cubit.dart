import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/scan_state.dart';
import '../../domain/usecases/validate_qr_security.dart';
import '../../domain/usecases/save_scanned_qr_code.dart';

class ScanQrCubit extends Cubit<ScanState> {
  final ValidateQrSecurity _validateQrSecurity;
  final SaveScannedQrCode _saveScannedQrCode;

  ScanQrCubit({
    required ValidateQrSecurity validateQrSecurity,
    required SaveScannedQrCode saveScannedQrCode,
  })  : _validateQrSecurity = validateQrSecurity,
        _saveScannedQrCode = saveScannedQrCode,
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

  Future<void> processScannedQr(String qrContent) async {
    try {
      emit(const ScanState.scanning());
      
      // Valida a segurança do QR Code
      final scannedData = await _validateQrSecurity(qrContent);
      
      // Salva no histórico
      await _saveScannedQrCode(scannedData);
      
      emit(const ScanState.success());
    } catch (e) {
      emit(ScanState.error('Erro ao processar QR Code: ${e.toString()}'));
    }
  }

  void reset() {
    emit(const ScanState.initial());
  }
}

