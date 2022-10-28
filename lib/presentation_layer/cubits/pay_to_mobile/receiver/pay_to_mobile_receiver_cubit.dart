import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data_layer/helpers.dart';
import '../../../../features/accounts.dart';
import '../../../../features/pay_to_mobile_receiver.dart';

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
          PayToMobileReceiverState(
            deviceUUID: randomAlphaNumeric(30),
          ),
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

  /// Post the mobile payment
  Future<void> postPayment({
    required String fromSendMoneyId,
  }) async {
    emit(
      state.copyWith(
        actions: state.addAction(PayToMobileReceiverActions.submit),
        errors: {},
        events: state.removeEvent(
          PayToMobileReceiverEvent.showSuccessDialog,
        ),
      ),
    );

    try {
      await _postPaymentUseCase(
        fromSendMoneyId: fromSendMoneyId,
        accountId: state.selectedAccount!.id!,
        withdrawalCode: state.withdrawalCode,
        withdrawalPin: state.withdrawalPin,
        deviceUUID: state.deviceUUID,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(PayToMobileReceiverActions.submit),
          events: state.addEvent(PayToMobileReceiverEvent.showSuccessDialog),
          errors: {},
        ),
      );
    } on Exception catch (e) {
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
}
