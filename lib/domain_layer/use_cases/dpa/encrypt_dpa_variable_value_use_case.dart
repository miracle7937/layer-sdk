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

  /// Create a new [EncryptDPAVariableValueUseCase] instance
  EncryptDPAVariableValueUseCase(this.encryptionKey);

  /// Returns a the list of variables with the value encrypted for the variables
  /// that can/should be encrypted
  List<DPAVariable> call(List<DPAVariable> variables) {
    if(encryptionKey == null){
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
        final encryptedValue = _encrypt(valueMap);
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
  String _encrypt(Map<String, dynamic> dictionary) {
    final cipher = RSACipher();
    final rsaPublicKey = cipher.parsePublicKeyFromPem(encryptionKey);
    final credentials = json.encode(dictionary);
    final encrypted = cipher.encrypt(credentials, rsaPublicKey);
    final units = encrypted.codeUnits;
    return base64.encode(units);
  }
}
