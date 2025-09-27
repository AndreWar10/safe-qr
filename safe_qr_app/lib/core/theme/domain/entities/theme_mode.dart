enum AppThemeMode {
  light,
  dark;

  String get value {
    switch (this) {
      case AppThemeMode.light:
        return 'light';
      case AppThemeMode.dark:
        return 'dark';
    }
  }

  static AppThemeMode fromString(String value) {
    switch (value) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
      default:
        return AppThemeMode.dark;
    }
  }
}
