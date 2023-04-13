import 'package:flutter/cupertino.dart';

/// A class containing all the necessary configuration for the app localization.
class AppLocalizationConfiguration {
  /// Localization delegate to be used in the [MaterialApp].
  ///
  /// This field is required.
  final LocalizationsDelegate localizationDelegate;

  /// A collection of supported locales to be passed to the [MaterialApp].
  final Iterable<Locale> supportedLocales;

  /// A custom algorithm to resolve the app locale.
  final LocaleResolutionCallback? localeResolutionCallback;

  /// The list of [LocalizationsDelegate]s for the languages that flutter does
  /// not support by default.
  final List<LocalizationsDelegate> unsupportedLanguageLocalizaitonDelegates;

  /// Creates [AppLocalizationConfiguration].
  AppLocalizationConfiguration({
    required this.localizationDelegate,
    required this.supportedLocales,
    this.localeResolutionCallback,
    this.unsupportedLanguageLocalizaitonDelegates = const [],
  });
}
