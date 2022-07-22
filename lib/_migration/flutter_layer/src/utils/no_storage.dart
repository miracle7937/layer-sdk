import 'dart:convert';

import 'package:logging/logging.dart';

import '../../../../data_layer/interfaces.dart';

/// An implementation of [GenericStorage] that does not store anything, only
/// logs accesses to it.
///
/// This can be used on web apps that do not rely on anything to be saved on the
/// secure storage (as this may be a security issue).
///
/// Creating this should not break any feature on your app, while logging
/// all accesses to help pinpoint where the app should work differently.
class NoStorage implements GenericStorage {
  final _log = Logger('NoStorage');

  Future<bool> _setString({
    required String key,
    required String value,
  }) async {
    _log.info('Ignored saving key "$key"');

    return false;
  }

  @override
  Future<bool> getBool({required String key}) async {
    _log.info('Returned boolean default false for key "$key"');

    return false;
  }

  @override
  Future<bool> setBool({
    required String key,
    required bool value,
  }) async =>
      _setString(key: key, value: value ? 'T' : 'F');

  @override
  Future<int?> getInt({required String key}) async {
    _log.info('Returned int default null for key "$key"');

    return null;
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
  Future<String?> getString({required String key}) async {
    _log.info('Returned string default null for key "$key"');

    return null;
  }

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
    _log.info('Returned json default null for key "$key"');

    return null;
  }

  @override
  Future<bool> setJson(String key, Map<String, dynamic> jsonMap) =>
      _setString(key: key, value: json.encode(jsonMap));

  @override
  Future<bool> remove({required String key}) async {
    _log.info('Ignoring removing key "$key"');

    return false;
  }

  @override
  Future<void> removeAll() async => _log.info('Ignoring removing all keys');
}
