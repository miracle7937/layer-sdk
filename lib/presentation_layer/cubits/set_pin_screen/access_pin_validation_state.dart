import '../../cubits.dart';

/// The actions that [AccessPinValidationCubit] performs.
enum AccessPinValidationAction {
  /// The global settings that control the validation are being loaded.
  loadSettings,
}

/// The validations errors that [AccessPinValidationCubit] emits.
enum AccessPinValidationError {
  /// The provided pin violates the maximum repetitive characters rule.
  maximumRepetitiveCharacters,

  /// The provided pin violates the maximum sequential digits rule.
  maximumSequentialDigits,
}

/// The state of the [AccessPinValidationCubit].
class AccessPinValidationState extends BaseState<AccessPinValidationAction,
    void, AccessPinValidationError> {
  /// Whether the last validated pin is valid.
  final bool valid;

  /// The maximum number of times the same character in the pin can be directly
  /// repeated.
  final int? maximumRepetitiveCharacters;

  /// The maximum number of times the pin digit can be the last digit
  /// incremented by one.
  final int? maximumSequentialDigits;

  /// Creates new [AccessPinValidationState].
  AccessPinValidationState({
    super.actions,
    super.errors,
    this.valid = false,
    this.maximumRepetitiveCharacters,
    this.maximumSequentialDigits,
  });

  @override
  AccessPinValidationState copyWith({
    Set<AccessPinValidationAction>? actions,
    Set<CubitError>? errors,
    bool? valid,
    int? maximumRepetitiveCharacters,
    int? maximumSequentialDigits,
  }) =>
      AccessPinValidationState(
        actions: actions ?? this.actions,
        errors: errors ?? this.errors,
        valid: valid ?? this.valid,
        maximumRepetitiveCharacters:
            maximumRepetitiveCharacters ?? this.maximumRepetitiveCharacters,
        maximumSequentialDigits:
            maximumSequentialDigits ?? this.maximumSequentialDigits,
      );

  @override
  List<Object?> get props => [
        actions,
        errors,
        events,
        valid,
        maximumRepetitiveCharacters,
        maximumSequentialDigits,
      ];
}
