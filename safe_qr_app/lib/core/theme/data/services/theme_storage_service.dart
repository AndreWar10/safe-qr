import '../../../storage/domain/services/local_storage_service.dart';
import '../../../storage/constants/local_storage_keys.dart';
import '../../domain/entities/theme_mode.dart';

class ThemeStorageService {
  final LocalStorageService _storage;

  ThemeStorageService(this._storage);

  Future<AppThemeMode> getThemeMode() async {
    final themeString = await _storage.get<String>(LocalStorageKeys.themeMode);
    return themeString != null
        ? AppThemeMode.fromString(themeString)
        : AppThemeMode.dark;
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    await _storage.set(LocalStorageKeys.themeMode, mode.value);
  }

  Future<void> removeThemeMode() async {
    await _storage.remove(LocalStorageKeys.themeMode);
  }
}
