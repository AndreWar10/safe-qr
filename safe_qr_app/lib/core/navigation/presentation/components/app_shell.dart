import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bottom_navigation_bar.dart';
import '../cubit/navigation_cubit.dart';
import '../../domain/entities/navigation_state.dart';
import '../../../../features/scan_qr/presentation/pages/scan_qr_page.dart';
import '../../../../features/generate_qr/presentation/pages/generate_qr_page.dart';
import '../../../../features/history/presentation/pages/history_page.dart';
import '../../../../features/settings/presentation/pages/settings_page.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  static const List<Widget> _pages = [
    ScanQrPage(),
    GenerateQrPage(),
    HistoryPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.currentIndex,
            children: _pages,
          ),
          bottomNavigationBar: AppBottomNavigationBar(
            currentIndex: state.currentIndex,
            onTap: (index) =>
                context.read<NavigationCubit>().navigateToTab(index),
          ),
        );
      },
    );
  }
}
