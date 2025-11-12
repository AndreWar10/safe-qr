import 'package:flutter_test/flutter_test.dart';
import 'package:safe_qr_app/features/scan_qr/domain/entities/qr_security_report.dart';
import 'package:safe_qr_app/features/scan_qr/domain/entities/scanned_qr_data.dart';
import 'package:safe_qr_app/features/scan_qr/domain/services/qr_security_validator.dart';
import 'package:safe_qr_app/features/scan_qr/domain/usecases/validate_qr_security.dart';

class _FakeValidator implements QrSecurityValidator {
  _FakeValidator(this.report);

  final QrSecurityReport report;

  @override
  Future<QrSecurityReport> validateSecurity(String qrContent) async => report;
}

void main() {
  group('ValidateQrSecurity', () {
    test('maps validator report into ScannedQrData', () async {
      final report = QrSecurityReport(
        level: QrSecurityLevel.warning,
        message: 'Indicador suspeito',
        verdict: 'suspicious',
        riskScore: 55,
        indicators: const ['Palavra-chave suspeita'],
        recommendations: const ['Evite abrir o link'],
        isSafe: false,
      );

      final usecase = ValidateQrSecurity(_FakeValidator(report));

      final result = await usecase('https://example.com');

      expect(result.securityLevel, QrSecurityLevel.warning);
      expect(result.securityMessage, 'Indicador suspeito');
      expect(result.verdict, 'suspicious');
      expect(result.riskScore, 55);
      expect(result.indicators, contains('Palavra-chave suspeita'));
      expect(result.recommendations, contains('Evite abrir o link'));
      expect(result.isSafe, isFalse);
      expect(result.qrType, 'URL');
      expect(result.content, 'https://example.com');
    });
  });
}
