/// Use case for validating an account.
class ValidateAccountUseCase {
  /// Creates a new [ValidateAccountUseCase].
  const ValidateAccountUseCase();

  int _getLengthWithoutWhitespace(String text) =>
      text.replaceAll(RegExp(r"\s+\b|\b\s|\s|\b"), "").length;

  /// check if the string is in a array of allowed values
  bool _isIn(String? str, values) {
    if (values == null || values.length == 0) {
      return false;
    }

    if (values is List) {
      values = values.map((e) => e.toString()).toList();
    }

    return values.indexOf(str) >= 0;
  }

  /// If passed [account] is valid or not.
  ///
  /// Uses the [allowedCharacters] for indicating a set of allowed characters
  /// for the [account].
  bool call({
    required String account,
    String? allowedCharacters,
    int? minAccountChars,
    int? maxAccountChars,
  }) {
    if (account.isEmpty || _getLengthWithoutWhitespace(account) == 0) {
      return false;
    }

    var allowedCharactersList = [];

    for (var rune in (allowedCharacters?.runes ?? Runes('1234567890'))) {
      var character = String.fromCharCode(rune);
      allowedCharactersList.add(character);
    }

    if (account.length < (minAccountChars ?? 8)) {
      return false;
    }

    if (account.length > (maxAccountChars ?? 30)) {
      return false;
    }

    for (var i = 0; i < account.length; i++) {
      var char = account[i];
      if (!_isIn(char, allowedCharactersList)) {
        return false;
      }
    }
    return true;
  }
}
