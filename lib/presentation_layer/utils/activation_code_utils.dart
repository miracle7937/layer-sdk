import 'dart:math';

/// A util class for generating the branch activation code.
class ActivationCodeUtils {
  /// The random generator for the activation code.
  final _generator = Random();

  /// The allowed chars for the activation code.
  final _chars = '1234567890'
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  /// Generates the activation code with the provided [length].
  String generateActivationCode(int length) {
    var challenge = '';
    for (var i = 0; i < length; i++) {
      challenge += _chars[_generator.nextInt(_chars.length)];
    }
    return challenge;
  }
}
