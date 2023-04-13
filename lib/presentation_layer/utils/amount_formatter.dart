import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart' as number_symbols_data;

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
    /// This fixes an unhandled exception when the passed locale is not
    /// supported by default by flutter.
    if (languageCode != null) {
      if (number_symbols_data.numberFormatSymbols[languageCode] == null) {
        languageCode = 'en';
      }
    }

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
    /// This fixes an unhandled exception when the passed locale is not
    /// supported by default by flutter.
    if (locale != null) {
      if (number_symbols_data.numberFormatSymbols[locale] == null) {
        locale = 'en';
      }
    }

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

/// Input formatter to limit the user to input an amount between
/// these two boundaries
class AmountInputFormatter {
  /// The min/max amount
  final double? minAmount, maxAmount;

  /// [AmountInputFormatter] input formatter
  AmountInputFormatter({
    this.minAmount,
    this.maxAmount,
  });

  /// This function helps with making sure that
  /// the inputted amount is below the maxAmount.
  /// This is used in the [SliderWidget].
  TextEditingValue maxMinAmountInputFormatter(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (minAmount == null && maxAmount == null) return newValue;
    final String? text = newValue.text;
    if (minAmount != null && text != null) {
      final value = double.tryParse(text);
      if (value != null && value < (minAmount ?? 0)) {
        return oldValue;
      }
    }
    if (maxAmount != null && text != null) {
      final value = double.tryParse(text);
      if (value != null && value > (maxAmount ?? 0)) {
        return oldValue;
      }
    }
    return newValue;
  }

  /// The text input formatter for the desired input
  /// based on the currency selected
  static TextInputFormatter currencyFormatter(
    Currency currency, {
    bool withNegativeNumbers = false,
  }) {
    var decimals = currency.decimals;

    var matcher = withNegativeNumbers
        ? RegExp("^-*\\d*\\.?\\d*\$")
        : RegExp("^\\d*\\.?\\d{0,$decimals}\$");

    return TextInputFormatter.withFunction((oldValue, newValue) {
      var hasMatch = matcher.hasMatch(newValue.text);

      if (hasMatch) return newValue;
      return oldValue;
    });
  }
}
