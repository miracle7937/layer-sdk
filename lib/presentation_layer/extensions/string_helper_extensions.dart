import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/foundation.dart';

/// Convenience extensions on the String type
extension StringHelperExtension on String {
  /// Capitalizes first letter of a substring
  ///
  /// Input: 'tHis is A string'
  /// Output: 'This is a string'
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';

  /// Capitalizes the first letter of each word on a string
  ///
  /// Input: 'tHis is A string'
  /// Output: 'This Is A String'
  String get capitalizeSentence => split(' ')
      .map(
        (t) => t.capitalize,
      )
      .join(' ');

  /// Replaces all non numeric chars with the provided mask character
  ///
  /// Uses '∙' if no maskCharacter is provided
  String maskDigits({String? maskCharacter}) => replaceAll(
        RegExp(r'[^0-9]'),
        maskCharacter ?? '∙',
      );

  /// Formats the string in the following way
  /// `AAAABBBB` becomes `AAAA BBBB` with a chunkSize of 4
  /// `AAAABBBB` becomes `AA AA BB BB` with a chunkSize of 2
  String formatByChunks(int chunkSize) {
    final chunks = [];

    for (var i = 0; i < length; i += chunkSize) {
      final end = (i + chunkSize < length) ? i + chunkSize : length;
      chunks.add(substring(i, end));
    }

    return chunks.join(' ');
  }

  /// Cleans up a URL string.
  String cleanURL() =>
      replaceAll('http://', '').replaceAll('https://', '').trim();

  /// Whether this string contains a match of [other] ignoring case.
  bool containsIgnoreCase(String other) =>
      toLowerCase().contains(other.toLowerCase());
}

/// Convenience extensions on the List<String> type
extension StringListHelperExtension on List<String?> {
  /// Joins all non nullable Strings of a list with the supplied separator
  ///
  /// Uses ' ∙ ' if no separator is provided
  String joinWithDots({String? separator}) => where(
        (e) => e?.isNotEmpty ?? false,
      ).join(
        // Due to Flutter missing chars on web, we're currently working around
        // it by using a dash for separator.
        separator ?? (kIsWeb ? ' - ' : ' ∙ '),
      );
}

/// Extension that tries to map a country or currency code into DK SVG Resource
extension StringFlagExtension on String {
  /// Gets the currency or country SVG asset path of this string
  ///
  /// Returns `null` if the string is neither a currency or country code.
  String? get currencyOrCountryFlag {
    final currencyFlag = DKFlags.currencyFlag(currency: toUpperCase());
    final currencySplit = currencyFlag.split('/').last;
    if (currencySplit != '.svg') return currencyFlag;

    final countryFlag = DKFlags.countryFlag(countryCode: toUpperCase());
    final countrySplit = countryFlag.split('/').last;
    if (countrySplit != '.svg') return countryFlag;

    return null;
  }
}
