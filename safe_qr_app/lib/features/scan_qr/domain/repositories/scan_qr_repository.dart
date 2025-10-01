import '../entities/scanned_qr_data.dart';

abstract class ScanQrRepository {
  Future<List<ScannedQrData>> getScannedQrCodes();
  Future<void> saveScannedQrCode(ScannedQrData qrData);
  Future<void> deleteScannedQrCode(String id);
  Future<void> clearScannedQrCodes();
}

