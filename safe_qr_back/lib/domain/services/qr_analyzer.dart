import 'package:safe_qr_back/domain/entities/analysis_report.dart';
import 'package:safe_qr_back/infrastructure/detectors/url_safety_detector.dart';

class QrAnalyzer {
  QrAnalyzer({
    UrlSafetyDetector? urlSafetyDetector,
  }) : _urlSafetyDetector = urlSafetyDetector ?? UrlSafetyDetector();

  final UrlSafetyDetector _urlSafetyDetector;

  AnalysisReport analyze(String payload) {
    final normalized = payload.trim();

    if (normalized.isEmpty) {
      return const AnalysisReport(
        isSafe: false,
        riskScore: 100,
        verdict: 'invalid',
        indicators: ['QR code is empty or unreadable'],
        recommendations: [
          'Rescan the QR code ensuring it is not damaged',
          'Avoid interacting with unreadable QR sources',
        ],
      );
    }

    final urlResult = _urlSafetyDetector.evaluate(normalized);
    if (urlResult != null) {
      return urlResult;
    }

    return const AnalysisReport(
      isSafe: true,
      riskScore: 0,
      verdict: 'trusted',
      indicators: ['Payload does not contain a URL or executable command'],
      recommendations: ['Proceed with caution and verify the data source'],
    );
  }
}
