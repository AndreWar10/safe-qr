import 'package:equatable/equatable.dart';

enum ScanResult {
  success,
  error,
  permissionDenied,
  cameraNotAvailable,
}

class ScanState extends Equatable {
  final ScanResult result;
  final String? errorMessage;
  final bool isScanning;
  final bool hasPermission;

  const ScanState({
    required this.result,
    this.errorMessage,
    required this.isScanning,
    required this.hasPermission,
  });

  const ScanState.initial()
      : result = ScanResult.success,
        errorMessage = null,
        isScanning = false,
        hasPermission = false;

  const ScanState.scanning()
      : result = ScanResult.success,
        errorMessage = null,
        isScanning = true,
        hasPermission = true;

  const ScanState.success()
      : result = ScanResult.success,
        errorMessage = null,
        isScanning = false,
        hasPermission = true;

  const ScanState.error(String message)
      : result = ScanResult.error,
        errorMessage = message,
        isScanning = false,
        hasPermission = true;

  const ScanState.permissionDenied()
      : result = ScanResult.permissionDenied,
        errorMessage = 'Permissão de câmera negada',
        isScanning = false,
        hasPermission = false;

  const ScanState.cameraNotAvailable()
      : result = ScanResult.cameraNotAvailable,
        errorMessage = 'Câmera não disponível',
        isScanning = false,
        hasPermission = true;

  @override
  List<Object?> get props => [result, errorMessage, isScanning, hasPermission];

  ScanState copyWith({
    ScanResult? result,
    String? errorMessage,
    bool? isScanning,
    bool? hasPermission,
  }) {
    return ScanState(
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
      isScanning: isScanning ?? this.isScanning,
      hasPermission: hasPermission ?? this.hasPermission,
    );
  }
}
