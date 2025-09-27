import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/data/repositories/theme_repository_impl.dart';
import 'core/theme/domain/repositories/theme_repository.dart';
import 'core/theme/domain/usecases/get_theme.dart';
import 'core/theme/domain/usecases/save_theme.dart';
import 'core/theme/presentation/bloc/theme_bloc.dart';
import 'core/logger/data/repositories/logger_repository_impl.dart';
import 'core/logger/domain/repositories/logger_repository.dart';
import 'core/logger/domain/usecases/log_message.dart';
import 'core/logger/domain/services/logger_service.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);
  getIt.registerLazySingleton<ThemeRepository>(
    () => ThemeRepositoryImpl(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<GetTheme>(
    () => GetTheme(getIt<ThemeRepository>()),
  );

  getIt.registerLazySingleton<SaveTheme>(
    () => SaveTheme(getIt<ThemeRepository>()),
  );

  getIt.registerFactory<ThemeBloc>(
    () => ThemeBloc(
      getTheme: getIt<GetTheme>(),
      saveTheme: getIt<SaveTheme>(),
    ),
  );

  getIt.registerLazySingleton<LoggerRepository>(
    () => LoggerRepositoryImpl(),
  );

  getIt.registerLazySingleton<LogMessage>(
    () => LogMessage(getIt<LoggerRepository>()),
  );

  getIt.registerLazySingleton<LoggerService>(
    () => LoggerService(
      logMessage: getIt<LogMessage>(),
    ),
  );
}
