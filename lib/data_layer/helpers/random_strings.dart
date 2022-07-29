import 'dart:math';

const _asciiStart = 33;
const _asciiEnd = 126;
const _numericStart = 48;
const _numericEnd = 57;
const _lowerAlphaStart = 97;
const _lowerAlphaEnd = 122;
const _upperAlphaStart = 65;
const _upperAlphaEnd = 90;

/// Generates a random integer where [from] <= [to].
int randomBetween(int from, int to) {
  if (from > to) throw Exception('$from cannot be > $to');
  var rand = Random();
  return ((to - from) * rand.nextDouble()).toInt() + from;
}

/// Generates a random string of [length] with characters
/// between ascii [from] to [to].
/// Defaults to characters of ascii '!' to '~'.
String randomString(int length, {int from = _asciiStart, int to = _asciiEnd}) =>
    String.fromCharCodes(
      List.generate(length, (index) => randomBetween(from, to)),
    );

/// Generates a random string of [length] with only numeric characters.
String randomNumeric(int length) =>
    randomString(length, from: _numericStart, to: _numericEnd);

/// Generates a random string of [length] with only alpha characters.
String randomAlpha(int length) {
  var lowerAlphaLength = randomBetween(0, length);
  var upperAlphaLength = length - lowerAlphaLength;
  var lowerAlpha = randomString(lowerAlphaLength,
      from: _lowerAlphaStart, to: _lowerAlphaEnd);
  var upperAlpha = randomString(upperAlphaLength,
      from: _upperAlphaStart, to: _upperAlphaEnd);
  return randomMerge(lowerAlpha, upperAlpha);
}

/// Generates a random string of [length] with alpha-numeric characters.
String randomAlphaNumeric(int length) {
  var alphaLength = randomBetween(0, length);
  var numericLength = length - alphaLength;
  var alpha = randomAlpha(alphaLength);
  var numeric = randomNumeric(numericLength);
  return randomMerge(alpha, numeric);
}

/// Merge [a] with [b] and scramble characters.
String randomMerge(String a, String b) {
  final mergedCodeUnits = List<int>.from('$a$b'.codeUnits);
  mergedCodeUnits.shuffle();
  return String.fromCharCodes(mergedCodeUnits);
}
