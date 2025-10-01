import 'package:equatable/equatable.dart';

enum QrHistoryType {
  generated,
  scanned,
}

class QrHistoryItem extends Equatable {
  final String id;
  final String content;
  final String? title;
  final QrHistoryType type;
  final DateTime createdAt;
  final String? qrType;
  final String? securityLevel;
  final String? securityMessage;

  const QrHistoryItem({
    required this.id,
    required this.content,
    this.title,
    required this.type,
    required this.createdAt,
    this.qrType,
    this.securityLevel,
    this.securityMessage,
  });

  @override
  List<Object?> get props => [
        id,
        content,
        title,
        type,
        createdAt,
        qrType,
        securityLevel,
        securityMessage,
      ];

  QrHistoryItem copyWith({
    String? id,
    String? content,
    String? title,
    QrHistoryType? type,
    DateTime? createdAt,
    String? qrType,
    String? securityLevel,
    String? securityMessage,
  }) {
    return QrHistoryItem(
      id: id ?? this.id,
      content: content ?? this.content,
      title: title ?? this.title,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      qrType: qrType ?? this.qrType,
      securityLevel: securityLevel ?? this.securityLevel,
      securityMessage: securityMessage ?? this.securityMessage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'title': title,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'qrType': qrType,
      'securityLevel': securityLevel,
      'securityMessage': securityMessage,
    };
  }

  factory QrHistoryItem.fromJson(Map<String, dynamic> json) {
    return QrHistoryItem(
      id: json['id'] as String,
      content: json['content'] as String,
      title: json['title'] as String?,
      type: QrHistoryType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => QrHistoryType.generated,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      qrType: json['qrType'] as String?,
      securityLevel: json['securityLevel'] as String?,
      securityMessage: json['securityMessage'] as String?,
    );
  }
}
