import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../domain/entities/qr_code_data.dart';

class QrCodeWidget extends StatelessWidget {
  final QrCodeData qrData;
  final double size;
  final Color? foregroundColor;
  final Color? backgroundColor;

  const QrCodeWidget({
    super.key,
    required this.qrData,
    this.size = 200.0,
    this.foregroundColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (qrData.title != null) ...[
              Text(
                qrData.title!,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],
            QrImageView(
              data: qrData.content,
              version: QrVersions.auto,
              size: size,
              gapless: false,
              backgroundColor: backgroundColor ?? Colors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Colors.black,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Colors.black,
              ),
              embeddedImage: null,
              embeddedImageStyle: const QrEmbeddedImageStyle(
                size: Size(40, 40),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              qrData.type.displayName,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatContent(qrData.content),
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _formatContent(String content) {
    if (content.length > 50) {
      return '${content.substring(0, 47)}...';
    }
    return content;
  }
}
