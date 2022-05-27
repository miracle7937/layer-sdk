import 'dart:typed_data';

import 'package:pointycastle/api.dart' show KeyParameter;
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/pbkdf2.dart';
import 'package:pointycastle/macs/hmac.dart';
import 'package:pointycastle/random/fortuna_random.dart';

import 'crypto_utils.dart';

// TODO: rewrite encryption
// ignore_for_file: public_member_api_docs
/// PBKDF2
class PBKDF2 {
  final int blockLength;
  final int iterationCount;
  final int desiredKeyLength;

  late PBKDF2KeyDerivator _derivator;
  late Uint8List _salt;

  String get saltHex => formatBytesAsHexString(_salt);

  PBKDF2({
    this.blockLength = 64,
    this.iterationCount = 1000,
    this.desiredKeyLength = 64,
    String? salt,
  }) {
    final rnd = FortunaRandom()..seed(KeyParameter(Uint8List(32)));
    _salt =
        salt == null ? rnd.nextBytes(32) : createUint8ListFromHexString(salt);

    _derivator = PBKDF2KeyDerivator(HMac(SHA256Digest(), blockLength))
      ..init(Pbkdf2Parameters(_salt, iterationCount, desiredKeyLength));
  }

  String hash(String password) {
    final bytes = _derivator.process(Uint8List.fromList(password.codeUnits));
    return String.fromCharCodes(bytes);
  }
}
