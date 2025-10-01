// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import '../cubit/scan_qr_cubit.dart';
import '../../domain/entities/scan_state.dart';
import '../../domain/entities/scanned_qr_data.dart';
import '../widgets/scanner_overlay.dart';
import '../widgets/scan_result_dialog.dart';

class ScanQrPage extends StatefulWidget {
  const ScanQrPage({super.key});

  @override
  State<ScanQrPage> createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  MobileScannerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeScanner();
  }

  Future<void> _initializeScanner() async {
    try {
      _controller = MobileScannerController();
      await _controller!.start();
      
      final permission = await Permission.camera.status;
      if (permission.isGranted) {
        context.read<ScanQrCubit>().setPermissionStatus(true);
        context.read<ScanQrCubit>().startScanning();
      } else {
        context.read<ScanQrCubit>().setPermissionDenied();
      }
      
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      context.read<ScanQrCubit>().setCameraNotAvailable();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    
    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;
      if (code != null && code.isNotEmpty) {
        _showScanResult(code);
      }
    }
  }

  Future<void> _showScanResult(String qrContent) async {
    // Para o scanner temporariamente
    context.read<ScanQrCubit>().stopScanning();
    
    // Processa o QR Code
    await context.read<ScanQrCubit>().processScannedQr(qrContent);
    
    // Mostra o diálogo de resultado
    if (mounted) {
      // Aqui você pode obter os dados processados do cubit
      // Por enquanto, vamos criar um objeto temporário
      final scannedData = ScannedQrData(
        content: qrContent,
        securityLevel: QrSecurityLevel.unknown, // Será atualizado pelo cubit
        scannedAt: DateTime.now(),
      );
      
      await showDialog(
        context: context,
        builder: (context) => ScanResultDialog(scannedData: scannedData),
      );
      
      // Reinicia o scanner
      context.read<ScanQrCubit>().startScanning();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner QR Code'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () {
              _controller?.toggleTorch();
            },
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () {
              _controller?.switchCamera();
            },
          ),
        ],
      ),
      body: BlocConsumer<ScanQrCubit, ScanState>(
        listener: (context, state) {
          if (state.result == ScanResult.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Erro desconhecido'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (!state.hasPermission) {
            return _buildPermissionDenied();
          }

          if (!_isInitialized || _controller == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Stack(
            children: [
              MobileScanner(
                controller: _controller!,
                onDetect: _onDetect,
              ),
              const ScannerOverlay(),
              if (state.isScanning)
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Posicione o QR Code dentro do frame',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPermissionDenied() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Permissão de Câmera Necessária',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Para escanear QR Codes, precisamos de acesso à sua câmera.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () async {
                final permission = await Permission.camera.request();
                if (permission.isGranted) {
                  context.read<ScanQrCubit>().setPermissionStatus(true);
                  await _initializeScanner();
                }
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Permitir Acesso'),
            ),
          ],
        ),
      ),
    );
  }
}