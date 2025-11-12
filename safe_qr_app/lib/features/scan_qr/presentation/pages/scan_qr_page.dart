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
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final permission = await Permission.camera.status;
    if (permission.isGranted) {
      context.read<ScanQrCubit>().setPermissionStatus(true);
    } else {
      context.read<ScanQrCubit>().setPermissionDenied();
    }
  }

  Future<void> _startScanning() async {
    try {
      if (_controller == null) {
        _controller = MobileScannerController();
        await _controller!.start();
      }

      context.read<ScanQrCubit>().startScanning();
      setState(() {
        _isScanning = true;
      });
    } catch (e) {
      context.read<ScanQrCubit>().setCameraNotAvailable();
    }
  }

  Future<void> _stopScanning() async {
    if (_controller != null) {
      await _controller!.stop();
      _controller?.dispose();
      _controller = null;
    }

    context.read<ScanQrCubit>().stopScanning();
    setState(() {
      _isScanning = false;
    });
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
    await _stopScanning();

    if (!mounted) {
      return;
    }

    _showAnalyzingDialog(context);

    final analyzeFuture =
        context.read<ScanQrCubit>().processScannedQr(qrContent);

    await Future.wait([
      analyzeFuture,
      Future.delayed(const Duration(seconds: 3)),
    ]);

    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    final scannedData = await analyzeFuture;

    if (!mounted || scannedData == null) {
      return;
    }

    await showDialog(
      context: context,
      builder: (context) => ScanResultDialog(scannedData: scannedData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner QR Code'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: _isScanning
            ? [
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
              ]
            : null,
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

          if (_isScanning && _controller != null) {
            return _buildScannerView();
          }

          return _buildInitialView();
        },
      ),
    );
  }

  Widget _buildInitialView() {
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
                Icons.qr_code_scanner,
                size: 80,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Scanner QR Code',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Toque no botão abaixo para iniciar o scanner e escanear QR Codes com segurança.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            FilledButton.icon(
              onPressed: _startScanning,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Iniciar Scanner'),
              style: FilledButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ).copyWith(
                textStyle: MaterialStateProperty.all(
                  const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    inherit: false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerView() {
    return Stack(
      children: [
        MobileScanner(
          controller: _controller!,
          onDetect: _onDetect,
        ),
        const ScannerOverlay(),
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
        Positioned(
          top: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: _stopScanning,
            backgroundColor: Colors.red,
            child: const Icon(Icons.stop, color: Colors.white),
          ),
        ),
      ],
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

  void _showAnalyzingDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Analisando QR Code...',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Isso pode levar alguns segundos.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
