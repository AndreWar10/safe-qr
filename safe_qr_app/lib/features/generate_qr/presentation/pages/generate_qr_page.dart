import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/qr_generator_cubit.dart';
import '../cubit/qr_generator_state.dart';
import '../widgets/qr_input_widget.dart';
import '../widgets/qr_code_widget.dart';
import '../widgets/qr_success_widget.dart';

class GenerateQrPage extends StatefulWidget {
  const GenerateQrPage({super.key});

  @override
  State<GenerateQrPage> createState() => _GenerateQrPageState();
}

class _GenerateQrPageState extends State<GenerateQrPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    context.read<QrGeneratorCubit>().clearResources();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Limpa recursos quando app vai para background
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      context.read<QrGeneratorCubit>().clearResources();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code'),
      ),
      body: BlocBuilder<QrGeneratorCubit, QrGeneratorState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Gerador de QR Code',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Widget de input ou sucesso
                BlocBuilder<QrGeneratorCubit, QrGeneratorState>(
                  builder: (context, state) {
                    if (state is QrGeneratorSuccess) {
                      return QrSuccessWidget(
                        onNew: () {
                          context.read<QrGeneratorCubit>().clearQrCode();
                        },
                        onSave: () {
                          context.read<QrGeneratorCubit>().saveQrCode();
                        },
                        onShare: () {
                          context.read<QrGeneratorCubit>().shareQrCode();
                        },
                      );
                    }

                    return QrInputWidget(
                      onGenerate: (content, title, type) {
                        context.read<QrGeneratorCubit>().generateQrCode(
                              content,
                              title: title,
                              type: type,
                            );
                      },
                      isLoading: state is QrGeneratorLoading,
                      shouldReset: state is QrGeneratorReset,
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Widget do QR Code gerado (apenas quando há sucesso)
                BlocBuilder<QrGeneratorCubit, QrGeneratorState>(
                  builder: (context, state) {
                    if (state is QrGeneratorSuccess) {
                      return QrCodeWidget(
                        qrData: state.qrCodeData,
                        size: 250.0,
                      );
                    } else if (state is QrGeneratorError) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Theme.of(context).colorScheme.error,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                state.message,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
