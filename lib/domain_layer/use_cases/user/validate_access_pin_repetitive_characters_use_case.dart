/// Validates if the provided pin doesn't violate the maximum repetitive
/// characters rule.
///
/// It checks if any character in the pin is not repeated more then the allowed
/// maximum. For example if the maximum is set to 2, then `112345` is a valid
/// pin, but `111234` is not.
class ValidateAccessPinRepetitiveCharactersUseCase {
  /// Returns true if the provided pin does **not** break the maximum repetitive
  /// characters rule and is therefore considered valid.
  bool call({
    required int maximumRepetitiveCharacters,
    required String pin,
  }) {
    if (pin.isEmpty) return true;
    var lastChar = pin[0];
    var lastCharCount = 1;
    for (var i = 1; i < pin.length; i++) {
      if (pin[i] == lastChar) {
        lastCharCount++;
        if (lastCharCount > maximumRepetitiveCharacters) {
          return false;
        }
      } else {
        lastChar = pin[i];
        lastCharCount = 1;
      }
    }
    return true;
  }
}
