import 'package:flutter/material.dart';
import '../../domain/entities/qr_code_data.dart';
import 'qr_type_fields_widget.dart';

class QrInputWidget extends StatefulWidget {
  final Function(String content, String? title, QrCodeType type) onGenerate;
  final bool isLoading;
  final bool shouldReset;

  const QrInputWidget({
    super.key,
    required this.onGenerate,
    this.isLoading = false,
    this.shouldReset = false,
  });

  @override
  State<QrInputWidget> createState() => _QrInputWidgetState();
}

class _QrInputWidgetState extends State<QrInputWidget> {
  QrCodeType _selectedType = QrCodeType.text;
  String _content = '';
  String? _title;

  @override
  void didUpdateWidget(QrInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldReset && !oldWidget.shouldReset) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _resetForm();
      });
    }
  }

  void _resetForm() {
    if (mounted) {
      setState(() {
        _selectedType = QrCodeType.text;
        _content = '';
        _title = null;
      });
    }
  }

  void _generateQrCode() {
    if (!_isFormValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_getEmptyContentMessage()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    widget.onGenerate(_content, _title, _selectedType);
  }

  bool _isFormValid() {
    switch (_selectedType) {
      case QrCodeType.email:
        return _content.contains('mailto:') && _content.split('mailto:')[1].isNotEmpty;
      case QrCodeType.phone:
        return _content.contains('tel:') && _content.split('tel:')[1].isNotEmpty;
      case QrCodeType.url:
        return _content.isNotEmpty && (_content.startsWith('http://') || _content.startsWith('https://'));
      case QrCodeType.wifi:
        return _content.contains('WIFI:') && _content.contains('S:') && _content.split('S:')[1].split(';')[0].isNotEmpty;
      case QrCodeType.sms:
        return _content.contains('sms:') && _content.split('sms:')[1].split(':')[0].isNotEmpty;
      default:
        return _content.isNotEmpty;
    }
  }

  String _getEmptyContentMessage() {
    switch (_selectedType) {
      case QrCodeType.email:
        return 'Por favor, digite o email';
      case QrCodeType.phone:
        return 'Por favor, digite o número do telefone';
      case QrCodeType.url:
        return 'Por favor, digite a URL';
      case QrCodeType.wifi:
        return 'Por favor, digite o nome da rede WiFi';
      case QrCodeType.sms:
        return 'Por favor, digite o número do telefone';
      default:
        return 'Por favor, digite algum conteúdo';
    }
  }

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
              '📝 Criar QR Code',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Seletor de tipo
            Text(
              'Tipo de QR Code:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            
            Wrap(
              spacing: 8,
              children: QrCodeType.values.map((type) {
                final isSelected = _selectedType == type;
                return FilterChip(
                  selected: isSelected,
                  showCheckmark: false,
                  label: Text('${type.icon} ${type.displayName}'),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedType = type;
                        _content = '';
                        _title = null;
                      });
                    }
                  },
                );
              }).toList(),
            ),
            
            const SizedBox(height: 16),

            // Campos específicos por tipo
            QrTypeFieldsWidget(
              selectedType: _selectedType,
              shouldReset: widget.shouldReset,
              onContentChanged: (content) {
                setState(() {
                  _content = content;
                });
              },
              onTitleChanged: (title) {
                setState(() {
                  _title = title;
                });
              },
            ),
            
            const SizedBox(height: 20),

            // Botão de gerar
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: (widget.isLoading || !_isFormValid()) ? null : _generateQrCode,
                icon: widget.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.qr_code),
                label: Text(widget.isLoading ? 'Gerando...' : 'Gerar QR Code'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
