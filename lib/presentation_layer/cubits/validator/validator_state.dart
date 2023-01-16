import '../../cubits.dart';

/// The available busy actions that the cubit can perform.
enum ValidatorActions {
  /// Validating the transaction pin
  validatingTransactionPin,
}

/// The state for the [ValidatorState].
class ValidatorState extends BaseState<ValidatorActions, void, void> {
  /// Creates a new [ValidatorState]
  ValidatorState({
    super.actions = const <ValidatorActions>{},
    super.errors = const <CubitError>{},
  });

  @override
  ValidatorState copyWith({
    Set<ValidatorActions>? actions,
    Set<CubitError>? errors,
  }) {
    return ValidatorState(
      actions: actions ?? this.actions,
      errors: errors ?? this.errors,
    );
  }

  @override
  List<Object?> get props => [
        actions,
        errors,
      ];
}
