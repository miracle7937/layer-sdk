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

  /// The second factor type
  final String secondFactor;

  /// Creates a new [MandateCancelState] instance
  MandateCancelState({
    this.busy = false,
    this.errorMessage = '',
    this.secondFactor = '',
    this.errorStatus = MandateCancelErrorStatus.none,
  });

  @override
  List<Object> get props => [
        busy,
        errorMessage,
        errorStatus,
        secondFactor,
      ];

  /// Creates a copy of [MandateCancelState]
  MandateCancelState copyWith({
    bool? busy,
    String? errorMessage,
    MandateCancelErrorStatus? errorStatus,
    String? secondFactor,
  }) {
    return MandateCancelState(
      busy: busy ?? this.busy,
      errorMessage: errorMessage ?? this.errorMessage,
      errorStatus: errorStatus ?? this.errorStatus,
      secondFactor: secondFactor ?? this.secondFactor,
    );
  }
}
