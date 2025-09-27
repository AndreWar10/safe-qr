import '../repositories/local_storage_repository.dart';

class RemoveLocalStorage {
  final LocalStorageRepository _repository;

  RemoveLocalStorage(this._repository);

  Future<void> call(String key) async {
    await _repository.remove(key);
  }
}
