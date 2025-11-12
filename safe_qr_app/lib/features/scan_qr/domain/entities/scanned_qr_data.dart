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
  final String? verdict;
  final int? riskScore;
  final List<String> indicators;
  final List<String> recommendations;
  final bool? isSafe;

  const ScannedQrData({
    required this.content,
    this.title,
    required this.securityLevel,
    this.securityMessage,
    required this.scannedAt,
    this.qrType,
    this.verdict,
    this.riskScore,
    this.indicators = const [],
    this.recommendations = const [],
    this.isSafe,
  });

  @override
  List<Object?> get props => [
        content,
        title,
        securityLevel,
        securityMessage,
        scannedAt,
        qrType,
        verdict,
        riskScore,
        indicators,
        recommendations,
        isSafe,
      ];

  ScannedQrData copyWith({
    String? content,
    String? title,
    QrSecurityLevel? securityLevel,
    String? securityMessage,
    DateTime? scannedAt,
    String? qrType,
    String? verdict,
    int? riskScore,
    List<String>? indicators,
    List<String>? recommendations,
    bool? isSafe,
  }) {
    return ScannedQrData(
      content: content ?? this.content,
      title: title ?? this.title,
      securityLevel: securityLevel ?? this.securityLevel,
      securityMessage: securityMessage ?? this.securityMessage,
      scannedAt: scannedAt ?? this.scannedAt,
      qrType: qrType ?? this.qrType,
      verdict: verdict ?? this.verdict,
      riskScore: riskScore ?? this.riskScore,
      indicators: indicators ?? this.indicators,
      recommendations: recommendations ?? this.recommendations,
      isSafe: isSafe ?? this.isSafe,
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
      'verdict': verdict,
      'riskScore': riskScore,
      'indicators': indicators,
      'recommendations': recommendations,
      'isSafe': isSafe,
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
      verdict: json['verdict'] as String?,
      riskScore: json['riskScore'] as int?,
      indicators: (json['indicators'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList(growable: false) ??
          const [],
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList(growable: false) ??
          const [],
      isSafe: json['isSafe'] as bool?,
    );
  }
}
