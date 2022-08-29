import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/network.dart';
import '../../../data_layer/network/net_exceptions.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../../layer_sdk.dart';
import 'patch_payment_state.dart';

/// TODO: cubit_issue | As discussed with Hassan, this cubit and the
/// [PaymentCubit] share lot of duplicated logic. We should create a base
/// state and try to reuse the common parameters there.
///
/// A cubit for patching customer bill payments.
class PatchPaymentCubit extends Cubit<PatchPaymentState> {
  final GetAccountsByStatusUseCase _getCustomerAccountsUseCase;
  final PatchPaymentUseCase _patchPaymentUseCase;

  /// Creates a new cubit
  PatchPaymentCubit({
    required GetAccountsByStatusUseCase getCustomerAccountsUseCase,
    required PatchPaymentUseCase patchPaymentUseCase,
    required Payment paymentToPatch,
  })  : _getCustomerAccountsUseCase = getCustomerAccountsUseCase,
        _patchPaymentUseCase = patchPaymentUseCase,
        super(
          PatchPaymentState(
            payment: paymentToPatch,
            initiallySelectedAccount: paymentToPatch.fromAccount,
            initialAmount: paymentToPatch.amount ?? 0.0,
            scheduleDetails: ScheduleDetails(
              recurrence: paymentToPatch.recurrence,
              startDate: paymentToPatch.recurrenceStart,
              endDate: paymentToPatch.recurrenceEnd,
              executions: (paymentToPatch.recurrence != Recurrence.none &&
                      paymentToPatch.recurrence != Recurrence.once)
                  ? const ScheduleDetails().calculateReccurenceExecutions(
                      paymentToPatch.recurrence,
                      paymentToPatch.recurrenceStart!,
                      paymentToPatch.recurrenceEnd!,
                    )
                  : null,
            ),
          ),
        );

  /// Loads all the required data, must be called at lease once before anything
  /// other method in this cubit.
  void load() async {
    emit(
      state.copyWith(
        busy: true,
        errorStatus: PatchPaymentErrorStatus.none,
      ),
    );
    try {
      final accounts = await _getCustomerAccountsUseCase(
        statuses: [
          AccountStatus.active,
        ],
        includeDetails: false,
      );

      emit(
        state.copyWith(
          busy: false,
          fromAccounts: accounts
              .where((element) => element.canPay)
              .toList(growable: false),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorStatus: e is NetException
              ? PatchPaymentErrorStatus.network
              : PatchPaymentErrorStatus.generic,
        ),
      );
    }
  }

  /// TODO: cubit_issue | Why is the payment nullable? This is the payment
  /// that we want to submit, right? And also, why should we pass it as a
  /// parameter when we have it on the state at this point?
  ///
  /// Submits the payment
  Future<Payment> submit({
    String? otp,
    Payment? payment,
    bool resendOtp = false,
  }) async {
    try {
      emit(
        state.copyWith(
          busy: true,
          busyAction: resendOtp
              ? PatchPaymentBusyAction.resendingOTP
              : otp != null
                  ? PatchPaymentBusyAction.validatingSecondFactor
                  : PatchPaymentBusyAction.submitting,
        ),
      );

      final res = await _patchPaymentUseCase(
        state.paymentToBePatched.copyWith(
          otpId: payment?.otpId,
        ),
        otp: otp,
        resendOtp: resendOtp,
      );

      emit(
        state.copyWith(
          busy: false,
        ),
      );

      return res;
    } on Exception catch (_) {
      /// TODO: cubit_issue | Handle errors.
      emit(
        state.copyWith(
          busy: false,
        ),
      );
      rethrow;
    }
  }

  /// TODO: cubit_issue | The account id should be required. Using a nullable
  /// parameter here does no have any effect, will copy the payment on the state
  /// with the same from account that the object used to have.
  ///
  /// Sets the selected account to the one matching the provided account id.
  void setFromAccount(String? accountId) {
    final selectedAccount = state.fromAccounts.firstWhereOrNull(
      (e) => e.id == accountId,
    );
    emit(
      state.copyWith(
        payment: state.payment.copyWith(fromAccount: selectedAccount),
      ),
    );
  }

  /// Sets the amount of the payment
  void setAmount(double amount) {
    emit(
      state.copyWith(
        payment: state.payment.copyWith(amount: amount),
      ),
    );
  }

  /// Set the payments scheduling details
  /// TODO: cubit_issue | If we are going to return when the passed schedule
  /// details are null, why not indicating this parameter as required?
  void setScheduleDetails({
    ScheduleDetails? scheduleDetails,
  }) {
    if (scheduleDetails == null) return;

    emit(
      state.copyWith(
        scheduleDetails: scheduleDetails,
      ),
    );
  }
}
