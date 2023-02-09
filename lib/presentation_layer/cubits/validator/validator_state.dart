import '../../cubits.dart';

/// The available busy actions that the cubit can perform.
enum ValidatorActions {
  /// Validating the transaction pin
  validatingTransactionPin,
}

/// The available events that the cubit can perform.
enum ValidatorEvent {
  /// In case that the validation is a success
  successEvent,
}

/// The state for the [ValidatorState].
class ValidatorState extends BaseState<ValidatorActions, ValidatorEvent, void> {
  /// Creates a new [ValidatorState]
  ValidatorState({
    super.actions = const <ValidatorActions>{},
    super.errors = const <CubitError>{},
    super.events = const <ValidatorEvent>{},
  });

  @override
  ValidatorState copyWith({
    Set<ValidatorActions>? actions,
    Set<CubitError>? errors,
    Set<ValidatorEvent>? events,
  }) {
    return ValidatorState(
      actions: actions ?? this.actions,
      errors: errors ?? this.errors,
      events: events ?? super.events,
    );
  }

  @override
  List<Object?> get props => [
        actions,
        errors,
        events,
      ];
}
