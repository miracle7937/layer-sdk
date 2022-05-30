import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

/// Provides translations for the application.
///
/// Localization files should be located in the following assets folder:
/// "assets/i18n/".
/// Localization json files should be named using the language code:
/// "en.json".
///
/// NOTE: The `Translation` class was renamed from `Localization` to avoid
/// conflicts with the implementation from x-app.
class Translation {
  final _log = Logger('Translation');

  /// When set to true localizations will not be loaded
  /// and the key will be used instead of translation.
  final bool isTest;

  /// The current locale
  final Locale locale;

  late Map<String, String> _sentences;

  /// The path to the directory containing the localization assets.
  ///
  /// If not provided `assets/i18n/` will be used.
  final String? localizationPath;

  /// Creates a new [Translation] with the locale.
  Translation(
    this.locale, {
    this.isTest = false,
    this.localizationPath,
  });

  /// Fetches the closest [Translation] on the tree.
  ///
  /// This method forcefully unwraps the translation, make sure to only call it
  /// with a context that contains the translation.
  static Translation of(BuildContext context) =>
      Localizations.of<Translation>(context, Translation)!;

  /// Used by children to fetch the [Translation] and translate the key.
  ///
  /// This is mainly used as a convenience method when you just have to
  /// translate one key on your widget. If more than one translations are
  /// needed, it's best practice to use the [Translation.of] method to get the
  /// [Translation] object and then call the translate directly on that.
  ///
  /// This method forcefully unwraps the translation, make sure to only call it
  /// with a context that contains the translation.
  static String translateOf(BuildContext context, String key) =>
      Localizations.of<Translation>(context, Translation)!.translate(key);

  /// Creates a test localization that returns keys instead of translations.
  Future<Translation> loadTest(Locale locale) async =>
      Translation(locale, isTest: true);

  /// Loads the localization data from the assets.
  Future<bool> load() async {
    final path = localizationPath ?? 'assets/i18n/';
    final data = await rootBundle.loadString(
      '$path${locale.languageCode}.json',
    );

    Map<String, dynamic> _result = json.decode(data);

    _sentences = {};

    _result.forEach(
      (key, value) => _sentences[key] = value.toString(),
    );

    return true;
  }

  /// Translates a key.
  ///
  /// If the localization is marked as test, just returns the key.
  ///
  /// If the key is not found and it's not a test environment, log a warning.
  ///
  /// If [warnOnKeyNotFound] is `true` (the default), we'll log a warning for
  /// the key that was not found on the localization sheet.
  String translate(String key, {bool warnOnKeyNotFound = true}) {
    if (isTest) return key;

    if (_sentences[key] != null) return _sentences[key]!;

    if (warnOnKeyNotFound) _log.warning('Key not found: $key');

    return key;
  }

  /// Returns a translated key and replaces any [variable] occurrences with
  /// the [value].
  String replaceVariable(
    String key,
    List<String> variables,
    List<String> values,
  ) {
    assert(variables.length == values.length);

    var translation = translate(key);

    for (var i = 0; i < variables.length; i++) {
      translation = translation.replaceAll(
        '{${variables[i]}}',
        values[i],
      );
    }

    return translation;
  }
}

/// The delegate that handles the localization
class LocalizationDelegate extends LocalizationsDelegate<Translation> {
  final _log = Logger('LocalizationDelegate');

  /// The supported language codes for this application.
  final List<String> supportedCodes;

  /// The supported locales for this application.
  Iterable<Locale> get supportedLocales => supportedCodes.map(Locale.new);

  /// When set to true localizations will not be loaded
  /// and the key will be used instead of translation.
  final bool isTest;

  /// The path to the directory containing the localization assets.
  ///
  /// If not provided `assets/i18n/` will be used.
  final String? localizationPath;

  /// Creates a new [LocalizationDelegate].
  LocalizationDelegate({
    required this.supportedCodes,
    this.isTest = false,
    this.localizationPath,
  });

  @override
  bool isSupported(Locale locale) => supportedCodes.contains(
        locale.languageCode,
      );

  @override
  Future<Translation> load(Locale locale) async {
    final translation = Translation(
      locale,
      isTest: isTest,
      localizationPath: localizationPath,
    );

    if (isTest) {
      await translation.loadTest(locale);
    } else {
      await translation.load();
    }

    _log.info("Loaded language: ${locale.languageCode}");

    return translation;
  }

  @override
  bool shouldReload(LocalizationDelegate old) => isTest != old.isTest;
}
