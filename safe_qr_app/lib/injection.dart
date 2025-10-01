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
import 'features/scan_qr/data/repositories/scan_qr_repository_impl.dart';
import 'features/scan_qr/domain/repositories/scan_qr_repository.dart';
import 'features/scan_qr/domain/usecases/get_scanned_qr_codes.dart';
import 'features/scan_qr/domain/usecases/save_scanned_qr_code.dart';
import 'features/scan_qr/domain/usecases/validate_qr_security.dart';
import 'features/scan_qr/data/services/qr_security_validator_impl.dart';
import 'features/scan_qr/domain/services/qr_security_validator.dart';
import 'features/scan_qr/presentation/cubit/scan_qr_cubit.dart';
import 'features/history/data/repositories/history_repository_impl.dart';
import 'features/history/domain/repositories/history_repository.dart';
import 'features/history/domain/usecases/get_history.dart';
import 'features/history/domain/usecases/get_generated_history.dart';
import 'features/history/domain/usecases/get_scanned_history.dart';
import 'features/history/domain/usecases/save_history_item.dart';
import 'features/history/domain/usecases/delete_history_item.dart';
import 'features/history/domain/usecases/clear_history.dart';
import 'features/history/presentation/cubit/history_cubit.dart';
import 'features/generate_qr/presentation/cubit/qr_generator_cubit.dart';

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

  // Scan QR Dependencies
  getIt.registerLazySingleton<ScanQrRepository>(
    () => ScanQrRepositoryImpl(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<QrSecurityValidator>(
    () => QrSecurityValidatorImpl(),
  );

  getIt.registerLazySingleton<GetScannedQrCodes>(
    () => GetScannedQrCodes(getIt<ScanQrRepository>()),
  );

  getIt.registerLazySingleton<SaveScannedQrCode>(
    () => SaveScannedQrCode(getIt<ScanQrRepository>()),
  );

  getIt.registerLazySingleton<ValidateQrSecurity>(
    () => ValidateQrSecurity(getIt<QrSecurityValidator>()),
  );

         getIt.registerFactory<ScanQrCubit>(
           () => ScanQrCubit(
             validateQrSecurity: getIt<ValidateQrSecurity>(),
             saveScannedQrCode: getIt<SaveScannedQrCode>(),
             saveHistoryItem: getIt<SaveHistoryItem>(),
             historyCubit: getIt<HistoryCubit>(),
           ),
         );

  // History Dependencies
  getIt.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImpl(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<GetHistory>(
    () => GetHistory(getIt<HistoryRepository>()),
  );

  getIt.registerLazySingleton<GetGeneratedHistory>(
    () => GetGeneratedHistory(getIt<HistoryRepository>()),
  );

  getIt.registerLazySingleton<GetScannedHistory>(
    () => GetScannedHistory(getIt<HistoryRepository>()),
  );

  getIt.registerLazySingleton<SaveHistoryItem>(
    () => SaveHistoryItem(getIt<HistoryRepository>()),
  );

  getIt.registerLazySingleton<DeleteHistoryItem>(
    () => DeleteHistoryItem(getIt<HistoryRepository>()),
  );

  getIt.registerLazySingleton<ClearHistory>(
    () => ClearHistory(getIt<HistoryRepository>()),
  );

         getIt.registerLazySingleton<HistoryCubit>(
           () => HistoryCubit(
             getGeneratedHistory: getIt<GetGeneratedHistory>(),
             getScannedHistory: getIt<GetScannedHistory>(),
             saveHistoryItem: getIt<SaveHistoryItem>(),
             deleteHistoryItem: getIt<DeleteHistoryItem>(),
             clearHistory: getIt<ClearHistory>(),
           ),
         );

         getIt.registerFactory<QrGeneratorCubit>(
           () => QrGeneratorCubit(
             saveHistoryItem: getIt<SaveHistoryItem>(),
             historyCubit: getIt<HistoryCubit>(),
           ),
         );
}
