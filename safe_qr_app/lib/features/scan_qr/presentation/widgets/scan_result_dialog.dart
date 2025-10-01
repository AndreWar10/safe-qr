// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/scanned_qr_data.dart';

class ScanResultDialog extends StatelessWidget {
  final ScannedQrData scannedData;

  const ScanResultDialog({
    super.key,
    required this.scannedData,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          _getSecurityIcon(),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'QR Code Escaneado',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (scannedData.qrType != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                scannedData.qrType!,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            'Conteúdo:',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
            ),
            child: Text(
              scannedData.content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getSecurityColor(context).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getSecurityColor(context).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                _getSecurityIcon(),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    scannedData.securityMessage ?? 'Status de segurança não disponível',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _getSecurityColor(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
        if (_canOpenContent(scannedData.content))
          FilledButton(
            onPressed: () => _openContent(scannedData.content),
            child: const Text('Abrir'),
          ),
      ],
    );
  }

  Widget _getSecurityIcon() {
    switch (scannedData.securityLevel) {
      case QrSecurityLevel.safe:
        return const Icon(
          Icons.check_circle,
          color: Colors.green,
        );
      case QrSecurityLevel.warning:
        return const Icon(
          Icons.warning,
          color: Colors.orange,
        );
      case QrSecurityLevel.dangerous:
        return const Icon(
          Icons.dangerous,
          color: Colors.red,
        );
      case QrSecurityLevel.unknown:
        return const Icon(
          Icons.help,
          color: Colors.grey,
        );
    }
  }

  Color _getSecurityColor(BuildContext context) {
    switch (scannedData.securityLevel) {
      case QrSecurityLevel.safe:
        return Colors.green;
      case QrSecurityLevel.warning:
        return Colors.orange;
      case QrSecurityLevel.dangerous:
        return Colors.red;
      case QrSecurityLevel.unknown:
        return Colors.grey;
    }
  }

  bool _canOpenContent(String content) {
    return content.startsWith('http') ||
        content.startsWith('mailto:') ||
        content.startsWith('tel:') ||
        content.startsWith('sms:');
  }

  Future<void> _openContent(String content) async {
    final uri = Uri.parse(content);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

