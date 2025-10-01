import '../entities/scanned_qr_data.dart';

abstract class QrSecurityValidator {
  Future<QrSecurityLevel> validateSecurity(String qrContent);
  String? getSecurityMessage(QrSecurityLevel level, String qrContent);
}

