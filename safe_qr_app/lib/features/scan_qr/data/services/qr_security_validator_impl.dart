import '../../domain/entities/scanned_qr_data.dart';
import '../../domain/services/qr_security_validator.dart';

class QrSecurityValidatorImpl implements QrSecurityValidator {
  @override
  Future<QrSecurityLevel> validateSecurity(String qrContent) async {
    // Simulação de validação - pode ser expandida no futuro
    await Future.delayed(const Duration(milliseconds: 500)); // Simula processamento
    
    // Validações básicas
    if (_isSuspiciousUrl(qrContent)) {
      return QrSecurityLevel.dangerous;
    }
    
    if (_isPotentiallyUnsafe(qrContent)) {
      return QrSecurityLevel.warning;
    }
    
    if (_isSafeContent(qrContent)) {
      return QrSecurityLevel.safe;
    }
    
    return QrSecurityLevel.unknown;
  }

  @override
  String? getSecurityMessage(QrSecurityLevel level, String qrContent) {
    switch (level) {
      case QrSecurityLevel.safe:
        return 'QR Code seguro - pode prosseguir';
      case QrSecurityLevel.warning:
        return 'Atenção: Este QR Code pode conter conteúdo suspeito';
      case QrSecurityLevel.dangerous:
        return 'PERIGO: Este QR Code contém conteúdo malicioso';
      case QrSecurityLevel.unknown:
        return 'Não foi possível determinar a segurança deste QR Code';
    }
  }

  bool _isSuspiciousUrl(String content) {
    if (!content.startsWith('http')) return false;
    
    // Lista de domínios suspeitos (exemplo)
    final suspiciousDomains = [
      'bit.ly',
      'tinyurl.com',
      'short.link',
      'malicious-site.com',
    ];
    
    return suspiciousDomains.any((domain) => content.contains(domain));
  }

  bool _isPotentiallyUnsafe(String content) {
    // Verifica se contém palavras suspeitas
    final suspiciousKeywords = [
      'download',
      'free',
      'click here',
      'urgent',
      'congratulations',
    ];
    
    final lowerContent = content.toLowerCase();
    return suspiciousKeywords.any((keyword) => lowerContent.contains(keyword));
  }

  bool _isSafeContent(String content) {
    // Conteúdo considerado seguro
    final safePatterns = [
      RegExp(r'^https://www\.google\.com'),
      RegExp(r'^https://www\.youtube\.com'),
      RegExp(r'^mailto:[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'),
      RegExp(r'^tel:\+?[1-9]\d{1,14}$'),
      RegExp(r'^WIFI:'),
    ];
    
    return safePatterns.any((pattern) => pattern.hasMatch(content));
  }
}

