import 'package:equatable/equatable.dart';
import '../../domain/entities/qr_code_data.dart';

abstract class QrGeneratorState extends Equatable {
  const QrGeneratorState();

  @override
  List<Object?> get props => [];
}

class QrGeneratorInitial extends QrGeneratorState {
  const QrGeneratorInitial();
}

class QrGeneratorLoading extends QrGeneratorState {
  const QrGeneratorLoading();
}

class QrGeneratorSuccess extends QrGeneratorState {
  final QrCodeData qrCodeData;
  final bool showSuccessMessage;

  const QrGeneratorSuccess(this.qrCodeData, {this.showSuccessMessage = true});

  @override
  List<Object?> get props => [qrCodeData, showSuccessMessage];
}

class QrGeneratorError extends QrGeneratorState {
  final String message;

  const QrGeneratorError(this.message);

  @override
  List<Object?> get props => [message];
}

class QrGeneratorReset extends QrGeneratorState {
  const QrGeneratorReset();
}

