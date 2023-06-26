import 'dart:convert';

import '../../../data_layer/encryption/rsa_cipher.dart';
import '../../../data_layer/extensions.dart';
import '../../models/dpa/dpa_link_data.dart';
import '../../models/dpa/dpa_variable.dart';

/// A use case that accepts an encryptionKey and use it to encrypt the value
/// of the variable in a variable list if possible
class EncryptDPAVariableValueUseCase {
  /// The encryption key used for encrypting the variables' values
  final String? encryptionKey;

  /// The encryption key future used to get the key and then use the key for
  /// encrypting the variables' values
  final Future<String?>? encryptionKeyFuture;

  /// Create a new [EncryptDPAVariableValueUseCase] instance
  EncryptDPAVariableValueUseCase({
    this.encryptionKey,
    this.encryptionKeyFuture,
  }) : assert(encryptionKey != null || encryptionKeyFuture != null);

  /// Save the loaded encryption key to avoid multiple futures calling
  String? _savedEncryptionKey;

  /// This function returns the encryption key based on what's passed to [this]
  Future<String?> _getEncryptionKey() async {
    if (encryptionKey != null) {
      return encryptionKey!;
    }

    // return the saved key from the future is possible to avoid multiple loads
    if (_savedEncryptionKey != null) {
      return _savedEncryptionKey!;
    }

    // save the key from the future to avoid multiple fethcing
    _savedEncryptionKey = await encryptionKeyFuture!;
    return _savedEncryptionKey;
  }

  /// Returns a the list of variables with the value encrypted for the variables
  /// that can/should be encrypted
  Future<List<DPAVariable>> call(List<DPAVariable> variables) async {
    // get the encryption key - if available
    final encryptionKey = await _getEncryptionKey();

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
        final originalValue = variable.value;
        final originalFixedValue = variable.type.shouldUploadFile
            ? null
            : originalValue is DateTime
                ? originalValue.toDTOString(truncateHours: true)
                : originalValue is List<String>
                    ? _mapListValue(originalValue)
                    : originalValue is DPALinkData
                        ? originalValue.originalText
                        : originalValue;
        final variableId = variable.key.isNotEmpty ? variable.key : variable.id;
        final valueMap = <String, dynamic>{
          variableId: originalFixedValue,
        };
        final encryptedValue = _encrypt(valueMap, encryptionKey);
        final updatedVariable = variable.copyWith(value: encryptedValue);
        newVariablesList.add(updatedVariable);
      } else {
        newVariablesList.add(variable);
      }
    }
    return newVariablesList;
  }

  /// fix the value of the variable when it is a list to be one concatenated
  /// string.
  String _mapListValue(List<String> list) {
    return list.fold(
      '',
      (prev, value) => prev += (prev.isNotEmpty ? '|' : '') + value,
    );
  }

  /// Returns the data encrypted using the [encryptionKey].
  String _encrypt(Map<String, dynamic> dictionary, String encryptionKey) {
    final cipher = RSACipher();
    final rsaPublicKey = cipher.parsePublicKeyFromPem(encryptionKey);
    final credentials = json.encode(dictionary);
    final encrypted = cipher.encrypt(credentials, rsaPublicKey);
    final units = encrypted.codeUnits;
    return base64.encode(units);
  }
}
