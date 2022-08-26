import 'dart:collection';

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
}

/// All the data needed to handle the profile modification
class ProfileState extends Equatable {
  /// The logged-in user.
  final User? user;

  /// The customer information
  final Customer? customer;

  /// The current error status.
  final ProfileErrorStatus error;

  /// The actions that the cubit is performing.
  final UnmodifiableSetView<ProfileBusyAction> actions;

  /// Creates a new profile state
  ProfileState({
    this.user,
    this.customer,
    this.error = ProfileErrorStatus.none,
    Set<ProfileBusyAction> actions = const <ProfileBusyAction>{},
  }) : actions = UnmodifiableSetView(actions);

  @override
  List<Object?> get props => [
        user,
        customer,
        error,
        actions,
      ];

  /// Creates a new state based on this one.
  ProfileState copyWith({
    User? user,
    Customer? customer,
    Set<ProfileBusyAction>? actions,
    ProfileErrorStatus? error,
  }) =>
      ProfileState(
        user: user ?? this.user,
        customer: customer ?? this.customer,
        actions: actions ?? this.actions,
        error: error ?? this.error,
      );
}
