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
import 'core/storage/data/repositories/local_storage_repository_impl.dart';
import 'core/storage/domain/repositories/local_storage_repository.dart';
import 'core/storage/domain/usecases/get_local_storage.dart';
import 'core/storage/domain/usecases/set_local_storage.dart';
import 'core/storage/domain/usecases/remove_local_storage.dart';
import 'core/storage/domain/usecases/clear_local_storage.dart';
import 'core/storage/domain/services/local_storage_service.dart';
import 'core/storage/data/services/local_storage_service_impl.dart';
import 'core/theme/data/services/theme_storage_service.dart';
import 'core/navigation/presentation/cubit/navigation_cubit.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  getIt.registerLazySingleton<LocalStorageRepository>(
    () => LocalStorageRepositoryImpl(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<GetLocalStorage>(
    () => GetLocalStorage(getIt<LocalStorageRepository>()),
  );

  getIt.registerLazySingleton<SetLocalStorage>(
    () => SetLocalStorage(getIt<LocalStorageRepository>()),
  );

  getIt.registerLazySingleton<RemoveLocalStorage>(
    () => RemoveLocalStorage(getIt<LocalStorageRepository>()),
  );

  getIt.registerLazySingleton<ClearLocalStorage>(
    () => ClearLocalStorage(getIt<LocalStorageRepository>()),
  );

  getIt.registerLazySingleton<LocalStorageService>(
    () => LocalStorageServiceImpl(
      getLocalStorage: getIt<GetLocalStorage>(),
      setLocalStorage: getIt<SetLocalStorage>(),
      removeLocalStorage: getIt<RemoveLocalStorage>(),
      clearLocalStorage: getIt<ClearLocalStorage>(),
    ),
  );

  getIt.registerLazySingleton<ThemeStorageService>(
    () => ThemeStorageService(getIt<LocalStorageService>()),
  );

  getIt.registerLazySingleton<ThemeRepository>(
    () => ThemeRepositoryImpl(getIt<ThemeStorageService>()),
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

  getIt.registerFactory<NavigationCubit>(
    () => NavigationCubit(),
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
