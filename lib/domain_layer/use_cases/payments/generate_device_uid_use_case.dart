import 'dart:math';

/// Use case to generate a random device uid for each payment
class GenerateDeviceUIDUseCase {
  /// Generates a random integer where [from] <= [to].
  int _randomBetween(int from, int to) {
    if (from > to) throw Exception('$from cannot be > $to');
    var rand = Random();
    return from + rand.nextInt(to - from + 1);
  }

  /// Callable method to generate a random uid
  String call(int length) {
    const allowedChars =
        "01234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnoprstuvwxyz";
    var uuid = '';
    for (var i = 0; i < length; i++) {
      final random = _randomBetween(0, allowedChars.length - 1);
      uuid = '$uuid${allowedChars[random]}';
    }
    return uuid;
  }
}
