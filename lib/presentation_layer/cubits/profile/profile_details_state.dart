import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

/// All possible errors for [ProfileState]
enum ProfileDetailsStateError {
  /// No error
  none,

  /// Generic error
  generic,
}

/// A state representing the profile in the app.
class ProfileDetailsState extends Equatable {
  /// This field is null before the profile is fetched.
  final Profile? profile;

  /// True if the cubit is processing something.
  /// This is calculated by what action is the cubit performing.
  final bool busy;

  /// The last occurred error
  final ProfileDetailsStateError error;

  /// Creates the [ProfileDetailsState].
  ProfileDetailsState({
    this.profile,
    this.busy = false,
    this.error = ProfileDetailsStateError.none,
  });

  /// Creates a new instance of [ProfileState] based on this one.
  ProfileDetailsState copyWith({
    Profile? profile,
    bool? busy,
    ProfileDetailsStateError? error,
  }) {
    return ProfileDetailsState(
      profile: profile ?? this.profile,
      busy: busy ?? this.busy,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        profile,
        busy,
        error,
      ];
}
