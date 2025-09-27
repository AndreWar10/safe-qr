import 'package:equatable/equatable.dart';
import 'theme_mode.dart';

class ThemeEntity extends Equatable {
  final AppThemeMode mode;

  const ThemeEntity({
    required this.mode,
  });

  bool get isDark => mode == AppThemeMode.dark;

  @override
  List<Object?> get props => [mode];

  ThemeEntity copyWith({
    AppThemeMode? mode,
  }) {
    return ThemeEntity(
      mode: mode ?? this.mode,
    );
  }
}
