import '../repositories/local_storage_repository.dart';

class SetLocalStorage {
  final LocalStorageRepository _repository;

  SetLocalStorage(this._repository);

  Future<void> call<T>(String key, T value) async {
    await _repository.set<T>(key, value);
  }
}
