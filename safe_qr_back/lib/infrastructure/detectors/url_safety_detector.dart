import 'dart:math';

import 'package:safe_qr_back/domain/entities/analysis_report.dart';

class UrlSafetyDetector {
  static final _suspiciousTlds = <String>{
    'zip',
    'mov',
    'gq',
    'work',
    'click',
    'country',
    'stream',
    'download',
    'lotto',
    'party',
    'racing',
    'review',
    'fit',
    'tk',
  };

  static final _phishingKeywords = <String>{
    'login',
    'update-account',
    'secure',
    'verify',
    'banking',
    'reset-password',
    'unlock',
    'account',
  };

  static final _knownSafeHosts = <String>{
    'https://www.apple.com',
    'https://www.google.com',
    'https://www.microsoft.com',
    'https://www.starbucks.com',
  };

  AnalysisReport? evaluate(String payload) {
    final uri = _normalizeUri(payload);
    if (uri == null) {
      return null;
    }

    final indicators = <String>[];
    var score = 0;

    if (!_isHttps(uri)) {
      indicators.add('Connection is not secured with HTTPS');
      score += 30;
    }

    if (_isIpAddress(uri.host)) {
      indicators.add('URL uses raw IP address');
      score += 25;
    }

    if (_containsSuspiciousTld(uri.host)) {
      indicators.add('Suspicious top-level domain detected');
      score += 20;
    }

    final keywordHits = _matchKeywords(uri.toString());
    if (keywordHits.isNotEmpty) {
      indicators.add('Potential phishing keywords: ${keywordHits.join(', ')}');
      score += min(30, keywordHits.length * 10);
    }

    if (_looksShortened(uri.host)) {
      indicators.add('URL appears to use a link shortener');
      score += 25;
    }

    if (_knownSafeHosts.contains(uri.origin)) {
      indicators.add('Recognized trusted domain');
      score = max(score - 30, 0);
    }

    final verdict = _classify(score);
    final isSafe = score < 40;

    return AnalysisReport(
      isSafe: isSafe,
      riskScore: score,
      verdict: verdict,
      indicators: indicators.isEmpty ? ['No suspicious indicators detected'] : indicators,
      recommendations: _buildRecommendations(isSafe),
    );
  }

  Uri? _normalizeUri(String value) {
    final trimmed = value.trim();

    if (!trimmed.contains('://') && trimmed.contains(RegExp(r'[./]'))) {
      return Uri.tryParse('https://$trimmed');
    }

    final uri = Uri.tryParse(trimmed);
    if (uri == null || (!uri.hasScheme && !uri.hasAuthority)) {
      return null;
    }

    return uri;
  }

  bool _isHttps(Uri uri) => uri.scheme.toLowerCase() == 'https';

  bool _isIpAddress(String host) => RegExp(r"^(\d{1,3}\.){3}\d{1,3}").hasMatch(host);

  bool _containsSuspiciousTld(String host) {
    final parts = host.split('.');
    if (parts.length < 2) {
      return false;
    }
    final tld = parts.last.toLowerCase();
    return _suspiciousTlds.contains(tld);
  }

  Iterable<String> _matchKeywords(String value) {
    final lowercase = value.toLowerCase();
    return _phishingKeywords.where(lowercase.contains);
  }

  bool _looksShortened(String host) {
    const shorteners = <String>{
      'bit.ly',
      'tinyurl.com',
      't.co',
      'goo.gl',
      'ow.ly',
      'is.gd',
      'buff.ly',
      'cutt.ly',
    };
    return shorteners.contains(host.toLowerCase());
  }

  String _classify(int score) {
    if (score >= 70) {
      return 'malicious';
    }
    if (score >= 40) {
      return 'suspicious';
    }
    return 'trusted';
  }

  List<String> _buildRecommendations(bool isSafe) {
    if (isSafe) {
      return const [
        'Open the link only if you trust the source',
        'Keep your device security patches up to date',
      ];
    }
    return const [
      'Do not open the link directly from the QR code',
      'Verify the source with the issuer through a trusted channel',
      'Report the QR code if it was received unexpectedly',
    ];
  }
}
