import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data_layer/interfaces.dart';

/// Uses [SharedPreferences] to handle preferences storage.
///
/// Should not be used to store sensitive data.
class PreferencesStorage implements GenericStorage {
  SharedPreferences? _preferences;

  /// Lazy getter for a [SharedPreferences] instance.
  Future<SharedPreferences> get _storage async {
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
    return _preferences!;
  }

  final _log = Logger('MobileStorage');

  @override
  Future<String?> getString({required String key}) async {
    final storage = await _storage;
    return storage.getString(key);
  }

  @override
  Future<bool> setString({
    required String key,
    required String value,
  }) async {
    try {
      final storage = await _storage;
      await storage.setString(key, value);
      return true;
    } on Exception catch (e) {
      _log.severe(e);
      return false;
    }
  }

  @override
  Future<int?> getInt({required String key}) async {
    final storage = await _storage;
    return storage.getInt(key);
  }

  @override
  Future<bool> setInt({
    required String key,
    required int value,
  }) async {
    final storage = await _storage;
    return storage.setInt(key, value);
  }

  @override
  Future<bool?> getBool({required String key}) async {
    final storage = await _storage;
    return storage.getBool(key);
  }

  @override
  Future<bool> setBool({
    required String key,
    required bool value,
  }) async {
    final storage = await _storage;
    return storage.setBool(key, value);
  }

  @override
  Future<bool> remove({required String key}) async {
    try {
      final storage = await _storage;
      await storage.remove(key);
      return true;
    } on Exception catch (e) {
      _log.severe(e);
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>?> getJson(String key) async {
    final storage = await _storage;
    final value = storage.getString(key);
    return value == null ? null : json.decode(value);
  }

  @override
  Future<bool> setJson(String key, Map<String, dynamic> jsonMap) async {
    final storage = await _storage;
    return storage.setString(key, json.encode(jsonMap));
  }

  @override
  Future<void> removeAll() async {
    final storage = await _storage;
    await storage.clear();
  }
}
