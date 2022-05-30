import 'dart:math';

/// A generator for OCRA challenge questions.
class OcraChallengeGenerator {
  /// A random value generator.
  final Random _generator;

  /// Creates a new [OcraChallengeGenerator].
  OcraChallengeGenerator(this._generator);

  /// Returns a random numeric challenge for the given length.
  String numericChallenge(int length) {
    const chars = '1234567890';
    return _generate(chars, length);
  }

  /// Returns a random alphanumeric challenge for the given length.
  String alphaNumericChallenge(int length) {
    const chars = '1234567890'
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        'abcdefghijklmnopqrstuvwxyz';
    return _generate(chars, length);
  }

  /// Returns a random string with a specified [length] using the provided
  /// [chars].
  String _generate(String chars, int length) {
    var challenge = '';
    for (var i = 0; i < length; i++) {
      challenge += chars[_generator.nextInt(chars.length)];
    }
    return challenge;
  }
}
