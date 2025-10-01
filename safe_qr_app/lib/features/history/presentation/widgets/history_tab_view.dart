import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/history_cubit.dart';
import 'history_list_view.dart';

class HistoryTabView extends StatelessWidget {
  const HistoryTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              indicator: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Theme.of(context).colorScheme.onPrimary,
              unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
              tabs: const [
                Tab(
                  icon: Icon(Icons.qr_code),
                  text: 'Gerados',
                ),
                Tab(
                  icon: Icon(Icons.qr_code_scanner),
                  text: 'Escaneados',
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<HistoryCubit, HistoryState>(
              builder: (context, state) {
                return TabBarView(
                  children: [
                    HistoryListView(
                      items: state.generatedHistory,
                      emptyMessage: 'Nenhum QR Code gerado ainda',
                      emptyIcon: Icons.qr_code,
                    ),
                    HistoryListView(
                      items: state.scannedHistory,
                      emptyMessage: 'Nenhum QR Code escaneado ainda',
                      emptyIcon: Icons.qr_code_scanner,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
