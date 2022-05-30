/// All the keys for the storage items
class StorageKeys {
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

  /// If the application was already launched since installation.
  static const launchedBefore = 'launchedBefore';

  /// The theme brightness setting
  static const themeBrightness = 'themeBrightness';

  /// The OCRA secret key setting
  static const ocraSecretKey = 'ocraSecretKey';
}
