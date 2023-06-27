import 'dart:convert';

import '../../../data_layer/encryption/rsa_cipher.dart';
import '../../models/dpa/dpa_variable.dart';

/// A use case that accepts an encryptionKey and use it to encrypt the value
/// of the variable in a variable list if possible
class EncryptDPAVariableValueUseCase {
  /// The encryption key used for encrypting the variables' values
  final String? encryptionKey;

  /// The [RSACipher] encryption class used to encrypt the [DPAVariable]'s
  /// value using the [encryptionKey]
  final RSACipher cipher;

  /// Create a new [EncryptDPAVariableValueUseCase] instance
  EncryptDPAVariableValueUseCase({
    required this.encryptionKey,
    required this.cipher,
  });

  /// Returns a the list of variables with the value encrypted for the variables
  /// that can/should be encrypted
  List<DPAVariable> call(List<DPAVariable> variables) {
    if (encryptionKey == null) {
      // If the encryption key is not available, just return the values as
      // they are.
      return variables;
    }

    final newVariablesList = <DPAVariable>[];
    for (var variable in variables) {
      final shouldEncrypt =
          (variable.key.isNotEmpty || variable.id.isNotEmpty) &&
              !variable.type.shouldUploadFile &&
              variable.property.encrypt;
      if (shouldEncrypt) {
        final variableId = variable.key.isNotEmpty ? variable.key : variable.id;
        final valueMap = <String, dynamic>{
          variableId: variable.value,
        };
        final encryptedValue = _encrypt(valueMap);
        final updatedVariable = variable.copyWith(value: encryptedValue);
        newVariablesList.add(updatedVariable);
      } else {
        newVariablesList.add(variable);
      }
    }
    return newVariablesList;
  }

  /// Returns the data encrypted using the [encryptionKey].
  String _encrypt(Map<String, dynamic> dictionary) {
    final rsaPublicKey = cipher.parsePublicKeyFromPem(encryptionKey);
    final credentials = json.encode(dictionary);
    final encrypted = cipher.encrypt(credentials, rsaPublicKey);
    final units = encrypted.codeUnits;
    return base64.encode(units);
  }
}
