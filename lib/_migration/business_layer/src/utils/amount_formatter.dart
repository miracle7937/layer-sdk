import 'package:intl/intl.dart';

import '../../../../domain_layer/models.dart';

// ignore: avoid_classes_with_only_static_members
/// A utils class that exposes some amount formatting functions
class AmountFormatter {
  /// The default pattern to use in [formatAmountWithCurrency].
  static String? defaultPattern;

  /// The default locale to be used in [formatAmountWithCurrency].
  static String? defaultLocale;

  /// Returns a formatted amount depending on the decimal places
  static String formatAmount({
    required num amount,
    required int decimalPlaces,
    String? languageCode,
  }) {
    final formatter = NumberFormat.decimalPattern(languageCode);
    formatter.minimumFractionDigits = decimalPlaces;
    formatter.maximumFractionDigits = decimalPlaces;
    return formatter.format(amount);
  }

  /// Returns a formatted amount using a currency.
  ///
  /// [defaultPattern] will be used if [customPattern] is not provided.
  ///
  /// The grouping and decimal separators are based on [Intl.defaultLocale].
  static String formatAmountWithCurrency(
    num amount, {
    Currency? currency,
    String? customPattern,
    bool addPlus = false,
    int? decimals,
    String? locale,
    bool withSymbol = true,
  }) {
    final formatter = NumberFormat.currency(
      locale: locale ?? defaultLocale,
      decimalDigits: decimals ?? currency?.decimals,
      name: currency?.name ?? null,
      symbol: withSymbol ? (currency?.symbol ?? currency?.code) : '',
      customPattern: customPattern ?? defaultPattern,
    );

    return '${(addPlus && amount > 0) ? '+' : ''}${formatter.format(amount)}'
        .trim();
  }
}
