import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data_layer/helpers.dart';
import '../../../../domain_layer/models/bank/bank.dart';
import '../../../../domain_layer/models/beneficiary/beneficiary.dart';
import '../../../../domain_layer/use_cases/bank/get_bank_by_bic_use_case.dart';
import '../../../../features/accounts.dart';
import '../../../../features/pay_to_mobile_receiver.dart';

/// Cubit that handles the receiving of PayToMobile/Cardless payments
class PayToMobileReceiverCubit extends Cubit<PayToMobileReceiverState> {
  /// Use case that posts a new mobile payment
  final PostReceivedPaymentUseCase _postPaymentUseCase;
  final GetCustomerAccountsUseCase _accountsUseCase;
  final GetBankByBicUseCase _getBankByBic;

  /// Creates a new [PayToMobileReceiverCubit]
  PayToMobileReceiverCubit({
    required PostReceivedPaymentUseCase postReceivedPaymentUseCase,
    required GetCustomerAccountsUseCase getCustomerAccountsUseCase,
    required GetBankByBicUseCase getBankByBic,
  })  : _postPaymentUseCase = postReceivedPaymentUseCase,
        _accountsUseCase = getCustomerAccountsUseCase,
        _getBankByBic = getBankByBic,
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

  /// Loads the accounts and the bank for the selected account
  Future<void> load() async {
    emit(
      state.copyWith(
        actions: state.addAction(PayToMobileReceiverActions.loadingData),
        errors: state.removeErrorForAction(
          PayToMobileReceiverActions.loadingData,
        ),
      ),
    );

    try {
      final accounts = await _accountsUseCase();

      final bank = await _getBankByBic(
        bic: accounts.first.extraSwiftCode ?? "",
      );
      emit(
        state.copyWith(
          actions: state.removeAction(PayToMobileReceiverActions.loadingData),
          bank: bank,
          selectedAccount: accounts.first,
          accounts: accounts,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(PayToMobileReceiverActions.loadingData),
          errors: state.addErrorFromException(
            action: PayToMobileReceiverActions.loadingData,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Loads accounts and set the user account
  Future<void> loadingData() async {}

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
        beneficiary: Beneficiary(
          middleName: '',
          nickname: '',
          lastName: '',
          firstName: 'temp',
          bankName: '',
          accountNumber: state.selectedAccount?.extraAccountNumber,
          bankCountryCode: state.bank?.countryCode,
          routingCode: state.selectedAccount?.extraSortCode,
          bank: Bank(
            bic: state.selectedAccount?.extraSwiftCode,
            countryCode: state.bank?.countryCode,
          ),
        ),
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
