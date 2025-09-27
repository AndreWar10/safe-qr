import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/theme_entity.dart';
import '../../domain/entities/theme_mode.dart';
import '../../domain/repositories/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  static const String _themeKey = 'app_theme_mode';
  final SharedPreferences _prefs;

  ThemeRepositoryImpl(this._prefs);

  static const AppThemeMode defaultThemeMode = AppThemeMode.dark;

  @override
  Future<ThemeEntity> getTheme() async {
    final themeString = _prefs.getString(_themeKey);
    final mode = themeString != null 
        ? AppThemeMode.fromString(themeString)
        : defaultThemeMode;
        
    return ThemeEntity(mode: mode);
  }

  @override
  Future<void> saveTheme(ThemeEntity theme) async {
    await _prefs.setString(_themeKey, theme.mode.value);
  }
}
