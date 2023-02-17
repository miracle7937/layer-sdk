/// Validates if the provided pin doesn't violate the maximum sequential digits
/// rule.
///
/// It checks if the digits in the pin are not being incremented one by one more
/// than the provided limit allows. For example if the maximum is set to 2, then
/// `124578` is a valid pin, but `123567` is not.
class ValidateAccessPinSequentialDigitsUseCase {
  /// Returns true if the provided pin does **not** break the maximum sequential
  /// digits rule and is therefore considered valid.
  bool call({
    required int maximumSequentialDigits,
    required String pin,
  }) {
    if (pin.isEmpty) return true;
    var occurrenceCount = 0;
    var negOccurrenceCount = 0;

    final s2 = <String>[];
    for (var i = 0; i < pin.length; i++) {
      // checking for arabic just for now
      if (pin.codeUnitAt(i) != 216 && pin.codeUnitAt(i) != 217) {
        s2.add(pin[i]);
      }
    }

    for (var i = 0; i < s2.length - 1; i++) {
      final d1 = s2[i];
      final d2 = s2[i + 1];

      final difference = int.parse(d1) - int.parse(d2);
      if (difference.abs() != 1) {
        occurrenceCount = 0;
        negOccurrenceCount = 0;
      } else if (difference == 1) {
        occurrenceCount += difference;
      } else if (difference == -1) {
        negOccurrenceCount += difference;
      }

      if (occurrenceCount >= maximumSequentialDigits) {
        if (occurrenceCount + negOccurrenceCount.abs() > 1) {
          return false;
        }
      }
      if (negOccurrenceCount.abs() >= maximumSequentialDigits) {
        if ((occurrenceCount + negOccurrenceCount).abs() > 1) {
          return false;
        }
      }
    }

    return true;
  }
}
