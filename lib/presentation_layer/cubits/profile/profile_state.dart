import 'dart:collection';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../../../../domain_layer/models.dart';
import '../../../../domain_layer/models.dart';

/// The available error status
enum ProfileErrorStatus {
  /// No errors
  none,

  /// Generic error
  generic,

  /// Network error
  network,
}

/// Describe what the cubit may be busy performing.
enum ProfileBusyAction {
  /// Loading the user/customer.
  load,

  /// Loading image
  loadingImage,

  /// Uploading image
  uploadingImage,
}

/// All the data needed to handle the profile modification
class ProfileState extends Equatable {
  /// The logged-in user.
  final User? user;

  /// The customer information
  final Customer? customer;

  /// The customer's image
  final Uint8List? image;

  /// The newly uploaded image as base64
  final String? base64;

  /// The current error status.
  final ProfileErrorStatus error;

  /// The actions that the cubit is performing.
  final UnmodifiableSetView<ProfileBusyAction> actions;

  /// The profile settings taken from the console
  final UnmodifiableListView<GlobalSetting> profileConsoleSettings;

  /// Creates a new profile state
  ProfileState({
    this.user,
    this.customer,
    this.image,
    this.base64,
    this.error = ProfileErrorStatus.none,
    Set<ProfileBusyAction> actions = const <ProfileBusyAction>{},
    Iterable<GlobalSetting> profileConsoleSettings = const <GlobalSetting>{},
  })  : actions = UnmodifiableSetView(actions),
        profileConsoleSettings = UnmodifiableListView(profileConsoleSettings);

  @override
  List<Object?> get props => [
        user,
        customer,
        error,
        actions,
        image,
        base64,
        profileConsoleSettings,
      ];

  /// Creates a new state based on this one.
  ProfileState copyWith({
    User? user,
    Customer? customer,
    Set<ProfileBusyAction>? actions,
    ProfileErrorStatus? error,
    Uint8List? image,
    String? base64,
    Iterable<GlobalSetting>? profileConsoleSettings,
  }) =>
      ProfileState(
        user: user ?? this.user,
        customer: customer ?? this.customer,
        actions: actions ?? this.actions,
        error: error ?? this.error,
        image: image ?? this.image,
        base64: base64 ?? this.base64,
        profileConsoleSettings:
            profileConsoleSettings ?? this.profileConsoleSettings,
      );
}
