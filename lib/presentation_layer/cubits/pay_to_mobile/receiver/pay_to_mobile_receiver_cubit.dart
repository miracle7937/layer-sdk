import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data_layer/helpers/dto_helpers.dart';
import '../../../../features/accounts.dart';
import '../../../../features/pay_to_mobile_receiver.dart';
import '../../base_cubit/base_state.dart';

/// Cubit that handles the receiving of PayToMobile/Cardless payments
class PayToMobileReceiverCubit extends Cubit<PayToMobileReceiverState> {
  /// Use case that posts a new mobile payment
  final PostReceivedPaymentUseCase _postPaymentUseCase;
  final GetCustomerAccountsUseCase _accountsUseCase;

  /// Creates a new [PayToMobileReceiverCubit]
  PayToMobileReceiverCubit({
    required PostReceivedPaymentUseCase postReceivedPaymentUseCase,
    required GetCustomerAccountsUseCase getCustomerAccountsUseCase,
  })  : _postPaymentUseCase = postReceivedPaymentUseCase,
        _accountsUseCase = getCustomerAccountsUseCase,
        super(
          PayToMobileReceiverState(),
        );

  /// Set the withdrawal pin number
  Future<void> setWithdrawalPin(String pin) async {
    emit(
      state.copyWith(
        withdrawalPin: pin,
      ),
    );
  }

  /// Set the withdrawal code
  Future<void> setWithdrawalCode(String code) async {
    emit(
      state.copyWith(
        withdrawalCode: code,
      ),
    );
  }

  /// Loads accounts and set the user account
  Future<void> load() async {
    if (state.accounts.isEmpty ||
        state.errors.contains(PayToMobileReceiverActions.accounts)) {
      emit(
        state.copyWith(
          actions: state.addAction(
            PayToMobileReceiverActions.accounts,
          ),
          errors: state.removeErrorForAction(
            PayToMobileReceiverActions.accounts,
          ),
        ),
      );

      try {
        final accounts = await _accountsUseCase();
        emit(
          state.copyWith(
            actions: state.removeAction(PayToMobileReceiverActions.accounts),
            selectedAccount: accounts.first,
            accounts: accounts,
          ),
        );
      } on Exception catch (e) {
        emit(
          state.copyWith(
            actions: state.removeAction(PayToMobileReceiverActions.accounts),
            errors: state.addErrorFromException(
              action: PayToMobileReceiverActions.accounts,
              exception: e,
            ),
          ),
        );
      }
    }
  }

  /// Post the mobile payment
  Future<void> postPayment({
    required String fromSendMoneyId,
  }) async {
    emit(state.copyWith(
      actions: state.addAction(PayToMobileReceiverActions.submit),
      errors: {},
    ));

    final validationErrors = _validatePayment(fromSendMoneyId);

    if (validationErrors.isNotEmpty) {
      emit(
        state.copyWith(
          actions: state.removeAction(PayToMobileReceiverActions.submit),
          errors: state.addValidationErrors(validationErrors: validationErrors),
        ),
      );

      return;
    }

    try {
      final result = await _postPaymentUseCase(
        fromSendMoneyId: fromSendMoneyId,
        accountId: state.selectedAccount!.accountNumber!,
        withdrawalCode: state.withdrawalCode,
        withdrawalPin: state.withdrawalPin,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(PayToMobileReceiverActions.submit),
          events:
              state.addEvent(PayToMobileReceiverEvents.showConfirmationView),
          errors: {},
        ),
      );
    } on Exception catch (e) {
      // TODO - check error codes for withdrawal code and transfer code
      emit(
        state.copyWith(
          actions: state.removeAction(PayToMobileReceiverActions.submit),
          errors: state.addErrorFromException(
            action: PayToMobileReceiverActions.submit,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Catch all validations
  Set<CubitValidationError<PayToMobileReceiverErrors>> _validatePayment(
    String? sendMoneyId,
  ) {
    final validationErrors =
        <CubitValidationError<PayToMobileReceiverErrors>>{};

    if (state.selectedAccount == null) {
      validationErrors.addError(
        PayToMobileReceiverErrors.noAccountSelectedError,
      );
    }

    if (isEmpty(state.withdrawalPin)) {
      validationErrors.addError(
        PayToMobileReceiverErrors.emptyWithdrawalPin,
      );
    }

    if (isEmpty(state.withdrawalCode)) {
      validationErrors.addError(
        PayToMobileReceiverErrors.emptyWithdrawalCode,
      );
    }

    if (isEmpty(sendMoneyId)) {
      validationErrors.addError(PayToMobileReceiverErrors.sendMoneyIdNotFilled);
    }

    return validationErrors;
  }
}

extension _ValidationHelper
    on Set<CubitValidationError<PayToMobileReceiverErrors>> {
  ///Adds a validation error to the set
  void addError(PayToMobileReceiverErrors error) {
    add(
      CubitValidationError(
        validationErrorCode: error,
      ),
    );
  }
}
