import '../repositories/local_storage_repository.dart';

class GetLocalStorage {
  final LocalStorageRepository _repository;

  GetLocalStorage(this._repository);

  Future<T?> call<T>(String key) async {
    return await _repository.get<T>(key);
  }
}
