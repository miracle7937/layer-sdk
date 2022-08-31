import 'package:equatable/equatable.dart';

///  The current error status
enum MandateCancelErrorStatus {
  ///  No errors
  none,

  ///  Generic error
  generic,

  ///  Network error
  network,
}

/// State for [MandateCancelCubit]
class MandateCancelState extends Equatable {
  /// if the cubit is busy
  final bool busy;

  /// A possible error message
  final String errorMessage;

  /// A possible error status
  final MandateCancelErrorStatus errorStatus;

  /// Creates a new [MandateCancelState] instance
  MandateCancelState({
    this.busy = false,
    this.errorMessage = '',
    this.errorStatus = MandateCancelErrorStatus.none,
  });

  @override
  List<Object?> get props => [
        busy,
        errorMessage,
        errorStatus,
      ];

  /// Creates a copy of [MandateCancelState]
  MandateCancelState copyWith({
    bool? busy,
    String? errorMessage,
    MandateCancelErrorStatus? errorStatus,
  }) {
    return MandateCancelState(
      busy: busy ?? this.busy,
      errorMessage: errorStatus == MandateCancelErrorStatus.none
          ? ''
          : errorMessage ?? this.errorMessage,
      errorStatus: errorStatus ?? this.errorStatus,
    );
  }
}
