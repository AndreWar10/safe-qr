import '../entities/scanned_qr_data.dart';
import '../repositories/scan_qr_repository.dart';

class SaveScannedQrCode {
  final ScanQrRepository _repository;

  SaveScannedQrCode(this._repository);

  Future<void> call(ScannedQrData qrData) async {
    await _repository.saveScannedQrCode(qrData);
  }
}
