import 'dart:async';

/// Interface for the storage used by the layers.
abstract class GenericStorage {
  /// Returns a string value for the key.
  Future<String?> getString({required String key});

  /// Saves the string value for a key
  Future<bool> setString({
    required String key,
    required String value,
  });

  /// Returns a int value for the key.
  Future<int?> getInt({required String key});

  /// Saves the int value for a key
  Future<bool> setInt({
    required String key,
    required int value,
  });

  /// Returns a boolean value for the key.
  Future<bool?> getBool({required String key});

  /// Saves the boolean value for a key
  Future<bool> setBool({
    required String key,
    required bool value,
  });

  /// Saves the json value for the key.
  Future<bool> setJson(
    String key,
    Map<String, dynamic> json,
  );

  /// Returns the json value for the key.
  Future<Map<String, dynamic>?> getJson(String key);

  /// Removes a key from storage.
  Future<bool> remove({required String key});

  /// Removes all stored values.
  Future<void> removeAll();
}
