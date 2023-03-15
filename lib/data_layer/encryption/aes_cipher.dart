import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';

import 'crypto_utils.dart';

// TODO: rewrite encryption
// ignore_for_file: public_member_api_docs
/// AES Cipher
class AESCipher {
  final Uint8List key;
  late CipherParameters _params;

  // final AESFastEngine _cipher = AESFastEngine();
  final BlockCipher _cipher = PaddedBlockCipher("AES/CBC/PKCS7");

  AESCipher(String key)
      : key = Digest("SHA-256").process(Uint8List.fromList(utf8.encode(key))) {
    var iv = Digest("SHA-256")
        .process(Uint8List.fromList(utf8.encode(key.substring(0, 16))))
        .sublist(0, 16);
    _params = PaddedBlockCipherParameters(
      ParametersWithIV(
        KeyParameter(this.key),
        iv,
      ),
      null,
    );
  }

  String encrypt(String plainText) {
    _cipher
      ..reset()
      ..init(true, _params);

    final output = _cipher.process(Uint8List.fromList(utf8.encode(plainText)));
    return formatBytesAsHexString(output);
  }

  String decrypt(String cipherText) {
    _cipher
      ..reset()
      ..init(false, _params);
    final input = createUint8ListFromHexString(cipherText);
    final output = _cipher.process(input);
    return utf8.decode(output);
  }
}
