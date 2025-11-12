import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/entities/scanned_qr_data.dart';
import '../../domain/repositories/scan_qr_repository.dart';

class ScanQrRepositoryImpl implements ScanQrRepository {
  final SharedPreferences _prefs;
  static const String _scannedQrCodesKey = 'scanned_qr_codes';

  ScanQrRepositoryImpl(this._prefs);

  @override
  Future<List<ScannedQrData>> getScannedQrCodes() async {
    final jsonString = _prefs.getString(_scannedQrCodesKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => ScannedQrData.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> saveScannedQrCode(ScannedQrData qrData) async {
    final existingCodes = await getScannedQrCodes();
    existingCodes.add(qrData);

    final jsonList = existingCodes.map((code) => code.toJson()).toList();
    await _prefs.setString(_scannedQrCodesKey, jsonEncode(jsonList));
  }

  @override
  Future<void> deleteScannedQrCode(String id) async {
    final existingCodes = await getScannedQrCodes();
    existingCodes.removeWhere((code) => code.content == id);

    final jsonList = existingCodes.map((code) => code.toJson()).toList();
    await _prefs.setString(_scannedQrCodesKey, jsonEncode(jsonList));
  }

  @override
  Future<void> clearScannedQrCodes() async {
    await _prefs.remove(_scannedQrCodesKey);
  }
}
