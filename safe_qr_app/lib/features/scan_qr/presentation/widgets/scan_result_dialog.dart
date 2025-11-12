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
      content: SingleChildScrollView(
        child: Column(
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
            _buildSecuritySummary(context),
            const SizedBox(height: 16),
            if (scannedData.riskScore != null || scannedData.verdict != null)
              _buildRiskDetails(context),
            if (scannedData.indicators.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildIndicatorList(context),
            ],
            if (scannedData.recommendations.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildRecommendations(context),
            ],
          ],
        ),
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

  Widget _buildSecuritySummary(BuildContext context) {
    return Container(
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
              scannedData.securityMessage ??
                  'Status de segurança não disponível',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _getSecurityColor(context),
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskDetails(BuildContext context) {
    final theme = Theme.of(context);
    final verdict = scannedData.verdict?.toUpperCase() ?? 'DESCONHECIDO';
    final riskScore =
        scannedData.riskScore != null ? '${scannedData.riskScore}/100' : '--';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.assessment, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Veredito: $verdict',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pontuação de risco: $riskScore',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorList(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Indicadores identificados',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ...scannedData.indicators.map(
          (indicator) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• '),
                Expanded(child: Text(indicator)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendations(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recomendações',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ...scannedData.recommendations.map(
          (recommendation) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check, size: 16),
                const SizedBox(width: 6),
                Expanded(child: Text(recommendation)),
              ],
            ),
          ),
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
