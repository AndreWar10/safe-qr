import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:safe_qr_back/domain/services/qr_analyzer.dart';
import 'package:shelf/shelf.dart';

class AnalyzeController {
  AnalyzeController({
    QrAnalyzer? analyzer,
    Logger? logger,
  })  : _analyzer = analyzer ?? QrAnalyzer(),
        _logger = logger != null
            ? Logger('${logger.name}.AnalyzeController')
            : Logger('SafeQrBack.AnalyzeController');

  final QrAnalyzer _analyzer;
  final Logger _logger;

  Future<Response> handle(Request request) async {
    try {
      final body = await request.readAsString();
      final Map<String, dynamic> jsonBody =
          json.decode(body) as Map<String, dynamic>;
      final payload = jsonBody['payload'] as String?;

      if (payload == null) {
        _logger.warning('Received request without payload field.');
        return Response.badRequest(
          body: jsonEncode({
            'error': 'invalid_payload',
            'message': 'The request must include a "payload" field.',
          }),
          headers: {HttpHeaders.contentTypeHeader: ContentType.json.mimeType},
        );
      }

      _logger.info(
        'Analyzing payload: ${_sanitizePayload(payload)}',
      );

      final report = _analyzer.analyze(payload);
      _logger.info(
        'Analysis result -> verdict: ${report.verdict}, '
        'riskScore: ${report.riskScore}, '
        'isSafe: ${report.isSafe}',
      );

      return Response.ok(
        jsonEncode(report.toJson()),
        headers: {HttpHeaders.contentTypeHeader: ContentType.json.mimeType},
      );
    } on FormatException catch (error) {
      _logger.warning('Invalid JSON received: ${error.message}');
      return Response.badRequest(
        body: jsonEncode({
          'error': 'invalid_json',
          'message': 'Malformed JSON body: ${error.message}',
        }),
        headers: {HttpHeaders.contentTypeHeader: ContentType.json.mimeType},
      );
    } catch (error, stackTrace) {
      _logger.severe(
        'Unexpected error while analyzing payload',
        error,
        stackTrace,
      );
      return Response.internalServerError(
        body: jsonEncode({
          'error': 'internal_error',
          'message': 'An unexpected error occurred while analyzing the QR code.',
        }),
        headers: {HttpHeaders.contentTypeHeader: ContentType.json.mimeType},
      );
    }
  }

  String _sanitizePayload(String payload) {
    final trimmed = payload.trim();
    if (trimmed.length <= 200) {
      return trimmed;
    }
    return '${trimmed.substring(0, 200)}...';
  }
}

class HttpHeaders {
  static const contentTypeHeader = 'content-type';
}

class ContentType {
  const ContentType._(this.mimeType);

  final String mimeType;

  static const json = ContentType._('application/json');
}
