import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that handles the state for the actions that the user
/// can perform on the transaction details for a [PayToMobile] item.
class PayToMobileTransactionCubit extends Cubit<PayToMobileTransactionState> {
  /// The pay to mobile transaction.
  final PayToMobile _payToMobile;

  /// Use cases
  final ResendWithdrawalCodeForPayToMobileUseCase
      _resendWithdrawalCodeForPayToMobileUseCase;
  final DeletePayToMobileUseCase _deletePayToMobileUseCase;
  final SendOTPCodeForDeletePayToMobileUseCase
      _sendOTPCodeForDeletePayToMobileUseCase;
  final ResendPayToMobileSecondFactorUseCase
      _resendPayToMobileSecondFactorUseCase;
  final VerifyDeletePayToMobileSecondFactorUseCase
      _verifyDeletePayToMobileSecondFactorUseCase;

  /// Creates a new [PayToMobileTransactionCubit].
  PayToMobileTransactionCubit({
    required PayToMobile payToMobile,
    required ResendWithdrawalCodeForPayToMobileUseCase
        resendWithdrawalCodeForPayToMobileUseCase,
    required DeletePayToMobileUseCase deletePayToMobileUseCase,
    required SendOTPCodeForDeletePayToMobileUseCase
        sendOTPCodeForDeletePayToMobileUseCase,
    required ResendPayToMobileSecondFactorUseCase
        resendPayToMobileSecondFactorUseCase,
    required VerifyDeletePayToMobileSecondFactorUseCase
        verifyDeletePayToMobileSecondFactorUseCase,
  })  : assert(
          payToMobile.requestId != null,
          'The passed pay to mobile request ID is null',
        ),
        _payToMobile = payToMobile,
        _resendWithdrawalCodeForPayToMobileUseCase =
            resendWithdrawalCodeForPayToMobileUseCase,
        _deletePayToMobileUseCase = deletePayToMobileUseCase,
        _sendOTPCodeForDeletePayToMobileUseCase =
            sendOTPCodeForDeletePayToMobileUseCase,
        _resendPayToMobileSecondFactorUseCase =
            resendPayToMobileSecondFactorUseCase,
        _verifyDeletePayToMobileSecondFactorUseCase =
            verifyDeletePayToMobileSecondFactorUseCase,
        super(PayToMobileTransactionState());

  /// Resends the withdrawal code for the pay to mobile transaction.
  Future<void> resendWithdrawalCode() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          PayToMobileTransactionAction.resendWithdrawalCode,
        ),
        errors: state.removeErrorForAction(
          PayToMobileTransactionAction.resendWithdrawalCode,
        ),
      ),
    );

    try {
      await _resendWithdrawalCodeForPayToMobileUseCase(
        requestId: _payToMobile.requestId ?? '',
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            PayToMobileTransactionAction.resendWithdrawalCode,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            PayToMobileTransactionAction.resendWithdrawalCode,
          ),
          errors: state.addErrorFromException(
            action: PayToMobileTransactionAction.resendWithdrawalCode,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Deletes the pay to mobile transaction.
  Future<void> delete() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          PayToMobileTransactionAction.delete,
        ),
        errors: state.removeErrorForAction(
          PayToMobileTransactionAction.delete,
        ),
      ),
    );

    try {
      final deletePayToMobileResult = await _deletePayToMobileUseCase(
        requestId: _payToMobile.requestId ?? '',
      );

      if (deletePayToMobileResult == null) {
        emit(
          state.copyWith(
            actions: state.removeAction(
              PayToMobileTransactionAction.delete,
            ),
            events: state.addEvent(
              PayToMobileTransactionEvent.closeAndReload,
            ),
          ),
        );
      } else {
        switch (deletePayToMobileResult.status) {
          case PayToMobileStatus.pendingSecondFactor:
            emit(
              state.copyWith(
                actions: state.removeAction(
                  PayToMobileTransactionAction.delete,
                ),
                deletePayToMobileResult: deletePayToMobileResult,
                events: state.addEvent(
                  PayToMobileTransactionEvent.openSecondFactor,
                ),
              ),
            );
            break;

          default:
            throw Exception(
              'Unhandled pay to mobile status -> '
              '${deletePayToMobileResult.status}',
            );
        }
      }
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            PayToMobileTransactionAction.delete,
          ),
          errors: state.addErrorFromException(
            action: PayToMobileTransactionAction.delete,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Send the OTP code for the current [PayToMobile] retrievied on the
  /// [delete] method.
  Future<void> sendOTPCode() async {
    assert(state.deletePayToMobileResult != null);

    emit(
      state.copyWith(
        actions: state.addAction(
          PayToMobileTransactionAction.sendOTPCode,
        ),
        errors: state.removeErrorForAction(
          PayToMobileTransactionAction.sendOTPCode,
        ),
        events: state.removeEvent(
          PayToMobileTransactionEvent.showOTPCodeView,
        ),
      ),
    );

    try {
      final deletePayToMobileResult =
          await _sendOTPCodeForDeletePayToMobileUseCase(
        requestId: state.deletePayToMobileResult?.requestId ?? '',
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            PayToMobileTransactionAction.sendOTPCode,
          ),
          deletePayToMobileResult: deletePayToMobileResult,
          events: state.addEvent(
            PayToMobileTransactionEvent.showOTPCodeView,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            PayToMobileTransactionAction.sendOTPCode,
          ),
          errors: state.addErrorFromException(
            action: PayToMobileTransactionAction.sendOTPCode,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Verifies the second factor for the [PayToMobile] retrievied on the
  /// [delete] method.
  Future<void> verifySecondFactor({
    String? otpCode,
    String? ocraClientResponse,
  }) async {
    assert(
      otpCode != null || ocraClientResponse != null,
      'An OTP code or OCRA client response must be provided in order for '
      'verifying the second factor',
    );

    emit(
      state.copyWith(
        actions: state.addAction(
          PayToMobileTransactionAction.verifySecondFactor,
        ),
        errors: {},
      ),
    );

    try {
      await _verifyDeletePayToMobileSecondFactorUseCase(
        requestId: state.deletePayToMobileResult?.requestId ?? '',
        value: otpCode ?? ocraClientResponse ?? '',
        secondFactorType:
            otpCode != null ? SecondFactorType.otp : SecondFactorType.ocra,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            PayToMobileTransactionAction.verifySecondFactor,
          ),
        ),
      );

      emit(
        state.copyWith(
          events: state.addEvent(
            PayToMobileTransactionEvent.closeSecondFactor,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            PayToMobileTransactionAction.verifySecondFactor,
          ),
        ),
      );

      emit(
        state.copyWith(
          errors: state.addErrorFromException(
            action: PayToMobileTransactionAction.verifySecondFactor,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Resends the second factor for the [PayToMobile] retrievied on
  /// the [delete] method.
  Future<void> resendSecondFactor() async {
    assert(state.deletePayToMobileResult != null);

    emit(
      state.copyWith(
        actions: state.addAction(
          PayToMobileTransactionAction.resendSecondFactor,
        ),
        errors: {},
      ),
    );

    try {
      final deletePayToMobileResult =
          await _resendPayToMobileSecondFactorUseCase(
        payToMobile: state.deletePayToMobileResult!,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            PayToMobileTransactionAction.resendSecondFactor,
          ),
        ),
      );

      emit(
        state.copyWith(
          deletePayToMobileResult: deletePayToMobileResult,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            PayToMobileTransactionAction.resendSecondFactor,
          ),
        ),
      );

      emit(
        state.copyWith(
          errors: state.addErrorFromException(
            action: PayToMobileTransactionAction.resendSecondFactor,
            exception: e,
          ),
        ),
      );
    }
  }
}
