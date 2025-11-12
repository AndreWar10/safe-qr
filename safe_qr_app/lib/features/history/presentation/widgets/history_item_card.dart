import 'package:flutter/material.dart';
import '../../domain/entities/qr_history_item.dart';

class HistoryItemCard extends StatelessWidget {
  final QrHistoryItem item;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onShare;
  final VoidCallback onOpen;

  const HistoryItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
    required this.onShare,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: item.type == QrHistoryType.generated
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      item.type == QrHistoryType.generated
                          ? Icons.qr_code
                          : Icons.qr_code_scanner,
                      color: item.type == QrHistoryType.generated
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSecondaryContainer,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.title != null) ...[
                          Text(
                            item.title!,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                        ],
                        Text(
                          item.type == QrHistoryType.generated
                              ? 'QR Code Gerado'
                              : 'QR Code Escaneado',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  if (item.qrType != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.qrType!,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item.content,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDateTime(item.createdAt),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const Spacer(),
                  if (item.securityLevel != null) ...[
                    Icon(
                      _getSecurityIcon(item.securityLevel!),
                      size: 16,
                      color: _getSecurityColor(context, item.securityLevel!),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getSecurityText(item.securityLevel!),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color:
                                _getSecurityColor(context, item.securityLevel!),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'open':
                          onOpen();
                          break;
                        case 'share':
                          onShare();
                          break;
                        case 'delete':
                          onDelete();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      if (_canOpenContent(item.content))
                        const PopupMenuItem(
                          value: 'open',
                          child: Row(
                            children: [
                              Icon(Icons.open_in_new),
                              SizedBox(width: 8),
                              Text('Abrir'),
                            ],
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'share',
                        child: Row(
                          children: [
                            Icon(Icons.share),
                            SizedBox(width: 8),
                            Text('Compartilhar'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Excluir'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

  String _getSecurityText(String securityLevel) {
    switch (securityLevel.toLowerCase()) {
      case 'safe':
        return 'Seguro';
      case 'warning':
        return 'Atenção';
      case 'dangerous':
        return 'Perigoso';
      default:
        return 'Desconhecido';
    }
  }
}
