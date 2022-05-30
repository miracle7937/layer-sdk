import 'dart:convert';
import 'dart:html';

import 'package:logging/logging.dart';

import '../secure_storage.dart';

/// Uses the session storage on the web as a secure storage.
///
/// This follows the idea used on the x-app web project.
///
/// Warning: this is not really secure. Only use and store values that can
/// be compromised.
///
/// Review if your web app really needs to store anything securely. Unlike the
/// mobile app, it does not need to keep the logged user, as the user should
/// log in by session. If you don't need to store anything, please create
/// the [NoStorage] object instead.
class PlatformSecureStorage implements SecureStorage {
  final _log = Logger('PlatformSecureStorage - Web');

  /// Creates a new [PlatformSecureStorage].
  PlatformSecureStorage();

  Future<bool> _setString({
    required String key,
    required String value,
  }) async {
    try {
      window.sessionStorage[key] = value;

      return true;
    } on Exception catch (e) {
      _log.severe('Error saving key "$key" with "$value". Exception: $e');

      return false;
    }
  }

  @override
  Future<bool> getBool({required String key}) async =>
      window.sessionStorage[key] == 'T';

  @override
  Future<bool> setBool({
    required String key,
    required bool value,
  }) async =>
      _setString(key: key, value: value ? 'T' : 'F');

  @override
  Future<int?> getInt({required String key}) async {
    final value = window.sessionStorage[key];

    return value == null ? null : int.tryParse(value);
  }

  @override
  Future<bool> setInt({
    required String key,
    required int value,
  }) =>
      _setString(
        key: key,
        value: value.toString(),
      );

  @override
  Future<String?> getString({required String key}) async =>
      window.sessionStorage[key];

  @override
  Future<bool> setString({
    required String key,
    required String value,
  }) =>
      _setString(
        key: key,
        value: value,
      );

  @override
  Future<Map<String, dynamic>?> getJson(String key) async {
    final value = window.sessionStorage[key];

    return value == null ? null : json.decode(value);
  }

  @override
  Future<bool> setJson(String key, Map<String, dynamic> jsonMap) =>
      _setString(key: key, value: json.encode(jsonMap));

  @override
  Future<bool> remove({required String key}) async {
    try {
      window.sessionStorage.remove(key);

      return true;
    } on Exception catch (e) {
      _log.severe('Error removing key "$key". Exception: $e');

      return false;
    }
  }

  @override
  Future<void> removeAll() async => window.sessionStorage.clear();
}
