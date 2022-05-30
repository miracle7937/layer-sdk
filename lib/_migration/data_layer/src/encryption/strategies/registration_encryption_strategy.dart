import 'dart:convert';

import '../../../encryption.dart';

/// A strategy for encrypting registration parameters.
///
/// This base strategy provider the encryption logic, subclasses should only
/// define the data to be encrypted by implementing the [getDictionary] method.
abstract class RegistrationEncryptionStrategy<T> {
  /// The key to be used for encryption.
  final String encryptionKey;

  /// Creates [RegistrationEncryptionStrategy].
  RegistrationEncryptionStrategy(this.encryptionKey);

  /// Returns a dictionary of data to encrypt.
  Map<String, dynamic> getDictionary(T data);

  /// Returns the data encrypted using the [encryptionKey].
  String encrypt(T data) {
    // TODO: refactor encryption and consider web needs
    final dictionary = getDictionary(data);
    final cipher = RSACipher();
    final rsaPublicKey = cipher.parsePublicKeyFromPem(encryptionKey);
    final credentials = json.encode(dictionary);
    final encrypted = cipher.encrypt(credentials, rsaPublicKey);
    final units = encrypted.codeUnits;
    return base64.encode(units);
  }
}
