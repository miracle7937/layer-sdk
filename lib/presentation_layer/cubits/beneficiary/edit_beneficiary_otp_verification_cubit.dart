import 'package:bloc/bloc.dart';

import '../../../../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that handles OTP verification of the beneficiary etit.
class EditBeneficiaryOtpVerificationCubit
    extends Cubit<EditBeneficiaryOtpVerificationState> {
  final VerifyBeneficiarySecondFactorUseCase
      _verifyBeneficiarySecondFactorUseCase;
  final ResendBeneficiarySecondFactorUseCase
      _resendBeneficiarySecondFactorUseCase;

  final bool _isEditing;

  /// Creates a new cubit using the supplied [LoadAvailableCurrenciesUseCase].
  EditBeneficiaryOtpVerificationCubit({
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
          EditBeneficiaryOtpVerificationState(
            beneficiary: beneficiary.copyWith(),
          ),
        );

  /// Verifies the second factor for the edited beneficiary
  /// retrieved on the [onEdit] method.
  Future<void> verifySecondFactor({
    required String otpValue,
  }) async {
    emit(
      state.copyWith(
        actions: _addAction(EditBeneficiaryOtpVerificationAction.verifyOtp),
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
          actions:
              _removeAction(EditBeneficiaryOtpVerificationAction.verifyOtp),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions:
              _removeAction(EditBeneficiaryOtpVerificationAction.verifyOtp),
          errors: _addError(
            action: EditBeneficiaryOtpVerificationAction.verifyOtp,
            errorStatus: e is NetException
                ? EditBeneficiaryOtpVerificationErrorStatus.network
                : EditBeneficiaryOtpVerificationErrorStatus.generic,
            code: e is NetException ? e.code : null,
            message: e is NetException ? e.message : e.toString(),
          ),
        ),
      );
    }
  }

  /// Verifies the second factor for the edited beneficiary
  /// retrieved on the [onEdit] method.
  Future<void> resendSecondFactor() async {
    emit(
      state.copyWith(
        actions: _addAction(EditBeneficiaryOtpVerificationAction.resendOtp),
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
          actions:
              _removeAction(EditBeneficiaryOtpVerificationAction.resendOtp),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions:
              _removeAction(EditBeneficiaryOtpVerificationAction.resendOtp),
          errors: _addError(
            action: EditBeneficiaryOtpVerificationAction.resendOtp,
            errorStatus: e is NetException
                ? EditBeneficiaryOtpVerificationErrorStatus.network
                : EditBeneficiaryOtpVerificationErrorStatus.generic,
            code: e is NetException ? e.code : null,
            message: e is NetException ? e.message : e.toString(),
          ),
        ),
      );
    }
  }

  /// Returns an error list that includes the passed action and error status.
  Set<EditBeneficiaryOtpVerificationError> _addError({
    required EditBeneficiaryOtpVerificationAction action,
    required EditBeneficiaryOtpVerificationErrorStatus errorStatus,
    String? code,
    String? message,
  }) =>
      state.errors.union({
        EditBeneficiaryOtpVerificationError(
          action: action,
          errorStatus: errorStatus,
          code: code,
          message: message,
        )
      });

  /// Returns an action list that includes the passed action.
  Set<EditBeneficiaryOtpVerificationAction> _addAction(
    EditBeneficiaryOtpVerificationAction action,
  ) =>
      state.actions.union({action});

  /// Returns an action list containing all the actions but the one that
  /// coincides with the passed action.
  Set<EditBeneficiaryOtpVerificationAction> _removeAction(
    EditBeneficiaryOtpVerificationAction action,
  ) =>
      state.actions.difference({action});
}
