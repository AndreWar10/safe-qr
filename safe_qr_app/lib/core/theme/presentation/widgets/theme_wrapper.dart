import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/theme_bloc.dart';
import '../bloc/theme_event.dart';
import '../bloc/theme_state.dart';
import '../../domain/entities/theme_mode.dart';
import '../themes/app_theme.dart';
import '../../../../injection.dart';

class ThemeWrapper extends StatelessWidget {
  final Widget child;

  const ThemeWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ThemeBloc>()..add(const ThemeLoadRequested()),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return Theme(
            data: _getThemeData(state is ThemeLoaded ? state.theme.isDark : true), 
            child: child,
          );
        },
      ),
    );
  }

  ThemeData _getThemeData(bool isDark) => isDark ? AppTheme.darkTheme : AppTheme.lightTheme;
}

extension ThemeBlocExtension on BuildContext {
  ThemeBloc get themeBloc => read<ThemeBloc>();

  void changeThemeMode(AppThemeMode mode) {
    themeBloc.add(ThemeModeChanged(mode));
  }
}
