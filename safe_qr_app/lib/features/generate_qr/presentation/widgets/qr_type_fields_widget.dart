import 'package:flutter/material.dart';
import '../../domain/entities/qr_code_data.dart';

class QrTypeFieldsWidget extends StatefulWidget {
  final QrCodeType selectedType;
  final Function(String content) onContentChanged;
  final Function(String? title) onTitleChanged;
  final bool shouldReset;

  const QrTypeFieldsWidget({
    super.key,
    required this.selectedType,
    required this.onContentChanged,
    required this.onTitleChanged,
    this.shouldReset = false,
  });

  @override
  State<QrTypeFieldsWidget> createState() => _QrTypeFieldsWidgetState();
}

class _QrTypeFieldsWidgetState extends State<QrTypeFieldsWidget> {
  final _titleController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  final _phoneController = TextEditingController();
  final _urlController = TextEditingController();
  final _ssidController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneSmsController = TextEditingController();
  final _messageController = TextEditingController();
  final _textController = TextEditingController();

  String _wifiSecurity = 'WPA';

  @override
  void didUpdateWidget(QrTypeFieldsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldReset && !oldWidget.shouldReset) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _resetAllFields();
      });
    }
  }

  void _resetAllFields() {
    if (mounted) {
      _titleController.clear();
      _emailController.clear();
      _subjectController.clear();
      _bodyController.clear();
      _phoneController.clear();
      _urlController.clear();
      _ssidController.clear();
      _passwordController.clear();
      _phoneSmsController.clear();
      _messageController.clear();
      _textController.clear();
      _wifiSecurity = 'WPA';
      
      widget.onContentChanged('');
      widget.onTitleChanged(null);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    _phoneController.dispose();
    _urlController.dispose();
    _ssidController.dispose();
    _passwordController.dispose();
    _phoneSmsController.dispose();
    _messageController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _updateContent() {
    String content = '';
    String? title;

    // Só usa o título se o usuário digitou algo no campo título
    if (_titleController.text.trim().isNotEmpty) {
      title = _titleController.text.trim();
    }

    switch (widget.selectedType) {
      case QrCodeType.email:
        final email = _emailController.text.trim();
        final subject = _subjectController.text.trim();
        final body = _bodyController.text.trim();
        if (email.isNotEmpty) {
          content = 'mailto:$email';
          if (subject.isNotEmpty || body.isNotEmpty) {
            final params = <String>[];
            if (subject.isNotEmpty) params.add('subject=${Uri.encodeComponent(subject)}');
            if (body.isNotEmpty) params.add('body=${Uri.encodeComponent(body)}');
            content += '?${params.join('&')}';
          }
        }
        break;

      case QrCodeType.phone:
        final phone = _phoneController.text.trim();
        if (phone.isNotEmpty) {
          content = 'tel:$phone';
        }
        break;

      case QrCodeType.url:
        final url = _urlController.text.trim();
        if (url.isNotEmpty) {
          content = url.startsWith('http') ? url : 'https://$url';
        }
        break;

      case QrCodeType.wifi:
        final ssid = _ssidController.text.trim();
        final password = _passwordController.text.trim();
        if (ssid.isNotEmpty) {
          content = 'WIFI:T:$_wifiSecurity;S:$ssid;P:$password;H:false;;';
        }
        break;

      case QrCodeType.sms:
        final phone = _phoneSmsController.text.trim();
        final message = _messageController.text.trim();
        if (phone.isNotEmpty) {
          content = 'sms:$phone';
          if (message.isNotEmpty) {
            content += ':${Uri.encodeComponent(message)}';
          }
        }
        break;

      case QrCodeType.text:
        content = _textController.text.trim();
        break;

      default:
        content = _textController.text.trim();
        break;
    }

    widget.onContentChanged(content);
    widget.onTitleChanged(title);
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        // Campo de título (sempre visível)
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'Título (opcional)',
            prefixIcon: const Icon(Icons.title),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          onChanged: (_) => _updateContent(),
        ),
        const SizedBox(height: 12),

        // Campos específicos por tipo
        ..._buildTypeSpecificFields(),
      ],
    );
  }

  List<Widget> _buildTypeSpecificFields() {
    
    switch (widget.selectedType) {
      case QrCodeType.email:
        return [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'Email',
              prefixIcon: const Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            onChanged: (_) => _updateContent(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _subjectController,
            decoration: InputDecoration(
              hintText: 'Assunto',
              prefixIcon: const Icon(Icons.subject),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            onChanged: (_) => _updateContent(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _bodyController,
            decoration: InputDecoration(
              hintText: 'Corpo da mensagem',
              prefixIcon: const Icon(Icons.message),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            onChanged: (_) => _updateContent(),
          ),
        ];

      case QrCodeType.phone:
        return [
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              hintText: 'Número do telefone',
              prefixIcon: const Icon(Icons.phone),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.phone,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            onChanged: (_) => _updateContent(),
          ),
        ];

      case QrCodeType.url:
        return [
          TextField(
            controller: _urlController,
            decoration: InputDecoration(
              hintText: 'URL do site',
              prefixIcon: const Icon(Icons.link),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.url,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            onChanged: (_) => _updateContent(),
          ),
        ];

      case QrCodeType.wifi:
        return [
          TextField(
            controller: _ssidController,
            decoration: InputDecoration(
              hintText: 'Nome da rede (SSID)',
              prefixIcon: const Icon(Icons.wifi),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            onChanged: (_) => _updateContent(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              hintText: 'Senha da rede',
              prefixIcon: const Icon(Icons.lock),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            obscureText: true,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            onChanged: (_) => _updateContent(),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _wifiSecurity,
            decoration: InputDecoration(
              hintText: 'Tipo de segurança',
              prefixIcon: const Icon(Icons.security),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'WPA', child: Text('WPA/WPA2')),
              DropdownMenuItem(value: 'WEP', child: Text('WEP')),
              DropdownMenuItem(value: 'nopass', child: Text('Sem senha')),
            ],
            onChanged: (value) {
              setState(() {
                _wifiSecurity = value!;
              });
              _updateContent();
            },
          ),
        ];

      case QrCodeType.sms:
        return [
          TextField(
            controller: _phoneSmsController,
            decoration: InputDecoration(
              hintText: 'Número do telefone',
              prefixIcon: const Icon(Icons.phone),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            keyboardType: TextInputType.phone,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            onChanged: (_) => _updateContent(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _messageController,
            decoration: InputDecoration(
              hintText: 'Mensagem',
              prefixIcon: const Icon(Icons.message),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            onChanged: (_) => _updateContent(),
          ),
        ];

      default:
        return [
          TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'Digite o texto...',
              prefixIcon: const Icon(Icons.edit),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            onChanged: (_) => _updateContent(),
          ),
        ];
    }
  }
}
