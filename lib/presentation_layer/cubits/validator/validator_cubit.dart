import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain_layer/use_cases.dart';
import 'validator_state.dart';

/// A cubit that manages the validations on the projects
class ValidatorCubit extends Cubit<ValidatorState> {
  final ValidateTransactionPinUseCase _validateTransactionPinUseCase;

  /// Creates a new [ValidatorCubit]
  ValidatorCubit({
    required ValidateTransactionPinUseCase validateTransactionPinUseCase,
  })  : _validateTransactionPinUseCase = validateTransactionPinUseCase,
        super(
          ValidatorState(),
        );

  /// Validate the transaction pin by `txnPin`
  Future<void> validate({
    required String txnPin,
    required String userId,
  }) async {
    emit(
      state.copyWith(
        actions: state.addAction(
          ValidatorActions.validatingTransactionPin,
        ),
        errors: state.removeErrorForAction(
          ValidatorActions.validatingTransactionPin,
        ),
        events: state.removeEvent(
          ValidatorEvent.successEvent,
        ),
      ),
    );

    try {
      await _validateTransactionPinUseCase(
        txnPin: txnPin,
        userId: userId,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            ValidatorActions.validatingTransactionPin,
          ),
          events: state.addEvent(ValidatorEvent.successEvent),
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(
        actions: state.removeAction(ValidatorActions.validatingTransactionPin),
        errors: state.addErrorFromException(
          action: ValidatorActions.validatingTransactionPin,
          exception: e,
        ),
      ));
    }
  }
}
