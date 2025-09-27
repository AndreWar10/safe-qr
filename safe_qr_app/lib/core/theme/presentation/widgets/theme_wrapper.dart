import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/theme_bloc.dart';
import '../bloc/theme_event.dart';
import '../bloc/theme_state.dart';
import '../../domain/entities/theme_mode.dart';
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
          if (state is ThemeLoaded) {
            return Theme(
              data: _getThemeData(state.theme.isDark),
              child: child,
            );
          }
          
          // Fallback para tema escuro enquanto carrega
          return Theme(
            data: _getThemeData(true),
            child: child,
          );
        },
      ),
    );
  }

  ThemeData _getThemeData(bool isDark) {
    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      useMaterial3: true,
    );
  }
}

// Extensão para facilitar o acesso ao ThemeBloc
extension ThemeBlocExtension on BuildContext {
  ThemeBloc get themeBloc => read<ThemeBloc>();
  
  void changeThemeMode(AppThemeMode mode) {
    themeBloc.add(ThemeModeChanged(mode));
  }
}
