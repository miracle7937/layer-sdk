import 'package:bloc/bloc.dart';

import '../../../../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that handles editing of the beneficiary.
class EditBeneficiaryCubit extends Cubit<EditBeneficiaryState> {
  final EditBeneficiaryUseCase _editBeneficiaryUseCase;
  final VerifyBeneficiarySecondFactorUseCase
      _verifyBeneficiarySecondFactorUseCase;
  final ResendBeneficiarySecondFactorUseCase
      _resendBeneficiarySecondFactorUseCase;

  /// Creates a new cubit using the supplied [LoadAvailableCurrenciesUseCase].
  EditBeneficiaryCubit({
    required EditBeneficiaryUseCase editBeneficiariesUseCase,
    required VerifyBeneficiarySecondFactorUseCase
        verifyBeneficiarySecondFactorUseCase,
    required ResendBeneficiarySecondFactorUseCase
        resendBeneficiarySecondFactorUseCase,
    required Beneficiary editingBeneficiary,
  })  : _editBeneficiaryUseCase = editBeneficiariesUseCase,
        _verifyBeneficiarySecondFactorUseCase =
            verifyBeneficiarySecondFactorUseCase,
        _resendBeneficiarySecondFactorUseCase =
            resendBeneficiarySecondFactorUseCase,
        super(
          EditBeneficiaryState(
            oldBeneficiary: editingBeneficiary,
            beneficiary: editingBeneficiary.copyWith(),
          ),
        );

  /// Handles event of nickname changes.
  void onNicknameChange(String text) => _emitBeneficiary(
        state.beneficiary.copyWith(
          nickname: text,
        ),
      );

  /// Handles event of first line of address changes.
  void onAddress1Change(String text) => _emitBeneficiary(
        state.beneficiary.copyWith(
          address1: text,
        ),
      );

  /// Handles event of second line of address changes.
  void onAddress2Change(String text) => _emitBeneficiary(
        state.beneficiary.copyWith(
          address2: text,
        ),
      );

  /// Handles event of third line of address changes.
  void onAddress3Change(String text) => _emitBeneficiary(
        state.beneficiary.copyWith(
          address3: text,
        ),
      );

  void _emitBeneficiary(Beneficiary? beneficiary) => emit(
        state.copyWith(
          beneficiary: beneficiary,
          actions: _addAction(EditBeneficiaryAction.editAction),
          errors: _addError(
            action: EditBeneficiaryAction.editAction,
            errorStatus: EditBeneficiaryErrorStatus.none,
          ),
        ),
      );

  /// Handles the editing of beneficiary.
  void onEdit() async {
    emit(
      state.copyWith(
        actions: _addAction(EditBeneficiaryAction.save),
        errors: _addError(
          action: EditBeneficiaryAction.save,
          errorStatus: EditBeneficiaryErrorStatus.none,
        ),
      ),
    );
    try {
      final hasAccount = state.hasAccount;
      final beneficiary = state.beneficiary.copyWith(
        accountNumber: hasAccount ? state.beneficiary.accountNumber! : '',
        sortCode: hasAccount ? state.beneficiary.sortCode! : '',
        iban: hasAccount ? '' : state.beneficiary.iban!,
      );
      final editedBeneficiary = await _editBeneficiaryUseCase(
        beneficiary: beneficiary,
      );

      emit(
        state.copyWith(
          beneficiary: editedBeneficiary,
          actions: {
            editedBeneficiary.otpId == null
                ? EditBeneficiaryAction.success
                : EditBeneficiaryAction.otpRequired
          },
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: _removeAction(EditBeneficiaryAction.save),
          errors: _addError(
            action: EditBeneficiaryAction.none,
            errorStatus: e is NetException
                ? EditBeneficiaryErrorStatus.network
                : EditBeneficiaryErrorStatus.generic,
            code: e is NetException ? e.code : null,
            message: e is NetException ? e.message : e.toString(),
          ),
        ),
      );
      rethrow;
    }
  }

  /// Verifies the second factor for the edited beneficiary
  /// retrieved on the [onEdit] method.
  Future<void> verifySecondFactor({
    required String otpValue,
  }) async {
    emit(
      state.copyWith(
        actions: _addAction(EditBeneficiaryAction.verifyOtp),
        errors: _addError(
          action: EditBeneficiaryAction.verifyOtp,
          errorStatus: EditBeneficiaryErrorStatus.none,
        ),
      ),
    );

    try {
      final beneficiary = await _verifyBeneficiarySecondFactorUseCase(
        beneficiary: state.beneficiary,
        otpValue: otpValue,
        isEditing: true,
      );

      emit(
        state.copyWith(
          beneficiary: beneficiary,
          actions: _removeAction(EditBeneficiaryAction.verifyOtp),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: _removeAction(EditBeneficiaryAction.verifyOtp),
          errors: _addError(
            action: EditBeneficiaryAction.none,
            errorStatus: e is NetException
                ? EditBeneficiaryErrorStatus.network
                : EditBeneficiaryErrorStatus.generic,
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
        actions: _addAction(EditBeneficiaryAction.resendOtp),
        errors: _addError(
          action: EditBeneficiaryAction.resendOtp,
          errorStatus: EditBeneficiaryErrorStatus.none,
        ),
      ),
    );

    try {
      final beneficiary = await _resendBeneficiarySecondFactorUseCase(
        beneficiary: state.beneficiary,
        isEditing: true,
      );

      emit(
        state.copyWith(
          beneficiary: beneficiary,
          actions: _removeAction(EditBeneficiaryAction.resendOtp),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: _removeAction(EditBeneficiaryAction.resendOtp),
          errors: _addError(
            action: EditBeneficiaryAction.none,
            errorStatus: e is NetException
                ? EditBeneficiaryErrorStatus.network
                : EditBeneficiaryErrorStatus.generic,
          ),
        ),
      );
    }
  }

  /// Returns an error list that includes the passed action and error status.
  Set<EditBeneficiaryError> _addError({
    required EditBeneficiaryAction action,
    required EditBeneficiaryErrorStatus errorStatus,
    String? code,
    String? message,
  }) =>
      state.errors.union({
        EditBeneficiaryError(
          action: action,
          errorStatus: errorStatus,
          code: code,
          message: message,
        )
      });

  /// Returns an action list that includes the passed action.
  Set<EditBeneficiaryAction> _addAction(
    EditBeneficiaryAction action,
  ) =>
      state.actions.union({action});

  /// Returns an action list containing all the actions but the one that
  /// coincides with the passed action.
  Set<EditBeneficiaryAction> _removeAction(
    EditBeneficiaryAction action,
  ) =>
      state.actions.difference({action});
}
