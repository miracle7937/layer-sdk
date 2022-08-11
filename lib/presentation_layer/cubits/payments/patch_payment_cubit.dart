import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/network.dart';
import '../../../data_layer/network/net_exceptions.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../../layer_sdk.dart';
import 'patch_payment_state.dart';

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
            initialRecurrence: ScheduleDetails(
              recurrence: paymentToPatch.recurrence,
              startDate: paymentToPatch.recurrenceStart,
              endDate: paymentToPatch.recurrenceEnd,
              executions: (paymentToPatch.recurrence != Recurrence.none &&
                      paymentToPatch.recurrence != Recurrence.once)
                  ? const ScheduleDetails().calculateReccurenceExecutions(
                      paymentToPatch.recurrence,
                      paymentToPatch.recurrenceStart,
                      paymentToPatch.recurrenceEnd,
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
          errorStatus: PatchPaymentErrorStatus.none,
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

      final res = await _patchPaymentUseCase.patch(
        payment ?? state.payment,
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
      emit(
        state.copyWith(
          busy: false,
        ),
      );
      rethrow;
    }
  }

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
  void setScheduleDetails({ScheduleDetails? scheduleDetails}) {
    if (scheduleDetails == null) return;

    emit(
      state.copyWith(
        scheduleDetails: scheduleDetails,
      ),
    );
  }
}
