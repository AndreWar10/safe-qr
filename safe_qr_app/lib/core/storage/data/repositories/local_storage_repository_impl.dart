import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/local_storage_repository.dart';

class LocalStorageRepositoryImpl implements LocalStorageRepository {
  final SharedPreferences _prefs;

  LocalStorageRepositoryImpl(this._prefs);

  @override
  Future<T?> get<T>(String key) async {
    try {
      final value = _prefs.getString(key);
      if (value == null) return null;

      if (T == String) {
        return value as T;
      } else if (T == int) {
        return _prefs.getInt(key) as T?;
      } else if (T == bool) {
        return _prefs.getBool(key) as T?;
      } else if (T == double) {
        return _prefs.getDouble(key) as T?;
      } else {
        return jsonDecode(value) as T;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> set<T>(String key, T value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else {
      await _prefs.setString(key, jsonEncode(value));
    }
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    return _prefs.containsKey(key);
  }
}
