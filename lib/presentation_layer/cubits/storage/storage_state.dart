import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../../../../domain_layer/models.dart';

/// A state representing storage values.
class StorageState extends Equatable {
  /// True if the cubit is processing something.
  final bool busy;

  /// The currently logged in user
  final User? currentUser;

  /// The user access pin.
  final String accessPin;

  /// List containing all the logged in users.
  final UnmodifiableListView<User> loggedInUsers;

  /// The authentication settings
  final AuthenticationSettings authenticationSettings;

  /// The application settings.
  final ApplicationSettings applicationSettings;

  /// The secret key that can be used to generate a new access token using the
  /// OCRA mutual authentication flow.
  final String? ocraSecretKey;

  /// If loyalty tutorial completed.
  final bool loyaltyTutorialCompleted;

  /// Creates [StorageState].
  StorageState({
    this.busy = false,
    this.currentUser,
    this.accessPin = '',
    Iterable<User> loggedInUsers = const [],
    this.authenticationSettings = const AuthenticationSettings(),
    this.applicationSettings = const ApplicationSettings(),
    this.ocraSecretKey,
    this.loyaltyTutorialCompleted = false,
  }) : loggedInUsers = UnmodifiableListView(loggedInUsers);

  /// Creates a new state based on this one.
  StorageState copyWith({
    bool? busy,
    User? currentUser,
    String? accessPin,
    Iterable<User>? loggedInUsers,
    bool clearCurrentUser = false,
    AuthenticationSettings? authenticationSettings,
    ApplicationSettings? applicationSettings,
    String? ocraSecretKey,
    bool? loyaltyTutorialCompleted,
  }) =>
      StorageState(
        busy: busy ?? this.busy,
        currentUser: clearCurrentUser ? null : currentUser ?? this.currentUser,
        accessPin: accessPin ?? this.accessPin,
        loggedInUsers: loggedInUsers ?? this.loggedInUsers,
        authenticationSettings:
            authenticationSettings ?? this.authenticationSettings,
        applicationSettings: applicationSettings ?? this.applicationSettings,
        ocraSecretKey: ocraSecretKey ?? this.ocraSecretKey,
        loyaltyTutorialCompleted:
            loyaltyTutorialCompleted ?? this.loyaltyTutorialCompleted,
      );

  @override
  List<Object?> get props => [
        busy,
        currentUser,
        accessPin,
        loggedInUsers,
        authenticationSettings,
        applicationSettings,
        ocraSecretKey,
        loyaltyTutorialCompleted,
      ];
}
