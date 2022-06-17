import 'dart:math';

import '../../utils.dart';

/// The use case responsible for generating OCRA challenges.
///
/// It depends on the OCRA suite value to decide for whether the challenge
/// should be numeric or alphanumeric and for what should be the challenge
/// length.
class GenerateOcraChallengeUseCase {
  /// The characters allowed for the numeric challenges.
  static const allowedNumericCharacters = '1234567890';

  /// The characters allowed for the alphanumeric challenges.
  static const allowedAlphanumericCharacters = '1234567890'
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      'abcdefghijklmnopqrstuvwxyz';

  /// A random value generator.
  final Random _generator;

  /// The configuration string for the OCRA algorithm.
  final String _ocraSuite;

  /// Creates a new [GenerateOcraChallengeUseCase].
  GenerateOcraChallengeUseCase({
    required Random generator,
    required String ocraSuite,
  })  : _generator = generator,
        _ocraSuite = ocraSuite;

  /// Returns a random OCRA challenge.
  String call() {
    final type = _ocraSuite.questionType;
    final length = _ocraSuite.questionLength;
    if (type == null || length == null) {
      throw ArgumentError(
        'The provided ocra suite does not contain '
        'the challenge question specification',
      );
    }
    switch (type) {
      case 'N':
        return _generate(allowedNumericCharacters, length);
      case 'A':
        return _generate(allowedAlphanumericCharacters, length);
      default:
        throw UnsupportedError(
          'Challenge question described by "$type" is not supported',
        );
    }
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
