import 'package:flutter/material.dart';
import '../../domain/entities/qr_code_data.dart';

class QrActionsWidget extends StatelessWidget {
  final QrCodeData qrData;
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onNew;
  final bool isSaving;

  const QrActionsWidget({
    super.key,
    required this.qrData,
    required this.onSave,
    required this.onShare,
    required this.onNew,
    this.isSaving = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎯 Qrcode Gerado',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isSaving ? null : onSave,
                    icon: isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(isSaving ? 'Baixando...' : 'Baixar'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onShare,
                    icon: const Icon(Icons.share),
                    label: const Text('Compartilhar'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: onNew,
                icon: const Icon(Icons.add),
                label: const Text('Criar Novo QR Code'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
