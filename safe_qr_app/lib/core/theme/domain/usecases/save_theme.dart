import '../entities/theme_entity.dart';
import '../repositories/theme_repository.dart';

class SaveTheme {
  final ThemeRepository repository;

  SaveTheme(this.repository);

  Future<void> call(ThemeEntity theme) async {
    await repository.saveTheme(theme);
  }
}
