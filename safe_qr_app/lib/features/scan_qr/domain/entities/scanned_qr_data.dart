import 'package:equatable/equatable.dart';

enum QrSecurityLevel {
  safe,
  warning,
  dangerous,
  unknown,
}

class ScannedQrData extends Equatable {
  final String content;
  final String? title;
  final QrSecurityLevel securityLevel;
  final String? securityMessage;
  final DateTime scannedAt;
  final String? qrType;

  const ScannedQrData({
    required this.content,
    this.title,
    required this.securityLevel,
    this.securityMessage,
    required this.scannedAt,
    this.qrType,
  });

  @override
  List<Object?> get props => [
        content,
        title,
        securityLevel,
        securityMessage,
        scannedAt,
        qrType,
      ];

  ScannedQrData copyWith({
    String? content,
    String? title,
    QrSecurityLevel? securityLevel,
    String? securityMessage,
    DateTime? scannedAt,
    String? qrType,
  }) {
    return ScannedQrData(
      content: content ?? this.content,
      title: title ?? this.title,
      securityLevel: securityLevel ?? this.securityLevel,
      securityMessage: securityMessage ?? this.securityMessage,
      scannedAt: scannedAt ?? this.scannedAt,
      qrType: qrType ?? this.qrType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'title': title,
      'securityLevel': securityLevel.name,
      'securityMessage': securityMessage,
      'scannedAt': scannedAt.toIso8601String(),
      'qrType': qrType,
    };
  }

  factory ScannedQrData.fromJson(Map<String, dynamic> json) {
    return ScannedQrData(
      content: json['content'] as String,
      title: json['title'] as String?,
      securityLevel: QrSecurityLevel.values.firstWhere(
        (e) => e.name == json['securityLevel'],
        orElse: () => QrSecurityLevel.unknown,
      ),
      securityMessage: json['securityMessage'] as String?,
      scannedAt: DateTime.parse(json['scannedAt'] as String),
      qrType: json['qrType'] as String?,
    );
  }
}
