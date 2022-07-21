import 'package:equatable/equatable.dart';

/// The state for the [LockScreenCubit].
class LockScreenState extends Equatable {
  /// Whether if the cubit is loading or not.
  /// Default is `false`.
  final bool busy;

  /// Creates a new [LockScreenState].
  const LockScreenState({
    this.busy = false,
  });

  @override
  List<Object?> get props => [];
}
