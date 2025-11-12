import '../entities/qr_security_report.dart';

class QrSecurityException implements Exception {
  QrSecurityException(this.message);

  final String message;

  @override
  String toString() => message;
}

abstract class QrSecurityValidator {
  Future<QrSecurityReport> validateSecurity(String qrContent);
}
