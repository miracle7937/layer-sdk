import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../../../../domain_layer/models.dart';

/// A state representing storage values.
class StorageState extends Equatable {
  /// True if the cubit is processing something.
  final bool busy;

  /// The currently logged in user
  final User? currentUser;

  /// List containing all the logged in users.
  final UnmodifiableListView<User> loggedInUsers;

  /// The authentication settings
  final AuthenticationSettings authenticationSettings;

  /// The application settings.
  final ApplicationSettings applicationSettings;

  /// The secret key that can be used to generate a new access token using the
  /// OCRA mutual authentication flow.
  final String? ocraSecretKey;

  /// Creates [StorageState].
  StorageState({
    this.busy = false,
    this.currentUser,
    Iterable<User> loggedInUsers = const [],
    this.authenticationSettings = const AuthenticationSettings(),
    this.applicationSettings = const ApplicationSettings(),
    this.ocraSecretKey,
  }) : loggedInUsers = UnmodifiableListView(loggedInUsers);

  /// Creates a new state based on this one.
  StorageState copyWith({
    bool? busy,
    User? currentUser,
    Iterable<User>? loggedInUsers,
    bool clearCurrentUser = false,
    AuthenticationSettings? authenticationSettings,
    ApplicationSettings? applicationSettings,
    String? ocraSecretKey,
  }) =>
      StorageState(
        busy: busy ?? this.busy,
        currentUser: clearCurrentUser ? null : currentUser ?? this.currentUser,
        loggedInUsers: loggedInUsers ?? this.loggedInUsers,
        authenticationSettings:
            authenticationSettings ?? this.authenticationSettings,
        applicationSettings: applicationSettings ?? this.applicationSettings,
        ocraSecretKey: ocraSecretKey ?? this.ocraSecretKey,
      );

  @override
  List<Object?> get props => [
        busy,
        currentUser,
        loggedInUsers,
        authenticationSettings,
        applicationSettings,
        ocraSecretKey,
      ];
}
