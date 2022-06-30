/// Keys for the storage items
abstract class FlutterStorageKeys {
  /// Code of the language selected by the user.
  static const userSelectedLanguageCode = 'user_selected_language_code';

  /// Name of the light theme selected by the user.
  static const userSelectedLightTheme = 'user_selected_light_theme';

  /// Name of the dark theme selected by the user.
  static const userSelectedDarkTheme = 'user_selected_dark_theme';

  /// Theme mode selected by the user.
  static const userSelectedThemeMode = 'user_selected_theme_mode';

  /// If the application was already launched since installation.
  static const launchedBefore = 'launchedBefore';

  /// The default domain to use when selecting one to connect to.
  static const authDomain = 'auth_domain';

  /// The default username used when authenticating
  static const authDefaultUsername = 'auth_default_username';

  /// If should use biometrics when authenticating the user
  static const authUseBiometrics = 'auth_use_biometrics';

  /// The data of users that are logged in.
  static const loggedUsers = 'logged_users';

  /// Current amount of times the user can try verifying the access pin
  static const remainingPinAttempts = 'remaining_pin_attempts';

  /// The theme brightness setting
  static const themeBrightness = 'themeBrightness';

  /// The OCRA secret key setting
  static const ocraSecretKey = 'ocraSecretKey';
}
