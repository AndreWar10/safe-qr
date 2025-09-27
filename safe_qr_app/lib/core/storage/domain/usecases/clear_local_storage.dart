import '../repositories/local_storage_repository.dart';

class ClearLocalStorage {
  final LocalStorageRepository _repository;

  ClearLocalStorage(this._repository);

  Future<void> call() async {
    await _repository.clear();
  }
}
