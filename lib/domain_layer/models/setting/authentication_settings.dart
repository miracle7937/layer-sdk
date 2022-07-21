import 'package:equatable/equatable.dart';

/// Holds the authentication settings
class AuthenticationSettings extends Equatable {
  /// The domain to log in.
  final String? domain;

  /// The user name to use as default.
  /// It's usually the last username to have logged in.
  final String? defaultUsername;

  /// If should use biometrics for this user.
  final bool useBiometrics;

  /// Creates a new settings object
  const AuthenticationSettings({
    this.domain,
    this.defaultUsername,
    this.useBiometrics = false,
  });

  @override
  List<Object?> get props => [
        domain,
        defaultUsername,
        useBiometrics,
      ];

  /// Creates a new state based on this one.
  AuthenticationSettings copyWith({
    String? domain,
    String? defaultUsername,
    bool? useBiometrics,
  }) =>
      AuthenticationSettings(
        domain: domain ?? this.domain,
        defaultUsername: defaultUsername ?? this.defaultUsername,
        useBiometrics: useBiometrics ?? this.useBiometrics,
      );
}
