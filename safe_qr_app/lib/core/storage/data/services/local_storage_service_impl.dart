import '../../domain/usecases/get_local_storage.dart';
import '../../domain/usecases/set_local_storage.dart';
import '../../domain/usecases/remove_local_storage.dart';
import '../../domain/usecases/clear_local_storage.dart';
import '../../domain/services/local_storage_service.dart';

class LocalStorageServiceImpl implements LocalStorageService {
  final GetLocalStorage _getLocalStorage;
  final SetLocalStorage _setLocalStorage;
  final RemoveLocalStorage _removeLocalStorage;
  final ClearLocalStorage _clearLocalStorage;

  LocalStorageServiceImpl({
    required GetLocalStorage getLocalStorage,
    required SetLocalStorage setLocalStorage,
    required RemoveLocalStorage removeLocalStorage,
    required ClearLocalStorage clearLocalStorage,
  })  : _getLocalStorage = getLocalStorage,
        _setLocalStorage = setLocalStorage,
        _removeLocalStorage = removeLocalStorage,
        _clearLocalStorage = clearLocalStorage;

  @override
  Future<T?> get<T>(String key) async {
    return await _getLocalStorage.call<T>(key);
  }

  @override
  Future<void> set<T>(String key, T value) async {
    await _setLocalStorage.call(key, value);
  }

  @override
  Future<void> remove(String key) async {
    await _removeLocalStorage.call(key);
  }

  @override
  Future<void> clear() async {
    await _clearLocalStorage.call();
  }
}
