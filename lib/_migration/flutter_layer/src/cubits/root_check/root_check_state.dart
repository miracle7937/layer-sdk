import 'package:equatable/equatable.dart';

/// The state representing the status of the root check.
class RootCheckState extends Equatable {
  /// True when the root check is in progress.
  final bool busy;

  /// The current status of the root check.
  final RootCheckStatus status;

  /// Creates a new [RootCheckState].
  RootCheckState({
    this.busy = false,
    this.status = RootCheckStatus.unknown,
  });

  /// Returns a modified copy.
  RootCheckState copyWith({
    bool? busy,
    RootCheckStatus? status,
  }) =>
      RootCheckState(
        busy: busy ?? this.busy,
        status: status ?? this.status,
      );

  @override
  List<Object?> get props => [
        busy,
        status,
      ];
}

/// The status of the root check.
enum RootCheckStatus {
  /// The status has not been checked yet.
  unknown,

  /// The device is rooted and the user should not be allowed to access the app.
  rootedDisallowed,

  /// The device is rooted and the user should see a warning before accessing
  /// the app.
  rootedAllowed,

  /// The device is not rooted.
  nonRooted,

  /// The root check failed.
  failed,
}
