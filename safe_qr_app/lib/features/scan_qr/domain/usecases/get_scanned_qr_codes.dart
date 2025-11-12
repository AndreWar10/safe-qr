import '../entities/scanned_qr_data.dart';
import '../repositories/scan_qr_repository.dart';

class GetScannedQrCodes {
  final ScanQrRepository _repository;

  GetScannedQrCodes(this._repository);

  Future<List<ScannedQrData>> call() async {
    return await _repository.getScannedQrCodes();
  }
}
