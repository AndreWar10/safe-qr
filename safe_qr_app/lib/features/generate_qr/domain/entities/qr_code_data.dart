import 'package:equatable/equatable.dart';

class QrCodeData extends Equatable {
  final String content;
  final DateTime createdAt;
  final String? title;
  final QrCodeType type;

  const QrCodeData({
    required this.content,
    required this.createdAt,
    this.title,
    this.type = QrCodeType.text,
  });

  @override
  List<Object?> get props => [content, createdAt, title, type];

  QrCodeData copyWith({
    String? content,
    DateTime? createdAt,
    String? title,
    QrCodeType? type,
  }) {
    return QrCodeData(
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      type: type ?? this.type,
    );
  }
}

enum QrCodeType {
  text,
  url,
  email,
  phone,
  wifi,
  location,
  sms,
  vcard,
}

extension QrCodeTypeExtension on QrCodeType {
  String get displayName {
    switch (this) {
      case QrCodeType.text:
        return 'Texto';
      case QrCodeType.url:
        return 'URL';
      case QrCodeType.email:
        return 'Email';
      case QrCodeType.phone:
        return 'Telefone';
      case QrCodeType.wifi:
        return 'WiFi';
      case QrCodeType.location:
        return 'Localização';
      case QrCodeType.sms:
        return 'SMS';
      case QrCodeType.vcard:
        return 'Cartão de Visita';
    }
  }

  String get icon {
    switch (this) {
      case QrCodeType.text:
        return '📄';
      case QrCodeType.url:
        return '🌐';
      case QrCodeType.email:
        return '📧';
      case QrCodeType.phone:
        return '📞';
      case QrCodeType.wifi:
        return '📶';
      case QrCodeType.location:
        return '📍';
      case QrCodeType.sms:
        return '💬';
      case QrCodeType.vcard:
        return '👤';
    }
  }
}
