import '../entities/theme_entity.dart';
import '../repositories/theme_repository.dart';

class GetTheme {
  final ThemeRepository repository;

  GetTheme(this.repository);

  Future<ThemeEntity> call() async {
    return await repository.getTheme();
  }
}
