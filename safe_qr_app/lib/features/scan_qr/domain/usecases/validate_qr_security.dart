import '../entities/scanned_qr_data.dart';
import '../services/qr_security_validator.dart';

class ValidateQrSecurity {
  ValidateQrSecurity(this._validator);

  final QrSecurityValidator _validator;

  Future<ScannedQrData> call(String qrContent) async {
    final report = await _validator.validateSecurity(qrContent);

    return ScannedQrData(
      content: qrContent,
      securityLevel: report.level,
      securityMessage: report.message,
      scannedAt: DateTime.now(),
      qrType: _detectQrType(qrContent),
      verdict: report.verdict,
      riskScore: report.riskScore,
      indicators: report.indicators,
      recommendations: report.recommendations,
      isSafe: report.isSafe,
    );
  }

  String? _detectQrType(String content) {
    if (content.startsWith('http://') || content.startsWith('https://')) {
      return 'URL';
    } else if (content.startsWith('mailto:')) {
      return 'Email';
    } else if (content.startsWith('tel:')) {
      return 'Phone';
    } else if (content.startsWith('sms:')) {
      return 'SMS';
    } else if (content.startsWith('WIFI:')) {
      return 'WiFi';
    } else {
      return 'Text';
    }
  }
}
