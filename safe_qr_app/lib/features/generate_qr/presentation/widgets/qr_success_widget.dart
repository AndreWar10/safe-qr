// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class QrSuccessWidget extends StatelessWidget {
  final VoidCallback onNew;
  final VoidCallback? onSave;
  final VoidCallback? onShare;

  const QrSuccessWidget({
    super.key,
    required this.onNew,
    this.onSave,
    this.onShare,
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
            // Container azul bonito como estava antes
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ícone de sucesso
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: colorScheme.onPrimary,
                      size: 32,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Texto de sucesso
                  Text(
                    'QR Code gerado com sucesso!',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Você pode compartilhar ou salvar o código gerado',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Botões de ação lado a lado
            Row(
              children: [
                // Botão de salvar
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onSave,
                    icon: const Icon(Icons.download),
                    label: const Text('Salvar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.secondary,
                      side: BorderSide(color: colorScheme.secondary),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Botão de compartilhar
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onShare,
                    icon: const Icon(Icons.share),
                    label: const Text('Compartilhar'),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Botão para criar novo
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onNew,
                icon: const Icon(Icons.add),
                label: const Text('Criar Novo QR Code'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  side: BorderSide(color: colorScheme.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
