import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:safe_qr_app/features/scan_qr/domain/entities/scanned_qr_data.dart';

import '../../domain/entities/qr_security_report.dart';
import '../../domain/services/qr_security_validator.dart';

class QrSecurityValidatorImpl implements QrSecurityValidator {
  QrSecurityValidatorImpl({
    http.Client? httpClient,
    String? baseUrl,
    Duration timeout = const Duration(seconds: 10),
  })  : _client = httpClient ?? http.Client(),
        _baseUrl = (baseUrl ?? dotenv.env['SAFE_QR_API_URL'] ?? '').trim(),
        _timeout = timeout;

  final http.Client _client;
  final String _baseUrl;
  final Duration _timeout;

  static const _serviceUnavailableMessage =
      'Serviço de análise temporariamente indisponível. Tente novamente mais tarde.';

  @override
  Future<QrSecurityReport> validateSecurity(String qrContent) async {
    if (_baseUrl.isEmpty) {
      throw QrSecurityException(_serviceUnavailableMessage);
    }

    try {
      final uri = Uri.parse('$_baseUrl/api/v1/analyze');
      debugPrint('SafeQrBackend request -> $uri');
      final response = await _client
          .post(
            uri,
            headers: const {'content-type': 'application/json'},
            body: jsonEncode({'payload': qrContent}),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body) as Map<String, dynamic>;
        return _mapToReport(data);
      }

      debugPrint(
        'SafeQrBackend returned status ${response.statusCode}: ${response.body}',
      );
      throw QrSecurityException(_serviceUnavailableMessage);
    } on QrSecurityException {
      rethrow;
    } catch (error, stackTrace) {
      debugPrint('SafeQrBackend error: $error\n$stackTrace');
      throw QrSecurityException(_serviceUnavailableMessage);
    }
  }

  QrSecurityReport _mapToReport(Map<String, dynamic> data) {
    final verdict = (data['verdict'] as String? ?? 'unknown').toLowerCase();
    final riskScore = data['riskScore'] as int? ?? 0;
    final indicators = (data['indicators'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList(growable: false);
    final recommendations = (data['recommendations'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList(growable: false);
    final isSafe = data['isSafe'] as bool? ?? false;

    return QrSecurityReport(
      level: _mapVerdictToLevel(verdict, isSafe),
      message: _buildMessage(verdict, indicators),
      verdict: verdict,
      riskScore: riskScore,
      indicators: indicators,
      recommendations: recommendations,
      isSafe: isSafe,
    );
  }

  QrSecurityLevel _mapVerdictToLevel(String verdict, bool isSafe) {
    switch (verdict) {
      case 'trusted':
        return QrSecurityLevel.safe;
      case 'suspicious':
        return QrSecurityLevel.warning;
      case 'malicious':
      case 'invalid':
        return QrSecurityLevel.dangerous;
      default:
        return isSafe ? QrSecurityLevel.safe : QrSecurityLevel.unknown;
    }
  }

  String _buildMessage(String verdict, List<String> indicators) {
    final capitalizedVerdict = verdict.isEmpty
        ? 'Desconhecido'
        : verdict[0].toUpperCase() + verdict.substring(1);
    if (indicators.isEmpty) {
      return 'Veredito: $capitalizedVerdict';
    }
    return 'Veredito: $capitalizedVerdict\n${indicators.join('\n')}';
  }
}
