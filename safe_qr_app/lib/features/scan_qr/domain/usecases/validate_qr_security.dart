import '../entities/scanned_qr_data.dart';
import '../services/qr_security_validator.dart';

class ValidateQrSecurity {
  final QrSecurityValidator _validator;

  ValidateQrSecurity(this._validator);

  Future<ScannedQrData> call(String qrContent) async {
    final securityLevel = await _validator.validateSecurity(qrContent);
    final securityMessage = _validator.getSecurityMessage(securityLevel, qrContent);
    
    return ScannedQrData(
      content: qrContent,
      securityLevel: securityLevel,
      securityMessage: securityMessage,
      scannedAt: DateTime.now(),
      qrType: _detectQrType(qrContent),
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

