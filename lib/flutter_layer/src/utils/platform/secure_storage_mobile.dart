import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../secure_storage.dart';

/// Uses [FlutterSecureStorage] to handle sensitive data storage.
///
/// On iOS `kSecAttrAccessibleWhenUnlockedThisDeviceOnly` flag is used to
/// prevent the secure data to be transferred to another device.
class PlatformSecureStorage implements SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Creates a new [PlatformSecureStorage].
  const PlatformSecureStorage();

  @override
  Future<bool> getBool({required String key}) async {
    final value = await _storage.read(key: key);
    return value == 'T';
  }

  @override
  Future<bool> setBool({
    required String key,
    required bool value,
  }) async {
    return _setString(key: key, value: value ? 'T' : 'F');
  }

  @override
  Future<int?> getInt({required String key}) async {
    final value = await _storage.read(key: key);
    return value == null ? null : int.tryParse(value);
  }

  @override
  Future<String?> getString({required String key}) {
    return _storage.read(key: key);
  }

  @override
  Future<bool> remove({required String key}) async {
    try {
      await _storage.delete(key: key);
      return true;
    } on Exception {
      return false;
    }
  }

  @override
  Future<bool> setInt({
    required String key,
    required int value,
  }) {
    return _setString(
      key: key,
      value: value.toString(),
    );
  }

  @override
  Future<bool> setString({
    required String key,
    required String value,
  }) {
    return _setString(key: key, value: value);
  }

  Future<bool> _setString({
    required String key,
    required String value,
  }) async {
    try {
      await _storage.write(
        key: key,
        value: value,
        iOptions: IOSOptions(
          // The `kSecAttrAccessibleWhenUnlockedThisDeviceOnly` flag is used to
          // prevent a security vulnerability.
          accessibility: IOSAccessibility.unlocked_this_device,
        ),
      );
      return true;
    } on Exception {
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>?> getJson(String key) async {
    final value = await _storage.read(key: key);
    return value == null ? null : json.decode(value);
  }

  @override
  Future<bool> setJson(String key, Map<String, dynamic> jsonMap) {
    return _setString(key: key, value: json.encode(jsonMap));
  }

  @override
  Future<void> removeAll() => _storage.deleteAll();
}
