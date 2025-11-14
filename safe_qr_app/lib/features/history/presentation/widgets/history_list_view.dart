import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/qr_history_item.dart';
import '../cubit/history_cubit.dart';
import 'history_item_card.dart';

class HistoryListView extends StatelessWidget {
  final List<QrHistoryItem> items;
  final String emptyMessage;
  final IconData emptyIcon;

  const HistoryListView({
    super.key,
    required this.items,
    required this.emptyMessage,
    required this.emptyIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<HistoryCubit>().loadHistory();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: HistoryItemCard(
              item: item,
              onTap: () => _showItemDetails(context, item),
              onDelete: () => _deleteItem(context, item),
              onShare: () => _shareItem(context, item),
              onOpen: () => _openItem(context, item),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                emptyIcon,
                size: 80,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              emptyMessage,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Seus QR Codes aparecerão aqui quando você gerar ou escanear novos códigos.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showItemDetails(BuildContext context, QrHistoryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              item.type == QrHistoryType.generated
                  ? Icons.qr_code
                  : Icons.qr_code_scanner,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.type == QrHistoryType.generated
                    ? 'QR Code Gerado'
                    : 'QR Code Escaneado',
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.title != null) ...[
              Text(
                'Título:',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 4),
              Text(item.title!),
              const SizedBox(height: 16),
            ],
            if (item.qrType != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.qrType!,
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
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                item.content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Data:',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatDateTime(item.createdAt),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (item.securityLevel != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getSecurityColor(context, item.securityLevel!)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getSecurityColor(context, item.securityLevel!)
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getSecurityIcon(item.securityLevel!),
                      color: _getSecurityColor(context, item.securityLevel!),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.securityMessage ??
                            'Status de segurança não disponível',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: _getSecurityColor(
                                  context, item.securityLevel!),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
          if (_canOpenContent(item.content))
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                _openItem(context, item);
              },
              child: const Text('Abrir'),
            ),
        ],
      ),
    );
  }

  void _deleteItem(BuildContext context, QrHistoryItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Item'),
        content: const Text(
          'Tem certeza que deseja excluir este item do histórico?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              context.read<HistoryCubit>().deleteHistoryItem(item.id);
              Navigator.of(context).pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _shareItem(BuildContext context, QrHistoryItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidade de compartilhamento em desenvolvimento'),
      ),
    );
  }

  Future<void> _openItem(BuildContext context, QrHistoryItem item) async {
    if (_canOpenContent(item.content)) {
      final uri = Uri.parse(item.content);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      }
    }
  }

  bool _canOpenContent(String content) {
    return content.startsWith('http') ||
        content.startsWith('mailto:') ||
        content.startsWith('tel:') ||
        content.startsWith('sms:');
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} dias atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} horas atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutos atrás';
    } else {
      return 'Agora mesmo';
    }
  }

  IconData _getSecurityIcon(String securityLevel) {
    switch (securityLevel.toLowerCase()) {
      case 'safe':
        return Icons.check_circle;
      case 'warning':
        return Icons.warning;
      case 'dangerous':
        return Icons.dangerous;
      default:
        return Icons.help;
    }
  }

  Color _getSecurityColor(BuildContext context, String securityLevel) {
    switch (securityLevel.toLowerCase()) {
      case 'safe':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'dangerous':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
