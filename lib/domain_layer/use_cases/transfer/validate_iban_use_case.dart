/// Use case for validating an IBAN account code.
class ValidateIBANUseCase {
  /// Creates a new [ValidateIBANUseCase].
  const ValidateIBANUseCase();

  /// Returns whether if the passed [iban] is valid or not.
  ///
  /// Use the [allowedCharacters] for indicating a set of allowed characters
  /// for the [iban].
  bool call({
    required String iban,
    List<String>? allowedCharacters,
  }) {
    if (iban.trim().length < 5) {
      return false;
    }

    allowedCharacters ??=
        'abcedfghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
            .split('');

    final hasInvalidCharacters = iban
        .split('')
        .where((character) => !allowedCharacters!.contains(character))
        .isNotEmpty;

    if (hasInvalidCharacters) {
      return false;
    }

    iban = iban.substring(4) + iban.substring(0, 4);
    var mods = StringBuffer();

    for (var i = 0; i < iban.length; i++) {
      var c = iban[i];
      var n = c.codeUnitAt(0);

      if (n > 64 && n < 91) {
        n = n - 55;
        mods.write(n.toString());
        mods = StringBuffer(mods.toString());
      } else {
        mods.write(c);
        mods = StringBuffer(mods.toString());
      }
    }

    try {
      final b = BigInt.tryParse(mods.toString());
      final modVal = BigInt.from(97);
      final resVal = b?.modPow(BigInt.from(1), modVal);
      if (resVal?.toInt() != 1) {
        return false;
      }
    } on Exception {
      return false;
    }

    return true;
  }
}
