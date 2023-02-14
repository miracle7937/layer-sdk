import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../../layer_sdk.dart';
import '../../cubits.dart';

/// TODO: cubit_issue | As discussed with Hassan, this cubit and the
/// [PaymentCubit] share lot of duplicated logic. We should create a base
/// state and try to reuse the common parameters there.
///
/// A cubit for patching customer bill payments.
class PatchPaymentCubit extends Cubit<PatchPaymentState> {
  final _logger = Logger('PatchPaymentCubit');

  final GetAccountsByStatusUseCase _getCustomerAccountsUseCase;
  final PatchPaymentUseCase _patchPaymentUseCase;
  final SendOTPCodeForPaymentUseCase _sendOTPCodeForPaymentUseCase;
  final VerifyPaymentSecondFactorUseCase _verifyPaymentSecondFactorUseCase;
  final ResendPaymentSecondFactorUseCase _resendPaymentSecondFactorUseCase;

  /// Creates a new cubit
  PatchPaymentCubit({
    required GetAccountsByStatusUseCase getCustomerAccountsUseCase,
    required PatchPaymentUseCase patchPaymentUseCase,
    required Payment paymentToPatch,
    required SendOTPCodeForPaymentUseCase sendOTPCodeForPaymentUseCase,
    required VerifyPaymentSecondFactorUseCase verifyPaymentSecondFactorUseCase,
    required ResendPaymentSecondFactorUseCase resendPaymentSecondFactorUseCase,
  })  : _getCustomerAccountsUseCase = getCustomerAccountsUseCase,
        _patchPaymentUseCase = patchPaymentUseCase,
        _sendOTPCodeForPaymentUseCase = sendOTPCodeForPaymentUseCase,
        _verifyPaymentSecondFactorUseCase = verifyPaymentSecondFactorUseCase,
        _resendPaymentSecondFactorUseCase = resendPaymentSecondFactorUseCase,
        super(
          PatchPaymentState(
            payment: paymentToPatch,
            initiallySelectedAccount: paymentToPatch.fromAccount,
            initialAmount: paymentToPatch.amount ?? 0.0,
            scheduleDetails: ScheduleDetails(
              recurrence: paymentToPatch.recurrence,
              startDate:
                  paymentToPatch.recurrenceStart ?? paymentToPatch.scheduled,
              endDate: paymentToPatch.recurrenceEnd,
              executions: (paymentToPatch.recurrence != Recurrence.none &&
                      paymentToPatch.recurrence != Recurrence.once)
                  ? const ScheduleDetails().calculateRecurrenceExecutions(
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
        actions: state.addAction(
          PatchPaymentAction.loading,
        ),
        errors: state.removeErrorForAction(
          PatchPaymentAction.loading,
        ),
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
          actions: state.removeAction(PatchPaymentAction.loading),
          fromAccounts: accounts
              .where((element) => element.canPay)
              .toList(growable: false),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            PatchPaymentAction.loading,
          ),
          errors: state.addErrorFromException(
            action: PatchPaymentAction.loading,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Submits the payment
  Future<void> submit() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          PatchPaymentAction.submitting,
        ),
        errors: state.removeErrorForAction(
          PatchPaymentAction.submitting,
        ),
        events: state.removeEvents(
          {
            PatchPaymentEvent.showResultView,
            PatchPaymentEvent.openSecondFactor,
          },
        ),
      ),
    );

    try {
      final returnedPayment = await _patchPaymentUseCase(
        state.paymentToBePatched,
      );

      switch (returnedPayment.status) {
        case PaymentStatus.completed:
        case PaymentStatus.pending:
        case PaymentStatus.scheduled:
        case PaymentStatus.pendingBank:
          emit(
            state.copyWith(
              actions: state.removeAction(
                PatchPaymentAction.submitting,
              ),
              returnedPayment: state.paymentToBePatched.copyWith(
                otpId: returnedPayment.otpId,
                secondFactor: returnedPayment.secondFactor,
              ),
              events: state.addEvent(
                PatchPaymentEvent.showResultView,
              ),
            ),
          );
          break;

        case PaymentStatus.failed:
          emit(
            state.copyWith(
              actions: state.removeAction(
                PatchPaymentAction.submitting,
              ),
              errors: state.addCustomCubitError(
                action: PatchPaymentAction.submitting,
                code: CubitErrorCode.paymentFailed,
              ),
            ),
          );
          break;
        //When editing the payment the BE returns the old payment data on the
        //first request. That's why we can't use the [returnedPayment] and
        //need to make sure that the updated values for amount, schedule date,
        //etc. are being sent on the 2FA request
        case PaymentStatus.otp:
          emit(
            state.copyWith(
              actions: state.removeAction(
                PatchPaymentAction.submitting,
              ),
              returnedPayment: state.paymentToBePatched.copyWith(
                otpId: returnedPayment.otpId,
                secondFactor: returnedPayment.secondFactor,
              ),
              events: state.addEvent(
                PatchPaymentEvent.openSecondFactor,
              ),
            ),
          );
          break;

        default:
          _logger.severe(
            'Unhandled payment status -> ${returnedPayment.status}',
          );
          throw Exception(
            'Unhandled payment status -> ${returnedPayment.status}',
          );
      }
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            PatchPaymentAction.submitting,
          ),
          errors: state.addErrorFromException(
            action: PatchPaymentAction.submitting,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Send the OTP code for the current returned payment.
  Future<void> sendOTPCode() async {
    assert(state.returnedPayment != null);

    emit(
      state.copyWith(
        actions: state.addAction(
          PatchPaymentAction.sendingOTPCode,
        ),
        errors: state.removeErrorForAction(
          PatchPaymentAction.sendingOTPCode,
        ),
        events: state.removeEvent(
          PatchPaymentEvent.showOTPCodeView,
        ),
      ),
    );

    try {
      final returnedPayment = await _sendOTPCodeForPaymentUseCase(
        payment: state.returnedPayment!,
        editMode: true,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            PatchPaymentAction.sendingOTPCode,
          ),
          returnedPayment: state.paymentToBePatched.copyWith(
            otpId: returnedPayment.otpId,
            secondFactor: returnedPayment.secondFactor,
          ),
          events: state.addEvent(
            PatchPaymentEvent.showOTPCodeView,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            PatchPaymentAction.sendingOTPCode,
          ),
          errors: state.addErrorFromException(
            action: PatchPaymentAction.sendingOTPCode,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Verifies the second factor for the payment retrievied on the [submit]
  /// method.
  Future<void> verifySecondFactor({
    String? otpCode,
    String? ocraClientResponse,
  }) async {
    assert(state.returnedPayment != null);
    assert(
      otpCode != null || ocraClientResponse != null,
      'An OTP code or OCRA client response must be provided in order for '
      'verifying the second factor',
    );

    emit(
      state.copyWith(
        actions: state.addAction(
          PatchPaymentAction.verifyingSecondFactor,
        ),
        errors: {},
      ),
    );

    try {
      final returnedPayment = await _verifyPaymentSecondFactorUseCase(
        payment: state.returnedPayment!,
        value: otpCode ?? ocraClientResponse ?? '',
        secondFactorType:
            otpCode != null ? SecondFactorType.otp : SecondFactorType.ocra,
        editMode: true,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            PatchPaymentAction.verifyingSecondFactor,
          ),
        ),
      );

      emit(
        state.copyWith(
          returnedPayment: returnedPayment,
          events: state.addEvent(
            PatchPaymentEvent.closeSecondFactor,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            PatchPaymentAction.verifyingSecondFactor,
          ),
        ),
      );

      emit(
        state.copyWith(
          errors: state.addErrorFromException(
            action: PatchPaymentAction.verifyingSecondFactor,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Resends the second factor for the payment retrievied on the [submit]
  /// method.
  Future<void> resendSecondFactor() async {
    assert(state.returnedPayment != null);

    try {
      emit(
        state.copyWith(
          actions: state.addAction(
            PatchPaymentAction.resendingOTP,
          ),
          errors: state.removeErrorForAction(
            PatchPaymentAction.resendingOTP,
          ),
        ),
      );

      final returnedPayment = await _resendPaymentSecondFactorUseCase(
        payment: state.returnedPayment!,
        editMode: true,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            PatchPaymentAction.resendingOTP,
          ),
          returnedPayment: returnedPayment,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            PatchPaymentAction.resendingOTP,
          ),
          errors: state.addErrorFromException(
            action: PatchPaymentAction.resendingOTP,
            exception: e,
          ),
        ),
      );
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
