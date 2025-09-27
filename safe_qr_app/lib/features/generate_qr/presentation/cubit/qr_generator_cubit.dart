import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/qr_code_data.dart';
import 'qr_generator_state.dart';

class QrGeneratorCubit extends Cubit<QrGeneratorState> {
  File? _cachedQrImage;
  QrCodeData? _cachedQrData;

  QrGeneratorCubit() : super(const QrGeneratorInitial());

  /// Limpa recursos para economizar memória
  void clearResources() {
    try {
      _cachedQrImage?.deleteSync();
    } catch (e) {
      // Ignora erro se arquivo já foi deletado
    }
    _cachedQrImage = null;
    _cachedQrData = null;
  }

  void generateQrCode(String content, {String? title, QrCodeType type = QrCodeType.text}) {
    if (content.trim().isEmpty) {
      emit(const QrGeneratorError('O conteúdo não pode estar vazio'));
      return;
    }

    emit(const QrGeneratorLoading());

    try {
      // Simula processamento (pode adicionar validações aqui)
      Future.delayed(const Duration(milliseconds: 500), () async {
        final qrData = QrCodeData(
          content: content.trim(),
          createdAt: DateTime.now(),
          title: title?.trim(),
          type: type,
        );

        // Gera e cacheia a imagem do QR Code
        try {
          _cachedQrImage = await _generateQrCodeImage(qrData);
          _cachedQrData = qrData;
        } catch (e) {
          // Se der erro ao gerar imagem, continua sem cache
          _cachedQrImage = null;
          _cachedQrData = qrData;
        }

        emit(QrGeneratorSuccess(qrData));
      });
    } catch (e) {
      emit(QrGeneratorError('Erro ao gerar QR Code: ${e.toString()}'));
    }
  }

  void clearQrCode() {
    // Limpa o cache da imagem
    _cachedQrImage = null;
    _cachedQrData = null;
    
    emit(const QrGeneratorReset());
    // Volta ao estado inicial após um pequeno delay
    Future.delayed(const Duration(milliseconds: 100), () {
      emit(const QrGeneratorInitial());
    });
  }

  /// Limpa tudo quando sair da aba (performance)
  void onTabChanged() {
    clearResources();
    emit(const QrGeneratorInitial());
  }

  void saveQrCode() {
    // Funcionalidade de salvar será implementada futuramente
    // Por enquanto, apenas mostra uma mensagem
  }

  Future<void> shareQrCode() async {
    final currentState = state;
    if (currentState is QrGeneratorSuccess) {
      final qrData = currentState.qrCodeData;
      
      try {
        File imageFile;
        
        // Usa a imagem em cache se disponível, senão gera uma nova
        if (_cachedQrImage != null && _cachedQrData == qrData) {
          imageFile = _cachedQrImage!;
        } else {
          imageFile = await _generateQrCodeImage(qrData);
          _cachedQrImage = imageFile;
          _cachedQrData = qrData;
        }
        
        // Compartilha a imagem
        await Share.shareXFiles(
          [XFile(imageFile.path)],
          text: _buildShareText(qrData),
          subject: qrData.title ?? 'QR Code',
        );
      } catch (e) {
        // Fallback: compartilha apenas o texto se der erro
        await Share.share(
          _buildShareText(qrData),
          subject: qrData.title ?? 'QR Code',
        );
      }
    }
  }

  Future<File> _generateQrCodeImage(QrCodeData qrData) async {
    // Cria um QrPainter diretamente
    final painter = QrPainter(
      data: qrData.content,
      version: QrVersions.auto,
      gapless: false,

      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: Colors.black,
      ),
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: Colors.black,
      ),
    );

    // Gera a imagem do QR Code
    final picData = await painter.toImageData(300, format: ui.ImageByteFormat.png);
    final imageData = picData!.buffer.asUint8List();
    
    // Salva a imagem em um arquivo temporário
    final tempDir = await getTemporaryDirectory();
    final fileName = 'qr_code_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(imageData);
    
    return file;
  }

  String _buildShareText(QrCodeData qrData) {
    final buffer = StringBuffer();
    
    if (qrData.title != null) {
      buffer.writeln('📱 ${qrData.title}');
      buffer.writeln();
    }
    
    buffer.writeln('🔗 Conteúdo do QR Code:');
    buffer.writeln(qrData.content);
    buffer.writeln();
    
    switch (qrData.type) {
      case QrCodeType.email:
        buffer.writeln('📧 Tipo: Email');
        break;
      case QrCodeType.phone:
        buffer.writeln('📞 Tipo: Telefone');
        break;
      case QrCodeType.url:
        buffer.writeln('🌐 Tipo: URL');
        break;
      case QrCodeType.wifi:
        buffer.writeln('📶 Tipo: WiFi');
        break;
      case QrCodeType.sms:
        buffer.writeln('💬 Tipo: SMS');
        break;
      case QrCodeType.text:
        buffer.writeln('📄 Tipo: Texto');
        break;
      default:
        buffer.writeln('📱 Tipo: QR Code');
    }
    
    buffer.writeln();
    buffer.writeln('Criado com Safe QR App');
    
    return buffer.toString();
  }
}
