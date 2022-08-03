import 'package:bloc/bloc.dart';

import '../../../../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that handles OTP verification of the beneficiary add/edit actions.
class BeneficiaryOtpVerificationCubit
    extends Cubit<BeneficiaryOtpVerificationState> {
  final VerifyBeneficiarySecondFactorUseCase
      _verifyBeneficiarySecondFactorUseCase;
  final ResendBeneficiarySecondFactorUseCase
      _resendBeneficiarySecondFactorUseCase;

  final bool _isEditing;

  /// Creates a new [BeneficiaryOtpVerificationCubit].
  BeneficiaryOtpVerificationCubit({
    required VerifyBeneficiarySecondFactorUseCase
        verifyBeneficiarySecondFactorUseCase,
    required ResendBeneficiarySecondFactorUseCase
        resendBeneficiarySecondFactorUseCase,
    required Beneficiary beneficiary,
    bool isEditing = false,
  })  : _verifyBeneficiarySecondFactorUseCase =
            verifyBeneficiarySecondFactorUseCase,
        _resendBeneficiarySecondFactorUseCase =
            resendBeneficiarySecondFactorUseCase,
        _isEditing = isEditing,
        super(
          BeneficiaryOtpVerificationState(
            beneficiary: beneficiary.copyWith(),
          ),
        );

  /// Verifies the second factor for the added/edited beneficiary.
  Future<void> verifySecondFactor({
    required String otpValue,
  }) async {
    emit(
      state.copyWith(
        actions: _addAction(BeneficiaryOtpVerificationAction.verifyOtp),
        errors: {},
      ),
    );

    try {
      final beneficiary = await _verifyBeneficiarySecondFactorUseCase(
        beneficiary: state.beneficiary,
        otpValue: otpValue,
        isEditing: _isEditing,
      );

      emit(
        state.copyWith(
          beneficiary: beneficiary,
          actions: _removeAction(BeneficiaryOtpVerificationAction.verifyOtp),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: _removeAction(BeneficiaryOtpVerificationAction.verifyOtp),
          errors: _addError(
            action: BeneficiaryOtpVerificationAction.verifyOtp,
            errorStatus: e is NetException
                ? BeneficiaryOtpVerificationErrorStatus.network
                : BeneficiaryOtpVerificationErrorStatus.generic,
            code: e is NetException ? e.code : null,
            message: e is NetException ? e.message : null,
          ),
        ),
      );
    }
  }

  /// Verifies the second factor for the added/edited beneficiary.
  Future<void> resendSecondFactor() async {
    emit(
      state.copyWith(
        actions: _addAction(BeneficiaryOtpVerificationAction.resendOtp),
        errors: {},
      ),
    );

    try {
      final beneficiary = await _resendBeneficiarySecondFactorUseCase(
        beneficiary: state.beneficiary,
        isEditing: _isEditing,
      );

      emit(
        state.copyWith(
          beneficiary: beneficiary,
          actions: _removeAction(BeneficiaryOtpVerificationAction.resendOtp),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: _removeAction(BeneficiaryOtpVerificationAction.resendOtp),
          errors: _addError(
            action: BeneficiaryOtpVerificationAction.resendOtp,
            errorStatus: e is NetException
                ? BeneficiaryOtpVerificationErrorStatus.network
                : BeneficiaryOtpVerificationErrorStatus.generic,
            code: e is NetException ? e.code : null,
            message: e is NetException ? e.message : null,
          ),
        ),
      );
    }
  }

  /// Returns an error list that includes the passed action and error status.
  Set<BeneficiaryOtpVerificationError> _addError({
    required BeneficiaryOtpVerificationAction action,
    required BeneficiaryOtpVerificationErrorStatus errorStatus,
    String? code,
    String? message,
  }) =>
      state.errors.union({
        BeneficiaryOtpVerificationError(
          action: action,
          errorStatus: errorStatus,
          code: code,
          message: message,
        )
      });

  /// Returns an action list that includes the passed action.
  Set<BeneficiaryOtpVerificationAction> _addAction(
    BeneficiaryOtpVerificationAction action,
  ) =>
      state.actions.union({action});

  /// Returns an action list containing all the actions but the one that
  /// coincides with the passed action.
  Set<BeneficiaryOtpVerificationAction> _removeAction(
    BeneficiaryOtpVerificationAction action,
  ) =>
      state.actions.difference({action});
}
