import 'package:equatable/equatable.dart';
import '../../domain/entities/theme_mode.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ThemeLoadRequested extends ThemeEvent {
  const ThemeLoadRequested();
}

class ThemeModeChanged extends ThemeEvent {
  final AppThemeMode mode;

  const ThemeModeChanged(this.mode);

  @override
  List<Object?> get props => [mode];
}
