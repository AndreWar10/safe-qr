import '../../domain/entities/theme_entity.dart';
import '../../domain/repositories/theme_repository.dart';
import '../services/theme_storage_service.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeStorageService _themeStorage;

  ThemeRepositoryImpl(this._themeStorage);

  @override
  Future<ThemeEntity> getTheme() async {
    final mode = await _themeStorage.getThemeMode();
    return ThemeEntity(mode: mode);
  }

  @override
  Future<void> saveTheme(ThemeEntity theme) async {
    await _themeStorage.setThemeMode(theme.mode);
  }
}
