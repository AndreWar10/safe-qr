import 'scanned_qr_data.dart';

class QrSecurityReport {
  const QrSecurityReport({
    required this.level,
    required this.message,
    required this.verdict,
    required this.riskScore,
    required this.indicators,
    required this.recommendations,
    required this.isSafe,
  });

  final QrSecurityLevel level;
  final String message;
  final String verdict;
  final int riskScore;
  final List<String> indicators;
  final List<String> recommendations;
  final bool isSafe;
}
